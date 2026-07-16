import 'dart:async'; // Necesario para TimeoutException
import 'dart:convert';
import 'dart:io'; // Necesario para SocketException
import 'dart:math'; // Necesario para Random
import 'package:http/http.dart' as http;

// Asumimos que estas importaciones existen en tu proyecto
import '../../../../40_security/direccionip.dart';
import '../../../../40_security/generate_hash.dart';
import '../../../../60_global_widgets/debugprint.dart';
import '../../../data_models/data_fotos_ordenadas.dart';
// Asumiendo que CouchDbReturnValue está definido en algún lugar similar
import '../datos_fotos/data_couchdb_post_return.dart';
//----------------------------------------------------------------------------
// OPTIMIZADO

Future<CouchDbReturnValue> guardaFotosOrdenadas(
  ListaFotosOrdenadas listaFotos,
) async {
  debugPrintLevels(7, "HTTP guardaFotosOrdenadas START");

  // URL de tu servidor CouchDB
  String baseUrl = '$direccionip/buscobien_fotos_ordenadas';

  // 1. GENERACIÓN DE DATOS
  listaFotos.timestamp = DateTime.now().toString();

  // Nota: Generar un nuevo ID cada vez crea un documento nuevo.
  // Asegúrate de que esto es lo deseado y no una actualización (PUT) de un documento existente.
  listaFotos.idListaFotos = generateSHA256Hash(
    listaFotos.idUsuario +
        listaFotos.idPropiedad +
        listaFotos.timestamp +
        Random().nextInt(999).toString(),
  );

  debugPrintLevels(
    7,
    "guardaFotosOrdenadas URL: $baseUrl ID Generado: ${listaFotos.idListaFotos}",
  );

  // 2. AUTENTICACIÓN
  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json",
  };

  // 3. CONSTRUCCIÓN DEL JSON
  // Nota: Construir JSON manualmente concatenando strings es riesgoso.
  // Se mantiene por solicitud de no cambiar lógica, pero se recomienda usar Map<String, dynamic> y jsonEncode.
  String internalJson = listaFotosOrdenadasToJson(listaFotos);
  String jsonContent = '{"listadefotos": $internalJson}';

  debugPrintLevels(
    7,
    "guardaFotosOrdenadas Payload Size: ${jsonContent.length} bytes",
  );

  // Inicializamos un valor de retorno por defecto (Error) para devolver en caso de fallo de red
  // Usamos un JSON string dummy para generar el objeto si falla la red, asumiendo que el parser lo soporta
  CouchDbReturnValue returnValue = couchDbReturnValueFromJson(
    '{"ok": false, "id": "", "rev": ""}',
  );
  int statusCode = 0;

  try {
    // 4. PETICIÓN HTTP CON TIMEOUT Y MANEJO DE ERRORES
    var response = await http
        .post(Uri.parse(baseUrl), headers: headers, body: jsonContent)
        .timeout(const Duration(seconds: 10)); // Timeout de 10 segundos

    statusCode = response.statusCode;
    debugPrintLevels(7, "guardaFotosOrdenadas StatusCode: $statusCode");

    if (statusCode == 201) {
      // 5. PARSEO SEGURO
      // Solo intentamos parsear si el servidor dice que todo salió bien (Created)
      try {
        returnValue = couchDbReturnValueFromJson(response.body);
        debugPrintLevels(
          9,
          '07 Exito: Documento guardado en CouchDB. Id: ${returnValue.id}',
        );
      } catch (e) {
        debugPrintLevels(9, 'Error de formato en respuesta de CouchDB: $e');
      }
    } else {
      debugPrintLevels(
        9,
        '09 Error CouchDB: $statusCode. Body: ${response.body}',
      );
    }
  } on SocketException {
    debugPrintLevels(
      9,
      'Error: Sin conexión a Internet o servidor no encontrado.',
    );
  } on TimeoutException {
    debugPrintLevels(9, 'Error: Tiempo de espera agotado al guardar orden.');
  } catch (e) {
    debugPrintLevels(9, 'Error no controlado en guardaFotosOrdenadas: $e');
  }

  return returnValue;
}

//----------------------------------------------------------------------------
/*
Future<CouchDbReturnValue> guardaFotosOrdenadas(
    ListaFotosOrdenadas listaFotos) async {
  debugPrintLevels(7, "HTTP guardaFotosOrdenadas");

  // Realizar la solicitud HTTP GET para recuperar el archivo adjunto
  int statusCode = 0;
  // URL de tu servidor CouchDB
  String baseUrl = '$direccionip/buscobien_fotos_ordenadas';
  debugPrintLevels(7,
      "guardaFotosOrdenadasURL GUARDAR: $baseUrl: ${listaFotosOrdenadasToJson(listaFotos)}");

  listaFotos.timestamp = DateTime.now().toString();
  listaFotos.idListaFotos = generateSHA256Hash(listaFotos.idUsuario +
      listaFotos.idPropiedad +
      listaFotos.timestamp +
      Random().nextInt(999).toString());

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json", // tipo de contenido
  };

  String jsonContent = listaFotosOrdenadasToJson(listaFotos);
  jsonContent = '{"listadefotos": $jsonContent}';
  debugPrintLevels(7,
      "guardaFotosOrdenadas jsonContent DE GUARDA LISTA FOTOS : $jsonContent");

  // CREA NUEVO DOCUMENTO FOTO DE LA PROPIEDAD
  var response =
      await http.post(Uri.parse(baseUrl), headers: headers, body: jsonContent);

  CouchDbReturnValue returnValue = couchDbReturnValueFromJson(response.body);
  statusCode = response.statusCode;

  debugPrintLevels(
      7, "guardaFotosOrdenadas statusCode DE GUARDA LISTA FOTOS : $statusCode");

  if (statusCode == 201) {
    //   registroGuardado = fotosCasaFromJson(response.body);
    debugPrintLevels(9,
        '07 guardaFotosOrdenadas SE GUARDO EL  documento en CouchDB. Id: ${listaFotos.idListaFotos}');
  } else {
    debugPrintLevels(9,
        '09 guardaFotosOrdenadas Error al GUARDAR documento en CouchDB. Código de estado: $statusCode');
  }
  return returnValue;
}
*/
