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

//----------------------------------------------------------------------------
