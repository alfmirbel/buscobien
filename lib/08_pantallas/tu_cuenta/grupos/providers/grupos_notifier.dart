import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:buscobien/40_security/direccionip.dart';
import 'package:buscobien/60_global_widgets/debugprint.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/grupos/models/grupo_model.dart';

// =============================================================================
// HELPERS DE AUTENTICACIÓN
// =============================================================================

Map<String, String> get _authHeaders => {
  'Authorization':
      'Basic ${base64Encode(utf8.encode('$username:$password'))}',
  'Content-Type': 'application/json',
};

const String _dbGrupos = 'buscobien_grupos';

// =============================================================================
// NOTIFIER PRINCIPAL — LISTA DE GRUPOS DEL USUARIO
// =============================================================================
// Índices CouchDB necesarios (crear en Fauxton):
//   1. {"index": {"fields": ["type", "miembros"]}, "name": "idx-tipo-miembros"}
//   2. {"index": {"fields": ["type", "privacidad"]}, "name": "idx-tipo-privacidad"}

class GruposNotifier extends AsyncNotifier<List<GrupoModel>> {
  @override
  FutureOr<List<GrupoModel>> build() async {
    return [];
  }

  // Carga los grupos donde el usuario es miembro.
  // Requiere índice CouchDB sobre ["type", "miembros.usuarioId"].
  Future<void> cargarMisGrupos(String userId) async {
    state = const AsyncValue.loading();
    try {
      final url = Uri.parse('$direccionip/$_dbGrupos/_find');
      final body = jsonEncode({
        'selector': {
          'type': 'grupo',
          'miembros': {
            r'$elemMatch': {'usuarioId': userId},
          },
        },
        'limit': 100,
      });

      final response = await http.post(url, headers: _authHeaders, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final docs = data['docs'] as List<dynamic>;
        state = AsyncValue.data(
          docs.map((e) => GrupoModel.fromJson(e as Map<String, dynamic>)).toList(),
        );
      } else {
        debugPrintLevels(1, 'GruposNotifier.cargarMisGrupos error: ${response.statusCode}');
        state = const AsyncValue.data([]);
      }
    } catch (e, st) {
      debugPrintLevels(1, 'GruposNotifier.cargarMisGrupos exception: $e');
      state = AsyncValue.error(e, st);
    }
  }

  // Carga todos los grupos públicos (para la pantalla Descubrir).
  Future<List<GrupoModel>> cargarGruposPublicos() async {
    try {
      final url = Uri.parse('$direccionip/$_dbGrupos/_find');
      final body = jsonEncode({
        'selector': {
          'type': 'grupo',
          'privacidad': 'publica',
        },
        'limit': 100,
      });

      final response = await http.post(url, headers: _authHeaders, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final docs = data['docs'] as List<dynamic>;
        return docs
            .map((e) => GrupoModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrintLevels(1, 'GruposNotifier.cargarGruposPublicos exception: $e');
      return [];
    }
  }

  // Crea un nuevo grupo. El creador queda como primer miembro con rol admin.
  Future<bool> crearGrupo({
    required String creadorId,
    required String creadorNombre,
    required String nombre,
    required String descripcion,
    String objetivo = '',
    String privacidad = 'publica',
    String visibilidad = 'todos',
    String participacion = 'abierta',
  }) async {
    try {
      final nuevo = GrupoModel(
        id: const Uuid().v4(),
        creadorId: creadorId,
        creadorNombre: creadorNombre,
        nombre: nombre,
        descripcion: descripcion,
        objetivo: objetivo,
        privacidad: privacidad,
        visibilidad: visibilidad,
        participacion: participacion,
        miembros: [
          MiembroGrupoModel(
            usuarioId: creadorId,
            usuarioNombre: creadorNombre,
            rol: 'admin',
            fechaIngreso: DateTime.now().toIso8601String(),
          ),
        ],
        timestamp: DateTime.now().toIso8601String(),
      );

      final url = Uri.parse('$direccionip/$_dbGrupos');
      final response = await http.post(
        url,
        headers: _authHeaders,
        body: grupoModelToJson(nuevo),
      );

      if (response.statusCode == 201) {
        final listaActual = state.value ?? [];
        state = AsyncValue.data([...listaActual, nuevo]);
        return true;
      }
      debugPrintLevels(1, 'GruposNotifier.crearGrupo error: ${response.statusCode} ${response.body}');
      return false;
    } catch (e) {
      debugPrintLevels(1, 'GruposNotifier.crearGrupo exception: $e');
      return false;
    }
  }

  // Agrega un miembro al grupo. Obtiene el _rev vigente antes de hacer PUT.
  Future<bool> agregarMiembro(String grupoId, MiembroGrupoModel nuevoMiembro) async {
    try {
      // 1. Obtener documento actual para tener el _rev vigente
      final getUrl = Uri.parse('$direccionip/$_dbGrupos/$grupoId');
      final getResponse = await http.get(getUrl, headers: _authHeaders);
      if (getResponse.statusCode != 200) return false;

      final grupoActual = GrupoModel.fromJson(
        jsonDecode(utf8.decode(getResponse.bodyBytes)) as Map<String, dynamic>,
      );

      // Evitar duplicados
      if (grupoActual.esMiembro(nuevoMiembro.usuarioId)) return true;

      // 2. Actualizar lista de miembros y hacer PUT
      final miembrosActualizados = [...grupoActual.miembros, nuevoMiembro];
      grupoActual.miembros = miembrosActualizados;

      final putUrl = Uri.parse('$direccionip/$_dbGrupos/$grupoId');
      final putResponse = await http.put(
        putUrl,
        headers: _authHeaders,
        body: grupoModelToJson(grupoActual),
      );

      if (putResponse.statusCode == 200 || putResponse.statusCode == 201) {
        // Refrescar estado local
        final listaActual = state.value ?? [];
        state = AsyncValue.data(
          listaActual
              .map((g) => g.id == grupoId ? grupoActual : g)
              .toList(),
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrintLevels(1, 'GruposNotifier.agregarMiembro exception: $e');
      return false;
    }
  }

  // Actualiza los datos editables de un grupo (nombre, descripción, objetivo, etc.).
  Future<bool> actualizarGrupo(GrupoModel grupo) async {
    try {
      final url = Uri.parse('$direccionip/$_dbGrupos/${grupo.id}');
      final response = await http.put(
        url,
        headers: _authHeaders,
        body: grupoModelToJson(grupo),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final listaActual = state.value ?? [];
        state = AsyncValue.data(
          listaActual.map((g) => g.id == grupo.id ? grupo : g).toList(),
        );
        return true;
      }
      debugPrintLevels(1, 'GruposNotifier.actualizarGrupo error: ${response.statusCode}');
      return false;
    } catch (e) {
      debugPrintLevels(1, 'GruposNotifier.actualizarGrupo exception: $e');
      return false;
    }
  }
}

final gruposProvider =
    AsyncNotifierProvider<GruposNotifier, List<GrupoModel>>(() {
      return GruposNotifier();
    });

// Provider separado para la pantalla Descubrir — grupos públicos.
// No afecta el estado de "mis grupos" del usuario.
final gruposPublicosProvider = FutureProvider<List<GrupoModel>>((ref) async {
  final url = Uri.parse('$direccionip/$_dbGrupos/_find');
  final body = jsonEncode({
    'selector': {
      'type': 'grupo',
      'privacidad': 'publica',
    },
    'limit': 100,
  });
  try {
    final response = await http.post(url, headers: _authHeaders, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final docs = data['docs'] as List<dynamic>;
      return docs
          .map((e) => GrupoModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  } catch (e) {
    debugPrintLevels(1, 'gruposPublicosProvider exception: $e');
    return [];
  }
});
