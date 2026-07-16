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

class ElementosDelMenuTuCuentaUsuario {
  int index = 0;
  String etiqueta = "";
  late IconData icono;

  List<bool> buttonSelectOpcion = [
    false, // Listas
    false, // Grupos
    false, // Personas
  ];

  List<ElementosMenus> elementosMenuTuCuentaUsuario = [
    iconoTusListas,
    iconoTusGrupos,
    iconoTusConocidos,
  ];

  late TabController
  tabControllerMenuTuCuentaUsuario; // menu superior principal
  int seleccionMenuTuCuentaUsuario = 0;
}

ElementosDelMenuTuCuentaUsuario varElementosMenuTuCuentaUsuario =
    ElementosDelMenuTuCuentaUsuario();

final menuTuCuentaUsuarioProvider =
    StateNotifierProvider<ClaseMenuTuCuentaUsuario, ElementosDelMenuTuCuentaUsuario>((
      ref,
    ) {
      return ClaseMenuTuCuentaUsuario(varElementosMenuTuCuentaUsuario);
    });

class ClaseMenuTuCuentaUsuario
    extends StateNotifier<ElementosDelMenuTuCuentaUsuario> {
  ClaseMenuTuCuentaUsuario(super.state);

  //-----------------------------------------------------------------------------.
  void restableceOpcionActualSeleccionada(WidgetRef ref) {
    // restablece posición
    state.tabControllerMenuTuCuentaUsuario.index =
        state.seleccionMenuTuCuentaUsuario;
    // restablece  icono y etiqueta
    asignaNuevoIconoEtiqueta(state.tabControllerMenuTuCuentaUsuario.index);
  }

  void inicializaController(TickerProvider thisvar) {
    void handleTabSelection() {}

    state.tabControllerMenuTuCuentaUsuario = TabController(
      vsync: thisvar,
      length: state.elementosMenuTuCuentaUsuario.length,
    );
    state.tabControllerMenuTuCuentaUsuario.addListener(handleTabSelection);

    state.tabControllerMenuTuCuentaUsuario.index =
        state.seleccionMenuTuCuentaUsuario;
  }

  void disposeController() {
    state.tabControllerMenuTuCuentaUsuario.dispose();
  }

  void asignaNuevaOpcionSeleccionada(WidgetRef ref, int index) {
    state.seleccionMenuTuCuentaUsuario = index;
    //  state.seleccionMenuPrincipal = index + state.indexPromotor;
    //  state.index = index;

    state.etiqueta = state
        .elementosMenuTuCuentaUsuario[state.seleccionMenuTuCuentaUsuario]
        .etiqueta;
    state.icono = state
        .elementosMenuTuCuentaUsuario[state.seleccionMenuTuCuentaUsuario]
        .icono;

    state.buttonSelectOpcion[0] = false;
    state.buttonSelectOpcion[1] = false;
    state.buttonSelectOpcion[2] = false;
    state.buttonSelectOpcion[state.seleccionMenuTuCuentaUsuario] = true;
  }

  int getTamanioListaElementos() {
    // usuario regresa 6, promotor regresa 7
    return state.elementosMenuTuCuentaUsuario.length;
  }

  void asignaNuevoIconoEtiqueta(int index) {
    // state.index = index;
    state.seleccionMenuTuCuentaUsuario = index;

    state.etiqueta = state
        .elementosMenuTuCuentaUsuario[state.seleccionMenuTuCuentaUsuario]
        .etiqueta;
    state.icono = state
        .elementosMenuTuCuentaUsuario[state.seleccionMenuTuCuentaUsuario]
        .icono;
  }

  //-----------------------------------------------------------------------------.
}
