import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../20_var_globales/var_elementos_menus.dart';

// Menu 04 ---------------------------------------------------------------------

// "Normales"
// "Destacados" - > "Relevantes"
// "Superdestacados" -> "Sobresalientes"
// "Oportunidades"
// "Remates"

class ElementosDelMenuTipoEspacios {
  int index = 0;
  String etiqueta = "";
  late IconData icono;

  List<bool> buttonSelectOpcion = [
    true, // "Normales"
    false, // "Destacados"
    false, // "Superdestacados"
    false, // "Oportunidades"
    false, // "Remates"
  ];

  List<ElementosMenus> elementosMenuTipoEspacio = [
    iconoSuperdestacados,
    iconoDestacados,
    iconoNormales,
    iconoOportunidades,
    iconoRemates,
  ];

  late TabController tabControllerMenuTipoEspacios;
  int seleccionMenuTipoEspacios = 0;
}

ElementosDelMenuTipoEspacios varElementosMenuTipoEspacios =
    ElementosDelMenuTipoEspacios();

final menuTipoEspaciosProvider =
    StateNotifierProvider<ClaseMenuTipoEspacio, ElementosDelMenuTipoEspacios>((
      ref,
    ) {
      return ClaseMenuTipoEspacio(varElementosMenuTipoEspacios);
    });

class ClaseMenuTipoEspacio extends StateNotifier<ElementosDelMenuTipoEspacios> {
  ClaseMenuTipoEspacio(super.state);

  //-----------------------------------------------------------------------------.

  void restableceOpcionActualSeleccionada(WidgetRef ref) {
    // restablece posición
    state.tabControllerMenuTipoEspacios.index = state.seleccionMenuTipoEspacios;
    // restablece  icono y etiqueta
    asignaNuevoIconoEtiqueta(state.tabControllerMenuTipoEspacios.index);
  }

  void inicializaController(TickerProvider thisvar) {
    void handleTabSelection() {}

    state.tabControllerMenuTipoEspacios = TabController(
      vsync: thisvar,
      length: state.elementosMenuTipoEspacio.length,
    );
    state.tabControllerMenuTipoEspacios.addListener(handleTabSelection);

    state.tabControllerMenuTipoEspacios.index = state.seleccionMenuTipoEspacios;
  }

  void disposeController() {
    state.tabControllerMenuTipoEspacios.dispose();
  }

  void asignaNuevaOpcionSeleccionada(WidgetRef ref, int index) {
    state.seleccionMenuTipoEspacios = index;
    //  state.seleccionMenuPrincipal = index + state.indexPromotor;
    //  state.index = index;

    state.etiqueta = state
        .elementosMenuTipoEspacio[state.seleccionMenuTipoEspacios]
        .etiqueta;
    state.icono =
        state.elementosMenuTipoEspacio[state.seleccionMenuTipoEspacios].icono;

    state.buttonSelectOpcion[0] = false;
    state.buttonSelectOpcion[1] = false;
    state.buttonSelectOpcion[2] = false;
    state.buttonSelectOpcion[3] = false;
    state.buttonSelectOpcion[4] = false;
    state.buttonSelectOpcion[state.seleccionMenuTipoEspacios] = true;
  }

  int getTamanioListaElementos() {
    // usuario regresa 6, promotor regresa 7
    return state.elementosMenuTipoEspacio.length;
  }

  void asignaNuevoIconoEtiqueta(int index) {
    // state.index = index;
    state.seleccionMenuTipoEspacios = index;

    state.etiqueta = state.elementosMenuTipoEspacio[index].etiqueta;
    state.icono = state.elementosMenuTipoEspacio[index].icono;
  }

  //------------------------------------------------------------------------------
}
