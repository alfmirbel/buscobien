import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../40_security/direccionip.dart';
import '../../60_global_widgets/debugprint.dart';
import '../data_models/data_get_user.dart';
import '../data_models/data_get_id_user_pass.dart';

part 'session_repository.g.dart';

class SessionRepository {
  /// Obtiene los datos del usuario por nombre. Devuelve el código de estado HTTP y los datos si fue exitoso.
  Future<(int, GetUserData?)> getUserDataByName({
    required String userName,
    required String nombrePerfil,
    required Map<String, String> authHeaders,
  }) async {
    debugPrintLevels(0, "HTTP getUserDataByName");
    int resultado = 0;

    String database = (nombrePerfil == "Promotor")
        ? "buscobien_usuarios_promotores"
        : "buscobien_usuarios";

    String encodedKey = Uri.encodeComponent('"$userName"');
    String url =
        '$direccionip/$database/_design/DDUSER/_view/vistaNOMBRE?key=$encodedKey';

    debugPrintLevels(0, "<<< HTTP getUserDataByName headers: $authHeaders >>>");

    try {
      final response = await http.get(Uri.parse(url), headers: authHeaders);

      if (response.statusCode == 200) {
        var responseBody = utf8.decode(response.bodyBytes);
        GetUserData userData = getUserDataFromJson(responseBody);

        if (userData.rows.isEmpty) {
          resultado = 201;
        } else {
          resultado = 401; // Lógica heredada
        }
        return (resultado, userData);
      } else {
        return (501, null);
      }
    } catch (e) {
      debugPrintLevels(0, ">> Exception: $e");
      return (500, null);
    }
  }

  /// Recupera ID y Contraseña pero consultando la vista por ID
  Future<(int, GetIdUserPass?)> getUserIdNamePassByNameID({
    required String userId,
    required bool esPromotor,
    required Map<String, String> authHeaders,
  }) async {
    debugPrintLevels(0, 'HTTP getUserIdNamePassByNameID');

    String database = esPromotor
        ? "buscobien_usuarios_promotores"
        : "buscobien_usuarios";

    String encodedKey = Uri.encodeComponent('"$userId"');
    String url =
        '$direccionip/$database/_design/DDUSER/_view/vistaUserID?key=$encodedKey';

    try {
      final response = await http.get(Uri.parse(url), headers: authHeaders);

      if (response.statusCode == 200) {
        var responseBody = utf8.decode(response.bodyBytes);
        GetIdUserPass idUserPass = getIdUserPassFromJson(responseBody);
        return (response.statusCode, idUserPass);
      } else {
        return (response.statusCode, null);
      }
    } catch (e) {
      debugPrintLevels(0, "Error: $e");
      return (500, null);
    }
  }
}

@riverpod
SessionRepository sessionRepository(Ref ref) {
  return SessionRepository();
}
