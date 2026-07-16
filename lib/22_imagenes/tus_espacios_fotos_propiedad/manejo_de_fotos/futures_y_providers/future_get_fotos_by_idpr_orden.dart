import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buscobien/40_security/direccionip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../60_global_widgets/debugprint.dart';
import '../lista_fotos_ordenadas/data_fotos_ordenadas_get_idpropiedad.dart';
import '../lista_fotos_ordenadas/provider_get_lista_fotos_ordenadas.dart';

// OPTIMIZADO
Future<int> recuperaFotosOrdenadasIdProperty(
  WidgetRef ref,
  String idPropiedad,
) async {
  debugPrintLevels(7, "HTTP recuperaFotosOrdenadasIdProperty");

  // PROTECCIÓN 1: Limpieza inicial segura
  // Intentamos limpiar. Si el widget ya no existe al entrar aquí, no hacemos nada.
  try {
    ref
        .read(getListaFotosOrdenadasProvider.notifier)
        .clearFotoListaPosiciones();
  } catch (e) {
    debugPrintLevels(
      1,
      "recuperaFotosOrdenadasIdProperty: Widget desmontado al inicio. Abortando.",
    );
    return 0; // Salimos si ni siquiera podemos iniciar
  }

  int statusCode = 0;

  // Codificación segura de la URL
  final String keyEncoded = Uri.encodeComponent('"$idPropiedad"');

  // Asumimos que 'direccionip', 'username' y 'password' son variables globales o importadas
  String baseUrl =
      '$direccionip/buscobien_fotos_ordenadas/_design/DDLISTAFOTOS/_view/idpropiedad?key=$keyEncoded';

  debugPrintLevels(7, "recuperaFotosOrdenadasIdProperty URL DE: $baseUrl");

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json",
    'Accept': "application/json",
  };

  try {
    // LLAMADA ASÍNCRONA (Aquí se genera el "Async Gap")
    var response = await http
        .get(Uri.parse(baseUrl), headers: headers)
        .timeout(const Duration(seconds: 30));

    statusCode = response.statusCode;

    debugPrintLevels(
      7,
      "recuperaFotosOrdenadasIdProperty statusCode: $statusCode",
    );

    if (statusCode == 200) {
      debugPrintLevels(
        7,
        "recuperaFotosOrdenadasIdProperty response.body received",
      );

      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      ListaFotosOrdenadasGetIdPropiedad resultado =
          ListaFotosOrdenadasGetIdPropiedad.fromJson(jsonResponse);

      // Verificación de datos vacíos
      if (resultado.rows.isEmpty) {
        statusCode = 408;
        debugPrintLevels(
          7,
          'recuperaFotosOrdenadasIdProperty LISTA VACIA en CouchDB.',
        );
        // Nota: Mantenemos 200 si la petición fue exitosa, aunque no haya fotos.
        // Si necesitas forzar error en UI, puedes usar otro código, pero 200 es correcto técnicamente.
      } else {
        // PROTECCIÓN 2: Actualización segura del Provider
        // Aquí es donde ocurría el crash. Verificamos si podemos usar 'ref'.
        debugPrintLevels(
          7,
          'recuperaFotosOrdenadasIdProperty Intentando guardar en provider...',
        );
        try {
          // Actualizamos el estado. No es necesario Future.microtask si estamos
          // en un callback asíncrono después de un await, pero el try-catch es vital.
          ref
              .read(getListaFotosOrdenadasProvider.notifier)
              .setFotoListaPosiciones(resultado);

          debugPrintLevels(
            7,
            'recuperaFotosOrdenadasIdProperty GUARDA LISTA EXITOSO: ${resultado.rows[0].value.listadefotos.fotosOrden.length}.',
          );
          statusCode = 200;
        } catch (e) {
          statusCode = 500;

          // Si entra aquí, es porque el widget se desmontó (Bad state: Using "ref"...)
          // Ignoramos el error intencionalmente porque ya no hay UI que actualizar.
          debugPrintLevels(
            1,
            "recuperaFotosOrdenadasIdProperty: Widget desmontado, omitiendo actualización de estado.",
          );
        }
      }
    } else {
      // NO 200
      statusCode = response.statusCode; // NO 200
      debugPrintLevels(
        7,
        'recuperaFotosOrdenadasIdProperty Error Servidor. Código: $statusCode Body: ${response.body}',
      );
    }
  } on SocketException {
    debugPrintLevels(7, 'recuperaFotosOrdenadasIdProperty Error: Sin conexión');
    statusCode = 503;
  } on TimeoutException {
    debugPrintLevels(7, 'recuperaFotosOrdenadasIdProperty Error: Timeout');
    statusCode = 408;
  } catch (e) {
    debugPrintLevels(7, 'recuperaFotosOrdenadasIdProperty Error general: $e');
    // Si el error fue por el http client u otra cosa
    statusCode = 500;
  }

  return statusCode;
}

/*
Future<int> recuperaFotosOrdenadasIdProperty(
  WidgetRef ref,
  String idPropiedad,
) async {
  debugPrintLevels(7, "HTTP recuperaFotosOrdenadasIdProperty");

  // OPTIMIZACIÓN: Limpiar el estado antes de la carga es correcto para evitar
  // mostrar datos viejos, pero asegura que esto no cause parpadeos indeseados.
  // CORRECCIÓN CRÍTICA:
  // Usamos Future.microtask para sacar la modificación del estado del ciclo de construcción (Build)
  // Esto evita el error "Tried to modify a provider while the widget tree was building".
  Future.microtask(() {
    ref
        .read(getListaFotosOrdenadasProvider.notifier)
        .clearFotoListaPosiciones();
  });

  int statusCode = 0;

  // OPTIMIZACIÓN: Codificación segura del parámetro para evitar errores de sintaxis en URL
  // CouchDB requiere que las keys string lleven comillas, por eso '"$idPropiedad"'
  final String keyEncoded = Uri.encodeComponent('"$idPropiedad"');

  // URL de tu servidor CouchDB
  // Se asume que 'direccionip' incluye el protocolo (http://IP:PORT)
  String baseUrl =
      '$direccionip/buscobien_fotos_ordenadas/_design/DDLISTAFOTOS/_view/idpropiedad?key=$keyEncoded';

  debugPrintLevels(7, "recuperaFotosOrdenadasIdProperty URL DE: $baseUrl");

  // OPTIMIZACIÓN: Manejo de autenticación seguro
  // Nota: Asegúrate de que 'username' y 'password' estén definidos en el ámbito global o pasados como argumentos.
  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': "application/json",
    'Accept': "application/json", // Buena práctica agregar Accept
  };

  try {
    // OPTIMIZACIÓN: Timeout agregado (10 segundos) para no congelar la app
    var response = await http
        .get(Uri.parse(baseUrl), headers: headers)
        .timeout(const Duration(seconds: 10));

    statusCode = response.statusCode;

    debugPrintLevels(
      7,
      "recuperaFotosOrdenadasIdProperty statusCode: $statusCode",
    );

    if (statusCode == 200) {
      debugPrintLevels(
        7,
        "recuperaFotosOrdenadasIdProperty response.body received",
      );

      // Decodificar JSON
      // Se recomienda usar compute() si el JSON es muy grande, pero para listas normales esto está bien.
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      ListaFotosOrdenadasGetIdPropiedad resultado =
          ListaFotosOrdenadasGetIdPropiedad.fromJson(jsonResponse);

      debugPrintLevels(
        7,
        "recuperaFotosOrdenadasIdProperty FOTOS RECUPERADAS: ${resultado.rows[0].value.listadefotos.fotosOrden.length}",
      );

      if (resultado.rows.isEmpty) {
        debugPrintLevels(
          7,
          'recuperaFotosOrdenadasIdProperty LISTA VACIA en CouchDB.',
        );
        statusCode = 404;
        // CAMBIO SUGERIDO: No retornar 500 si está vacío. Es un 200 válido sin datos.
        // Mantenemos statusCode 200, y el provider quedará vacío (que es lo correcto).
        // Si tu lógica UI depende estrictamente de que sea error para mostrar "No hay fotos",
        // puedes descomentar la siguiente línea, pero no es estándar HTTP.
        // statusCode = 404; // 404 Not Found es mejor que 500 Server Error
      } else {
        // Actualizar Provider
        debugPrintLevels(
          7,
          'recuperaFotosOrdenadasIdProperty GUARDA LISTA EN PROVIDER: ${resultado.rows[0].value.listadefotos.fotosOrden.length}.',
        );
        await Future.microtask(() {
          debugPrintLevels(7, 'EJECUTA MICROTASK.');
          ref
              .read(getListaFotosOrdenadasProvider.notifier)
              .setFotoListaPosiciones(resultado);
          debugPrintLevels(
            7,
            'TERMINA MICROTASK. ${ref.read(getListaFotosOrdenadasProvider).rows[0].value.listadefotos.fotosOrden.length}',
          );
        });

        debugPrintLevels(
          7,
          'recuperaFotosOrdenadasIdProperty LISTA ORDEN recuperada exitosamente de CouchDB.',
        );
      }
    } else {
      debugPrintLevels(
        7,
        'recuperaFotosOrdenadasIdProperty Error Servidor. Código de estado: $statusCode Body: ${response.body}',
      );
    }
  } on SocketException {
    // Error de conexión (Sin internet, servidor caído)
    debugPrintLevels(
      7,
      'recuperaFotosOrdenadasIdProperty Error: Sin conexión a internet o servidor inalcanzable',
    );
    statusCode = 503; // Service Unavailable
  } on TimeoutException {
    // Error de tiempo de espera
    debugPrintLevels(
      7,
      'recuperaFotosOrdenadasIdProperty Error: Tiempo de espera agotado',
    );
    statusCode = 408; // Request Timeout
  } catch (e) {
    // Otros errores no controlados
    debugPrintLevels(
      7,
      'recuperaFotosOrdenadasIdProperty Error no controlado: $e',
    );
    statusCode = 500;
  }

  return statusCode;
}
*/
//----------------------------------------------------------------------------
/*
Future<int> recuperaFotosOrdenadasIdProperty(
  WidgetRef ref,
  String idPropiedad,
) async {
  debugPrintLevels(7, "HTTP recuperaFotosOrdenadasIdProperty");
  // LIMPIA LISTA DE ORDEN DE FOTOS
  ref.read(getListaFotosOrdenadasProvider.notifier).clearFotoListaPosiciones();
  // Realizar la solicitud HTTP GET para recuperar lista de fotos
  int statusCode = 0;
  // URL de tu servidor CouchDB
  String baseUrl =
      '$direccionip/buscobien_fotos_ordenadas/_design/DDLISTAFOTOS/_view/idpropiedad?key="$idPropiedad"';
  debugPrintLevels(7, "recuperaFotosOrdenadasIdProperty URL DE: $baseUrl");

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
    "recuperaFotosOrdenadasIdProperty statusCode: $statusCode",
  );

  if (statusCode == 200) {
    // Decodificar el contenido del archivo recuperado
    debugPrintLevels(7, "recuperaFotosOrdenadasIdProperty response.body: ");
    ListaFotosOrdenadasGetIdPropiedad resultado =
        ListaFotosOrdenadasGetIdPropiedad.fromJson(jsonDecode(response.body));
    debugPrintLevels(
      7,
      "recuperaFotosOrdenadasIdProperty FOTOS RECUPERADAS: ${resultado.rows.length}",
    );
    if (resultado.rows.isEmpty) {
      debugPrintLevels(
        7,
        'recuperaFotosOrdenadasIdProperty LISTA VACIA en CouchDB.',
      );
      statusCode = 500;
    } else {
      ref
          .read(getListaFotosOrdenadasProvider.notifier)
          .setFotoListaPosiciones(resultado);
      //state = resultado;
      debugPrintLevels(
        7,
        'recuperaFotosOrdenadasIdProperty LISTA ORDEN recuperada exitosamente de CouchDB.',
      );
    }
  } else {
    debugPrintLevels(
      7,
      'recuperaFotosOrdenadasIdProperty Error. Código de estado: $statusCode',
    );
  }
  return statusCode;
}
*/
