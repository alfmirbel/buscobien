//-----------------------------------------------------------------------------
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../20_var_globales/couchdb_errors.dart';
import '../../../40_security/direccionip.dart';
import '../../../40_security/urls_endpoints_espacios.dart';
import '../../../60_global_widgets/debugprint.dart';
import '../../inicio/data_espacios_casas.dart';
import '../../inicio/data_espacios_casas_get.dart';

//-----------------------------------------------------------------------------
// OPTIMIZADO
Future<String> upsertEspacioPublicadoToCouchDB(
  String tipoDeEspacio,
  ValueEspaciosCasaGet datosPropiedadPublicar,
) async {
  debugPrintLevels(10, "**************************************************");
  debugPrintLevels(10, 'HTTP updatePropiedadCasaGetToCouchDB (Logic: Upsert)');
  debugPrintLevels(10, "**************************************************");

  int resultado = 0;
  String idDocumentoGuardado = "";

  // Bandera para determinar si debemos proceder a crear un nuevo documento
  bool realizarInsercion = false;

  try {
    DateTime timeStamp = DateTime.now();
    String tipoanuncio = datosPropiedadPublicar.espacioscasa.tipodeanuncio;

    // NOTA: Asumo que 'fotoprincipal' guarda el ID de CouchDB antes de ser sobrescrito
    String idPublicacion = datosPropiedadPublicar.espacioscasa.fotoprincipal;
    String idEspacio = datosPropiedadPublicar.id;

    debugPrintLevels(10, "*** Tipodeanuncio: $tipoanuncio");

    // Actualización de timestamps
    datosPropiedadPublicar.espacioscasa.fechadepublicacioncasa.dia =
        timeStamp.day;
    datosPropiedadPublicar.espacioscasa.fechadepublicacioncasa.mes =
        timeStamp.month;
    datosPropiedadPublicar.espacioscasa.fechadepublicacioncasa.anio =
        timeStamp.year;

    datosPropiedadPublicar.espacioscasa.activa = 1;
    datosPropiedadPublicar.espacioscasa.timestampcasa = timeStamp.toString();

    Map<String, String> headers = _getHeaders();

    // Construcción de la URL base
    String baseUrl = '$direccionip/';

    // Optimizacion: Switch simplificado y construcción de ruta
    baseUrl += endpointsPublicados[tipoanuncio.toLowerCase()]!;
    /*
    switch (tipoanuncio.toLowerCase()) {
      case "normales":
        baseUrl += endpointsPublicados["Normales"]!;
        break;
      case "destacados":
        baseUrl += endpointsPublicados["Destacados"]!;
        break;
      case "superdestacados":
        baseUrl += endpointsPublicados["Superdestacados"]!;
        break;
      case "oportunidades":
        baseUrl += endpointsPublicados["Oportunidades"]!;
        break;
      case "remates":
        baseUrl += endpointsPublicados["Remates"]!;
        break;
      default:
        baseUrl += endpointsPublicados["Normales"]!;
    }
    */

    debugPrintLevels(10, "*** baseUrl + endpoint: $baseUrl");

    // URL específica para UPDATE (PUT)
    String urlUpdate = "$baseUrl/$idPublicacion";

    // ---------------------------------------------------------
    // LÓGICA UPSERT OPTIMIZADA
    // ---------------------------------------------------------

    // CASO 1: INTENTO DE ACTUALIZACIÓN (Si tenemos un ID previo)
    if (idPublicacion != "") {
      debugPrintLevels(
        10,
        "*** ID DE PUBLICACIÓN NO NULO. Verificando existencia para Update.",
      );

      final getResponse = await http.get(
        Uri.parse(urlUpdate),
        headers: headers,
      );

      debugPrintLevels(10, "*** STATUS GET CHECK: ${getResponse.statusCode}");

      if (getResponse.statusCode == 200) {
        // --- EL DOCUMENTO EXISTE: PROCEDEMOS A HACER PUT ---
        try {
          // 1. Obtener _rev actual
          Map<String, dynamic> docActual = jsonDecode(getResponse.body);
          String currentRev = docActual['_rev'];

          debugPrintLevels(
            10,
            "*** DOC EXISTENTE: ID: ${docActual["_id"]} - REV: $currentRev",
          );

          // 2. Preparar objeto para subir (Merge de datos nuevos con _id y _rev existentes)
          // Usamos jsonDecode/Encode para asegurar una copia limpia y manipulación de mapa
          String propiedadJson = jsonEncode(datosPropiedadPublicar);
          Map<String, dynamic> mapAsubir = jsonDecode(propiedadJson);

          // Sobrescribimos fotoprincipal con el idEspacio (Lógica original mantenida)
          mapAsubir["espacioscasa"]["fotoprincipal"] = idEspacio;

          // Inyectamos metadatos de CouchDB
          mapAsubir["_id"] = docActual["_id"];
          mapAsubir['_rev'] = currentRev;

          debugPrintLevels(10, "*** SUBIENDO UPDATE...");

          final responsePut = await http.put(
            Uri.parse(urlUpdate),
            headers: headers,
            body: jsonEncode(mapAsubir), // Aseguramos enviar JSON string válido
          );

          resultado = responsePut.statusCode;
          debugPrintLevels(10, "*** REGRESA DE HTTP PUT: $resultado");

          if (responsePut.statusCode == 200 || responsePut.statusCode == 201) {
            idDocumentoGuardado = idPublicacion; // Mantenemos el ID
            debugPrintLevels(10, "*** Documento ACTUALIZADO exitosamente.");
          } else {
            // Si falló el PUT (ej. conflicto de revisión), marcamos error
            debugPrintLevels(
              10,
              "*** Error al actualizar documento: $resultado",
            );
          }
        } catch (e) {
          debugPrintLevels(10, "Error procesando _rev o body para update: $e");
          // Si algo falla en la lógica de actualización, podríamos reintentar o abortar.
        }
      } else if (getResponse.statusCode == 404) {
        // --- EL DOCUMENTO NO EXISTE (404) ---
        debugPrintLevels(
          10,
          "*** Documento no encontrado (404). Cambiando flujo a INSERT.",
        );
        realizarInsercion = true;
      } else {
        debugPrintLevels(
          10,
          "*** Warning: Check de existencia retornó código inesperado: ${getResponse.statusCode}",
        );
        idDocumentoGuardado = "";
        // No hacemos nada, idDocumentoGuardado se queda vacío
      }
    } else {
      // --- NO HAY ID PREVIO ---
      debugPrintLevels(10, "*** ID nulo. Flujo directo a INSERT.");
      realizarInsercion = true;
    }

    // CASO 2: INSERCIÓN (Si no había ID o si el ID no se encontró)
    if (realizarInsercion) {
      debugPrintLevels(10, "*** INICIANDO PROCESO DE INSERCIÓN (POST) ***");
      debugPrintLevels(10, "*** URL CREATE: $baseUrl");

      // Asignamos el idEspacio a fotoprincipal según lógica original
      datosPropiedadPublicar.espacioscasa.fotoprincipal = idEspacio;

      // Construcción del Body.
      // Sugerencia: Usar un mapa wrapper es más seguro que string interpolation,
      // pero mantenemos tu función 'espaciosCasaToJson' dentro de la estructura.
      String espacioJson =
          '{"espacioscasa": ${espaciosCasaToJson(datosPropiedadPublicar.espacioscasa)}}';

      final responseInsert = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: espacioJson,
      );

      resultado = responseInsert.statusCode;

      // Safe access para logs usando el mapa codigoCouchDB
      String statusLabel = codigoCouchDB[resultado]?.label ?? 'Unknown';
      String statusDesc = codigoCouchDB[resultado]?.description ?? '';
      debugPrintLevels(
        10,
        "HTTP Resultado POST $resultado: $statusLabel: $statusDesc",
      );

      if (responseInsert.statusCode == 200 ||
          responseInsert.statusCode == 201 ||
          responseInsert.statusCode == 202) {
        debugPrintLevels(
          10,
          '*** HTTP CREACIÓN EXITOSA. repuesta de CouchDB: ${responseInsert.body}',
        );

        Map<String, dynamic> docResultado = jsonDecode(responseInsert.body);
        idDocumentoGuardado = docResultado["id"];

        debugPrintLevels(
          10,
          '*** HTTP CREACIÓN EXITOSA. Nuevo ID CouchDB: $idDocumentoGuardado',
        );
      } else {
        debugPrintLevels(
          10,
          '*** Error creando documento en CouchDB: $resultado',
        );
        idDocumentoGuardado = "";
      }
    }
  } catch (e) {
    debugPrintLevels(
      1,
      'Error Excepción en updatePropiedadCasaGetToCouchDB: $e',
    );
    resultado = 500;
    idDocumentoGuardado = "";
  }

  return idDocumentoGuardado;
}

/*
Future<String> upsertEspacioPublicadoToCouchDB(
  String tipoDeEspacio,
  ValueEspaciosCasaGet datosPropiedadPublicar,
) async {
  debugPrintLevels(10, "**************************************************");
  debugPrintLevels(10, 'HTTP updatePropiedadCasaGetToCouchDB (Logic: Upsert)');
  debugPrintLevels(10, "**************************************************");

  int resultado = 0;
  String idDocumentoGuardado = "";
  try {
    DateTime timeStamp = DateTime.now();
    String tipoanuncio = datosPropiedadPublicar.espacioscasa.tipodeanuncio;
    String idPublicacion = datosPropiedadPublicar.espacioscasa.fotoprincipal;
    String idEspacio = datosPropiedadPublicar.id;

    debugPrintLevels(10, "*** Tipodeanuncio: $tipoanuncio");

    // Actualización de timestamps
    datosPropiedadPublicar.espacioscasa.fechadepublicacioncasa.dia =
        timeStamp.day;
    datosPropiedadPublicar.espacioscasa.fechadepublicacioncasa.mes =
        timeStamp.month;
    datosPropiedadPublicar.espacioscasa.fechadepublicacioncasa.anio =
        timeStamp.year;

    datosPropiedadPublicar.espacioscasa.activa = 1;
    datosPropiedadPublicar.espacioscasa.timestampcasa = timeStamp.toString();

    Map<String, String> headers = _getHeaders();

    // Selección de URL basada en tipo de anuncio
    if (endpointsPublicados.containsKey(tipoanuncio)) {
      // Lógica de coincidencia existente
    }

    String baseUrl = '$direccionip/';
    debugPrintLevels(10, "*** baseUrl: $baseUrl");

    switch (tipoanuncio.toLowerCase()) {
      case "normales":
        baseUrl += endpointsPublicados["Normales"]!;
        break;
      case "destacados":
        baseUrl += endpointsPublicados["Destacados"]!;
        break;
      case "superdestacados":
        baseUrl += endpointsPublicados["Superdestacados"]!;
        break;
      case "oportunidades":
        baseUrl += endpointsPublicados["Oportunidades"]!;
        break;
      case "remates":
        baseUrl += endpointsPublicados["Remates"]!;
        break;
      default:
        baseUrl += endpointsPublicados["Normales"]!;
    }
    debugPrintLevels(10, "*** baseUrl + endpoint: $baseUrl");

    String url =
        "$baseUrl/${datosPropiedadPublicar.espacioscasa.fotoprincipal}";

    debugPrintLevels(10, "*** URL Update/Upsert: $url");

    // ---------------------------------------------------------
    // INICIO CAMBIO LOGICA UPSERT
    // ---------------------------------------------------------

    // 1. Convertimos el objeto a Mapa/JSON base
    String propiedadJson = jsonEncode(datosPropiedadPublicar);

    // 2. Verificamos si el documento existe para obtener el '_rev'
    // CouchDB requiere el '_rev' actual para permitir una actualización (Update).
    // Si no se envía '_rev', y el doc existe, devuelve 409. Si no existe, lo crea (Insert).
    if (idPublicacion != "") {
      debugPrintLevels(
        10,
        "*** ID DE PUBLICACIÓPN NO NULO. Procediendo a Insert.",
      );

      final getResponse = await http.get(Uri.parse(url), headers: headers);
      // YA EXISTE EL DOCUMENTO
      debugPrintLevels(
        10,
        "*** BUSCA ID DE PUBLICACIÓN PARA Insert. ${getResponse.statusCode}",
      );
      if (getResponse.statusCode == 200) {
        // Variable para el cuerpo final de la petición
        resultado = getResponse.statusCode;
        idDocumentoGuardado = idPublicacion;

        debugPrintLevels(
          10,
          "*** Documento existente encontrado. Aplicando _rev para Update.",
        );
        // INTENTO DE ACTUALIZACIÓN
        try {
          // Decodificamos la respuesta de la BD para sacar el _rev actual
          Map<String, dynamic> docActual = jsonDecode(getResponse.body);
          debugPrintLevels(
            10,
            "*** DOCUMENTO ACTUAL Update/Upsert: ${docActual["_id"]} - ${docActual['_rev']}",
          );

          String currentRev = docActual['_rev'];

          // Decodificamos nuestro objeto a subir para inyectarle el _rev
          propiedadJson = jsonEncode(datosPropiedadPublicar);

          Map<String, dynamic> mapAsubir = jsonDecode(propiedadJson);
          mapAsubir["espacioscasa"]["fotoprincipal"] = idEspacio;
          mapAsubir["_id"] = docActual["_id"];
          mapAsubir['_rev'] = currentRev;
          //mapAsubir["espacioscasa"]["fotoprincipal"] = idEspacio;
          debugPrintLevels(
            10,
            "*** DOCUMENTO NUEVO Update/Upsert: ${mapAsubir["_id"]} - ${mapAsubir['_rev']} - ${mapAsubir["espacioscasa"]["fotoprincipal"]}",
          );

          debugPrintLevels(10, "*** DOCUMETO Update/Upsert: $mapAsubir");

          final response = await http.put(
            Uri.parse(url),
            headers: headers,
            body: mapAsubir,
            // Usamos el body modificado con _rev si fue necesario
          );
          debugPrintLevels(10, "*** REGRESA DE HTTP: ${response.statusCode}");

          if (response.statusCode == 200) {
            resultado = getResponse.statusCode;
            debugPrintLevels(10, "*** Documento ACTUALIZADO.");
          } else {
            resultado = 404;
            debugPrintLevels(10, "*** Documento NO ACTUALIZADO.");
          }
        } catch (e) {
          debugPrintLevels(1, "Error parseando _rev para upsert: $e");
          // Si falla, intentamos enviar el body original (probablemente fallará con 409)
        }
      } else if (getResponse.statusCode == 404) {
        resultado = getResponse.statusCode;
        debugPrintLevels(10, "*** Documento no existe. Procediendo a Insert.");
        // No hacemos nada, bodyFinal ya es propiedadJson (sin _rev), lo cual creará el doc.
        // DOCUMENTO NUEVO
        debugPrintLevels(10, "*** URL CREATE: $baseUrl");

        datosPropiedadPublicar.espacioscasa.fotoprincipal = idEspacio;

        String espacioJson =
            '{"espacioscasa": ${espaciosCasaToJson(datosPropiedadPublicar.espacioscasa)}}';

        final responseInsert = await http.post(
          Uri.parse(baseUrl),
          headers: headers,
          body: espacioJson,
        );

        resultado = responseInsert.statusCode;

        debugPrintLevels(
          10,
          "Resultado put: ${codigoCouchDB[resultado]?.label ?? 'Unknown'}: ${codigoCouchDB[resultado]?.description ?? ''}",
        );

        if (responseInsert.statusCode == 201 ||
            responseInsert.statusCode == 200) {
          // SE CREO EL DOCUMENTO
          resultado = responseInsert.statusCode;
          Map<String, dynamic> docResultado = jsonDecode(responseInsert.body);

          debugPrintLevels(10, '*** Data CouchDB docResultado! $docResultado');
          // DEVUELVE EL ID NUEVO
          idDocumentoGuardado = docResultado["_id"];
          debugPrintLevels(
            10,
            '*** Data ID docResultado! $idDocumentoGuardado',
          );

          debugPrintLevels(
            10,
            '*** Data written to CouchDB successfully! $resultado',
          );
        } else {
          debugPrintLevels(
            8,
            '*** Error writing data to CouchDB: ${responseInsert.statusCode}',
          );
          idDocumentoGuardado = "";
        }
      } else {
        debugPrintLevels(
          8,
          "*** Warning: Check de existencia retornó: ${getResponse.statusCode}",
        );
        idDocumentoGuardado = "";
        // Dependiendo de la lógica de negocio, aquí podríamos abortar,
        // pero seguimos intentando el PUT por si acaso.
      }
    } else {
      // NO EXISTE EL DOCUMENTO ID NULO
      idDocumentoGuardado = "";

      debugPrintLevels(
        10,
        "*** Documento no existe. Procediendo a Insert ID NULO.",
      );
      // No hacemos nada, bodyFinal ya es propiedadJson (sin _rev), lo cual creará el doc.
      // DOCUMENTO NUEVO
      debugPrintLevels(10, "*** URL CREATE: $baseUrl");

      datosPropiedadPublicar.espacioscasa.fotoprincipal = idEspacio;
      String espacioJson =
          '{"espacioscasa": ${espaciosCasaToJson(datosPropiedadPublicar.espacioscasa)}}';

      final responseInsert = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: espacioJson,
      );

      resultado = responseInsert.statusCode;

      debugPrintLevels(
        10,
        "Resultado put: ${codigoCouchDB[resultado]?.label ?? 'Unknown'}: ${codigoCouchDB[resultado]?.description ?? ''}",
      );

      if (responseInsert.statusCode == 201 ||
          responseInsert.statusCode == 200) {
        // SE CREO EL DOCUMENTO
        resultado = responseInsert.statusCode;
        Map<String, dynamic> docResultado = jsonDecode(responseInsert.body);

        debugPrintLevels(10, '*** Data CouchDB docResultado! $docResultado');
        // DEVUELVE EL ID NUEVO
        idDocumentoGuardado = docResultado["_id"];
        debugPrintLevels(10, '*** Data ID docResultado! $idDocumentoGuardado');

        debugPrintLevels(
          10,
          '*** Data written to CouchDB successfully! $resultado',
        );
      } else {
        debugPrintLevels(
          8,
          '*** Error writing data to CouchDB: ${responseInsert.statusCode}',
        );
        idDocumentoGuardado = "";
      }
      debugPrintLevels(10, "*** TERMINA DE HTTP:");
    }

    // ---------------------------------------------------------
    // FIN CAMBIO LOGICA UPSERT
    // ---------------------------------------------------------
  } catch (e) {
    debugPrintLevels(
      1,
      'Error Excepción en updatePropiedadCasaGetToCouchDB: $e',
    );
    resultado = 500;
    idDocumentoGuardado = "";
  }
  return idDocumentoGuardado;
}
*/
//-----------------------------------------------------------------------------

Future<int> deleteEspacioPublicadoToCouchDB(
  String tipoDeEspacio,
  String idPublicacion,
) async {
  debugPrintLevels(10, "**************************************************");
  debugPrintLevels(10, 'HTTP deleteEspacioPublicadoToCouchDB');
  debugPrintLevels(10, "**************************************************");

  int resultado = 0;
  try {
    debugPrintLevels(
      10,
      "*** deleteEspacioPublicadoToCouchDB Tipodeanuncio a borrar: $tipoDeEspacio",
    );

    Map<String, String> headers = _getHeaders();

    // ---------------------------------------------------------
    // CONSTRUCCIÓN DE LA URL BASE
    // (Misma lógica que en el Upsert para localizar la BD correcta)
    // ---------------------------------------------------------
    String baseUrl = '$direccionip/';
    baseUrl += endpointsPublicados[tipoDeEspacio.toLowerCase()]!;
    /*
    switch (tipoDeEspacio.toLowerCase()) {
      case "normales":
        baseUrl += endpointsPublicados["Normales"]!;
        break;
      case "destacados":
        baseUrl += endpointsPublicados["Destacados"]!;
        break;
      case "superdestacados":
        baseUrl += endpointsPublicados["Superdestacados"]!;
        break;
      case "oportunidades":
        baseUrl += endpointsPublicados["Oportunidades"]!;
        break;
      case "remates":
        baseUrl += endpointsPublicados["Remates"]!;
        break;
      default:
        baseUrl += endpointsPublicados["Normales"]!;
    }
    */
    // ID DEL DOCUMENTO PUBLICADO
    String url = "$baseUrl/${idPublicacion}";
    debugPrintLevels(
      10,
      "*** deleteEspacioPublicadoToCouchDB URL Base para Delete: $url",
    );

    // ---------------------------------------------------------
    // PASO 1: OBTENER EL _REV ACTUAL (GET)
    // CouchDB requiere el '_rev' para autorizar el borrado.
    // ---------------------------------------------------------
    final getResponse = await http.get(Uri.parse(url), headers: headers);

    if (getResponse.statusCode == 200) {
      // El documento existe, procedemos a borrarlo.
      try {
        Map<String, dynamic> docActual = jsonDecode(getResponse.body);
        String currentRev = docActual['_rev'];

        debugPrintLevels(
          10,
          "*** Documento encontrado. _rev para borrar: $currentRev",
        );

        // ---------------------------------------------------------
        // PASO 2: EJECUTAR EL BORRADO (PUT con _deleted: true)
        // Se evita DELETE por problemas de CORS
        // ---------------------------------------------------------

        final deleteResponse = await http.put(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode({
            '_id': idPublicacion,
            '_rev': currentRev,
            '_deleted': true,
          }),
        );

        resultado = deleteResponse.statusCode;

        if (resultado == 200 || resultado == 202) {
          debugPrintLevels(
            10,
            "*** deleteEspacioPublicadoToCouchDB Documento borrado exitosamente de CouchDB.",
          );
        } else {
          debugPrintLevels(
            8,
            "*** deleteEspacioPublicadoToCouchDB Error al intentar borrar: $resultado",
          );
        }
      } catch (e) {
        debugPrintLevels(
          1,
          " deleteEspacioPublicadoToCouchDB Error parseando respuesta GET para delete: $e",
        );
        resultado = 500;
      }
    } else if (getResponse.statusCode == 404) {
      // El documento NO existe.
      // Consideramos esto como "éxito" (ya no está) o devolvemos 404 según necesites.
      debugPrintLevels(
        10,
        "*** deleteEspacioPublicadoToCouchDB El documento ya no existe (404). No se requiere acción.",
      );
      resultado = 404;
    } else {
      debugPrintLevels(
        8,
        "*** Error consultando existencia del documento: ${getResponse.statusCode}",
      );
      resultado = getResponse.statusCode;
    }

    debugPrintLevels(
      10,
      "Resultado Delete: ${codigoCouchDB[resultado]?.label ?? 'Unknown'}: ${codigoCouchDB[resultado]?.description ?? ''}",
    );
  } catch (e) {
    debugPrintLevels(
      1,
      'Error Excepción en deleteEspacioPublicadoToCouchDB: $e',
    );
    resultado = 500;
  }
  return resultado;
}

//-----------------------------------------------------------------------------

Future<int> deleteEspacioToCouchDB(
  String tipoDeEspacio,
  ValueEspaciosCasaGet datosPropiedadPublicar,
) async {
  debugPrintLevels(10, "**************************************************");
  debugPrintLevels(10, 'HTTP deleteEspacioToCouchDB');
  debugPrintLevels(10, "**************************************************");

  int resultado = 0;
  try {
    String tipoanuncio = datosPropiedadPublicar.espacioscasa.tipodeanuncio;
    debugPrintLevels(10, "*** Tipodeanuncio a borrar: $tipoanuncio");

    Map<String, String> headers = _getHeaders();

    // ---------------------------------------------------------
    // CONSTRUCCIÓN DE LA URL BASE
    // (Misma lógica que en el Upsert para localizar la BD correcta)
    // ---------------------------------------------------------
    String baseUrl = '$direccionip/';
    switch (tipoanuncio.toLowerCase()) {
      case "normales":
        baseUrl += endpointsCaptura["Normales"]!;
        break;
      case "destacados":
        baseUrl += endpointsCaptura["Destacados"]!;
        break;
      case "superdestacados":
        baseUrl += endpointsCaptura["Superdestacados"]!;
        break;
      case "oportunidades":
        baseUrl += endpointsCaptura["Oportunidades"]!;
        break;
      case "remates":
        baseUrl += endpointsCaptura["Remates"]!;
        break;
      default:
        baseUrl += endpointsCaptura["Normales"]!;
    }

    String url = "$baseUrl/${datosPropiedadPublicar.id}";
    debugPrintLevels(10, "*** URL Base para Delete: $url");

    // ---------------------------------------------------------
    // PASO 1: OBTENER EL _REV ACTUAL (GET)
    // CouchDB requiere el '_rev' para autorizar el borrado.
    // ---------------------------------------------------------
    final getResponse = await http.get(Uri.parse(url), headers: headers);

    if (getResponse.statusCode == 200) {
      // El documento existe, procedemos a borrarlo.
      try {
        Map<String, dynamic> docActual = jsonDecode(getResponse.body);
        String currentRev = docActual['_rev'];

        debugPrintLevels(
          10,
          "*** Documento encontrado. _rev para borrar: $currentRev",
        );

        // ---------------------------------------------------------
        // PASO 2: EJECUTAR EL BORRADO (PUT con _deleted: true)
        // Se evita DELETE por problemas de CORS
        // ---------------------------------------------------------

        final deleteResponse = await http.put(
          Uri.parse(url),
          headers: headers,
          body: jsonEncode({
            '_id': datosPropiedadPublicar.id,
            '_rev': currentRev,
            '_deleted': true,
          }),
        );

        resultado = deleteResponse.statusCode;

        if (resultado == 200 || resultado == 202) {
          debugPrintLevels(
            10,
            "*** Documento borrado exitosamente de CouchDB.",
          );
        } else {
          debugPrintLevels(8, "*** Error al intentar borrar: $resultado");
        }
      } catch (e) {
        debugPrintLevels(1, "Error parseando respuesta GET para delete: $e");
        resultado = 500;
      }
    } else if (getResponse.statusCode == 404) {
      // El documento NO existe.
      // Consideramos esto como "éxito" (ya no está) o devolvemos 404 según necesites.
      debugPrintLevels(
        10,
        "*** El documento ya no existe (404). No se requiere acción.",
      );
      resultado = 404;
    } else {
      debugPrintLevels(
        8,
        "*** Error consultando existencia del documento: ${getResponse.statusCode}",
      );
      resultado = getResponse.statusCode;
    }

    debugPrintLevels(
      10,
      "Resultado Delete: ${codigoCouchDB[resultado]?.label ?? 'Unknown'}: ${codigoCouchDB[resultado]?.description ?? ''}",
    );
  } catch (e) {
    debugPrintLevels(
      1,
      'Error Excepción en deleteEspacioPublicadoToCouchDB: $e',
    );
    resultado = 500;
  }
  return resultado;
}

//-----------------------------------------------------------------------------

// Helper para generar headers (Optimización: Evita repetir código de auth)
Map<String, String> _getHeaders() {
  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  return {'Authorization': basicAuth, 'Content-Type': 'application/json'};
}
