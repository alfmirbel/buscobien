import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../20_var_globales/var_elementos_menus.dart';

// Menu 03 ---------------------------------------------------------------------

// "Asentamiento/Tipo", // "Zona",
// "C.P.",
// "Municipio"
// "Estado"
// "Nacional"

class ElementosDelMenuNivelDeGobierno {
  int index = 0;
  String etiqueta = "";
  late IconData icono;
  List<bool> buttonSelectOpcion = [
    true, // Asentamiento/Tipo
    //  false, // Zona
    false, // CP
    false, // Municipio
    false, // Estado
    false, // Nacional
  ];
  List<ElementosMenus> elementosMenuNivelDeGobierno = [
    iconoNacional,
    iconoEstado,
    iconoMunicipio,
    iconoCP,
    iconoColonia,
    //iconoLocalidad,
  ];
  late TabController tabControllerMenuNivelDeGobierno;
  int seleccionMenuNivelDeGobierno = 0;
}

ElementosDelMenuNivelDeGobierno varElementosMenuNivelDeGobierno =
    ElementosDelMenuNivelDeGobierno();

final menuNivelDeGobiernoProvider =
    StateNotifierProvider<
      ClaseMenuNivelDeGobierno,
      ElementosDelMenuNivelDeGobierno
    >((ref) {
      return ClaseMenuNivelDeGobierno(varElementosMenuNivelDeGobierno);
    });

class ClaseMenuNivelDeGobierno
    extends StateNotifier<ElementosDelMenuNivelDeGobierno> {
  ClaseMenuNivelDeGobierno(super.state);

  List<String> listNivelesDeGobierno = [
    "Nacional",
    "Estado",
    "Municipio",
    "C.P.",
    "Tipo/Localidad",
    // "Zona",
  ];

  //-----------------------------------------------------------------------------.

  void restableceOpcionActualSeleccionada(WidgetRef ref) {
    // restablece posición
    state.tabControllerMenuNivelDeGobierno.index =
        state.seleccionMenuNivelDeGobierno;
    // restablece  icono y etiqueta
    asignaNuevoIconoEtiqueta(state.tabControllerMenuNivelDeGobierno.index);
  }

  void inicializaController(TickerProvider thisvar) {
    void handleTabSelection() {}

    state.tabControllerMenuNivelDeGobierno = TabController(
      vsync: thisvar,
      length: state.elementosMenuNivelDeGobierno.length,
    );
    state.tabControllerMenuNivelDeGobierno.addListener(handleTabSelection);

    state.tabControllerMenuNivelDeGobierno.index =
        state.seleccionMenuNivelDeGobierno;
  }

  void disposeController() {
    state.tabControllerMenuNivelDeGobierno.dispose();
  }

  void asignaNuevaOpcionSeleccionada(WidgetRef ref, int index) {
    state.seleccionMenuNivelDeGobierno = index;
    //  state.seleccionMenuPrincipal = index + state.indexPromotor;
    // state.index = index;

    state.etiqueta = state
        .elementosMenuNivelDeGobierno[state.seleccionMenuNivelDeGobierno]
        .etiqueta;
    state.icono = state
        .elementosMenuNivelDeGobierno[state.seleccionMenuNivelDeGobierno]
        .icono;

    state.buttonSelectOpcion[0] = false;
    state.buttonSelectOpcion[1] = false;
    state.buttonSelectOpcion[2] = false;
    state.buttonSelectOpcion[3] = false;
    state.buttonSelectOpcion[4] = false;
    //  state.buttonSelectOpcion[5] = false;
    state.buttonSelectOpcion[state.seleccionMenuNivelDeGobierno] = true;
  }

  int getTamanioListaElementos() {
    // usuario regresa 6, promotor regresa 7
    return state.elementosMenuNivelDeGobierno.length;
  }

  void asignaNuevoIconoEtiqueta(int index) {
    // state.index = index;
    state.seleccionMenuNivelDeGobierno = index;

    state.etiqueta = state.elementosMenuNivelDeGobierno[index].etiqueta;
    state.icono = state.elementosMenuNivelDeGobierno[index].icono;
  }
}
