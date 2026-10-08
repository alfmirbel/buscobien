//------------------------------------------------------------------------------
//--- FUNCIONES FUERA DEL PROVIDER LISTAFOTOS ----------------------------------
//------------------------------------------------------------------------------
import 'dart:async'; // Necesario para Timeout y manejo de errores asíncronos
import 'dart:convert';
import 'dart:io'; // Necesario para SocketException
import 'dart:math';
import 'package:buscobien/22_imagenes/data_models/data_fotos_casa.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../07_routes/routes_parameters.dart';
import '../../../../40_security/direccionip.dart';
import '../../../../40_security/generate_hash.dart';
import '../../../../60_global_widgets/debugprint.dart';
import '../../../data_models/data_fotos_casa_get.dart';
import '../../../data_models/data_fotos_casa_get_ids.dart';
import '../datos_fotos/data_cuenta_fotos.dart';
import '../../image_file_structure.dart';
import '../datos_fotos/data_fotos_lista_fotos_iduser_idprop.dart';
import 'provider_get_fotos_ids_user_propiedad.dart';

//------------------------------------------------------------------------------
// OPTIMIZADO
//------------------------------------------------------------------------------
//--- FUNCIONES FUERA DEL PROVIDER LISTAFOTOS ----------------------------------
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
Future<int> deleteFotoPorIdFoto(String id, String rev) async {
  debugPrintLevels(9, "// HTTP deleteFotoPorIdFoto START");

  int resultado = 0;

  if (id == "") {
    debugPrintLevels(9, '// Error: ID vacío, no se puede borrar.');
    return 400; // Bad Request
  }

  // OPTIMIZACIÓN: Codificar parámetros URL
  String encodedRev = Uri.encodeQueryComponent(rev);
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/$id?rev=$encodedRev';

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json",
  };

  try {
    debugPrintLevels(9, "/// deleteFotoPorIdFoto Request: $baseUrl");

    var response = await http
        .delete(Uri.parse(baseUrl), headers: headers)
        .timeout(const Duration(seconds: 10));

    resultado = response.statusCode;

    debugPrintLevels(9, "/// deleteFotoPorIdFoto StatusCode: $resultado");

    if (response.statusCode == 200 ||
        response.statusCode == 202 ||
        response.statusCode == 404) {
      // 200/202: Borrado OK. 404: Ya no existe (lo cual es bueno si queríamos borrar).
      debugPrintLevels(9, '/// Operación de borrado finalizada.');
    } else {
      debugPrintLevels(9, '/// Error al borrar en CouchDB: ${response.body}');
    }
  } on SocketException {
    debugPrintLevels(9, '/// Error: Sin conexión a internet.');
    resultado = 503;
  } catch (e) {
    debugPrintLevels(9, '/// Error no controlado: $e');
    resultado = 500;
  }

  return resultado;
}

//------------------------------------------------------------------------------

Future<String> recuperaFotoPorIdFoto(String idFoto) async {
  debugPrintLevels(9, "// recuperaFotoPorIdFoto START");

  // OBJETO POR DEFECTO (VACÍO)
  // Se inicializa aquí para devolverlo en caso de error sin repetir código
  FotosCasaGet fotosCasa = FotosCasaGet(totalRows: 0, offset: 0, rows: []);

  if (idFoto == "") {
    debugPrintLevels(9, "// Error: idFoto vacío");
    return "";
  }

  // OPTIMIZACIÓN: Codificar la key para evitar errores de sintaxis URL
  String encodedKey = Uri.encodeComponent('"$idFoto"');
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDFOTO/_view/idFoto?key=$encodedKey';

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json",
  };

  try {
    debugPrintLevels(9, "// Request: $baseUrl");

    var response = await http
        .get(Uri.parse(baseUrl), headers: headers)
        .timeout(const Duration(seconds: 10));

    debugPrintLevels(9, "/// StatusCode: ${response.statusCode}");

    if (response.statusCode == 200) {
      fotosCasa = fotosCasaGetFromJson(response.body);

      if (fotosCasa.rows.isNotEmpty) {
        debugPrintLevels(
          9,
          "/// Foto encontrada. Tamaño: ${fotosCasa.rows[0].value.fotosCasa.foto.length}",
        );
        return fotosCasa.rows[0].value.fotosCasa.foto;
      } else {
        debugPrintLevels(
          9,
          '/// Consulta exitosa pero sin resultados (Lista vacía).',
        );
      }
    } else {
      debugPrintLevels(9, '// Error HTTP: ${response.statusCode}');
    }
  } catch (e) {
    debugPrintLevels(9, '// Error recuperando foto: $e');
  }

  // Si algo falla o no hay filas, retorna cadena vacía
  return "";
}

//recuperaObjetoFotoPorId

Future<FotosCasaClass> recuperaFotoCompletaPorIdFoto(String idFoto) async {
  debugPrintLevels(9, "// recuperaRegistroFotoPorIdFoto START");

  // OBJETO POR DEFECTO (VACÍO)
  // Se inicializa aquí para devolverlo en caso de error sin repetir código
  FotosCasaGet fotosCasa = FotosCasaGet(totalRows: 0, offset: 0, rows: []);

  FotosCasaClass datosFoto = FotosCasaClass(
    idFoto: "", // hash
    idUsuario: "", // hash
    idPropiedad: "", // hash
    foto: "",
    filaname: "",
    path: "",
    size: 0,
    identifier: "",
    contentType: "",
    timestamp: "",
  );

  if (idFoto == "") {
    debugPrintLevels(9, "// Error: idFoto vacío");
    return datosFoto;
  }

  // OPTIMIZACIÓN: Codificar la key para evitar errores de sintaxis URL
  String encodedKey = Uri.encodeComponent('"$idFoto"');
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDFOTO/_view/idFoto?key=$encodedKey';

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json",
  };

  try {
    debugPrintLevels(9, "// Request: $baseUrl");

    var response = await http
        .get(Uri.parse(baseUrl), headers: headers)
        .timeout(const Duration(seconds: 10));

    debugPrintLevels(9, "/// StatusCode: ${response.statusCode}");

    if (response.statusCode == 200) {
      fotosCasa = fotosCasaGetFromJson(response.body);

      if (fotosCasa.rows.isNotEmpty) {
        debugPrintLevels(
          9,
          "/// Foto encontrada. Tamaño: ${fotosCasa.rows[0].value.fotosCasa.foto.length}",
        );
        return fotosCasa.rows[0].value.fotosCasa;
      } else {
        debugPrintLevels(
          9,
          '/// Consulta exitosa pero sin resultados (Lista vacía).',
        );
      }
    } else {
      debugPrintLevels(9, '// Error HTTP: ${response.statusCode}');
    }
  } catch (e) {
    debugPrintLevels(9, '// Error recuperando foto: $e');
  }

  // Si algo falla o no hay filas, retorna cadena vacía
  return datosFoto;
}

//------------------------------------------------------------------------------

Future<CuentaFotos> numeroDeImagenesIdUserPropiedad(
  WidgetRef ref,
  String idUsuario,
  String idPropiedad,
) async {
  debugPrintLevels(9, "---- numeroDeImagenesIdUserPropiedad START");

  CuentaFotos numerodefotos = CuentaFotos(
    rows: [RowCuentaFotos(key: "", value: 0)],
  );

  // OPTIMIZACIÓN: Codificación segura del Array JSON en la URL
  String jsonKey = '["$idUsuario","$idPropiedad"]';
  String encodedKey = Uri.encodeComponent(jsonKey);

  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDUSPR/_view/cuentaFotos?key=$encodedKey';

  debugPrintLevels(9, "------------ URL: $baseUrl");

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json",
  };

  try {
    var response = await http
        .get(Uri.parse(baseUrl), headers: headers)
        .timeout(const Duration(seconds: 10));

    debugPrintLevels(9, "02 StatusCode: ${response.statusCode}");

    if (response.statusCode == 200) {
      numerodefotos = cuentaFotosFromJson(response.body);

      if (numerodefotos.rows.isEmpty) {
        // Restaurar valor por defecto seguro si viene vacío
        numerodefotos = CuentaFotos(rows: [RowCuentaFotos(key: "", value: 0)]);
        debugPrintLevels(9, 'Lista vacía en CouchDB (0 fotos).');
      } else {
        debugPrintLevels(
          9,
          "Cantidad de fotos: ${numerodefotos.rows[0].value}",
        );
      }
    } else {
      debugPrintLevels(9, 'Error HTTP: ${response.statusCode}');
    }
  } catch (e) {
    debugPrintLevels(9, 'Error en numeroDeImagenesIdUserPropiedad: $e');
  }

  debugPrintLevels(9, "---- numeroDeImagenesIdUserPropiedad END");
  return numerodefotos;
}

//------------------------------------------------------------------------------

Future<ResultadoGuardaFoto> guardaFotoEnFotosDeLaPropiedad(
  PlatformFileNoFinal platformFile,
  String fileContent,
  String idUsuario,
  String idPropiedad,
) async {
  debugPrintLevels(10, "HTTP guardaFotoDeLaPropiedad START");

  ResultadoGuardaFoto resultado = ResultadoGuardaFoto(
    statusCode: 0,
    idFoto: "",
  );

  String uploadUrl = '$direccionip/buscobien_propiedades_casas_fotos';
  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  String timestamp = DateTime.now().toString();

  // Generación de ID único
  resultado.idFoto = generateSHA256Hash(
    idUsuario +
        platformFile.name +
        timestamp +
        Random().nextInt(999).toString(),
  );

  debugPrintLevels(
    10,
    "01 Uploading: ${platformFile.name} Size: ${platformFile.size}",
  );

  Map<String, dynamic> attachmentData = {
    "fotosCasa": {
      "idFoto": resultado.idFoto,
      "idUsuario": idUsuario,
      "idPropiedad": idPropiedad,
      "filaname": platformFile.name,
      "path": platformFile.path,
      "size": platformFile.size,
      "identifier": platformFile.identifier,
      "foto": fileContent,
      "content_type":
          "image/jpg", // Asegúrate de que esto sea dinámico si soportas PNG
      "timestamp": timestamp,
    },
  };

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json",
  };

  try {
    String jsonContent = jsonEncode(attachmentData);

    // OPTIMIZACIÓN: Timeout aumentado para subida de archivos
    var response = await http
        .post(Uri.parse(uploadUrl), headers: headers, body: jsonContent)
        .timeout(const Duration(seconds: 30));

    resultado.statusCode = response.statusCode;

    if (resultado.statusCode == 201) {
      debugPrintLevels(
        9,
        '07 Foto guardada exitosamente. Id: ${resultado.idFoto}',
      );
    } else {
      debugPrintLevels(
        9,
        '09 Error al guardar. Code: ${resultado.statusCode}. Body: ${response.body}',
      );
      resultado.idFoto = ""; // Limpiar ID si falló
    }
  } catch (e) {
    debugPrintLevels(9, 'Error Excepción al guardar foto: $e');
    resultado.statusCode = 500;
    resultado.idFoto = "";
  }

  return resultado;
}

//------------------------------------------------------------------------------

Future<FotosCasaGetIDs> recuperaFotosDePropiedadesSkipLimit(
  WidgetRef ref,
  String idUsuario,
  String idPropiedad,
  int skip,
  int limit,
) async {
  FotosCasaGetIDs listaDeFotosRecuperadas = FotosCasaGetIDs(
    totalRows: 0,
    offset: 0,
    rows: [],
  );

  // OPTIMIZACIÓN: Codificación segura
  String jsonKey = '["$idUsuario","$idPropiedad"]';
  String encodedKey = Uri.encodeComponent(jsonKey);

  // CORRECCIÓN: Se eliminó el doble ']]' que había en el código original
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDUSPR/_view/userproperty?key=$encodedKey&skip=$skip&limit=$limit';

  debugPrintLevels(7, "URL SkipLimit: $baseUrl");

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json",
  };

  try {
    var response = await http
        .get(Uri.parse(baseUrl), headers: headers)
        .timeout(const Duration(seconds: 10));

    debugPrintLevels(7, "StatusCode SkipLimit: ${response.statusCode}");

    if (response.statusCode == 200) {
      listaDeFotosRecuperadas = FotosCasaGetIDs.fromJson(
        jsonDecode(response.body),
      );
      debugPrintLevels(
        6,
        "FOTOS RECUPERADAS: ${listaDeFotosRecuperadas.rows.length}",
      );

      if (listaDeFotosRecuperadas.rows.isEmpty) {
        debugPrintLevels(7, 'Sin fotos en CouchDB (Lista vacía).');
      }
    } else {
      debugPrintLevels(7, 'Error HTTP: ${response.statusCode}');
    }
  } catch (e) {
    debugPrintLevels(7, 'Error recuperaFotosDePropiedadesSkipLimit: $e');
  }

  return listaDeFotosRecuperadas;
}

//------------------------------------------------------------------------------

Future<int> recuperaFotosDePropiedades(
  WidgetRef ref,
  String idUsuario,
  String idPropiedad,
) async {
  debugPrintLevels(7, "HTTP recuperaFotosDePropiedades START");
  int statusCode = 0;

  String jsonKey = '["$idUsuario","$idPropiedad"]';
  String encodedKey = Uri.encodeComponent(jsonKey);
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDUSPR/_view/userproperty?key=$encodedKey';

  debugPrintLevels(7, "URL: $baseUrl");

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json",
  };

  try {
    var response = await http
        .get(Uri.parse(baseUrl), headers: headers)
        .timeout(const Duration(seconds: 10));

    statusCode = response.statusCode;
    debugPrintLevels(7, "StatusCode: $statusCode");

    if (response.statusCode == 200) {
      FotosCasaGetIDs listaFotos = FotosCasaGetIDs.fromJson(
        jsonDecode(response.body),
      );

      // Actualizamos el Provider
      ref
          .read(getListaFotosCasaProviderId.notifier)
          .setListaDeFotosPropiedad(listaFotos);

      // Verificamos la longitud después de actualizar
      int lengthListaFotos = ref
          .read(getListaFotosCasaProviderId.notifier)
          .getLengthListaDeFotosPropiedad();
      debugPrintLevels(
        6,
        "NUMERO DE FOTOS RECUPERADAS (Provider): $lengthListaFotos",
      );

      if (listaFotos.rows.isEmpty) {
        debugPrintLevels(7, 'Lista vacía recibida.');
        // Mantengo lógica original de retornar 500 si no hay fotos, aunque 200 es más estándar
        statusCode = 500;
      }
    } else {
      debugPrintLevels(7, 'Error HTTP: ${response.statusCode}');
    }
  } on SocketException {
    statusCode = 503;
    debugPrintLevels(7, 'Error: Sin conexión.');
  } catch (e) {
    statusCode = 500;
    debugPrintLevels(7, 'Error Excepción: $e');
  }

  return statusCode;
}

//------------------------------------------------------------------------------

Future<ListaFotosIdsPropiedadGet> getListaIdsFotosByIdUserIdPropiedad(
  WidgetRef ref,
  String idUsuario,
  String idPropiedad,
) async {
  debugPrintLevels(7, "HTTP getListaIdsFotosByIdUserIdPropiedad START");

  ListaFotosIdsPropiedadGet listaOrdenFotos = ListaFotosIdsPropiedadGet(
    totalRows: 0,
    offset: 0,
    rows: [],
  );

  String jsonKey = '["$idUsuario","$idPropiedad"]';
  String encodedKey = Uri.encodeComponent(jsonKey);
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDUSPR/_view/idUserPropiedadFoto?key=$encodedKey';

  debugPrintLevels(7, "URL: $baseUrl");

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json",
  };

  try {
    var response = await http
        .get(Uri.parse(baseUrl), headers: headers)
        .timeout(const Duration(seconds: 10));

    debugPrintLevels(7, "StatusCode: ${response.statusCode}");

    if (response.statusCode == 200) {
      listaOrdenFotos = ListaFotosIdsPropiedadGet.fromJson(
        jsonDecode(response.body),
      );

      debugPrintLevels(
        6,
        "NUMERO DE FOTOS RECUPERADAS: ${listaOrdenFotos.rows.length}",
      );

      if (listaOrdenFotos.rows.isEmpty) {
        debugPrintLevels(7, 'Sin fotos en CouchDB.');
      }
    } else {
      debugPrintLevels(7, 'Error HTTP: ${response.statusCode}');
    }
  } catch (e) {
    debugPrintLevels(7, 'Error Excepción: $e');
  }

  return listaOrdenFotos;
}

//------------------------------------------------------------------------------

Future<ListaFotosIdsPropiedadGet> getListaIdsFotosByIdPropiedad(
  WidgetRef ref,
  String idPropiedad,
) async {
  debugPrintLevels(7, "HTTP getListaIdsFotosByIdPropiedad START");

  ListaFotosIdsPropiedadGet listaIdsFotos = ListaFotosIdsPropiedadGet(
    totalRows: 0,
    offset: 0,
    rows: [],
  );

  String encodedKey = Uri.encodeComponent('"$idPropiedad"');
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDFOTO/_view/idFotoIdPropiedad?key=$encodedKey';

  debugPrintLevels(7, "URL: $baseUrl");

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json",
  };

  try {
    var response = await http
        .get(Uri.parse(baseUrl), headers: headers)
        .timeout(const Duration(seconds: 10));

    debugPrintLevels(7, "StatusCode: ${response.statusCode}");

    if (response.statusCode == 200) {
      listaIdsFotos = ListaFotosIdsPropiedadGet.fromJson(
        jsonDecode(response.body),
      );
      debugPrintLevels(6, "FOTOS RECUPERADAS: ${listaIdsFotos.rows.length}");

      if (listaIdsFotos.rows.isEmpty) {
        debugPrintLevels(7, 'Sin fotos en CouchDB.');
      }
    } else {
      debugPrintLevels(7, 'Error HTTP: ${response.statusCode}');
    }
  } catch (e) {
    debugPrintLevels(7, 'Error Excepción: $e');
  }

  return listaIdsFotos;
}

//------------ COMENTADO

//------------ COMENTADO
