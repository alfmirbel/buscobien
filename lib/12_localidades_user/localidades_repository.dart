import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../08_pantallas/ubicacion/data_sepomex_localidades_get_cp.dart';
import '../40_security/direccionip.dart';
import 'data_user_localidad.dart';
import 'data_user_localidad_get.dart';

final localidadesRepositoryProvider = Provider<LocalidadesRepository>(
  (ref) => LocalidadesRepository(),
);

class LocalidadesRepository {
  Map<String, String> get _headers {
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    return {'Authorization': basicAuth, 'Content-Type': 'application/json'};
  }

  // ── Usuario localidades ────────────────────────────────────────────────────

  Future<UsuarioLocalidadesGet> fetchUserLocalidades(String userId) async {
    final encodedKey = Uri.encodeComponent('"$userId"');
    final url =
        '$direccionip/buscobien_user_localidad/_design/DDUL/_view/vistaUserID?key=$encodedKey';
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      if (response.statusCode == 200) {
        return usuarioLocalidadesGetFromJson(utf8.decode(response.bodyBytes));
      }
    } catch (_) {}
    return UsuarioLocalidadesGet(totalRows: 0, offset: 0, rows: []);
  }

  Future<UsuarioLocalidadesGet> fetchUserLocalidad(
    String userId,
    String asentamiento,
  ) async {
    final url =
        '$direccionip/buscobien_user_localidad/_design/DDUL/_view/vistaUserAsentamiento'
        '?key=["${Uri.encodeComponent(userId)}","${Uri.encodeComponent(asentamiento)}"]';
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      if (response.statusCode == 200) {
        return usuarioLocalidadesGetFromJson(utf8.decode(response.bodyBytes));
      }
    } catch (_) {}
    return UsuarioLocalidadesGet(totalRows: 0, offset: 0, rows: []);
  }

  // Retorna: 200 guardado, 409 duplicado, 400/500 error
  Future<int> saveUserLocalidad(UsuarioLocalidades localidad) async {
    try {
      final existente = await fetchUserLocalidad(
        localidad.idUsuario,
        localidad.localidadCp.asentamiento,
      );
      if (existente.rows.isNotEmpty) return 409;

      final body = json.encode(localidad.toJson());
      final url = '$direccionip/buscobien_user_localidad';
      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: body,
      );
      return response.statusCode == 201 ? 200 : 400;
    } catch (_) {
      return 500;
    }
  }

  Future<bool> deleteUserLocalidad(String id) async {
    final getUrl = '$direccionip/buscobien_user_localidad/$id';
    try {
      final getResponse = await http.get(Uri.parse(getUrl), headers: _headers);
      if (getResponse.statusCode == 200) {
        final doc = json.decode(utf8.decode(getResponse.bodyBytes));
        final rev = doc['_rev'];
        if (rev != null) {
          final deleteUrl = '$direccionip/buscobien_user_localidad/$id?rev=$rev';
          final deleteResponse = await http.delete(Uri.parse(deleteUrl), headers: _headers);
          return deleteResponse.statusCode == 200;
        }
      }
    } catch (_) {}
    return false;
  }

  // ── Catálogo SEPOMEX ───────────────────────────────────────────────────────

  Future<LocalidadesGet> fetchByCodigoPostal(int cp) async {
    final url =
        '$direccionip/codigospostales/_design/DDCP/_view/vistaCP?key=$cp';
    try {
      final response = await http.get(Uri.parse(url), headers: _headers);
      if (response.statusCode == 200) {
        return localidadesGetFromJson(utf8.decode(response.bodyBytes));
      }
    } catch (_) {}
    return LocalidadesGet(totalRows: 0, offset: 0, rows: []);
  }
}
