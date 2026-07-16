import 'dart:async'; // Necesario para TimeoutException
import 'dart:convert';
import 'dart:math'; // Necesario para Random
import 'package:http/http.dart' as http;

// Asumimos que estas importaciones existen en tu proyecto
import '../../../../40_security/direccionip.dart';
import '../../../../40_security/generate_hash.dart';
import '../../../../60_global_widgets/debugprint.dart';
// Importa tus modelos aquí (ValueGetIdPropiedad, etc.)
import 'data_fotos_ordenadas_get_idpropiedad.dart'; // Para listaFotosOrdenadasToJson

//----------------------------------------------------------------------------
// OPTIMIZADO

Future<int> actualizaFotosOrdenadas(ValueGetIdPropiedad listaFotos) async {
  debugPrintLevels(7, "HTTP actualizaFotosOrdenadas START");

  // VALIDACIÓN PREVIA
  if (listaFotos.id.isEmpty) {
    debugPrintLevels(
      7,
      "Error: El ID del documento es vacío. No se puede actualizar.",
    );
    return 400; // Bad Request
  }

  int statusCode = 0;

  // URL de tu servidor CouchDB
  String baseUrl = '$direccionip/buscobien_fotos_ordenadas';

  // 1. GENERACIÓN DE HASH Y TIMESTAMP
  // Se mantiene la lógica original de actualizar el ID interno y el timestamp
  listaFotos.listadefotos.timestamp = DateTime.now().toString();

  listaFotos.listadefotos.idListaFotos = generateSHA256Hash(
    listaFotos.listadefotos.idUsuario +
        listaFotos.listadefotos.idPropiedad +
        listaFotos.listadefotos.timestamp +
        Random().nextInt(999).toString(),
  );

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json",
  };

  // 2. PREPARACIÓN DEL PAYLOAD
  // Nota: Al usar jsonEncode sobre el objeto completo (ValueGetIdPropiedad),
  // asegúrate de que incluya el campo "_rev" o "rev" necesario para CouchDB.
  String jsonContent = jsonEncode(listaFotos);

  // Construcción de la URL final para el recurso específico
  String updateUrl = "$baseUrl/${listaFotos.id}";

  debugPrintLevels(
    7,
    "actualizaFotosOrdenadas URL: $updateUrl Payload Size: ${jsonContent.length}",
  );

  try {
    // 3. PETICIÓN HTTP CON TIMEOUT
    var response = await http
        .put(Uri.parse(updateUrl), headers: headers, body: jsonContent)
        .timeout(const Duration(seconds: 10)); // Timeout de 10 segundos

    statusCode = response.statusCode;

    debugPrintLevels(7, "actualizaFotosOrdenadas StatusCode: $statusCode");

    // En CouchDB, una actualización exitosa suele devolver 201 (Created) o 200 (OK)
    if (statusCode == 201 || statusCode == 200) {
      debugPrintLevels(
        9,
        '07 actualizaFotosOrdenadas ÉXITO. ID: ${listaFotos.listadefotos.idListaFotos}',
      );
      // Opcional: Aquí podrías actualizar el 'rev' local con el que devuelve el body response
      // para futuras actualizaciones sin recargar todo.
    } else {
      debugPrintLevels(
        9,
        '09 actualizaFotosOrdenadas ERROR CouchDB. Código: $statusCode. Body: ${response.body}',
      );
    }
  } on TimeoutException {
    debugPrintLevels(7, "Error: Tiempo de espera agotado (Timeout).");
    statusCode = 408; // Request Timeout
  } catch (e) {
    // Captura errores generales (incluyendo SocketException para Móvil/Desktop y ClientException para Web)
    debugPrintLevels(7, "Error Excepción no controlada: $e");
    statusCode = 500; // Internal Server Error simulado
  }

  return statusCode;
}

//----------------------------------------------------------------------------
/*
Future<int> actualizaFotosOrdenadas(ValueGetIdPropiedad listaFotos) async {
  debugPrintLevels(7, "HTTP actualizaFotosOrdenadas");

  // Realizar la solicitud HTTP GET para recuperar el archivo adjunto
  int statusCode = 0;
  // URL de tu servidor CouchDB
  String baseUrl = '$direccionip/buscobien_fotos_ordenadas';
  debugPrintLevels(
    7,
    "actualizaFotosOrdenadas GUARDAR: $baseUrl: ${listaFotosOrdenadasToJson(listaFotos.listadefotos)}",
  );

  listaFotos.listadefotos.timestamp = DateTime.now().toString();
  listaFotos.listadefotos.idListaFotos = generateSHA256Hash(
    listaFotos.listadefotos.idUsuario +
        listaFotos.listadefotos.idPropiedad +
        listaFotos.listadefotos.timestamp +
        Random().nextInt(999).toString(),
  );

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json", // tipo de contenido
  };

  String jsonContent = jsonEncode(listaFotos);
  baseUrl = "$baseUrl/${listaFotos.id}";

  debugPrintLevels(
    7,
    "actualizaFotosOrdenadas jsonContent DE ACTUALIZA LISTA FOTOS : $jsonContent",
  );

  // ACTUALIZA FOTO DE LA PROPIEDAD
  var response = await http.put(
    Uri.parse(baseUrl),
    headers: headers,
    body: jsonContent,
  );
  debugPrintLevels(
    7,
    "actualizaFotosOrdenadas statusCode DE ACTUALIZA LISTA FOTOS : ${response.body}",
  );
  statusCode = response.statusCode;
  //  CouchDbReturnValue returnValue = CouchDbReturnValue(ok: false, id: '', rev: '');
  // returnValue = couchDbReturnValueFromJson(response.body);

  debugPrintLevels(
    7,
    "actualizaFotosOrdenadas statusCode DE ACTUALIZA LISTA FOTOS : $statusCode",
  );

  if (statusCode == 201) {
    //   registroGuardado = fotosCasaFromJson(response.body);
    debugPrintLevels(
      9,
      '07 actualizaFotosOrdenadas SE ACTUALIZO EL documento en CouchDB. Id: ${listaFotos.listadefotos}',
    );
  } else {
    debugPrintLevels(
      9,
      '09 actualizaFotosOrdenadas Error al ACTUALIZAR documento en CouchDB. Código de estado: $statusCode',
    );
  }
  return statusCode;
}
*/
