import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../10_user_login/usuario_login/provider_session.dart';
import '../20_var_globales/var_elementos_menus.dart';

// Menu 01 ---------------------------------------------------------------------
// Propiedades -> Todas
// "Casas"
// "Departamentos"
// "Otros inmuebles"

class ElementosDelMenuPrincipal {
  int index = 0; // usuario
  String etiqueta = "";
  int indexPromotor = 0; // no promotor, user o no user
  late IconData icono;
  List<bool> buttonSelectOpcion = [
    true,  // Todas 0
    false, // Casas 1
    false, // Departamentos 2
    false, // Otros 3
  ];
  List<ElementosMenus> elementosMenuPrincipal = [
    iconoTodasPropiedades,
    iconoCasas,
    iconoDepartamentos,
    iconoOtrosInmuebles,
  ];
  late TabController tabControllerMenuPrincipal; // menu superior principal
  int seleccionMenuPrincipal = 0;
}

ElementosDelMenuPrincipal varElementosMenuPrincipal =
    ElementosDelMenuPrincipal();

final menuPrincipalProvider =
    StateNotifierProvider<ClaseMenuPrincipal, ElementosDelMenuPrincipal>((ref) {
      return ClaseMenuPrincipal(varElementosMenuPrincipal);
    });

class ClaseMenuPrincipal extends StateNotifier<ElementosDelMenuPrincipal> {
  ClaseMenuPrincipal(super.state);

  void restableceOpcionActualSeleccionada(WidgetRef ref) {
    // restablece posición
    state.tabControllerMenuPrincipal.index = state.seleccionMenuPrincipal;
    // restablece  icono y etiqueta
    asignaNuevoIconoEtiqueta(state.tabControllerMenuPrincipal.index);
  }

  void setIndexPromotor(WidgetRef ref) {
    //debugPrintLevels(0, "+++ setIndexPromotor: ${ref.read(sessionDataNotifierProvider).boolUsuarioPromotor}");
    (ref.read(sessionProvider).esPromotor)
        ? state.indexPromotor =
              0 // promotor
        : state.indexPromotor = 1; // usuario
    //debugPrintLevels(0, "+++ setIndexPromotor Index: ${ref.read(menuPrincipalProvider).indexPromotor.toString()}");
  }

  void inicializaController(TickerProvider thisvar) {
    void handleTabSelection() {}

    state.tabControllerMenuPrincipal = TabController(
      vsync: thisvar,
      length: state.elementosMenuPrincipal.length,
    );
    state.tabControllerMenuPrincipal.addListener(handleTabSelection);

    state.tabControllerMenuPrincipal.index = state.seleccionMenuPrincipal;
  }

  void disposeController() {
    state.tabControllerMenuPrincipal.dispose();
  }

  void asignaNuevaOpcionSeleccionada(WidgetRef ref, int index) {
    state.seleccionMenuPrincipal = index;
    //  state.seleccionMenuPrincipal = index + state.indexPromotor;
    //  state.index = index;

    state.etiqueta =
        state.elementosMenuPrincipal[state.seleccionMenuPrincipal].etiqueta;
    state.icono =
        state.elementosMenuPrincipal[state.seleccionMenuPrincipal].icono;

    state.buttonSelectOpcion[0] = false;
    state.buttonSelectOpcion[1] = false;
    state.buttonSelectOpcion[2] = false;
    state.buttonSelectOpcion[3] = false;
    state.buttonSelectOpcion[state.seleccionMenuPrincipal] = true;
  }

  int getTamanioListaElementos() {
    return state.elementosMenuPrincipal.length;
  }

  void asignaNuevoIconoEtiqueta(int index) {
    // state.index = index;
    state.seleccionMenuPrincipal = index;

    state.etiqueta = state.elementosMenuPrincipal[index].etiqueta;
    state.icono = state.elementosMenuPrincipal[index].icono;
  }
}
