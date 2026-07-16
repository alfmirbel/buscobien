import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import 'dart:convert';
import '../../../40_security/direccionip.dart';
import '../../05_provider_menus/provider_menu_tipo_espacio.dart';
import '../../40_security/urls_endpoints_espacios.dart';
import '../../60_global_widgets/debugprint.dart';
import 'data_espacios_casas_get.dart';

import '../propiedades/data_find_propiedades.dart';
import 'data_get_valores_menus.dart';

/*
Para convertir esta función en un provider utilizando Riverpod Generator, 
seguiremos el patrón de un FutureProvider con parámetros (lo que antes se conocía como .family).

Cambios Clave y Mejoras:
Parámetros Nombrados: En Riverpod Gen, cuando pasas múltiples argumentos, 
es mejor usarlos como parámetros nombrados ({required int skip...}) para que el código sea más legible al llamarlo.

Uso de ref.watch: He cambiado ref.read por ref.watch(menuTipoEspaciosProvider). 
Esto es vital: si el usuario cambia la categoría (ej. de "Normales" a "Remates"), Riverpod detectará el cambio y disparará la petición automáticamente.

Refactorización del Switch: Utilicé la nueva sintaxis de switch de Dart 
(expresiones switch) para que la asignación de la URL sea mucho más limpia.

Mapeo Funcional: Eliminé el for donde inicializabas manualmente cada campo del 
objeto vacío. Usar .map() sobre los documentos recibidos es más eficiente y menos propenso a errores de "tecleo".

Seguridad JSON: En lugar de concatenar strings para el cuerpo del POST, cree un 
mapa de Dart y usé jsonEncode. Esto asegura que el JSON sea válido siempre.
*/
part 'http_find_propiedades_10en10.g.dart';

@riverpod
Future<EspaciosCasaGet> findPropiedadesEstadosde10en10(
  Ref ref, {
  required int paramSkipFind,
  required int paramLimitFind,
  required VariablesViewQuery valueQry,
}) async {
  // 1. Escuchamos el tipo de espacio. Si cambia en el menú, este provider se reinicia solo.
  final tipoEspacio = ref
      .watch(menuTipoEspaciosProvider)
      .etiqueta
      .toLowerCase();

  String url = "";
  String selector = "";

  // Lógica de selección de selector (Simplificada para legibilidad)
  if (valueQry.etiquetaMenuPrincipal == "Todas" &&
      valueQry.etiquetaTipoDeTransaccion == "Todas") {
    selector =
        '{"\$and": [${valueQry.queryNivelGobierno}, ${valueQry.queryTipoDeEspacio}]}';
  } else if (valueQry.etiquetaMenuPrincipal == "Todas") {
    selector =
        '{"\$and": [${valueQry.queryNivelGobierno}, ${valueQry.queryTipoDeEspacio}, ${valueQry.queryTipoDeTransaccion}]}';
  } else if (valueQry.etiquetaTipoDeTransaccion == "Todas") {
    selector =
        '{"\$and": [${valueQry.queryMenuPrincipal}, ${valueQry.queryNivelGobierno}, ${valueQry.queryTipoDeEspacio}]}';
  } else {
    selector =
        '{"\$and": [${valueQry.queryMenuPrincipal}, ${valueQry.queryNivelGobierno}, ${valueQry.queryTipoDeEspacio}, ${valueQry.queryTipoDeTransaccion}]}';
  }

  final dbName =
      endpointsPublicados[tipoEspacio] ?? endpointsPublicados["normales"];
  url = '$direccionip/$dbName/_find';

  // Preparación de la petición
  final busquedaJSON = jsonEncode({
    "selector": jsonDecode(
      selector,
    ), // Convertimos el string a objeto JSON real
    "skip": paramSkipFind,
    "limit": paramLimitFind,
  });

  debugPrintLevels(10, " >>>> findPropiedadesEstadosde10en10 URL: $url");
  debugPrintLevels(
    10,
    " >>>> findPropiedadesEstadosde10en10 busquedaJSON: $busquedaJSON",
  );

  final headers = {
    'Authorization':
        'Basic ${base64Encode(utf8.encode('$username:$password'))}',
    'Content-Type': 'application/json',
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: busquedaJSON,
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final findDocs = findPropiedadesFromJson(responseBody);

      // Mapeo optimizado: Convertimos la respuesta de CouchDB al formato de tu lista
      return EspaciosCasaGet(
        offset: paramSkipFind,
        totalRows: findDocs.docs.length,
        rows: findDocs.docs
            .map(
              (doc) => RowEspaciosCasaGet(
                id: doc.id,
                key: doc.rev,
                value: ValueEspaciosCasaGet(
                  id: doc.id,
                  rev: doc.rev,
                  espacioscasa: doc.espacioscasa,
                ),
              ),
            )
            .toList(),
      );
    } else {
      return EspaciosCasaGet(offset: 0, totalRows: 0, rows: []);
    }
  } catch (e) {
    return EspaciosCasaGet(offset: 0, totalRows: 0, rows: []);
  }
}

/*
Cómo llamar a este provider en tu UI:
Dart

@override
Widget build(BuildContext context, WidgetRef ref) {
  // Solo pasas los parámetros. Riverpod se encarga del caché y el estado.
  final propiedadesAsync = ref.watch(findPropiedadesEstadosde10en10Provider(
    skip: paramSkip,
    limit: paramLimit,
    valueQry: miQueryObject,
  ));

  return propiedadesAsync.when(
    data: (data) => _buildLista(data.rows),
    loading: () => const CircularProgressIndicator(),
    error: (err, stack) => Text('Error: $err'),
  );
}
*/
