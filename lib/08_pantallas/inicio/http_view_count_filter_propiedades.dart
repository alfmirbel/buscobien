import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import '../../../40_security/direccionip.dart';
import '../../02_principal_screen/principal_sliver_screen_menus_inicio.dart';
import '../../05_provider_menus/provider_menu_nivel_gobierno.dart';
import '../../05_provider_menus/provider_menu_principal.dart';
import '../../40_security/urls_endpoints_espacios.dart';
import '../../60_global_widgets/debugprint.dart';
import 'data_count_view_documentos.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'data_get_valores_menus.dart';

// Importa tus modelos y otros providers necesarios
// import 'variables_view_query.dart';


part 'http_view_count_filter_propiedades.g.dart';

@riverpod
Future<int> viewCountFilterPropiedades(
  Ref ref,
  VariablesViewQuery valueQry,
) async {
  // 1. "Observamos" los estados globales
  final menuPrincipalEtiqueta = ref.watch(menuPrincipalProvider).etiqueta;
  final nivelGobierno = ref
      .watch(menuNivelDeGobiernoProvider)
      .seleccionMenuNivelDeGobierno;

  // 2. Lógica para el dropdown "Otros" usando el provider reactivo
  if (menuPrincipalEtiqueta == "Otros") {
    valueQry.etiquetaMenuPrincipal = selectedDropDownMenuPrincipalValue;
  }

  String url = "";
  String design = "";
  String view = "";
  String parametros = "";

  // 3. Selección del Documento (URL Base)
  url = '$direccionip/${endpointsPublicados[valueQry.etiquetaTipoDeEspacio]}';

  // 4. Selección de Diseño, Vista y Parámetros
  final isPrincipalTodos = valueQry.etiquetaMenuPrincipal == "Todas";
  final isTransaccionTodas = valueQry.etiquetaTipoDeTransaccion == "Todas";

  if (isPrincipalTodos && isTransaccionTodas) {
    design = "UB-TDA";
    view = switch (nivelGobierno) {
      0 => "count_by_pais_anuncio",
      1 => "count_by_estado_anuncio",
      2 => "count_by_municipio_anuncio",
      3 => "count_by_cp_anuncio",
      4 => "count_by_asentamiento_anuncio",
      _ => "",
    };
    parametros = _buildParams(nivelGobierno, valueQry, [
      if (nivelGobierno != 3 && nivelGobierno != 0) // CP = 1-3, PA = 4-0
        valueQry.etiquetaNivelGobierno,
      if (nivelGobierno == 4 || nivelGobierno == 3) // AS = 0-4, CP = 1-3
        valueQry.codigoPostal,
      if (nivelGobierno == 0) "México", // PA = 4-0
      valueQry.etiquetaTipoDeEspacio,
    ]);
  } else if (isPrincipalTodos) {
    design = "UB-TDA-TTX";
    view = switch (nivelGobierno) {
      0 => "count_by_pais_transaccion",
      1 => "count_by_municipio_transaccion",
      2 => "count_by_estado_transaccion",
      3 => "count_by_cp_transaccion",
      4 => "count_by_asentamiento_transaccion",
      _ => "",
    };
    parametros = _buildParams(nivelGobierno, valueQry, [
      if (nivelGobierno != 3 && nivelGobierno != 4) // CP = 1-3, PA = 4-0
        valueQry.etiquetaNivelGobierno,
      if (nivelGobierno == 4 || nivelGobierno == 3) // AS = 0-4, CP = 1-3
        valueQry.codigoPostal,
      if (nivelGobierno == 0) "México", // PA = 4-0
      valueQry.etiquetaTipoDeEspacio,
      valueQry.etiquetaTipoDeTransaccion,
    ]);
  } else if (isTransaccionTodas) {
    design = "TDP-UB-TDA";
    view = switch (nivelGobierno) {
      0 => "count_by_pais",
      1 => "count_by_estado",
      2 => "count_by_municipio",
      3 => "count_by_cp",
      4 => "count_by_asentamiento",
      _ => "",
    };
    parametros = _buildParams(nivelGobierno, valueQry, [
      valueQry.etiquetaMenuPrincipal,
      if (nivelGobierno != 3 && nivelGobierno != 0) // CP = 1-3, PA = 4-0
        valueQry.etiquetaNivelGobierno,
      if (nivelGobierno == 4 || nivelGobierno == 3) // AS = 0-4, CP = 1-3
        valueQry.codigoPostal,
      if (nivelGobierno == 0) "México", // PA = 4-0
      valueQry.etiquetaTipoDeEspacio,
    ]);
  } else {
    design = "TDP-UB-TDA-TTX";
    view = switch (nivelGobierno) {
      0 => "count_by_criteria",
      1 => "count_by_state",
      2 => "count_by_municipio",
      3 => "count_by_cp",
      4 => "count_by_asentamiento",
      _ => "",
    };

    parametros = _buildParams(nivelGobierno, valueQry, [
      valueQry.etiquetaMenuPrincipal,
      if (nivelGobierno != 3 && nivelGobierno != 0) // CP = 1-3, PA = 4-0
        valueQry.etiquetaNivelGobierno,
      if (nivelGobierno == 4 || nivelGobierno == 3) // AS = 0-4, CP = 1-3
        valueQry.codigoPostal,
      if (nivelGobierno == 40) "México", // PA = 4-0
      valueQry.etiquetaTipoDeEspacio,
      valueQry.etiquetaTipoDeTransaccion,
    ]);
  }

  // 5. Ejecución de la Petición
  final fullUrl = "$url/_design/$design/_view/$view?$parametros";
  final String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  try {
    final response = await http.get(
      Uri.parse(fullUrl),
      headers: {'Authorization': basicAuth, 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = utf8.decode(response.bodyBytes);
      final data = countViewDoctosFromJson(responseBody);
      return data.rows.isEmpty ? 0 : data.rows[0].value;
    }
    return 0;
  } catch (e) {
    debugPrintLevels(20, "Error en viewCountFilterPropiedades: $e");
    return 0;
  }
}

// Helper para construir las llaves de CouchDB de forma limpia
String _buildParams(int nivel, VariablesViewQuery q, List<dynamic> keys) {
  final keyString = jsonEncode(keys);
  return "group=true&key=$keyString";
}

/*
2. Cambios realizados
De Función a Provider: La función ahora está anotada con @riverpod. Esto genera 
automáticamente un provider llamado viewCountFilterPropiedadesProvider.

Manejo de Parámetros (Family): Al incluir VariablesViewQuery valueQry en la firma, 
Riverpod permite pasar este objeto desde la UI.

Reactividad con ref.watch: He sustituido ref.read por ref.watch en los menús. 
Esto es vital: si el usuario cambia el nivel de gobierno en el dropdown, este provider se disparará de nuevo automáticamente sin que tengas que llamar a la función manualmente.

Manejo de Excepciones: Agregué un bloque try-catch para manejar fallos de red, 
devolviendo 0 como hacías en tu lógica original.
*/

