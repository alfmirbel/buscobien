import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../01_home/home_navigation_provider.dart';
import '../20_var_globales/var_color_themes.dart';
import '../20_var_globales/var_de_estilo_widgets.dart';
import '../60_global_widgets/debugprint.dart';
import 'provider_menu_inicial.dart';
import 'variables_menus.dart';

// https://www.geeksforgeeks.org/flutter/flutter-silverappbar-widget/

SliverAppBar menuSuperiorMenuInicial(WidgetRef ref) {
  // Inicio
  // "Propiedades"
  // "Promotores"
  // "Particulares"
  // "Anfitriones"
  // "Tienda"
  // "Servicios"
  // "Productos"
  // "Asociaciones"
  // "Inmobiliarias"
  debugPrintLevels(0, "--- menuSuperiorMenuInicial");
  final manuPrincipal = ref.watch(menuInicialProvider);

  return SliverAppBar(
    pinned: true, // No se queda fija arriba
    floating: false,
    // Reaparece inmediatamente al deslizar un poco hacia arriba
    snap: false,
    // Se desliza completamente hacia afuera o hacia adentro sin detenerse a la mitad
    // La Key dinámica basada en el índice actual previene el error AXTree
    key: ValueKey(
      'sliver_MenuInicial_${manuPrincipal.tabControllerMenuInicial.index}',
    ),
    automaticallyImplyLeading: false,
    backgroundColor: appTheme.surface,
    // toolbarHeight: 0 oculta el espacio del título,
    // pero para SliverAppBar 'pinned: true' es lo que mantiene el 'bottom' visible.
    toolbarHeight: 0,
    scrolledUnderElevation: 0.0,
    elevation: 0.0,
    bottom: ButtonsTabBar(
      controller: ref.read(menuInicialProvider).tabControllerMenuInicial,
      backgroundColor: appTheme.primary,
      unselectedBackgroundColor: appTheme.onInverseSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      buttonMargin: const EdgeInsets.all(4),
      height: menuToolbarHeight,
      labelStyle: ButtonsTabBarLabelStyle,
      unselectedLabelStyle: ButtonsTabBarUnselectedLabelStyle,
      borderColor: appTheme.primary,
      borderWidth: 1,
      unselectedBorderColor: appTheme.onInverseSurface,
      radius: 100,
      onTap: (index) {
        debugPrintLevels(
          10,
          "*************** INVALIDA PROVIDERS MENU INICIAL ************",
        );
        ref
            .read(menuInicialProvider.notifier)
            .asignaNuevaOpcionSeleccionada(ref, index);

        ref.read(homeNavigationProvider.notifier).actualizarInicial(index);
      },
      tabs: List<Widget>.generate(
        ref.read(menuInicialProvider.notifier).getTamanioListaElementos(),
        (int index) {
          return Tab(
            icon: Icon(
              ref.read(menuInicialProvider).elementosMenuInicial[index].icono,
              size: menuTabIconSize,
            ),
            text: ref
                .read(menuInicialProvider)
                .elementosMenuInicial[index]
                .etiqueta,
          );
        },
      ),
    ),
  );
}
