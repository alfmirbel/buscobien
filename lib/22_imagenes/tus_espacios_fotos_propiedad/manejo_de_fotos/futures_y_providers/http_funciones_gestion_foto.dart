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

/*
Future<ResultadoGuardaFoto> updateFotoDeLaPropiedad(PlatformFile platformFile,
    String fileContent, String idUsuario, String idPropiedad) async {
  // debugPrintLevels(10, "-----------------------------------------------------");
  /*
    FotosCasaClass registroGuardado = FotosCasaClass(
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
    */
  debugPrintLevels(10, "HTTP guardaFotoDeLaPropiedad");
  /*
  PlatformFile platformFile = PlatformFile(
    name: "",
    path: "",
    bytes: null,
    size: 0,
    identifier: "",
    readStream: null,
  );
  */
  // Subir el archivo al servidor CouchDB
  ResultadoGuardaFoto resultado = ResultadoGuardaFoto(
    statusCode: 0,
    idFoto: "",
  );
  // ignore: unused_local_variable
  String uploadUrl = '$direccionip/buscobien_propiedades_casas_fotos';

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  String timestamp = DateTime.now().toString();

  resultado.idFoto = generateSHA256Hash(idUsuario +
      platformFile.name +
      timestamp +
      Random().nextInt(999).toString());

  debugPrintLevels(10, "01 guardaFotoPropiedad uploadUrl: $uploadUrl");
  debugPrintLevels(10, "02 guardaFotoPropiedad filePath: ${platformFile.path}");
  debugPrintLevels(10, "03 guardaFotoPropiedad size: ${platformFile.size}");
  debugPrintLevels(
      10, "04 guardaFotoPropiedad fileName : ${platformFile.name}");

  // Crear el objeto de datos a adjuntar al documento
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
      "content_type": "image/jpg",
      "timestamp": timestamp
    },
  };

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json", // tipo de contenido
  };

  String jsonContent = jsonEncode(attachmentData);
  debugPrintLevels(10, "05 guardaFotoPropiedad jsonContent");
  //String jsonContent = jsonEncode({"fileContent": fileContent});

  // GUARDA FOTO DE LA PROPIEDAD
  var response = await http.post(Uri.parse(uploadUrl),
      headers: headers, body: jsonContent);

  //debugPrintLevels(9,
  //    "06 guardaFotoPropiedad response statusCode: ${response.statusCode}");
  resultado.statusCode = response.statusCode;
  // resultado.statusCode = 201;

  if (resultado.statusCode == 201) {
    //   registroGuardado = fotosCasaFromJson(response.body);
    debugPrintLevels(9,
        '07 guardaFotoPropiedad Archivo adjuntado exitosamente al documento en CouchDB. Id: ${resultado.idFoto}');
  } else {
    resultado.idFoto = "";
    debugPrintLevels(9,
        '09 guardaFotoPropiedad Error al adjuntar el archivo al documento en CouchDB. Código de estado: ${resultado.statusCode}');
  }
  return resultado;
}
*/
//------------ COMENTADO
/*
//------------------------------------------------------------------------------
Future<int> deleteFotoPorIdFoto(String id, String rev) async {
  debugPrintLevels(9, "// HTTP deleteFotoPorIdFoto");
  // debugPrintLevels(9, "////////////////////////////");
  // https://citigov.cloud:6984/buscobien_propiedades_casas_fotos/02167bd73a2e8bc29ec1830c9766edc1
  // URL de tu servidor CouchDB
  int resultado = 0;
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/$id?rev=$rev';
  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json", // tipo de contenido
  };
  if (id != "") {
    debugPrintLevels(9, "/// deleteFotoPorIdFoto01 borra foto $baseUrl");

    var response = await http.delete(Uri.parse(baseUrl), headers: headers);
    debugPrintLevels(
      9,
      "/// 02 deleteFotoPorIdFoto01 Get documento con archivo ${response.statusCode}",
    );
    resultado = response.statusCode;
    if (response.statusCode == 200) {
      debugPrintLevels(9, '/// Sin Archivo en CouchDB.');
    } else {
      debugPrintLevels(9, '/// Sin Archivo en CouchDB.');
    }
  } else {
    debugPrintLevels(
      9,
      '// Error al deleteFotoPorIdFoto01 el archivo imagen de CouchDB. Código de estado: $resultado',
    );
  }
  //Navigator.of(context).pop(resultado);
  return resultado;
}

//------------------------------------------------------------------------------

Future<String> recuperaFotoPorIdFoto(String idFoto) async {
  // Realizar la solicitud HTTP GET para recuperar el archivo adjunto
  // debugPrintLevels(9, "////////////////////////////");
  debugPrintLevels(9, "// recuperaFotoPorIdFoto");
  // debugPrintLevels(9, "////////////////////////////");

  FotosCasaGet fotosCasa = FotosCasaGet(
    totalRows: 0,
    offset: 0,
    rows: [
      RowFotosCasaGet(
        id: "",
        key: "",
        value: ValueFotosCasaGet(
          id: "",
          rev: "",
          fotosCasa: FotosCasaClass(
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
          ),
        ),
      ),
    ],
  );
  // URL de tu servidor CouchDB
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDFOTO/_view/idFoto?key="$idFoto"';
  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json", // tipo de contenido
  };
  if (idFoto != "") {
    debugPrintLevels(9, "// 01 recuperar id foto principal $baseUrl");

    var response = await http.get(Uri.parse(baseUrl), headers: headers);
    debugPrintLevels(
      9,
      "/// 02 recuperarArchivoAdjunto Get documento con archivo ${response.statusCode}",
    );

    if (response.statusCode == 200) {
      // Decodificar el contenido del archivo recuperado
      fotosCasa = fotosCasaGetFromJson(response.body);

      if (fotosCasa.rows.isNotEmpty) {
        debugPrintLevels(
          9,
          "/// 04 foto ${fotosCasa.rows[0].value.fotosCasa.foto.length}",
        );
        debugPrintLevels(
          9,
          '/// Foto recuperada exitosamente de CouchDB.idFoto: ${fotosCasa.rows[0].value.fotosCasa.idFoto}',
        );
      } else {
        debugPrintLevels(9, '/// Sin Archivo en CouchDB.');
        fotosCasa = FotosCasaGet(
          totalRows: 0,
          offset: 0,
          rows: [
            RowFotosCasaGet(
              id: "",
              key: "",
              value: ValueFotosCasaGet(
                id: "",
                rev: "",
                fotosCasa: FotosCasaClass(
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
                ),
              ),
            ),
          ],
        );
      }
    } else {
      fotosCasa = FotosCasaGet(
        totalRows: 0,
        offset: 0,
        rows: [
          RowFotosCasaGet(
            id: "",
            key: "",
            value: ValueFotosCasaGet(
              id: "",
              rev: "",
              fotosCasa: FotosCasaClass(
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
              ),
            ),
          ),
        ],
      );
      debugPrintLevels(
        9,
        '// Error al recuperar el archivo imagen de CouchDB. Código de estado: ${response.statusCode}',
      );
    }
  } else {
    debugPrintLevels(9, "// 01 recuperar id foto principal vacio");
    fotosCasa = FotosCasaGet(
      totalRows: 0,
      offset: 0,
      rows: [
        RowFotosCasaGet(
          id: "",
          key: "",
          value: ValueFotosCasaGet(
            id: "",
            rev: "",
            fotosCasa: FotosCasaClass(
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
            ),
          ),
        ),
      ],
    );
  }
  debugPrintLevels(9, "// recuperaFotoPorIdFoto end");
  // debugPrintLevels(9, "////////////////////////////");
  return fotosCasa.rows[0].value.fotosCasa.foto;
}
//------------------------------------------------------------------------------

Future<CuentaFotos> numeroDeImagenesIdUserPropiedad(
  WidgetRef ref,
  String idUsuario,
  String idPropiedad,
) async {
  // Realizar la solicitud HTTP GET para recuperar el archivo adjunto
  // debugPrintLevels(9, "------------------------------------------------");
  debugPrintLevels(9, "---- numeroDeImagenesIdUserPropiedad");
  // debugPrintLevels(9, "------------------------------------------------");

  CuentaFotos numerodefotos = CuentaFotos(
    rows: [RowCuentaFotos(key: "", value: 0)],
  );

  // URL de tu servidor CouchDB
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDUSPR/_view/cuentaFotos?key=["$idUsuario","$idPropiedad"]';
  debugPrintLevels(
    9,
    "------------ numeroDeImagenesIdUserPropiedad Get documento: $baseUrl",
  );
  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json", // tipo de contenido
  };

  var response = await http.get(Uri.parse(baseUrl), headers: headers);

  debugPrintLevels(
    9,
    "02 recuperarArchivoAdjunto statusCode ${response.statusCode}",
  );

  if (response.statusCode == 200) {
    // Decodificar el contenido del archivo recuperado
    numerodefotos = cuentaFotosFromJson(response.body);
    debugPrintLevels(
      9,
      "02 recuperarArchivoAdjunto rows empty: ${numerodefotos.rows.isEmpty}",
    );
    if (numerodefotos.rows.isEmpty) {
      numerodefotos = CuentaFotos(rows: [RowCuentaFotos(key: "", value: 0)]);
      debugPrintLevels(9, 'No se encontraron Archivos en CouchDB.');
    } else {
      debugPrintLevels(
        9,
        "02 recuperarArchivoAdjunto numero de fotos: ${numerodefotos.rows[0].value}",
      );
    }
  } else {
    debugPrintLevels(
      9,
      'Error al recuperar lista de imagenes CouchDB. Código de estado: ${response.statusCode}',
    );
  }
  //  debugPrintLevels(9, "------------------------------------------------");
  debugPrintLevels(9, "---- numeroDeImagenesIdUserPropiedad end");
  //  debugPrintLevels(9, "------------------------------------------------");
  return numerodefotos;
}
//------------------------------------------------------------------------------

Future<ResultadoGuardaFoto> guardaFotoEnFotosDeLaPropiedad(
  PlatformFileNoFinal platformFile,
  String fileContent,
  String idUsuario,
  String idPropiedad,
) async {
  // debugPrintLevels(10, "-----------------------------------------------------");
  /*
    FotosCasaClass registroGuardado = FotosCasaClass(
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
    */
  debugPrintLevels(10, "HTTP guardaFotoDeLaPropiedad");
  /*
  PlatformFile platformFile = PlatformFile(
    name: "",
    path: "",
    bytes: null,
    size: 0,
    identifier: "",
    readStream: null,
  );
  */
  // Subir el archivo al servidor CouchDB
  ResultadoGuardaFoto resultado = ResultadoGuardaFoto(
    statusCode: 0,
    idFoto: "",
  );
  // ignore: unused_local_variable
  String uploadUrl = '$direccionip/buscobien_propiedades_casas_fotos';

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  String timestamp = DateTime.now().toString();

  resultado.idFoto = generateSHA256Hash(
    idUsuario +
        platformFile.name +
        timestamp +
        Random().nextInt(999).toString(),
  );

  debugPrintLevels(10, "01 guardaFotoPropiedad uploadUrl: $uploadUrl");
  debugPrintLevels(10, "02 guardaFotoPropiedad filePath: ${platformFile.path}");
  debugPrintLevels(10, "03 guardaFotoPropiedad size: ${platformFile.size}");
  debugPrintLevels(
    10,
    "04 guardaFotoPropiedad fileName : ${platformFile.name}",
  );

  // Crear el objeto de datos a adjuntar al documento
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
      "content_type": "image/jpg",
      "timestamp": timestamp,
    },
  };

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json", // tipo de contenido
  };

  String jsonContent = jsonEncode(attachmentData);
  debugPrintLevels(10, "05 guardaFotoPropiedad jsonContent");
  //String jsonContent = jsonEncode({"fileContent": fileContent});

  // GUARDA FOTO DE LA PROPIEDAD
  var response = await http.post(
    Uri.parse(uploadUrl),
    headers: headers,
    body: jsonContent,
  );

  //debugPrintLevels(9,
  //    "06 guardaFotoPropiedad response statusCode: ${response.statusCode}");
  resultado.statusCode = response.statusCode;
  // resultado.statusCode = 201;

  if (resultado.statusCode == 201) {
    //   registroGuardado = fotosCasaFromJson(response.body);
    debugPrintLevels(
      9,
      '07 guardaFotoPropiedad Archivo adjuntado exitosamente al documento en CouchDB. Id: ${resultado.idFoto}',
    );
  } else {
    resultado.idFoto = "";
    debugPrintLevels(
      9,
      '09 guardaFotoPropiedad Error al adjuntar el archivo al documento en CouchDB. Código de estado: ${resultado.statusCode}',
    );
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
  // Realizar la solicitud HTTP GET para recuperar el archivo adjunto
  int statusCode = 0;
  FotosCasaGetIDs listaDeFotosRecuperadas = FotosCasaGetIDs(
    totalRows: 0,
    offset: 0,
    rows: [
      RowFotosCasaGetIDs(
        id: "",
        key: ["", ""],
        value: ValueFotosCasaGetIDs(
          id: "",
          rev: "",
          fotosCasa: FotosCasaClass(
            idFoto: "", // hash
            idUsuario: "", // hash
            foto: "",
            idPropiedad: "", // hash
            filaname: "",
            path: "",
            size: 0,
            identifier: "",
            contentType: "",
            timestamp: "",
          ),
        ),
      ),
    ],
  );

  // URL de tu servidor CouchDB
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDUSPR/_view/userproperty?key=["$idUsuario","$idPropiedad"]]&skip=$skip&limit=$limit';
  debugPrintLevels(7, "URL DE FOTOS RECUPERADAS: $baseUrl");

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json", // tipo de contenido
  };

  var response = await http.get(Uri.parse(baseUrl), headers: headers);
  statusCode = response.statusCode;

  debugPrintLevels(7, " statusCode DE FOTOS RECUPERADAS: $statusCode");

  if (response.statusCode == 200) {
    // Decodificar el contenido del archivo recuperado
    listaDeFotosRecuperadas = FotosCasaGetIDs.fromJson(
      jsonDecode(response.body),
    );

    if (response.statusCode == 200) {
      debugPrintLevels(
        6,
        "NUMERO DE FOTOS RECUPERADAS: ${listaDeFotosRecuperadas.rows.length}",
      );
      statusCode = listaDeFotosRecuperadas.rows.length;

      if (listaDeFotosRecuperadas.rows.isEmpty) {
        debugPrintLevels(7, 'Sin fotos en CouchDB.');
        statusCode = 500;
      }
    } else {
      debugPrintLevels(7, 'Archivos recuperado exitosamente de CouchDB.');
    }
  } else {
    debugPrintLevels(
      7,
      'Error al recuperar el archivo adjunto de CouchDB. Código de estado: ${response.statusCode}',
    );
  }
  return listaDeFotosRecuperadas;
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

Future<int> recuperaFotosDePropiedades(
  WidgetRef ref,
  String idUsuario,
  String idPropiedad,
) async {
  debugPrintLevels(7, "HTTP recuperaFotosDePropiedades");

  // Realizar la solicitud HTTP GET para recuperar fotos
  int statusCode = 0;
  // URL de tu servidor CouchDB
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDUSPR/_view/userproperty?key=["$idUsuario","$idPropiedad"]';
  debugPrintLevels(7, "URL DE FOTOS RECUPERADAS: $baseUrl");

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json", // tipo de contenido
  };

  var response = await http.get(Uri.parse(baseUrl), headers: headers);
  statusCode = response.statusCode;

  debugPrintLevels(
    7,
    " statusCode DE FOTOS USER PROP RECUPERADAS: $statusCode",
  );

  if (response.statusCode == 200) {
    int lengthListaFotos = ref
        .read(getListaFotosCasaProviderId.notifier)
        .getLengthListaDeFotosPropiedad();

    debugPrintLevels(6, "NUMERO DE FOTOS RECUPERADAS: $lengthListaFotos");
    // Decodificar el contenido del archivo recuperado
    FotosCasaGetIDs listaFotos = FotosCasaGetIDs.fromJson(
      jsonDecode(response.body),
    );
    // state = FotosCasaGetIDs.fromJson(jsonDecode(response.body));

    ref
        .read(getListaFotosCasaProviderId.notifier)
        .setListaDeFotosPropiedad(listaFotos);

    statusCode = response.statusCode;

    if (lengthListaFotos < 0) {
      debugPrintLevels(7, 'Sin fotos en CouchDB.');
      statusCode = 500;
    } else {
      debugPrintLevels(7, 'Archivos recuperado exitosamente de CouchDB.');
    }
  } else {
    debugPrintLevels(
      7,
      'Error al recuperar el archivo adjunto de CouchDB. Código de estado: ${response.statusCode}',
    );
  }
  return response.statusCode;
}

Future<ListaFotosIdsPropiedadGet> getListaIdsFotosByIdUserIdPropiedad(
  WidgetRef ref,
  String idUsuario,
  String idPropiedad,
) async {
  debugPrintLevels(7, "HTTP recuperaFotosDePropiedades");
  ListaFotosIdsPropiedadGet listaOrdenFotos = ListaFotosIdsPropiedadGet(
    totalRows: 0,
    offset: 0,
    rows: [],
  );
  // Realizar la solicitud HTTP GET para recuperar el archivo adjunto
  int statusCode = 0;
  // URL de tu servidor CouchDB
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDUSPR/_view/idUserPropiedadFoto?key=["$idUsuario","$idPropiedad"]';
  debugPrintLevels(7, "URL DE FOTOS RECUPERADAS: $baseUrl");

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json", // tipo de contenido
  };

  var response = await http.get(Uri.parse(baseUrl), headers: headers);
  statusCode = response.statusCode;

  debugPrintLevels(
    7,
    " statusCode DE FOTOS USER PROP RECUPERADAS: $statusCode",
  );

  if (response.statusCode == 200) {
    int lengthListaFotos = ref
        .read(getListaFotosCasaProviderId.notifier)
        .getLengthListaDeFotosPropiedad();
    debugPrintLevels(6, "NUMERO DE FOTOS RECUPERADAS: $lengthListaFotos");

    // Decodificar el contenido del archivo recuperado
    listaOrdenFotos = ListaFotosIdsPropiedadGet.fromJson(
      jsonDecode(response.body),
    );

    statusCode = response.statusCode;

    if (lengthListaFotos < 0) {
      // if (state.rows.isEmpty) {
      debugPrintLevels(7, 'Sin fotos en CouchDB.');
      statusCode = 500;
    } else {
      debugPrintLevels(7, 'Archivos recuperado exitosamente de CouchDB.');
    }
  } else {
    debugPrintLevels(
      7,
      'Error al recuperar el archivo adjunto de CouchDB. Código de estado: ${response.statusCode}',
    );
  }
  return listaOrdenFotos;
}

Future<ListaFotosIdsPropiedadGet> getListaIdsFotosByIdPropiedad(
  WidgetRef ref,
  String idPropiedad,
) async {
  debugPrintLevels(7, "HTTP recuperaIdsFotosIdPropiedad");
  ListaFotosIdsPropiedadGet listaIdsFotos = ListaFotosIdsPropiedadGet(
    totalRows: 0,
    offset: 0,
    rows: [],
  );
  // Realizar la solicitud HTTP GET para recuperar el archivo adjunto
  int statusCode = 0;
  // URL de tu servidor CouchDB
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDFOTO/_view/idFotoIdPropiedad?key="$idPropiedad"';
  debugPrintLevels(7, "URL DE IDS FOTOS RECUPERADAS: $baseUrl");

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json", // tipo de contenido
  };

  var response = await http.get(Uri.parse(baseUrl), headers: headers);
  statusCode = response.statusCode;

  debugPrintLevels(
    7,
    " statusCode DE FOTOS USER PROP RECUPERADAS: $statusCode",
  );

  if (response.statusCode == 200) {
    int lengthListaFotos = ref
        .read(getListaFotosCasaProviderId.notifier)
        .getLengthListaDeFotosPropiedad();
    debugPrintLevels(6, "NUMERO DE FOTOS RECUPERADAS: $lengthListaFotos");
    // Decodificar el contenido del archivo recuperado
    listaIdsFotos = ListaFotosIdsPropiedadGet.fromJson(
      jsonDecode(response.body),
    );

    statusCode = response.statusCode;

    //if (state.rows.isEmpty) {
    if (lengthListaFotos < 0) {
      debugPrintLevels(7, 'Sin fotos en CouchDB.');
      statusCode = 500;
    } else {
      debugPrintLevels(7, 'Archivos recuperado exitosamente de CouchDB.');
    }
  } else {
    debugPrintLevels(
      7,
      'Error al recuperar el archivo adjunto de CouchDB. Código de estado: ${response.statusCode}',
    );
  }
  return listaIdsFotos;
}

//------------------------------------------------------------------------------
*/
