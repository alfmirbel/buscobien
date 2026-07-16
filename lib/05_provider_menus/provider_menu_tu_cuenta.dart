import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../20_var_globales/var_elementos_menus.dart';

// Menu 02 ---------------------------------------------------------------------

// "Propiedades"
// "Listas"
// "Grupos"
// "Conocidos"

class ElementosDelMenuTuCuenta {
  int index = 0;
  String etiqueta = "";
  late IconData icono;

  List<bool> buttonSelectOpcion = [
    true, // Publicaciones
    false, // Listas
    false, // Grupos
    false, // Personas
  ];

  List<ElementosMenus> elementosMenuTuCuenta = [
    iconoTusEspacios,
    iconoTusListas,
    iconoTusGrupos,
    iconoTusConocidos,
  ];

  late TabController tabControllerMenuTuCuenta; // menu superior principal
  int seleccionMenuTuCuenta = 0;
}

ElementosDelMenuTuCuenta varElementosMenuTuCuenta = ElementosDelMenuTuCuenta();

final menuTuCuentaProvider =
    StateNotifierProvider<ClaseMenuTuCuenta, ElementosDelMenuTuCuenta>((ref) {
      return ClaseMenuTuCuenta(varElementosMenuTuCuenta);
    });

class ClaseMenuTuCuenta extends StateNotifier<ElementosDelMenuTuCuenta> {
  ClaseMenuTuCuenta(super.state);

  //-----------------------------------------------------------------------------.
  void restableceOpcionActualSeleccionada(WidgetRef ref) {
    // restablece posición
    state.tabControllerMenuTuCuenta.index = state.seleccionMenuTuCuenta;
    // restablece  icono y etiqueta
    asignaNuevoIconoEtiqueta(state.tabControllerMenuTuCuenta.index);
  }

  void inicializaController(TickerProvider thisvar) {
    void handleTabSelection() {}

    state.tabControllerMenuTuCuenta = TabController(
      vsync: thisvar,
      length: state.elementosMenuTuCuenta.length,
    );
    state.tabControllerMenuTuCuenta.addListener(handleTabSelection);

    state.tabControllerMenuTuCuenta.index = state.seleccionMenuTuCuenta;
  }

  void disposeController() {
    state.tabControllerMenuTuCuenta.dispose();
  }

  void asignaNuevaOpcionSeleccionada(WidgetRef ref, int index) {
    state.seleccionMenuTuCuenta = index;
    //  state.seleccionMenuPrincipal = index + state.indexPromotor;
    //  state.index = index;

    state.etiqueta =
        state.elementosMenuTuCuenta[state.seleccionMenuTuCuenta].etiqueta;
    state.icono =
        state.elementosMenuTuCuenta[state.seleccionMenuTuCuenta].icono;

    state.buttonSelectOpcion[0] = false;
    state.buttonSelectOpcion[1] = false;
    state.buttonSelectOpcion[2] = false;
    state.buttonSelectOpcion[3] = false;
    state.buttonSelectOpcion[state.seleccionMenuTuCuenta] = true;
  }

  int getTamanioListaElementos() {
    // usuario regresa 6, promotor regresa 7
    return state.elementosMenuTuCuenta.length;
  }

  void asignaNuevoIconoEtiqueta(int index) {
    // state.index = index;
    state.seleccionMenuTuCuenta = index;

    state.etiqueta =
        state.elementosMenuTuCuenta[state.seleccionMenuTuCuenta].etiqueta;
    state.icono =
        state.elementosMenuTuCuenta[state.seleccionMenuTuCuenta].icono;
  }

  //-----------------------------------------------------------------------------.
}
