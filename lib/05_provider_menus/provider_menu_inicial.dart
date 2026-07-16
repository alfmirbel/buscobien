import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../10_user_login/usuario_login/provider_session.dart';
import '../20_var_globales/var_elementos_menus.dart';

// Menu 01 ---------------------------------------------------------------------
// Inicio
// "Propiedades"
// "Ubicación"
// "Mi Cuenta"
// "Perfil"

List<String> listaTipoUsuarios = [
  "Usuario", // iconoInicio,
  "Promotor", //   iconoPromotores,
  "Propietario", //   iconoPropietarios,
  // "Anfitrión", //   iconoHospedaje,
  //  "Vendedor", //   iconoTienda,
  //  "Especialista", //  iconoServicios,
  //  "Proveedor", //   iconoProveedores,
  //  "Asociación", //   iconoAsociaciones,
  //  "Inmobiliaria", //   iconoInmobiliarias,
];

class ElementosDelMenuInicial {
  int index = 0; // usuario
  String etiqueta = "";
  int indexPromotor = 0; // no promotor, user o no user
  late IconData icono;
  List<bool> buttonSelectOpcion = [
    true, // Inicio 0
    false, // Propiedades 1
    false, // Ubicación 2
    false, // Mi Cuenta 3
    false, // Perfil 4
  ];
  List<ElementosMenus> elementosMenuInicial = [
    iconoInicio,
    iconoVerPropiedades,
    iconoUbicacion,
    iconoTuCuenta,
    iconoPerfil,
  ];
  late TabController tabControllerMenuInicial; // menu superior principal
  int seleccionMenuInicial = 0;
}

ElementosDelMenuInicial varElementosMenuInicial = ElementosDelMenuInicial();

final menuInicialProvider =
    StateNotifierProvider<ClaseMenuInicial, ElementosDelMenuInicial>((ref) {
      return ClaseMenuInicial(varElementosMenuInicial);
    });

class ClaseMenuInicial extends StateNotifier<ElementosDelMenuInicial> {
  ClaseMenuInicial(super.state);

  void restableceOpcionActualSeleccionada(WidgetRef ref) {
    // restablece posición
    state.tabControllerMenuInicial.index = state.seleccionMenuInicial;
    // restablece  icono y etiqueta
    asignaNuevoIconoEtiqueta(state.tabControllerMenuInicial.index);
  }

  void setIndexPromotor(WidgetRef ref) {
    //debugPrintLevels(0, "+++ setIndexPromotor: ${ref.read(sessionDataNotifierProvider).boolUsuarioPromotor}");
    (ref.read(sessionProvider).esPromotor)
        ? state.indexPromotor =
              0 // promotor
        : state.indexPromotor = 1; // usuario
    //debugPrintLevels(0, "+++ setIndexPromotor Index: ${ref.read(MenuInicialProvider).indexPromotor.toString()}");
  }

  void inicializaController(TickerProvider thisvar) {
    void handleTabSelection() {}

    state.tabControllerMenuInicial = TabController(
      vsync: thisvar,
      length: state.elementosMenuInicial.length,
    );
    state.tabControllerMenuInicial.addListener(handleTabSelection);

    state.tabControllerMenuInicial.index = state.seleccionMenuInicial;
  }

  void disposeController() {
    state.tabControllerMenuInicial.dispose();
  }

  void asignaNuevaOpcionSeleccionada(WidgetRef ref, int index) {
    state.seleccionMenuInicial = index;
    //  state.seleccionMenuInicial = index + state.indexPromotor;
    //  state.index = index;

    state.etiqueta =
        state.elementosMenuInicial[state.seleccionMenuInicial].etiqueta;
    state.icono = state.elementosMenuInicial[state.seleccionMenuInicial].icono;

    state.buttonSelectOpcion[0] = false;
    state.buttonSelectOpcion[1] = false;
    state.buttonSelectOpcion[2] = false;
    state.buttonSelectOpcion[3] = false;
    state.buttonSelectOpcion[4] = false;
    state.buttonSelectOpcion[state.seleccionMenuInicial] = true;
  }

  int getTamanioListaElementos() {
    return state.elementosMenuInicial.length;
  }

  void asignaNuevoIconoEtiqueta(int index) {
    // state.index = index;
    state.seleccionMenuInicial = index;

    state.etiqueta = state.elementosMenuInicial[index].etiqueta;
    state.icono = state.elementosMenuInicial[index].icono;
  }
}
