import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../20_var_globales/var_elementos_menus.dart';

// Menu 03 ---------------------------------------------------------------------

// "Todas"
// "Venta"
// "Renta"
// "Venta/Renta"
// "Traspaso"

class ElementosDelMenuTipoDePublicacion {
  int index = 0;
  String etiqueta = "";
  late IconData icono;
  List<bool> buttonSelectOpcion = [
    true, //
    false, //
    false, //
    false, //
    false, //
  ];

  List<ElementosMenus> elementosMenuTipoDePublicacion = [
    iconoTodas,
    iconoVenta,
    iconoRenta,
    iconoVentaRenta,
    iconoTraspaso,
    //iconoPreventa,
    // iconoBuscar
  ];

  List<ElementosMenus> elementosMenuTipoDePublicacionSolid = [
    iconoTodasSolid,
    iconoVentaSolid,
    iconoRentaSolid,
    iconoVentaRentaSolid,
    iconoTraspasoSolid,
    //iconoPreventa,
    // iconoBuscar
  ];

  late TabController tabControllerMenuTipoDePublicacion;
  int seleccionMenuTipoDePublicacion = 0;
}

ElementosDelMenuTipoDePublicacion varElementosMenuTipoDePublicacion =
    ElementosDelMenuTipoDePublicacion();

final menuTipoDeTransaccionProvider =
    StateNotifierProvider<
      ClaseMenuTipoDePublicacion,
      ElementosDelMenuTipoDePublicacion
    >((ref) {
      return ClaseMenuTipoDePublicacion(varElementosMenuTipoDePublicacion);
    });

class ClaseMenuTipoDePublicacion
    extends StateNotifier<ElementosDelMenuTipoDePublicacion> {
  ClaseMenuTipoDePublicacion(super.state);

  //-----------------------------------------------------------------------------.

  void restableceOpcionActualSeleccionada(WidgetRef ref) {
    // restablece posición
    state.tabControllerMenuTipoDePublicacion.index =
        state.seleccionMenuTipoDePublicacion;
    // restablece  icono y etiqueta
    asignaNuevoIconoEtiqueta(state.tabControllerMenuTipoDePublicacion.index);
  }

  void inicializaController(TickerProvider thisvar) {
    void handleTabSelection() {}

    state.tabControllerMenuTipoDePublicacion = TabController(
      vsync: thisvar,
      length: state.elementosMenuTipoDePublicacion.length,
    );
    state.tabControllerMenuTipoDePublicacion.addListener(handleTabSelection);

    state.tabControllerMenuTipoDePublicacion.index =
        state.seleccionMenuTipoDePublicacion;
  }

  void disposeController() {
    state.tabControllerMenuTipoDePublicacion.dispose();
  }

  void asignaNuevaOpcionSeleccionada(WidgetRef ref, int index) {
    state.seleccionMenuTipoDePublicacion = index;
    //  state.seleccionMenuPrincipal = index + state.indexPromotor;
    //  state.index = index;

    state.etiqueta = state
        .elementosMenuTipoDePublicacion[state.seleccionMenuTipoDePublicacion]
        .etiqueta;
    state.icono = state
        .elementosMenuTipoDePublicacion[state.seleccionMenuTipoDePublicacion]
        .icono;

    state.buttonSelectOpcion[0] = false;
    state.buttonSelectOpcion[1] = false;
    state.buttonSelectOpcion[2] = false;
    state.buttonSelectOpcion[3] = false;
    state.buttonSelectOpcion[4] = false;
    state.buttonSelectOpcion[state.seleccionMenuTipoDePublicacion] = true;
  }

  int getTamanioListaElementos() {
    return state.elementosMenuTipoDePublicacion.length;
  }

  void asignaNuevoIconoEtiqueta(int index) {
    //  state.index = index;
    state.seleccionMenuTipoDePublicacion = index;

    state.etiqueta = state.elementosMenuTipoDePublicacion[index].etiqueta;
    state.icono = state.elementosMenuTipoDePublicacion[index].icono;
  }
}
