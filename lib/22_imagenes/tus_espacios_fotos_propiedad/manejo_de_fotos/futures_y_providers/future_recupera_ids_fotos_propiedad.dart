//------------------------------------------------------------------------------
//--- FUNCIONES FUERA DEL PROVIDER LISTAFOTOS ----------------------------------
//------------------------------------------------------------------------------
import 'dart:async'; // Necesario para TimeoutException
import 'dart:convert';
import 'dart:io'; // Necesario para SocketException
import 'package:http/http.dart' as http;

import '../../../../40_security/direccionip.dart';
import '../../../../60_global_widgets/debugprint.dart';
import '../lista_ids_fotos/data_fotos_get_ids_fotos_user_prop.dart';

// OPTMIZADO
//------------------------------------------------------------------------------
//--- FUNCIONES FUERA DEL PROVIDER LISTAFOTOS ----------------------------------
//------------------------------------------------------------------------------

Future<GetIdsFotosUserProp> recuperaIdsFotosDePropiedades(
  String idUsuario,
  String idPropiedad,
) async {
  debugPrintLevels(9, "// recuperaIdsFotosDePropiedades START");

  // 1. Inicialización del objeto de retorno (vacío por defecto)
  GetIdsFotosUserProp listaIdsFotos = GetIdsFotosUserProp(
    totalRows: 0,
    offset: 0,
    rows: [],
  );

  int statusCode = 0;

  // 2. Construcción segura de la URL
  // CouchDB requiere que el parámetro 'key' sea un JSON válido.
  // Es CRÍTICO codificar este string para evitar errores si los IDs tienen caracteres especiales.
  String jsonKey = '["$idUsuario","$idPropiedad"]';
  String encodedKey = Uri.encodeComponent(jsonKey);

  // URL de tu servidor CouchDB
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDUSPR/_view/getIdFotos?key=$encodedKey';

  debugPrintLevels(9, "URL IDS FOTOS: $baseUrl");

  // 3. Autenticación
  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json",
    'Accept': "application/json",
  };

  try {
    // 4. Petición HTTP con Timeout y manejo de errores
    var response = await http.get(Uri.parse(baseUrl), headers: headers);
    // .timeout(const Duration(seconds: 10)); // Timeout de 10 segundos

    statusCode = response.statusCode;
    debugPrintLevels(9, "statusCode RECUPERADO: $statusCode");

    if (statusCode == 200) {
      debugPrintLevels(9, "Decodificando respuesta...");

      // Decodificar el contenido
      listaIdsFotos = getIdsFotosUserPropFromJson(response.body);

      debugPrintLevels(
        9,
        "200 OK - FOTOS RECUPERADAS: ${listaIdsFotos.rows.length}",
      );

      if (listaIdsFotos.rows.isEmpty) {
        debugPrintLevels(
          9,
          'La consulta fue exitosa pero no hay fotos en CouchDB.',
        );
        // Nota: Una lista vacía es un 200 OK válido, no un error 500.
        // Se mantiene el objeto listaIdsFotos vacío inicializado arriba.
      }
    } else {
      debugPrintLevels(
        9,
        'Error Servidor CouchDB. Código: $statusCode. Body: ${response.body}',
      );
    }
  } on SocketException {
    debugPrintLevels(
      9,
      'Error: Sin conexión a Internet o servidor inalcanzable.',
    );
  } on TimeoutException {
    debugPrintLevels(9, 'Error: Tiempo de espera agotado (Timeout).');
  } catch (e) {
    debugPrintLevels(
      9,
      'Error no controlado en recuperaIdsFotosDePropiedades: $e',
    );
  }

  debugPrintLevels(9, "// recuperaIdsFotosDePropiedades END");

  // Siempre devuelve el objeto (con datos o vacío en caso de error), nunca null.
  return listaIdsFotos;
}

//---------------------------------------------------------------------------
/*
Future<GetIdsFotosUserProp> recuperaIdsFotosDePropiedades(
  String idUsuario,
  String idPropiedad,
) async {
  // debugPrintLevels(9, "////////////////////////////");
  debugPrintLevels(9, "// recuperaIdsFotosDePropiedades");
  // debugPrintLevels(9, "////////////////////////////");
  // Realizar la solicitud HTTP GET para recuperar el archivo adjunto
  int statusCode = 0;
  GetIdsFotosUserProp listaIdsFotos = GetIdsFotosUserProp(
    totalRows: 0,
    offset: 0,
    rows: [],
  );
  // URL de tu servidor CouchDB
  String baseUrl =
      '$direccionip/buscobien_propiedades_casas_fotos/_design/DDUSPR/_view/getIdFotos?key=["$idUsuario","$idPropiedad"]';
  debugPrintLevels(9, "URL DE IDS FOTOS RECUPERADAS: $baseUrl");

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json", // tipo de contenido
  };

  var response = await http.get(Uri.parse(baseUrl), headers: headers);
  statusCode = response.statusCode;

  debugPrintLevels(9, " statusCode DE IDS FOTOS RECUPERADAS: $statusCode");

  if (response.statusCode == 200) {
    // Decodificar el contenido del archivo recuperado
    debugPrintLevels(9, " statusCode 200 getIdsFotosUserPropFromJson");
    listaIdsFotos = getIdsFotosUserPropFromJson(response.body);
    debugPrintLevels(9, " response listaIdsFotos getIdsFotosUserPropFromJson");

    statusCode = response.statusCode;
    if (response.statusCode == 200) {
      debugPrintLevels(
        9,
        "200 NUMERO DE ids FOTOS RECUPERADAS: ${listaIdsFotos.rows.length}",
      );

      if (listaIdsFotos.rows.isEmpty) {
        debugPrintLevels(9, 'Sin fotos en CouchDB.');
        statusCode = 500;
      }
    } else {
      debugPrintLevels(9, 'Archivos recuperado exitosamente de CouchDB.');
    }
  } else {
    debugPrintLevels(
      9,
      'Error al recuperar el archivo adjunto de CouchDB. Código de estado: ${response.statusCode}',
    );
  }
  debugPrintLevels(9, "// recuperaIdsFotosDePropiedades");
  // debugPrintLevels(9, "////////////////////////////");

  return listaIdsFotos;
}
*/
