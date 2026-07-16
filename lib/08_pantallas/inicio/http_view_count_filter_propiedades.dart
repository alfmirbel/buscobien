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

/*
*************************************************************************
flutter pub run build_runner build --delete-conflicting-outputs
************************************************************************
1. Definición del Provider con Generador
Crea el archivo (ej. view_count_filter_provider.dart):

3. Cómo usarlo en tu Widget (UI)
Para usar un provider que recibe parámetros (Family), se hace de la siguiente manera:

@override
Widget build(BuildContext context, WidgetRef ref) {
  // Supongamos que tienes tu objeto de consulta
  final myQuery = VariablesViewQuery(
    etiquetaTipoDeEspacio: "normales",
    // ... resto de campos
  );

  // Pasamos el objeto al provider
  final countAsync = ref.watch(viewCountFilterPropiedadesProvider(myQuery));

  return countAsync.when(
    data: (count) => Text('Resultados: $count'),
    loading: () => const CircularProgressIndicator(),
    error: (err, stack) => Text('Error: $err'),
  );
}
************************************************************************
*/

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

  /*
  switch (valueQry.etiquetaTipoDeEspacio) {
    "normales" => '$direccionip/${endpointsPublicados[0]}',
    "destacados" => '$direccionip/${endpointsPublicados[1]}',
    "superdestacados" => '$direccionip/${endpointsPublicados[2]}',
    "oportunidades" => '$direccionip/${endpointsPublicados[3]}',
    "remates" => '$direccionip/${endpointsPublicados[4]}',
    _ => '$direccionip/${endpointsPublicados[0]}',
  };
  */
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

/*
Future<int> viewCountFilterPropiedades(
  WidgetRef ref,
  VariablesViewQuery valueQry,
) async {
  String url = "";
  String design = "";
  String view = "";
  String parametros = "";

  int statusCode = 0;

  //----------------------------------------------------------------------------
  // SELECCION DEL DOCUMENTO
  switch (valueQry.etiquetaTipoDeEspacio) {
    case "normales":
      url = '$direccionip/buscobien_casas_comprados_normal';
      break;
    case "destacados":
      url = '$direccionip/buscobien_casas_comprados_destacado';
      break;
    case "superdestacados":
      url = '$direccionip/buscobien_casas_comprados_super';
      break;
    case "oportunidades":
      url = '$direccionip/buscobien_casas_comprados_oportunidad';
      break;
    case "remates":
      url = '$direccionip/buscobien_casas_comprados_remate';
      break;
    default:
      url = '$direccionip/buscobien_casas_comprados_normal';
  }
  //----------------------------------------------------------------------------
  // DRODOWN CHANGE
  if (ref.read(menuPrincipalProvider).etiqueta == "Otros") {
    valueQry.etiquetaMenuPrincipal = selectedDropDownMenuPrincipalValue;
    debugPrintLevels(
      2,
      "viewCountProviewCountFilterPropiedadespiedades etiquetaMenuPrincipal: $selectedDropDownMenuPrincipalValue",
    );
  }
  // SELECCION DEL DISEÑO, LA VISTA y PARAMETROS
  if ((valueQry.etiquetaMenuPrincipal == "Todos") &&
      (valueQry.etiquetaTipoDeTransaccion == "Todas")) {
    // 4.	UB-TDA - TODOS LOS TDP Y LOS TDTX
    design = "UB-TDA";
    // SELECCION DE LA VISTA y PARAMETROS
    switch (ref
        .read(menuNivelDeGobiernoProvider)
        .seleccionMenuNivelDeGobierno) {
      case 0:
        view = "count_by_asentamiento_anuncio";
        parametros =
            'group=true&key=["${valueQry.etiquetaNivelGobierno}","${valueQry.codigoPostal}","${valueQry.etiquetaTipoDeEspacio}"]';
        // parametros = 'group=true&key=["Asentamiento Y","12345","normales"]';
        break;
      case 1:
        view = "count_by_cp_anuncio";
        parametros =
            'group=true&key=["${valueQry.codigoPostal}","${valueQry.etiquetaTipoDeEspacio}"]';
        // parametros = 'group=true&key=["12345","normales"]';
        break;
      case 2:
        view = "count_by_municipio_anuncio";
        parametros =
            'group=true&key=["${valueQry.etiquetaNivelGobierno}","${valueQry.etiquetaTipoDeEspacio}"]';
        // parametros = 'group=true&key=["Municipio X","normales"]';
        break;
      case 3:
        view = "count_by_estado_anuncio";
        parametros =
            'group=true&key=["${valueQry.etiquetaNivelGobierno}","${valueQry.etiquetaTipoDeEspacio}"]';
        // parametros = 'group=true&key=["Estado","normales"]';
        break;
      case 4:
        view = "count_by_pais_anuncio";
        parametros =
            'group=true&key=["México","${valueQry.etiquetaTipoDeEspacio}"]';
        // parametros = 'group=true&key=["México","normales"]';
        break;
      default:
    }
  } else {
    if (valueQry.etiquetaMenuPrincipal == "Todos") {
      // && valueQry.etiquetaTipoDeTransaccion != "Todas")
      // 3.	UB-TDA-TTX -> TODOS LOS TDP
      design = "UB-TDA-TTX";
      // SELECCION DE LA VISTA y PARAMETROS
      switch (ref
          .read(menuNivelDeGobiernoProvider)
          .seleccionMenuNivelDeGobierno) {
        case 0:
          view = "count_by_asentamiento_transaccion";
          parametros =
              'group=true&key=["${valueQry.etiquetaNivelGobierno}","${valueQry.codigoPostal}","${valueQry.etiquetaTipoDeEspacio}","${valueQry.etiquetaTipoDeTransaccion}"]';
          // 'group=true&key=["Asentamiento Y","12345","normales","Venta"]';
          break;
        case 1:
          view = "count_by_cp_transaccion";
          parametros =
              'group=true&key=["${valueQry.codigoPostal}","${valueQry.etiquetaTipoDeEspacio}","${valueQry.etiquetaTipoDeTransaccion}"]';
          // parametros = 'group=true&key=["12345","normales","Venta"]';
          break;
        case 2:
          view = "count_by_municipio_transaccion";
          parametros =
              'group=true&key=["${valueQry.etiquetaNivelGobierno}","${valueQry.etiquetaTipoDeEspacio}","${valueQry.etiquetaTipoDeTransaccion}"]';
          // parametros = 'group=true&key=["Municipio X","normales","Venta"]';
          break;
        case 3:
          view = "count_by_estado_transaccion";
          parametros =
              'group=true&key=["${valueQry.etiquetaNivelGobierno}","${valueQry.etiquetaTipoDeEspacio}","${valueQry.etiquetaTipoDeTransaccion}"]';
          // parametros = 'group=true&key=["México","normales","Venta"]';
          break;
        case 4:
          view = "count_by_pais_transaccion";
          parametros =
              'group=true&key=["México","${valueQry.etiquetaTipoDeEspacio}","${valueQry.etiquetaTipoDeTransaccion}"]';
          // parametros = 'group=true&key=["México","normales","Venta"]';
          break;
        default:
      }
    } else {
      if (valueQry.etiquetaTipoDeTransaccion == "Todas") {
        // && (valueQry.etiquetaMenuPrincipal != "Todos")
        // 2.	TDP-UB-TDA -> TODOS LOS TDTX
        design = "TDP-UB-TDA";
        // SELECCION DE LA VISTA y PARAMETROS
        switch (ref
            .read(menuNivelDeGobiernoProvider)
            .seleccionMenuNivelDeGobierno) {
          case 0:
            view = "count_by_asentamiento";
            parametros =
                '?group=true&key=["${valueQry.etiquetaMenuPrincipal}","${valueQry.etiquetaNivelGobierno}","${valueQry.codigoPostal}","${valueQry.etiquetaTipoDeEspacio}"]';
            // '?group=true&key=["Casas","Asentamiento Y","12345","normales"]';
            break;
          case 1:
            view = "count_by_cp";
            parametros =
                'group=true&key=["${valueQry.etiquetaMenuPrincipal}","${valueQry.codigoPostal}","${valueQry.etiquetaTipoDeEspacio}"]';
            // 'group=true&key=["Casas","12345","normales"]';
            break;
          case 2:
            view = "count_by_municipio";
            parametros =
                'group=true&key=["${valueQry.etiquetaMenuPrincipal}","${valueQry.etiquetaNivelGobierno}","${valueQry.etiquetaTipoDeEspacio}"]';
            // 'group=true&key=["Casas","Municipio X","normales"]';
            break;
          case 3:
            view = "count_by_estado";
            parametros =
                'group=true&key=["${valueQry.etiquetaMenuPrincipal}","${valueQry.etiquetaNivelGobierno}","${valueQry.etiquetaTipoDeEspacio}"]';
            // 'group=true&key=["Casas","México","normales"]';
            break;
          case 4:
            view = "count_by_pais";
            parametros =
                'group=true&key=["${valueQry.etiquetaMenuPrincipal}","México","${valueQry.etiquetaTipoDeEspacio}"]';
            // 'group=true&key=["Casas","México","normales"]';
            break;
          default:
        }
      } else {
        // 1.	TDP-UB-TDA-TTX -> TDP = CASA, DEPARTAMENTOS U OTROS
        design = "TDP-UB-TDA-TTX";
        // SELECCION DE LA VISTA y PARAMETROS
        switch (ref
            .read(menuNivelDeGobiernoProvider)
            .seleccionMenuNivelDeGobierno) {
          case 0:
            view = "count_by_asentamiento";
            parametros =
                'group=true&key=["${valueQry.etiquetaMenuPrincipal}","${valueQry.etiquetaNivelGobierno}","${valueQry.codigoPostal}","${valueQry.etiquetaTipoDeEspacio}","${valueQry.etiquetaTipoDeTransaccion}"]';
            // 'group=true&key=["Casas","Asentamiento","12345","normales","Venta"]';
            break;
          case 1:
            view = "count_by_cp";
            parametros =
                'group=true&key=["${valueQry.etiquetaMenuPrincipal}","${valueQry.codigoPostal}","${valueQry.etiquetaTipoDeEspacio}","${valueQry.etiquetaTipoDeTransaccion}"]';
            // 'group=true&key=["Casas","12345","normales","Venta"]';
            break;
          case 2:
            view = "count_by_municipio";
            parametros =
                'group=true&key=["${valueQry.etiquetaMenuPrincipal}", "${valueQry.etiquetaNivelGobierno}", "${valueQry.etiquetaTipoDeEspacio}","${valueQry.etiquetaTipoDeTransaccion}"]';
            break;
          case 3:
            view = "count_by_state";
            parametros =
                'group=true&key=["${valueQry.etiquetaMenuPrincipal}", "${valueQry.etiquetaNivelGobierno}", "${valueQry.etiquetaTipoDeEspacio}","${valueQry.etiquetaTipoDeTransaccion}"]';
            // 'group=true&key=["Casa", "Estado", "destacados","Venta"]';
            break;
          case 4:
            view = "count_by_criteria";
            parametros =
                'group=true&key=["${valueQry.etiquetaMenuPrincipal}", "México", "${valueQry.etiquetaTipoDeEspacio}","${valueQry.etiquetaTipoDeTransaccion}"]';
            // 'group=true&key=["Casa", "México", "destacados","Venta"]';
            break;
          default:
        }
      }
    }
  }
  //----------------------------------------------------------------------------
  // 1.	TDP-UB-TDA-TTX -> TDP = CASA, DEPARTAMENTOS U OTROS
  // 2.	TDP-UB-TDA -> TODOS LOS TDTX
  // 3.	UB-TDA-TTX -> TODOS LOS TDP
  // 4.	UB-TDA - TODOS LOS TDP Y LOS TDTX
  //----------------------------------------------------------------------------
  String selector = '';
  selector = '/_design/$design/_view/$view?$parametros';

  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  Map<String, String> headers = {
    'Authorization': basicAuth,
    'Content-Type': 'application/json',
  };

  url = url + selector;

  debugPrintLevels(2, "viewCountFilterPropiedades fetch url get user: $url");

  //------------------------------------------------------------------------------
  switch (valueQry.etiquetaMenuPrincipal) {
    case "Propiedades":
      valueQry.etiquetaMenuPrincipal = "Todos";
      break;
    case "Casas":
      valueQry.etiquetaMenuPrincipal = "Casa";
      valueQry.queryMenuPrincipal =
          '{"espacioscasa.tipodepropiedad": {"\$eq": "${valueQry.etiquetaMenuPrincipal}"}}';
      break;
    case "Departamentos":
      valueQry.etiquetaMenuPrincipal = "Departamento";
      valueQry.queryMenuPrincipal =
          '{"espacioscasa.tipodepropiedad": {"\$eq": "${valueQry.etiquetaMenuPrincipal}"}}';
      break;
    case "Otros":
      // CHANGE DRODOWN
      valueQry.etiquetaMenuPrincipal = "Otros";
      valueQry.queryMenuPrincipal =
          '{"espacioscasa.tipodepropiedad": {"\$eq": $selectedDropDownMenuPrincipalValue}}';
      // '{"\$or": [{"espacioscasa.tipodepropiedad": {"\$eq": "Oficina"}}, {"espacioscasa.tipodepropiedad": {"\$eq": "Local"}}, {"espacioscasa.tipodepropiedad": {"\$eq": "Terreno"}}, {"espacioscasa.tipodepropiedad": {"\$eq": "Otros"}}]}';
      break;
  }
  /*
  "Bodega",
  "Casa",
  "Departamento",
  "Oficina",
  "Lote",
  "Accesoria",
  "Rancho",
  "Local",
  "Terreno",
  "Otros",
*/
  //------------------------------------------------------------------------------
  var response = await http.get(Uri.parse(url), headers: headers);
  //------------------------------------------------------------------------------

  //debugPrintLevels(2, "respuesta: ${response.body}");
  debugPrintLevels(
    2,
    "viewCountFilterPropiedades statusCode: ${response.statusCode}",
  );
  if (response.statusCode == 200) {
    var responseBody = utf8.decode(response.bodyBytes);
    debugPrintLevels(2, "viewCountFilterPropiedades responseBody: $responseBody");

    CountViewDoctos futureResponseDocs = countViewDoctosFromJson(responseBody);
    if (futureResponseDocs.rows.isEmpty) {
      statusCode = 0;
    } else {
      statusCode = futureResponseDocs.rows[0].value;
      debugPrintLevels(
        2,
        "viewCountFilterPropiedades columnas en value: ${futureResponseDocs.rows[0].value.toString()}",
      );
    }
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    debugPrintLevels(2, "Failed to load data ${response.statusCode}");
    //throw Exception('Failed to load data');
    statusCode = 0;
  }
  return statusCode;
}
*/
