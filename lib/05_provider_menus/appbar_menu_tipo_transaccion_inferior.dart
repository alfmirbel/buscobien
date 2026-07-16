import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../01_home/home_navigation_provider.dart';
import '../20_var_globales/var_color_themes.dart';
import '../20_var_globales/var_de_estilo_widgets.dart';
import '../60_global_widgets/debugprint.dart';
import 'provider_menu_tipo_de_transaccion.dart';
import 'variables_menus.dart';

// https://www.geeksforgeeks.org/flutter/flutter-silverappbar-widget/

class MenuInferiorTipoDeTransaccion extends ConsumerStatefulWidget {
  const MenuInferiorTipoDeTransaccion({super.key});

  @override
  ConsumerState<MenuInferiorTipoDeTransaccion> createState() =>
      _MenuInferiorTipoDeTransaccionState();
}

// Usamos TickerProviderStateMixin porque tu provider parece necesitar un 'vsync' para el TabController
class _MenuInferiorTipoDeTransaccionState
    extends ConsumerState<MenuInferiorTipoDeTransaccion>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    //-----------------------------------------------------------------------------
    // MENU TIPO DE TRANSACCION LATERAL E INFERIOR INICIALIZACION
    ref.read(menuTipoDeTransaccionProvider.notifier).inicializaController(this);
    ref
        .read(menuTipoDeTransaccionProvider.notifier)
        .asignaNuevaOpcionSeleccionada(
          ref,
          ref
              .read(menuTipoDeTransaccionProvider)
              .seleccionMenuTipoDePublicacion,
        );
    ref
        .read(menuTipoDeTransaccionProvider.notifier)
        .restableceOpcionActualSeleccionada(ref);
    //-----------------------------------------------------------------------------
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos el estado para redibujar cuando cambie la selección
    //   final menuTransaccion = ref.watch(menuTipoDeTransaccionProvider);

    return Container(
      key: const ValueKey('bottom_menu_tipo_publicacion_inferior'),
      height: menuToolbarHeight * 1.8,
        color: appTheme.surface,
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: ButtonsTabBar(
        // Accedemos al controller desde el estado observado
        controller: ref
            .watch(menuTipoDeTransaccionProvider)
            .tabControllerMenuTipoDePublicacion,
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
            "*************** INVALIDA PROVIDERS MENU INFERIOR ************",
          );
          debugPrintLevels(
            0,
            "--- menuTipoDeTransaccionProvider INFERIOR restableceOpcionActualSeleccionada: $index",
          );
          ref
              .read(menuTipoDeTransaccionProvider.notifier)
              .asignaNuevaOpcionSeleccionada(ref, index);
          ref
              .read(homeNavigationProvider.notifier)
              .actualizarTipoTransaccion(index);
        },
        tabs: List<Tab>.generate(
          ref
              .watch(menuTipoDeTransaccionProvider)
              .elementosMenuTipoDePublicacion
              .length,
          (int index) {
            return Tab(
              icon: Icon(
                ref
                    .watch(menuTipoDeTransaccionProvider)
                    .elementosMenuTipoDePublicacion[index]
                    .icono,
                size: menuTabIconSize + 5,
              ),
              text: ref.watch(menuTipoDeTransaccionProvider).etiqueta,
            );
          },
        ),
      ),
    );
  }
}
