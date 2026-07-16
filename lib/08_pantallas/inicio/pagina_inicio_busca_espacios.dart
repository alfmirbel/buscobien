import 'package:buscobien/01_home/home_state.dart';
import 'package:buscobien/08_pantallas/inicio/http_find_propiedades_10en10.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../01_home/home_navigation_provider.dart';
import '../../02_principal_screen/principal_sliver_screen_menus_inicio.dart';
import '../../05_provider_menus/appbar_menu_tipo_transaccion_inferior.dart';
import '../../05_provider_menus/appbar_sliver_menu_nivel_gobierno.dart';
import '../../05_provider_menus/appbar_sliver_menu_tipo_espacio.dart';
import '../../05_provider_menus/dropdown_menu_principal_propiedades.dart';
import '../../05_provider_menus/provider_menu_principal.dart';
import '../../05_provider_menus/provider_menu_tipo_de_transaccion.dart';
import '../../05_provider_menus/variables_menus.dart';
import '../../07_routes/app_routes.dart';
import '../../20_var_globales/var_color_themes.dart';
import '../../20_var_globales/var_color_widget.dart';
import '../../22_imagenes/variables_imagenes.dart';
import '../../60_global_widgets/debugprint.dart';
import 'clase_busqueda_estado.dart';
import 'data_espacios_casas_get.dart';
import 'http_view_count_filter_propiedades.dart';
import 'inicio_propiedades_providers.dart';
import 'widget_wrap_modern_card.dart';

/*
¿Qué mejoramos con este ajuste?
Eliminación de FutureBuilder anidado: Al usar countAsync.when, el widget es mucho 
más limpio y manejas los estados de carga y error de forma nativa de Riverpod.

Adiós a los .then(): Ya no tienes que llamar a findPropiedades... manualmente. 
Como el provider listaPropiedadesProvider depende de skip y queryParams, se 
dispara automáticamente cuando cualquiera de esos dos cambia.

Paginación simplificada: Al mover paramSkip a un busquedaPaginacionProvider, 
cualquier cambio en la página gatilla la actualización de la lista sin lógica 
extra en el botón.

Reactividad en Cadena:

Usuario cambia Nivel de Gobierno -> currentQueryProvider se actualiza.

currentQueryProvider se actualiza -> listaPropiedadesProvider detecta el cambio 
y hace el nuevo POST.

La UI recibe el nuevo AsyncValue y se redibuja.

Nota sobre el Filtrado Local (onQueryChanged)
En tu código original, tenías una función onQueryChanged que filtraba la lista 
localmente. Con Riverpod, lo ideal es que ese filtro sea otro provider que reciba 
el texto de búsqueda y devuelva la lista filtrada, o mejor aún, pasar ese texto 
como parámetro al listaPropiedadesProvider para que la búsqueda se haga desde 
la base de datos (CouchDB) usando el selector.
*/

// Asumo que tienes los imports de tus providers y modelos aquí

// Mantengo las variables globales como pediste, aunque Riverpod gestiona esto internamente ahora.
late TextEditingController controllerSearch;
double tamanoLetra = 12;

// Esta variable ahora se sincronizará con el provider busquedaPaginacionProvider
int paramSkip = 0;

// Esta variable se actualizará con los datos que lleguen del provider
EspaciosCasaGet listaPropiedadesVar = EspaciosCasaGet(
  offset: 0,
  totalRows: 0,
  rows: [],
);

class PaginaBuscaEspacios extends ConsumerStatefulWidget {
  final HomeState posicionNueva;
  const PaginaBuscaEspacios(this.posicionNueva, {super.key});

  @override
  ConsumerState<PaginaBuscaEspacios> createState() =>
      _PaginaBuscaEspaciosState();
}

class _PaginaBuscaEspaciosState extends ConsumerState<PaginaBuscaEspacios> {
  late TextEditingController controllerSearch;

  @override
  void initState() {
    super.initState();
    controllerSearch = TextEditingController();

    // Reseteamos la paginación al entrar
    // Usamos addPostFrameCallback porque no se debe modificar provider en initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(busquedaPaginacionProvider.notifier).reset();
    });

    debugPrintLevels(10, " >>>> INICIALIZA PROPIEDAD PAGINADAS");
  }

  // didUpdateWidget ELIMINADO: Riverpod se encarga de reaccionar a cambios en homeNavigationProvider

  @override
  void deactivate() {
    debugPrintLevels(1, " PaginaBuscaEspacios deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaBuscaEspacios dispose");
    controllerSearch.dispose();
    super.dispose();
  }

  // Helper para resetear paginación cuando cambian filtros
  void _resetPaginacion() {
    // ref.read(busquedaPaginacionProvider.notifier).reset();
    ref.invalidate(currentQueryProvider);
    ref.invalidate(
      viewCountFilterPropiedadesProvider(ref.watch(currentQueryProvider)),
    );
    ref.invalidate(findPropiedadesEstadosde10en10Provider);
    paramSkip = 0;
  }

  Scrollbar navigationRailTipoTransaccion() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            //   width: 90,
            color: appTheme.surface,
            // Fondo consistente con el Rail
            child: NavigationRail(
              useIndicator: false,
              indicatorColor: appTheme.primary,
              backgroundColor: appTheme.surface,
              groupAlignment: -1.0, // Alineado arriba
              //  elevation: 8,
              // Sincronización con el provider
              selectedIndex: ref
                  .watch(menuTipoDeTransaccionProvider)
                  .tabControllerMenuTipoDePublicacion
                  .index,

              onDestinationSelected: (int index) {
                debugPrintLevels(
                  10,
                  "*************** INVALIDA PROVIDERS TRANSACCION LATERAL ************",
                );
                setState(() {
                  ref
                      .read(menuTipoDeTransaccionProvider.notifier)
                      .asignaNuevaOpcionSeleccionada(ref, index);
                  ref
                      .read(homeNavigationProvider.notifier)
                      .actualizarTipoTransaccion(index);
                });
              },

              labelType: NavigationRailLabelType.all,
              destinations: List.generate(
                ref
                    .watch(menuTipoDeTransaccionProvider)
                    .elementosMenuTipoDePublicacion
                    .length,
                (int index) {
                  return NavigationRailDestination(
                    icon: Icon(
                      ref
                              .watch(menuTipoDeTransaccionProvider)
                              .buttonSelectOpcion[index]
                          ? ref
                              .watch(menuTipoDeTransaccionProvider)
                              .elementosMenuTipoDePublicacionSolid[index]
                              .icono
                          : ref
                              .watch(menuTipoDeTransaccionProvider)
                              .elementosMenuTipoDePublicacion[index]
                              .icono,
                      fill: ref
                              .watch(menuTipoDeTransaccionProvider)
                              .buttonSelectOpcion[index]
                          ? 1.0
                          : 0.0,
                      size: menuTabIconSize +
                          (ref
                                  .watch(menuTipoDeTransaccionProvider)
                                  .buttonSelectOpcion[index]
                              ? 8
                              : 5),
                      applyTextScaling: true,
                      color: appTheme.primary,
                    ),
                    label: Text(
                      ref
                          .watch(menuTipoDeTransaccionProvider)
                          .elementosMenuTipoDePublicacion[index]
                          .etiqueta,
                      style: TextStyle(
                        fontSize: menuTabLabelSize -
                            (ref
                                    .watch(menuTipoDeTransaccionProvider)
                                    .buttonSelectOpcion[index]
                                ? 0
                                : 1),
                        letterSpacing: -0.25,
                        fontWeight: ref
                                .watch(menuTipoDeTransaccionProvider)
                                .buttonSelectOpcion[index]
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: appTheme.onPrimaryContainer,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Escuchar estados necesarios
    // Al hacer watch del query y la paginación, el build se reconstruye si cambian
    // final queryParams = ref.watch(currentQueryProvider);
    // final skipActual = ref.watch(busquedaPaginacionProvider);

    // Sincronizamos la variable global visualmente (opcional, por mantener tu lógica)
    // paramSkip = skipActual;

    // 2. Escuchar los Providers de datos (AsyncValue)
    // Este provider nos da el total de documentos para calcular la paginación
    final countAsync = ref.watch(
      viewCountFilterPropiedadesProvider(ref.watch(currentQueryProvider)),
    );
    final listaAsync = ref.watch(
      findPropiedadesEstadosde10en10Provider(
        paramSkipFind: paramSkip,
        paramLimitFind: numerodefichas,
        valueQry: ref.watch(currentQueryProvider),
      ),
    );
    // Este provider nos da la lista de propiedades actual basada en filtros y skip

    debugPrintLevels(
      10,
      "MENU PRINCIPAL: ${ref.watch(homeNavigationProvider).indicePrincipal}",
    );

    ref.listen(homeNavigationProvider, (previous, next) {
      if ((previous!.indicePrincipal != next.indicePrincipal) ||
          (previous.indiceNivelGobierno != next.indiceNivelGobierno) ||
          (previous.indiceTipoEspacio != next.indiceTipoEspacio) ||
          (previous.indiceTipoTransaccion != next.indiceTipoTransaccion)) {
        // Esto se ejecuta de forma segura fuera de la fase de construcción
        /*
        CAMBIO POR EL PROVIDER
                listaPropiedades(
                  ref,
                  paramSkip,
                  numerodefichas,
                  ref.watch(currentQueryProvider),
                ).then((onValue) {
                  listaPropiedadesVar = onValue;
                });
        */
        ref.invalidate(
          viewCountFilterPropiedadesProvider(ref.watch(currentQueryProvider)),
        );
        ref.invalidate(currentQueryProvider);
        ref.invalidate(findPropiedadesEstadosde10en10Provider);
        paramSkip = 0;
      }
    });
    bool mostrarmapa = false;

    final bool esPantallaCorta =
        MediaQuery.of(context).size.width < smallScreenMin;

    return Scaffold(
      backgroundColor: appTheme.surface,
      bottomNavigationBar: ((esPantallaCorta) &&
              (ref.watch(homeNavigationProvider).indicePrincipal >= 0) &&
              (ref.watch(homeNavigationProvider).indicePrincipal <= 3) &&
              (ref.watch(homeNavigationProvider).indiceInicial == 1))
          ? const MenuInferiorTipoDeTransaccion()
          : null,
      floatingActionButton: FloatingActionButton(
        backgroundColor: appTheme.primary,
        mini: true,
        tooltip: "Mapa",
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          // PaginaMapaPropiedades(listaPropiedadesVar: listaPropiedadesVar);
          (mostrarmapa)
              ? Navigator.pushNamed(
                  context,
                  AppRoutes.mapapropiedades,
                  arguments: listaPropiedadesVar,
                )
              : null;
        },
        // foregroundColor: appTheme.onPrimary,
        child: Icon(Symbols.map, color: appTheme.onPrimary, size: 20),
      ),
      body: Row(
        children: [
          // 1. NavigationRail Lateral (Solo si el ancho > 600)
          //SliverToBoxAdapter(child: LandingBusquedaPage()),
          // 2. CATEGORÍAS RÁPIDAS
          if ((!esPantallaCorta) &&
              (ref.watch(homeNavigationProvider).indicePrincipal >= 0) &&
              (ref.watch(homeNavigationProvider).indicePrincipal <= 3))
            navigationRailTipoTransaccion(),
          // 2. Contenido Principal
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: desktopContentMaxWidth,
                ),
                child: countAsync.when(
                  // Estado de carga inicial del conteo
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text("Error: $err")),
                  data: (totalDoctos) {
                    debugPrintLevels(
                      10,
                      "****** SE EJECUTO countAsync: totalDoctos = $totalDoctos",
                    );
                    return CustomScrollView(
                      scrollCacheExtent: ScrollCacheExtent.pixels(1500),
                      slivers: [
                        /*
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                          "¿Qué tipo de espacio estás buscando?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    */
                        //menuSuperiorMenuPrincipal(ref),
                        if (ref.watch(homeNavigationProvider).indicePrincipal <=
                            3) ...[
                          const MenuSuperiorPaginaInicioNivelGobierno(),
                          const MenuSuperiorPaginaTipoDeEspacios(),
                        ],

                        // CUERPO PRINCIPAL
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              // DROPDOWN OTROS
                              if (ref.read(menuPrincipalProvider).etiqueta ==
                                  "Otros")
                                _buildDropdownOtros(),
                              const SizedBox(height: 15),
                              // PAGINADOR SUPERIOR
                              //_buildPaginador(totalDoctos),
                              if (totalDoctos > 0) _buildPaginador(totalDoctos),
                              const SizedBox(height: 15),

                              // LISTA DE PROPIEDADES (Manejada por listaAsync)
                              listaAsync.when(
                                loading: () => const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: LinearProgressIndicator(),
                                ),
                                error: (e, s) =>
                                    Text("Error al cargar lista: $e"),
                                data: (listaDatos) {
                                  // Actualizamos la variable global por compatibilidad,
                                  // pero usamos 'listaDatos' para renderizar.

                                  if (listaDatos.rows.isEmpty) {
                                    debugPrintLevels(
                                      9,
                                      "** numero de propiedades vacio",
                                    );
                                    listaPropiedadesVar.rows = [];
                                    mostrarmapa = false;
                                    return _buildSinPropiedades();
                                  } else {
                                    listaPropiedadesVar = listaDatos;
                                    mostrarmapa = true;
                                    return _buildGrid(listaPropiedadesVar);
                                  }
                                },
                              ),
                              //------------
                              const SizedBox(height: 20),

                              // PAGINADOR INFERIOR
                              if (totalDoctos > 0) _buildPaginador(totalDoctos),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownOtros() {
    return Container(
      width: 200,
      height: 35,
      decoration: BoxDecoration(
        color: appTheme.onPrimary,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: appTheme.primary, width: 2),
      ),
      child: DropdownButtonPropiedad(
        ref,
        widget.posicionNueva.indicePrincipal,
        selectedDropDownMenuPrincipalValue,
        (nuevoValor) async {
          // Eliminamos el callback manual y el setState.
          // El widget DropdownButtonPropiedad ya actualiza el provider internamente.
          selectedDropDownMenuPrincipalValue = nuevoValor;
          _resetPaginacion(); // Al cambiar el filtro, volvemos a la página 0
          //setState(() {}); // Actualiza la UI del dropdown local
        },
        false,
      ),
    );
  }

  Widget _buildPaginador(int total) {
    return SizedBox(
      height: 30,
      width: widthCuadroFotoPropiedad,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(appTheme.primary),
            ),
            icon: Icon(Symbols.arrow_back, size: 14, color: appTheme.onPrimary),
            onPressed: (paramSkip > 0)
                ? () {
                    // MEJORA: Solo actualizamos el estado del provider.
                    // Riverpod detecta el cambio y recarga la lista automáticamente.
                    paramSkip = (paramSkip - numerodefichas);
                    setState(() {});
                  }
                : null,
          ),
          Text(
            '${paramSkip + 1}-${(paramSkip + numerodefichas) > total ? total : paramSkip + numerodefichas} de $total',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(appTheme.primary),
            ),
            icon: Icon(
              Symbols.arrow_forward,
              size: 14,
              color: appTheme.onPrimary,
            ),
            onPressed: (paramSkip + numerodefichas) < total
                ? () {
                    // MEJORA: Actualización reactiva
                    paramSkip = paramSkip + numerodefichas;
                    setState(() {});
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(EspaciosCasaGet lista) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: List.generate(lista.rows.length, (index) {
        //
        // Se pasa el contexto y ref correctamente
        return WrapModernCardPropiedades(index, lista);
      }),
    );
  }

  Widget _buildSinPropiedades() {
    return const Text('No hay propiedades que mostrar');
  }
}
