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

