import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:buscobien/40_security/direccionip.dart';
import 'package:buscobien/60_global_widgets/debugprint.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/grupos/models/publicacion_grupo_model.dart';

// =============================================================================
// PROVIDER — PUBLICACIONES DE PROPIEDADES EN GRUPOS
// =============================================================================
// Base: buscobien_grupos_publicaciones
// Índice requerido:
//   {"index":{"fields":["type","grupoId","timestamp"]},"name":"idx-pub-grupo"}

const String _dbPublicaciones = 'buscobien_grupos_publicaciones';
const int _pageSize = 10;

Map<String, String> get _authHeaders => {
  'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
  'Content-Type': 'application/json',
};

// Patrón Riverpod 3.x: factory recibe el arg y lo pasa al constructor.
final publicacionesGrupoProvider = AsyncNotifierProvider.family<
    PublicacionesGrupoNotifier, List<PublicacionGrupoModel>, String>(
  (grupoId) => PublicacionesGrupoNotifier(grupoId),
);

class PublicacionesGrupoNotifier
    extends AsyncNotifier<List<PublicacionGrupoModel>> {
  PublicacionesGrupoNotifier(this._grupoId);

  final String _grupoId;
  int _skip = 0;
  bool _hayMas = true;

  bool get hayMas => _hayMas;

  @override
  Future<List<PublicacionGrupoModel>> build() async {
    _skip = 0;
    _hayMas = true;
    return _fetch(0);
  }

  Future<List<PublicacionGrupoModel>> _fetch(int skip) async {
    try {
      final url = Uri.parse('$direccionip/$_dbPublicaciones/_find');
      final body = jsonEncode({
        'selector': {'type': 'publicacion_grupo', 'grupoId': _grupoId},
        'sort': [
          {'timestamp': 'desc'},
        ],
        'limit': _pageSize,
        'skip': skip,
      });
      final response = await http.post(url, headers: _authHeaders, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final docs = (data['docs'] as List)
            .map(
              (e) => PublicacionGrupoModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
        if (docs.length < _pageSize) _hayMas = false;
        return docs;
      }
      debugPrintLevels(
        1,
        'PublicacionesGrupoNotifier._fetch error: ${response.statusCode}',
      );
      return [];
    } catch (e) {
      debugPrintLevels(1, 'PublicacionesGrupoNotifier._fetch exception: $e');
      return [];
    }
  }

  Future<void> cargarMas() async {
    if (!_hayMas) return;
    _skip += _pageSize;
    final actuales = state.value ?? [];
    final nuevas = await _fetch(_skip);
    state = AsyncValue.data([...actuales, ...nuevas]);
  }

  Future<bool> compartirPropiedad({
    required String propiedadId,
    required String propiedadNombre,
    required String tipodeespacio,
    required String autorId,
    required String autorNombre,
  }) async {
    try {
      final actuales = state.value ?? [];
      // Evitar duplicado del mismo autor para la misma propiedad
      if (actuales.any(
        (p) => p.propiedadId == propiedadId && p.autorId == autorId,
      )) {
        return false;
      }

      final id = const Uuid().v4();
      final pub = PublicacionGrupoModel(
        id: id,
        grupoId: _grupoId,
        propiedadId: propiedadId,
        propiedadNombre: propiedadNombre,
        tipodeespacio: tipodeespacio,
        autorId: autorId,
        autorNombre: autorNombre,
        timestamp: DateTime.now().toIso8601String(),
      );

      final response = await http.put(
        Uri.parse('$direccionip/$_dbPublicaciones/$id'),
        headers: _authHeaders,
        body: publicacionGrupoModelToJson(pub),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        state = AsyncValue.data([pub, ...actuales]);
        return true;
      }
      debugPrintLevels(1, 'compartirPropiedad error: ${response.statusCode}');
      return false;
    } catch (e) {
      debugPrintLevels(1, 'compartirPropiedad exception: $e');
      return false;
    }
  }

  Future<bool> quitarPublicacion(PublicacionGrupoModel pub) async {
    try {
      final getResp = await http.get(
        Uri.parse('$direccionip/$_dbPublicaciones/${pub.id}'),
        headers: _authHeaders,
      );
      if (getResp.statusCode != 200) return false;
      final doc = jsonDecode(utf8.decode(getResp.bodyBytes));
      final rev = doc['_rev'] as String;

      final delResp = await http.put(
        Uri.parse('$direccionip/$_dbPublicaciones/${pub.id}'),
        headers: _authHeaders,
        body: jsonEncode({
          '_id': pub.id,
          '_rev': rev,
          '_deleted': true,
        }),
      );
      if (delResp.statusCode == 200 || delResp.statusCode == 201 || delResp.statusCode == 202) {
        final actuales = state.value ?? [];
        state = AsyncValue.data(
          actuales.where((p) => p.id != pub.id).toList(),
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrintLevels(1, 'quitarPublicacion exception: $e');
      return false;
    }
  }
}
