import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../01_home/home_navigation_provider.dart';
import '../20_var_globales/var_color_themes.dart';
import '../20_var_globales/var_de_estilo_widgets.dart';
import 'provider_menu_tu_cuenta_usuario.dart';
import 'variables_menus.dart';

// https://www.geeksforgeeks.org/flutter/flutter-silverappbar-widget/

class MenuSuperiorPaginaTuCuentaUsuario extends ConsumerWidget {
  const MenuSuperiorPaginaTuCuentaUsuario({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuTuCuentaUsuario = ref.watch(menuTuCuentaUsuarioProvider);

    return SliverAppBar(
      // Key dinámica para evitar errores de AXTree al cambiar de pestañas
      key: ValueKey(
        'sliver_tu_cuenta_usuario_${menuTuCuentaUsuario.tabControllerMenuTuCuentaUsuario.index}',
      ),
      automaticallyImplyLeading: false,
      backgroundColor: appTheme.surface,
      toolbarHeight: 0,
      scrolledUnderElevation: 0.0,
      elevation: 0.0,
      pinned: true,
      floating: false,
      bottom: ButtonsTabBar(
        controller: menuTuCuentaUsuario.tabControllerMenuTuCuentaUsuario,
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
              .read(menuTuCuentaUsuarioProvider.notifier)
              .asignaNuevaOpcionSeleccionada(ref, index);

          // 2. Notificamos al controlador de navegación global
          // Esto disparará la lógica en HomePage para mostrar/ocultar
          // los menús de "Espacios" o "Nivel de Gobierno"
          ref
              .read(homeNavigationProvider.notifier)
              .actualizarMiCuentaUsuario(index);
        },
        tabs: List<Widget>.generate(
          ref
              .read(menuTuCuentaUsuarioProvider.notifier)
              .getTamanioListaElementos(),
          (int index) {
            final elemento =
                menuTuCuentaUsuario.elementosMenuTuCuentaUsuario[index];
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
