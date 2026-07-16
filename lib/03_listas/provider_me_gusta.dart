import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../40_security/direccionip.dart';
import '../60_global_widgets/debugprint.dart';
import 'models/me_gusta_model.dart';
import 'provider_user_lists.dart';

// =============================================================================
// PROVIDER — ME GUSTA EN PROPIEDADES
// =============================================================================
// Base: buscobien_megusta_propiedades
// Índices requeridos:
//   {"index":{"fields":["type","usuarioId"]},"name":"idx-megusta-usuario"}
//   {"index":{"fields":["type","usuarioId","propiedadId"]},"name":"idx-megusta-usuario-propiedad"}

const String _dbMeGusta = 'buscobien_megusta_propiedades';

Map<String, String> get _authHeaders => {
  'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
  'Content-Type': 'application/json',
};

// =============================================================================
// NOTIFIER
// =============================================================================

class MeGustaNotifier extends AsyncNotifier<List<MeGustaModel>> {
  String _currentUserId = '';

  /// Estado inicial vacío. La carga se activa explícitamente con [init].
  @override
  Future<List<MeGustaModel>> build() async => [];

  // ---------------------------------------------------------------------------
  // API PÚBLICA
  // ---------------------------------------------------------------------------

  /// Llama esto cuando el usuario abre la pantalla de búsqueda o inicia sesión.
  /// Si [userId] está vacío o es el mismo que ya se cargó, no hace nada.
  Future<void> init(String userId) async {
    if (userId.isEmpty) {
      _currentUserId = '';
      state = const AsyncValue.data([]);
      return;
    }
    if (_currentUserId == userId && state is AsyncData) return; // Ya cargado
    _currentUserId = userId;
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await _fetch(userId));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Limpia el estado al cerrar sesión.
  void clear() {
    _currentUserId = '';
    state = const AsyncValue.data([]);
  }

  bool tieneMeGusta(String propiedadId) {
    final lista = state.value ?? [];
    return lista.any((m) => m.propiedadId == propiedadId);
  }

  // Agrega o quita el "Me gusta". Al agregar por primera vez crea lista Favoritas.
  Future<bool> toggleMeGusta({
    required String usuarioId,
    required String propiedadId,
    required UserListsNotifier userListsNotifier,
  }) async {
    // Garantiza que _currentUserId esté asignado
    if (_currentUserId.isEmpty) {
      _currentUserId = usuarioId;
      // Carga inicial si aún no se había hecho
      if (state is! AsyncData ||
          (state.value?.isEmpty ?? true)) {
        state = AsyncValue.data(await _fetch(usuarioId));
      }
    }

    final lista = state.value ?? [];
    final existente = lista.where((m) => m.propiedadId == propiedadId).toList();

    if (existente.isNotEmpty) {
      return await _quitarMeGusta(existente.first);
    } else {
      final esPrimero = lista.isEmpty;
      final ok = await _agregarMeGusta(usuarioId, propiedadId);
      if (ok && esPrimero) {
        await _crearListaFavoritasSiNoExiste(usuarioId, userListsNotifier);
      }
      if (ok) {
        await _agregarPropiedadAFavoritas(
          usuarioId,
          propiedadId,
          userListsNotifier,
        );
      }
      return ok;
    }
  }

  // ---------------------------------------------------------------------------
  // PRIVADOS
  // ---------------------------------------------------------------------------

  Future<List<MeGustaModel>> _fetch(String userId) async {
    final url = Uri.parse('$direccionip/$_dbMeGusta/_find');
    final body = jsonEncode({
      'selector': {'type': 'me_gusta', 'usuarioId': userId},
      'limit': 500,
    });
    final response = await http.post(url, headers: _authHeaders, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return (data['docs'] as List)
          .map((e) => MeGustaModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    debugPrintLevels(1, 'fetchMeGusta HTTP ${response.statusCode}');
    return [];
  }

  Future<bool> _agregarMeGusta(String usuarioId, String propiedadId) async {
    try {
      final id = const Uuid().v4();
      final modelo = MeGustaModel(
        id: id,
        usuarioId: usuarioId,
        propiedadId: propiedadId,
        timestamp: DateTime.now().toIso8601String(),
      );
      final response = await http.put(
        Uri.parse('$direccionip/$_dbMeGusta/$id'),
        headers: _authHeaders,
        body: meGustaModelToJson(modelo),
      );
      debugPrintLevels(1, '_agregarMeGusta HTTP ${response.statusCode}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Actualización optimista: agrega al estado local sin re-fetch
        final current = List<MeGustaModel>.from(state.value ?? []);
        current.add(modelo);
        state = AsyncValue.data(current);
        return true;
      }
      return false;
    } catch (e) {
      debugPrintLevels(1, '_agregarMeGusta exception: $e');
      return false;
    }
  }

  Future<bool> _quitarMeGusta(MeGustaModel modelo) async {
    try {
      // Obtener _rev actual
      final getResp = await http.get(
        Uri.parse('$direccionip/$_dbMeGusta/${modelo.id}'),
        headers: _authHeaders,
      );
      if (getResp.statusCode != 200) return false;
      final doc = jsonDecode(utf8.decode(getResp.bodyBytes));
      
      // Marcar como eliminado para CouchDB
      doc['_deleted'] = true;

      final delResp = await http.put(
        Uri.parse('$direccionip/$_dbMeGusta/${modelo.id}'),
        headers: _authHeaders,
        body: jsonEncode(doc),
      );
      debugPrintLevels(1, '_quitarMeGusta HTTP ${delResp.statusCode}');
      if (delResp.statusCode == 200 || delResp.statusCode == 201 || delResp.statusCode == 202) {
        // Actualización optimista: quita del estado local sin re-fetch
        final current = List<MeGustaModel>.from(state.value ?? [])
          ..removeWhere((m) => m.id == modelo.id);
        state = AsyncValue.data(current);
        return true;
      }
      return false;
    } catch (e) {
      debugPrintLevels(1, '_quitarMeGusta exception: $e');
      return false;
    }
  }

  // Crea la lista "Favoritas" si el usuario aún no la tiene.
  Future<void> _crearListaFavoritasSiNoExiste(
    String userId,
    UserListsNotifier userListsNotifier,
  ) async {
    final listas = userListsNotifier.state.rows;
    final yaExiste = listas.any((r) => r.value.listName == 'Favoritas');
    if (yaExiste) return;
    await userListsNotifier.createList(userId, 'Favoritas');
  }

  // Agrega la propiedad a la lista Favoritas del usuario.
  Future<void> _agregarPropiedadAFavoritas(
    String userId,
    String propiedadId,
    UserListsNotifier userListsNotifier,
  ) async {
    try {
      // Refrescar listas para garantizar que "Favoritas" exista
      await userListsNotifier.fetchUserLists(userId);

      final listas = userListsNotifier.state.rows;
      final favRow = listas.where((r) => r.value.listName == 'Favoritas');
      if (favRow.isEmpty) {
        debugPrintLevels(
          1,
          '_agregarPropiedadAFavoritas: lista Favoritas no encontrada',
        );
        return;
      }

      final listaId = favRow.first.value.listaId;

      // Anti-duplicado: verificar si la propiedad ya está en Favoritas
      final checkUrl = Uri.parse(
        '$direccionip/buscobien_listas_propiedades/_find',
      );
      final checkBody = jsonEncode({
        'selector': {
          'listapropiedad.listaId': listaId,
          'listapropiedad.propertyId': propiedadId,
        },
        'limit': 1,
      });
      final checkResp = await http.post(
        checkUrl,
        headers: _authHeaders,
        body: checkBody,
      );
      if (checkResp.statusCode == 200) {
        final checkData = jsonDecode(utf8.decode(checkResp.bodyBytes));
        if ((checkData['docs'] as List).isNotEmpty) {
          debugPrintLevels(
            1,
            '_agregarPropiedadAFavoritas: propiedad ya existe en Favoritas',
          );
          return;
        }
      }

      final url = Uri.parse('$direccionip/buscobien_listas_propiedades');
      final body = jsonEncode({
        '_id': const Uuid().v4(),
        'listapropiedad': {
          'listapropiedadId': const Uuid().v4(),
          'userId': userId,
          'listaId': listaId,
          'propertyId': propiedadId,
          'tipodeespacio': '',
          'type': 'lista_propiedad_item',
          'timestamp': DateTime.now().toIso8601String(),
        },
      });
      final resp = await http.post(url, headers: _authHeaders, body: body);
      debugPrintLevels(1, '_agregarPropiedadAFavoritas HTTP ${resp.statusCode}');
    } catch (e) {
      debugPrintLevels(1, '_agregarPropiedadAFavoritas exception: $e');
    }
  }
}

final meGustaProvider =
    AsyncNotifierProvider<MeGustaNotifier, List<MeGustaModel>>(
      MeGustaNotifier.new,
    );
