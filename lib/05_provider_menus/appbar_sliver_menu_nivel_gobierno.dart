import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../01_home/home_navigation_provider.dart';
import '../20_var_globales/var_color_themes.dart';
import '../08_pantallas/ubicacion/provider_localidades_del_cp.dart';
import '../20_var_globales/var_de_estilo_widgets.dart';
import '../60_global_widgets/debugprint.dart';
import 'provider_menu_nivel_gobierno.dart';
import 'variables_menus.dart';

// Cambiamos el tipo de retorno de AppBar a SliverAppBar
// Definimos la llave fuera del método build para que sea persistente
// https://www.geeksforgeeks.org/flutter/flutter-silverappbar-widget/

final GlobalKey _barraNivelGobiernoKey = GlobalKey();

class MenuSuperiorPaginaInicioNivelGobierno extends ConsumerWidget {
  const MenuSuperiorPaginaInicioNivelGobierno({super.key});

  // "Asentamiento/Tipo", // "Zona",
  // "C.P.",
  // "Municipio"
  // "Estado"
  // "Nacional"

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos los providers: cualquier cambio aquí refrescará SOLO este widget
    // 1. Escuchamos los cambios de estado.
    // Cuando 'asignaNuevaOpcionSeleccionada' cambie el estado, este build se dispara.
    final menuNivelProv = ref.watch(menuNivelDeGobiernoProvider);
    final localidadesProv = ref.watch(localidadesPorCodigoPostalProvider);

    // Obtenemos el índice actual para la Key (esto soluciona el error AXTree)

    return SliverAppBar(
      pinned: false, // No se queda fija arriba
      floating: true,
      // Reaparece inmediatamente al deslizar un poco hacia arriba
      snap: false,
      // 2. Key dinámica: obliga a Flutter a recrear el árbol de accesibilidad
      // evitando el error [AXTree] y asegurando el refresco visual.
      // Usamos una GlobalObjectKey para asegurar que el ID en el AXTree sea único por pestaña
      key: _barraNivelGobiernoKey,
      // key: ValueKey('sliver_app_bar_nivel_$indexActual'),
      automaticallyImplyLeading: false,
      backgroundColor: appTheme.surface,
      toolbarHeight: 0,
      scrolledUnderElevation: 0.0,
      elevation: 0.0,

      bottom: ButtonsTabBar(
        key: ValueKey('nivel_gobierno_${localidadesProv.codigoPostal}'),
        // Usamos el controller desde el estado que estamos observando
        controller: menuNivelProv.tabControllerMenuNivelDeGobierno,
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
          // 3. Actualización de estado
          // Actualizamos el estado a través del notifier
          debugPrintLevels(
            10,
            "*************** INVALIDA PROVIDERS NIVEL GOBIERNO ************",
          );
          ref
              .read(menuNivelDeGobiernoProvider.notifier)
              .asignaNuevaOpcionSeleccionada(ref, index);
          ref
              .read(homeNavigationProvider.notifier)
              .actualizarNivelGobierno(index);
        },
        tabs: List<Tab>.generate(
          ref
              .read(menuNivelDeGobiernoProvider.notifier)
              .listNivelesDeGobierno
              .length,
          (int index) {
            String etiquetaNivelGobierno = "";

            final int indiceLocalidad = localidadesProv.localidadSeleccionada;
            final rows = localidadesProv.localidades.rows;
            final hasData = localidadesProv.codigoPostal != 0 &&
                rows.isNotEmpty &&
                indiceLocalidad < rows.length;
            final localidadData =
                hasData ? rows[indiceLocalidad].value.localidadCp : null;

            switch (index) {
              case 0:
                etiquetaNivelGobierno = "México";
                break;
              case 1:
                etiquetaNivelGobierno =
                    (localidadData == null || localidadData.estado.isEmpty)
                        ? "Sin Estado"
                        : localidadData.estado;
                break;
              case 2:
                etiquetaNivelGobierno =
                    (localidadData == null || localidadData.municipio.isEmpty)
                        ? "Sin Municipio"
                        : localidadData.municipio;
                break;
              case 3:
                etiquetaNivelGobierno =
                    (localidadData == null || localidadData.cp == 0)
                        ? "Sin C.P."
                        : localidadData.cp.toString();
                break;
              case 4:
                etiquetaNivelGobierno =
                    (localidadData == null ||
                            localidadData.asentamiento.isEmpty)
                        ? "Sin localidad"
                        : localidadData.asentamiento;
                break;
              default:
                etiquetaNivelGobierno = "Sin ubicación";
            }

            return Tab(
              text: etiquetaNivelGobierno,
              icon: Icon(
                ref
                    .read(menuNivelDeGobiernoProvider)
                    .elementosMenuNivelDeGobierno[index]
                    .icono,
                size: menuTabIconSize,
              ),
            );
          },
        ),
      ),
    );
  }
}
