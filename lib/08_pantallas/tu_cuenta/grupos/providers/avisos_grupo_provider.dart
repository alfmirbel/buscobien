import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:buscobien/40_security/direccionip.dart';
import 'package:buscobien/60_global_widgets/debugprint.dart';
import 'package:buscobien/08_pantallas/tu_cuenta/grupos/models/aviso_grupo_model.dart';

// =============================================================================
// PROVIDER — AVISOS DEL GRUPO
// =============================================================================
// Base: buscobien_grupos_avisos
// Índice requerido:
//   {"index":{"fields":["type","grupoId","timestamp"]},"name":"idx-aviso-grupo"}

const String _dbAvisos = 'buscobien_grupos_avisos';

Map<String, String> get _authHeaders => {
  'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
  'Content-Type': 'application/json',
};

// Patrón Riverpod 3.x: factory recibe el arg y lo pasa al constructor.
final avisosGrupoProvider = AsyncNotifierProvider.family<
    AvisosGrupoNotifier, List<AvisoGrupoModel>, String>(
  (grupoId) => AvisosGrupoNotifier(grupoId),
);

class AvisosGrupoNotifier extends AsyncNotifier<List<AvisoGrupoModel>> {
  AvisosGrupoNotifier(this._grupoId);

  final String _grupoId;

  @override
  Future<List<AvisoGrupoModel>> build() async => _fetch();

  Future<List<AvisoGrupoModel>> _fetch() async {
    try {
      final url = Uri.parse('$direccionip/$_dbAvisos/_find');
      final body = jsonEncode({
        'selector': {'type': 'aviso_grupo', 'grupoId': _grupoId},
        'sort': [
          {'timestamp': 'desc'},
        ],
        'limit': 100,
      });
      final response = await http.post(url, headers: _authHeaders, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return (data['docs'] as List)
            .map((e) => AvisoGrupoModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      debugPrintLevels(
        1,
        'AvisosGrupoNotifier._fetch error: ${response.statusCode}',
      );
      return [];
    } catch (e) {
      debugPrintLevels(1, 'AvisosGrupoNotifier._fetch exception: $e');
      return [];
    }
  }

  Future<bool> publicarAviso({
    required String autorId,
    required String autorNombre,
    required String contenido,
  }) async {
    if (contenido.trim().isEmpty || contenido.length > 250) return false;
    try {
      final id = const Uuid().v4();
      final aviso = AvisoGrupoModel(
        id: id,
        grupoId: _grupoId,
        autorId: autorId,
        autorNombre: autorNombre,
        contenido: contenido.trim(),
        timestamp: DateTime.now().toIso8601String(),
      );

      final response = await http.put(
        Uri.parse('$direccionip/$_dbAvisos/$id'),
        headers: _authHeaders,
        body: avisoGrupoModelToJson(aviso),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final actual = state.value ?? [];
        state = AsyncValue.data([aviso, ...actual]);
        return true;
      }
      debugPrintLevels(1, 'publicarAviso error: ${response.statusCode}');
      return false;
    } catch (e) {
      debugPrintLevels(1, 'publicarAviso exception: $e');
      return false;
    }
  }

  Future<bool> eliminarAviso(AvisoGrupoModel aviso) async {
    try {
      final getResp = await http.get(
        Uri.parse('$direccionip/$_dbAvisos/${aviso.id}'),
        headers: _authHeaders,
      );
      if (getResp.statusCode != 200) return false;
      final doc = jsonDecode(utf8.decode(getResp.bodyBytes));
      final rev = doc['_rev'] as String;

      final delResp = await http.put(
        Uri.parse('$direccionip/$_dbAvisos/${aviso.id}'),
        headers: _authHeaders,
        body: jsonEncode({
          '_id': aviso.id,
          '_rev': rev,
          '_deleted': true,
        }),
      );
      if (delResp.statusCode == 200 || delResp.statusCode == 201 || delResp.statusCode == 202) {
        final actual = state.value ?? [];
        state = AsyncValue.data(actual.where((a) => a.id != aviso.id).toList());
        return true;
      }
      return false;
    } catch (e) {
      debugPrintLevels(1, 'eliminarAviso exception: $e');
      return false;
    }
  }
}
