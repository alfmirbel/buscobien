import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../08_pantallas/ubicacion/data_sepomex_localidades_get_cp.dart';
import '../40_security/api_client.dart';
import '../40_security/couch_http.dart' as http;
import '../40_security/direccionip.dart';
import 'data_user_localidad.dart';
import 'data_user_localidad_get.dart';

final localidadesRepositoryProvider = Provider<LocalidadesRepository>(
  (ref) => LocalidadesRepository(),
);

class LocalidadesRepository {
  LocalidadesRepository({ApiClient? api}) : _api = api ?? apiClient;

  final ApiClient _api;

  // ── Localidades del usuario (buscobien-api; solo el propio usuario) ────────

  /// Las localidades guardadas por el usuario con sesión. [userId] se conserva por compatibilidad:
  /// el servidor siempre responde con las del usuario del token.
  Future<UsuarioLocalidadesGet> fetchUserLocalidades(String userId) async {
    final vacio = UsuarioLocalidadesGet(totalRows: 0, offset: 0, rows: []);
    final r = await _api.get('/usuarios/me/localidades');
    final lista = r.data;
    if (!r.ok || lista is! List) return vacio;
    try {
      final filas = lista
          .whereType<Map<String, dynamic>>()
          .map((d) => {'id': d['id'], 'key': d['id_usuario'] ?? userId, 'value': d})
          .toList();
      return UsuarioLocalidadesGet.fromJson({'total_rows': filas.length, 'offset': 0, 'rows': filas});
    } catch (_) {
      return vacio;
    }
  }

  Future<UsuarioLocalidadesGet> fetchUserLocalidad(String userId, String asentamiento) async {
    final todas = await fetchUserLocalidades(userId);
    final coinciden = todas.rows.where((f) => f.value.localidadCp.asentamiento == asentamiento).toList();
    return UsuarioLocalidadesGet(totalRows: coinciden.length, offset: 0, rows: coinciden);
  }

  // Retorna: 200 guardado, 409 duplicado, 400/500 error
  Future<int> saveUserLocalidad(UsuarioLocalidades localidad) async {
    try {
      final existente = await fetchUserLocalidad(localidad.idUsuario, localidad.localidadCp.asentamiento);
      if (existente.rows.isNotEmpty) return 409;
      final r = await _api.post('/usuarios/me/localidades', cuerpo: localidad.toJson());
      if (r.status == 201) return 200;
      return r.sinRed ? 500 : 400;
    } catch (_) {
      return 500;
    }
  }

  Future<bool> deleteUserLocalidad(String id) async {
    final r = await _api.delete('/usuarios/me/localidades/${Uri.encodeComponent(id)}');
    return r.ok;
  }

  // ── Catálogo SEPOMEX (lectura pública, también sin iniciar sesión) ─────────

  Future<LocalidadesGet> fetchByCodigoPostal(int cp) async {
    final url = '$dbBaseUrl/codigospostales/_design/DDCP/_view/vistaCP?key=$cp';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return localidadesGetFromJson(utf8.decode(response.bodyBytes));
      }
    } catch (_) {}
    return LocalidadesGet(totalRows: 0, offset: 0, rows: []);
  }
}
