import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../01_home/home_navigation_provider.dart';
import '../20_var_globales/var_color_themes.dart';
import '../20_var_globales/var_de_estilo_widgets.dart';
import '../60_global_widgets/debugprint.dart';
import 'provider_menu_tipo_espacio.dart';
import 'variables_menus.dart';

// https://www.geeksforgeeks.org/flutter/flutter-silverappbar-widget/

// Definimos la llave fuera del método build para que sea persistente
final GlobalKey _barraTipoEspaciosKey = GlobalKey();

class MenuSuperiorPaginaTipoDeEspacios extends ConsumerWidget {
  const MenuSuperiorPaginaTipoDeEspacios({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el provider para reaccionar a cambios de selección
    final menuTipoEspacios = ref.watch(menuTipoEspaciosProvider);

    return SliverAppBar(
      pinned: false, // No se queda fija arriba
      floating: true,
      // Reaparece inmediatamente al deslizar un poco hacia arriba
      snap: false,
      // Usamos una GlobalObjectKey para asegurar que el ID en el AXTree sea único por pestaña
      key: _barraTipoEspaciosKey,
      //key: GlobalObjectKey('sliver_espacios_$currentIndex'),
      automaticallyImplyLeading: false,
      backgroundColor: appTheme.surface,
      toolbarHeight: 0,
      scrolledUnderElevation: 0.0,
      elevation: 0.0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(menuToolbarHeight),
        child: ExcludeSemantics(
          child: ButtonsTabBar(
            controller: menuTipoEspacios.tabControllerMenuTipoEspacios,
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
                "*************** INVALIDA PROVIDERS TIPO DE ESPACIO ************",
              );
              // Actualización de estado mediante el notifier
              ref
                  .read(menuTipoEspaciosProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, index);
              ref
                  .read(homeNavigationProvider.notifier)
                  .actualizarTipoEspacio(index);
            },
            tabs: List<Widget>.generate(
              ref
                  .read(menuTipoEspaciosProvider.notifier)
                  .getTamanioListaElementos(),
              (int index) {
                final elemento =
                    menuTipoEspacios.elementosMenuTipoEspacio[index];

                return Tab(
                  icon: Icon(elemento.icono, size: menuTabIconSize),
                  text: elemento.etiqueta,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
