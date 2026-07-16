import 'package:buscobien/20_var_globales/var_color_themes.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../01_home/home_navigation_provider.dart';
import '../20_var_globales/var_de_estilo_widgets.dart';
import 'provider_menu_tu_cuenta.dart';
import 'variables_menus.dart';

// https://www.geeksforgeeks.org/flutter/flutter-silverappbar-widget/

class MenuSuperiorPaginaTuCuenta extends ConsumerWidget {
  const MenuSuperiorPaginaTuCuenta({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el estado del menú "Mi Cuenta"
    final menuTuCuenta = ref.watch(menuTuCuentaProvider);

    return SliverAppBar(
      // Key dinámica para evitar errores de AXTree al cambiar de pestañas
      key: ValueKey(
        'sliver_tu_cuenta_${menuTuCuenta.tabControllerMenuTuCuenta.index}',
      ),
      automaticallyImplyLeading: false,
      backgroundColor: appTheme.surface,
      toolbarHeight: 0,
      scrolledUnderElevation: 0.0,
      elevation: 0.0,
      pinned: true,
      floating: false,
      bottom: ButtonsTabBar(
        controller: menuTuCuenta.tabControllerMenuTuCuenta,
        backgroundColor: appTheme.primary,
        unselectedBackgroundColor: appTheme.onInverseSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        buttonMargin: const EdgeInsets.all(4),
        height: menuToolbarHeight,
        labelStyle: ButtonsTabBarLabelStyle.copyWith(color: appTheme.onPrimary),
        unselectedLabelStyle: ButtonsTabBarUnselectedLabelStyle.copyWith(
          color: appTheme.onSurfaceVariant,
        ),
        borderColor: appTheme.primary,
        borderWidth: 1,
        unselectedBorderColor: appTheme.outlineVariant,
        radius: 100,
        onTap: (index) {
          // 1. Actualizamos el estado interno del menú "Mi Cuenta"
          ref
              .read(menuTuCuentaProvider.notifier)
              .asignaNuevaOpcionSeleccionada(ref, index);

          // 2. Notificamos al controlador de navegación global
          // Esto disparará la lógica en HomePage para mostrar/ocultar
          // los menús de "Espacios" o "Nivel de Gobierno"
          ref.read(homeNavigationProvider.notifier).actualizarMiCuenta(index);
        },
        tabs: List<Widget>.generate(
          ref.read(menuTuCuentaProvider.notifier).getTamanioListaElementos(),
          (int index) {
            final elemento = menuTuCuenta.elementosMenuTuCuenta[index];
            return Tab(
              icon: Icon(elemento.icono, size: menuTabIconSize),
              text: elemento.etiqueta,
            );
          },
        ),
      ),
    );
  }
}
