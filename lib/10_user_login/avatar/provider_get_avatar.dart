import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../60_global_widgets/debugprint.dart';
import 'data_user_avatar_get.dart';
import '../../40_security/direccionip.dart';
import '../../40_security/generate_hash.dart';
import 'dart:typed_data';

// Asumo que tienes imports para tus modelos (GetUserAvatar, RowGetUserAvatar, etc.)
// y funciones globales (generateSHA256Hash, direccionip, username, password).

// Importación necesaria para el generador
import 'package:riverpod_annotation/riverpod_annotation.dart';
// Este archivo será generado por build_runner

part 'provider_get_avatar.g.dart';

// Variables de estado simples (Considerar mover a otro provider si deben ser reactivas)
bool notAvatarSearch = true;
bool avatarLoaded = false;

// Objeto inicial inmutable
final GetUserAvatar initialGetUserAvatar = GetUserAvatar(
  totalRows: 0,
  offset: 0,
  rows: [
    RowGetUserAvatar(
      id: "",
      key: "",
      value: ValueGetUserAvatar(
        id: "",
        rev: "",
        idFoto: "",
        idUsuario: "",
        filaname: "",
        path: "",
        size: 0,
        identifier: "",
        avatar: "",
        contentType: "",
        timestamp: "",
      ),
    ),
  ],
);

@riverpod
class ClassUserAvatarNotifier extends _$ClassUserAvatarNotifier {
  @override
  GetUserAvatar build() {
    return initialGetUserAvatar;
  }

  // Actualiza el estado del avatar
  void setclassUserAvatarProvider(GetUserAvatar avatarUser) {
    state = avatarUser;
  }

  // Resetea el estado
  void resetclassUserAvatarProvider() {
    state = initialGetUserAvatar;
    debugPrintLevels(
      4,
      "1. resetclassUserAvatarProvider: ${state.rows[0].value.idFoto}",
    );
  }

  // Lógica para guardar archivo (Native Attachments)
  Future<int> guardaArchivoAvatar(PlatformFile file, String idUsuario) async {
    debugPrintLevels(4, 'HTTP guardaArchivoAvatar (Native Attachments)');

    try {
      String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
      String timestamp = DateTime.now().toString();
      String idFoto = generateSHA256Hash(idUsuario + file.name + timestamp);

      // Usamos el idFoto como documentId para CouchDB
      String encodedFilename = Uri.encodeComponent(file.name);
      String uploadUrl = '$direccionip/buscobien_avatares/$idFoto/$encodedFilename';

      List<int> fileBytes = await File(file.path!).readAsBytes();

      var response = await http.put(
        Uri.parse(uploadUrl),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': "image/jpeg", // O el mime detectado, usamos image/jpeg por defecto
        },
        body: fileBytes,
      );

      return response.statusCode;
    } catch (e) {
      debugPrintLevels(0, "Error en guardaArchivoAvatar: $e");
      return 500;
    }
  }

  // Recupera datos y actualiza el estado interno
  Future<int> recuperaDatosDelAvatar(String idUsuario) async {
    try {
      String encodedId = Uri.encodeComponent('"$idUsuario"');
      String baseUrl =
          '$direccionip/buscobien_avatares/_design/DDUSER/_view/vistaUserID?key=$encodedId';
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      var response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': "application/json",
        },
      );

      if (response.statusCode == 200) {
        GetUserAvatar data = getUserAvatarFromJson(response.body);
        if (data.rows.isNotEmpty) {
          state = data;
          // GUARDA AVATAR EN PROVIDER
        }
        return 200;
      }
      return response.statusCode;
    } catch (e) {
      debugPrintLevels(0, "Error recuperaDatosDelAvatar: $e");
      return 500;
    }
  }

  // Método auxiliar para obtener bytes
  Future<Uint8List> recuperaImagenDelAvatar(String idUsuario) async {
    await recuperaDatosDelAvatar(idUsuario);
    if (state.rows.isNotEmpty && state.rows[0].value.avatar.isNotEmpty) {
      return base64Decode(state.rows[0].value.avatar);
    }
    return Uint8List(0);
  }

  //------------------------------------------------------------------------------
  Future<int> updateUserAvatarFile(
    String recordId,
    String filePath,
    PlatformFile file,
    String rev,
    String idFoto,
    String idUsuario,
  ) async {
    // Actualizar el registro en CouchDB con la URL del archivo
    debugPrintLevels(4, 'HTTP updateUserAvatarFile (Native Attachments)');

    int statusCode = 0;
    String encodedFilename = Uri.encodeComponent(file.name);
    // Para Attachments nativos, mandamos PUT /db/docId/filename?rev=...
    String updateUrl = '$direccionip/buscobien_avatares/$recordId/$encodedFilename?rev=$rev';
    
    debugPrintLevels(4, "01 updateRecordWithFile updateUrl: $updateUrl");

    List<int> fileBytes = File(filePath).readAsBytesSync();

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, String> headers = {
      'Authorization': basicAuth,
      'Content-Type': "image/jpeg", // tipo de contenido binario
    };

    var response = await http.put(
      Uri.parse(updateUrl),
      headers: headers,
      body: fileBytes,
    );
    
    debugPrintLevels(4, "06 updateRecordWithFile response: $response");
    statusCode = response.statusCode;
    
    if (response.statusCode == 201) {
      debugPrintLevels(4, '07 updateRecordWithFile Archivo actualizado exitosamente de CouchDB. ${response.statusCode}');
    } else {
      debugPrintLevels(4, '08 updateRecordWithFile Error en la actualización de CouchDB.  ${response.statusCode}');
    }

    return statusCode;
  }
}

// Provider asíncrono generado para obtener la imagen directamente
@riverpod
Future<Uint8List> getAvatarImage(Ref ref, String idUsuario) async {
  // Este provider observa al notifier principal
  final notifier = ref.read(classUserAvatarProvider.notifier);
  return await notifier.recuperaImagenDelAvatar(idUsuario);
}

