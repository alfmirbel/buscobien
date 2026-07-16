import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../01_home/home_navigation_provider.dart';
import '../../02_principal_screen/principal_sliver_screen_menus_inicio.dart';
import '../../05_provider_menus/provider_menu_nivel_gobierno.dart';
import '../../05_provider_menus/provider_menu_principal.dart';
import '../../05_provider_menus/provider_menu_tipo_de_transaccion.dart';
import '../../05_provider_menus/provider_menu_tipo_espacio.dart';
import '../ubicacion/provider_localidades_del_cp.dart';
import '../../60_global_widgets/debugprint.dart';
import 'data_get_valores_menus.dart';
// ... otros imports

part 'inicio_propiedades_providers.g.dart';

/// Maneja el estado del 'skip' (paginación)
@riverpod
class PaginacionBusqueda extends _$PaginacionBusqueda {
  @override
  int build() => 0;

  void avanzar(int limit, int total) {
    if ((state + limit) < total) state += limit;
  }

  void retroceder(int limit) {
    if (state >= limit) state -= limit;
  }

  void reset() => state = 0;
}

/// Provider que consolida los valores de los menús en un objeto VariablesViewQuery
@riverpod
VariablesViewQuery currentQuery(Ref ref) {
  // Al usar watch, este provider se invalida y recrea
  // automáticamente si cualquiera de estos cambia.
  VariablesViewQuery varValoresMenus = VariablesViewQuery();

  // Aquí pones la lógica que antes tenías en getValoresMenus
  // ... (llenar query basado en los estados de los providers)
  varValoresMenus.etiquetaMenuPrincipal = ref
      .read(menuPrincipalProvider)
      .elementosMenuPrincipal[ref.read(homeNavigationProvider).indicePrincipal]
      .etiqueta;
  debugPrintLevels(
    10,
    "getValoresMenus PaginacionBusqueda: ${varValoresMenus.etiquetaMenuPrincipal}",
  );
  // TuCuenta, Inicio, Casas, Departamentos, Otros, Ubicación, Perfil
  // String listaTiposPropiedad = '["Casas", "Departamentos", "Oficinas",
  // "Locales", "Terrenos", "Otros"]';
  switch (varValoresMenus.etiquetaMenuPrincipal) {
    case "Todas":
      varValoresMenus.etiquetaMenuPrincipal = "Todas";
      break;
    case "Casas":
      varValoresMenus.etiquetaMenuPrincipal = "Casa";
      varValoresMenus.queryMenuPrincipal =
          '{"espacioscasa.tipodepropiedad": {"\$eq": "${varValoresMenus.etiquetaMenuPrincipal}"}}';
      break;
    case "Departamentos":
      varValoresMenus.etiquetaMenuPrincipal = "Departamento";
      varValoresMenus.queryMenuPrincipal =
          '{"espacioscasa.tipodepropiedad": {"\$eq": "${varValoresMenus.etiquetaMenuPrincipal}"}}';
      break;
    case "Otros":
      // varValoresMenus.etiquetaMenuPrincipal = "Otros";
      varValoresMenus.etiquetaMenuPrincipal =
          selectedDropDownMenuPrincipalValue;
      varValoresMenus.queryMenuPrincipal =
          '{"espacioscasa.tipodepropiedad": {"\$eq": "$selectedDropDownMenuPrincipalValue"}}';
      //            '{"\$or": [{"espacioscasa.tipodepropiedad": {"\$eq": "Oficina"}}, {"espacioscasa.tipodepropiedad": {"\$eq": "Local"}}, {"espacioscasa.tipodepropiedad": {"\$eq": "Terreno"}}, {"espacioscasa.tipodepropiedad": {"\$eq": "Otros"}}]}';
      break;
    /*
    default:
      varValoresMenus.etiquetaMenuPrincipal = selectedDropdownValue;
       varValoresMenus.queryTipoPropiedad =
          '{"espacioscasa.tipodepropiedad": {"\$eq": "${varValoresMenus.etiquetaMenuPrincipal}"}}';
    */
  }
  // "TuCuenta"
  // "Inicio
  // "Casas"
  // "Departamentos"
  // "Otros"
  // "Ubicación"
  // "Perfil"
  //----------------------------------------------------------------------------
  int posicionNivelGobierno = ref
      .read(menuNivelDeGobiernoProvider)
      .seleccionMenuNivelDeGobierno;

  int indiceNivel = ref
      .read(localidadesPorCodigoPostalProvider)
      .localidadSeleccionada;

  varValoresMenus.codigoPostal = ref
      .read(localidadesPorCodigoPostalProvider)
      .localidades
      .rows[indiceNivel]
      .value
      .localidadCp
      .cp;

  switch (posicionNivelGobierno) {
    case 0:
      varValoresMenus.etiquetaNivelGobierno = "México";
      varValoresMenus.queryNivelGobierno =
          '{"espacioscasa.ubicacioncasa.pais": {"\$eq": "${varValoresMenus.etiquetaNivelGobierno}"}}';
      break;
    case 1:
      varValoresMenus.etiquetaNivelGobierno = ref
          .read(localidadesPorCodigoPostalProvider)
          .localidades
          .rows[indiceNivel]
          .value
          .localidadCp
          .estado;
      varValoresMenus.queryNivelGobierno =
          '{"espacioscasa.ubicacioncasa.localidadCp.estado": {"\$eq": "${varValoresMenus.etiquetaNivelGobierno}"}}';
      break;
    case 2:
      varValoresMenus.etiquetaNivelGobierno = ref
          .read(localidadesPorCodigoPostalProvider)
          .localidades
          .rows[indiceNivel]
          .value
          .localidadCp
          .municipio;
      varValoresMenus.queryNivelGobierno =
          '{"espacioscasa.ubicacioncasa.localidadCp.municipio": {"\$eq": "${varValoresMenus.etiquetaNivelGobierno}"}}';
      break;
    case 3:
      varValoresMenus.codigoPostal = ref
          .read(localidadesPorCodigoPostalProvider)
          .localidades
          .rows[indiceNivel]
          .value
          .localidadCp
          .cp;
      varValoresMenus.queryNivelGobierno =
          '{"espacioscasa.ubicacioncasa.localidadCp.cp": {"\$eq": ${varValoresMenus.codigoPostal}}}';
      break;
    case 4: // "Ubicación/Asentamiento/Tipo",
      varValoresMenus.etiquetaNivelGobierno = ref
          .read(localidadesPorCodigoPostalProvider)
          .localidades
          .rows[indiceNivel]
          .value
          .localidadCp
          .asentamiento;
      varValoresMenus.queryNivelGobierno =
          '{"\$and": [{"espacioscasa.ubicacioncasa.localidadCp.asentamiento": {"\$eq": "${varValoresMenus.etiquetaNivelGobierno}"}}, {"espacioscasa.ubicacioncasa.localidadCp.cp": {"\$eq": ${varValoresMenus.codigoPostal}}}]}';
      break;

    default:
  }
  // "Asentamiento o Ubicación/Tipo", // "Zona",
  // "C.P.",
  // "Municipio"
  // "Estado"
  // "Nacional"
  //----------------------------------------------------------------------------
  varValoresMenus.etiquetaTipoDeEspacio = ref
      .read(menuTipoEspaciosProvider)
      .etiqueta
      .toLowerCase();

  varValoresMenus.queryTipoDeEspacio =
      '{"espacioscasa.tipodeanuncio": {"\$eq": "${varValoresMenus.etiquetaTipoDeEspacio}"}}';
  // "Normales"
  // "Destacados"
  // "Superdestacados"
  // "Oportunidades"
  // "Remates"
  //----------------------------------------------------------------------------
  varValoresMenus.etiquetaTipoDeTransaccion = ref
      .read(menuTipoDeTransaccionProvider)
      .etiqueta;
  varValoresMenus.queryTipoDeTransaccion =
      '{"espacioscasa.tipodetransaccion": {"\$eq": "${varValoresMenus.etiquetaTipoDeTransaccion}"}}';
  if (varValoresMenus.etiquetaTipoDeTransaccion == "Todas") {
    varValoresMenus.queryTipoDeTransaccion =
        '{"\$or": [{"espacioscasa.tipodetransaccion": {"\$eq": "Venta"}}, {"espacioscasa.tipodetransaccion": {"\$eq": "Renta"}}, {"espacioscasa.tipodetransaccion": {"\$eq": "Venta/Renta"}}, {"espacioscasa.tipodetransaccion": {"\$ne": "Traspaso"}}]}';
  }
  // "Todas"
  // "Venta"
  // "Renta"
  // "Venta/Renta"
  // "Traspaso"
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  debugPrintLevels(
    2,
    "getValoresMenus etiquetaMenuPrincipal: ${varValoresMenus.etiquetaMenuPrincipal}",
  );
  debugPrintLevels(
    2,
    "getValoresMenus etiquetaNivelGobierno: ${varValoresMenus.etiquetaNivelGobierno}",
  );
  debugPrintLevels(
    2,
    "getValoresMenus etiquetaTipoDeEspacio: ${varValoresMenus.etiquetaTipoDeEspacio}",
  );
  debugPrintLevels(
    2,
    "getValoresMenus etiquetaTipoDeTransaccion: ${varValoresMenus.etiquetaTipoDeTransaccion}",
  );
  //----------------------------------------------------------------------------
  return varValoresMenus;
}
