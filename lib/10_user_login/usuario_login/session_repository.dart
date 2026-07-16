import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../40_security/direccionip.dart';
import '../../40_security/generate_hash.dart';
import '../../60_global_widgets/debugprint.dart';
import '../data_models/data_get_user.dart';
import '../data_models/data_get_id_user_pass.dart';
import '../data_models/data_usuarios.dart';

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

  /// Recupera el ID, Nombre y Contraseña por nombre de usuario
  Future<(int, GetIdUserPass?)> getUserIdNamePassByName({
    required String userName,
    required String nombrePerfil,
    required Map<String, String> authHeaders,
  }) async {
    debugPrintLevels(0, "HTTP getUserIdNamePassByName");

    String database = (nombrePerfil == "Promotor")
        ? "buscobien_usuarios_promotores"
        : "buscobien_usuarios";

    String url =
        '$direccionip/$database/_design/DDUSER/_view/vistaIdUserPassByNAME?key="$userName"';
        
    debugPrintLevels(0, "HTTP getUserIdNamePassByName url: $url");
    try {
      final response = await http.get(Uri.parse(url), headers: authHeaders);
      debugPrintLevels(0, "HTTP getUserIdNamePassByName status: ${response.statusCode}");

      if (response.statusCode == 200) {
        var responseBody = utf8.decode(response.bodyBytes);
        GetIdUserPass idUserPass = getIdUserPassFromJson(responseBody);

        if (idUserPass.rows.isEmpty) {
          debugPrintLevels(0, ">>> 6. Usuario no existente");
          return (501, idUserPass);
        } else {
          return (200, idUserPass);
        }
      } else {
        return (response.statusCode, null);
      }
    } catch (e) {
      debugPrintLevels(0, "Error: $e");
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

  /// Escribe un nuevo usuario en la base de datos CouchDB
  Future<int> writeUserToCouchDB({
    required Usuario nvoUsuario,
    required bool esPromotor,
    required Map<String, String> authHeaders,
  }) async {
    debugPrintLevels(0, "HTTP writeUserToCouchDB: ${nvoUsuario.nombreusuario}");
    int resultado = 0;

    try {
      DateTime timeStamp = DateTime.now();
      nvoUsuario.timestamp = timeStamp.toString();

      nvoUsuario.idUsuario = generateSHA256Hash(
        nvoUsuario.nombreusuario +
            nvoUsuario.claveacceso +
            nvoUsuario.timestamp,
      );
      nvoUsuario.claveacceso = generateSHA256Hash(nvoUsuario.claveacceso);

      String dbName = esPromotor
          ? "buscobien_usuarios_promotores"
          : "buscobien_usuarios";
      
      debugPrintLevels(0, "HTTP writeUserToCouchDB dbName: $dbName");

      String encodedKey = Uri.encodeComponent('"${nvoUsuario.nombreusuario}"');
      String checkUrl =
          '$direccionip/$dbName/_design/DDUSER/_view/vistaNOMBRE?key=$encodedKey';

      // 1. Verificar si existe
      final checkResponse = await http.get(
        Uri.parse(checkUrl),
        headers: authHeaders,
      );

      if (checkResponse.statusCode == 200) {
        var checkBody = utf8.decode(checkResponse.bodyBytes);
        var existingData = getUserDataFromJson(checkBody);

        if (existingData.rows.isNotEmpty) {
          debugPrintLevels(0, ">> El usuario ya existe.");
          return 501;
        }
      }

      // 2. Proceder al Alta
      debugPrintLevels(0, ">> Creando usuario nuevo...");

      Map<String, dynamic> userMap = {"usuario": nvoUsuario.toJson()};
      String usuarioDB = jsonEncode(userMap);
      String postUrl = '$direccionip/$dbName';

      final postResponse = await http.post(
        Uri.parse(postUrl),
        headers: authHeaders,
        body: usuarioDB,
      );

      resultado = postResponse.statusCode;
      if (postResponse.statusCode == 201) {
        debugPrintLevels(0, '>> Éxito: Usuario creado.');
      } else {
        debugPrintLevels(0, '>> Error CouchDB: ${postResponse.statusCode}');
      }
    } catch (e) {
      debugPrintLevels(1, ">> Error Excepción Write: $e");
      resultado = 500;
    }

    return resultado;
  }
}

@riverpod
SessionRepository sessionRepository(Ref ref) {
  return SessionRepository();
}
