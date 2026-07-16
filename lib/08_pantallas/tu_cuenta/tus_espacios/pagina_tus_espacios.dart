import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Imports de tus archivos (Mantenidos igual)
import 'package:buscobien/22_imagenes/variables_imagenes.dart';
import '../../../05_provider_menus/appbar_sliver_menu_tipo_espacio.dart';
import '../../../07_routes/app_routes.dart';
// AJUSTE: Importamos el provider generado correcto basado en tu solicitud anterior
import '../../../10_user_login/usuario_login/dialogbox_login.dart';
import '../../../10_user_login/usuario_login/provider_session.dart';
import '../../../60_global_widgets/future_builder_state_widgets.dart';
import '../../../20_var_globales/var_color_themes.dart';
import '../../../20_var_globales/var_elementos_menus.dart';
import '../../../20_var_globales/variables_globales.dart';
import '../../../60_global_widgets/debugprint.dart';
import '../../../20_var_globales/var_color_widget.dart';
import '../../../05_provider_menus/provider_menu_tipo_espacio.dart';
import 'provider_espacios_casa_get.dart';
import 'form_crea_ficha_captura_propiedad.dart';

//------------------------------------------------------------------------------
// OPTIMIZADO
//------------------------------------------------------------------------------

class PaginaTusEspacios extends ConsumerStatefulWidget {
  const PaginaTusEspacios({super.key});

  @override
  ConsumerState<PaginaTusEspacios> createState() {
    debugPrintLevels(1, "1. PaginaTusEspacios createState");
    return PaginaTipoEspaciosState();
  }
}

class PaginaTipoEspaciosState extends ConsumerState<PaginaTusEspacios>
    with TickerProviderStateMixin {
  final scaffoldTipoEspacioKey = GlobalKey<ScaffoldState>();

  // OPTIMIZACIÓN: Variable para almacenar el Future y evitar recargas en cada build
  // late Future<int> _futurePropiedades;

  @override
  void initState() {
    super.initState();
    debugPrintLevels(1, "*** 2. PaginaTusEspacios initState");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(menuTipoEspaciosProvider.notifier).inicializaController(this);

      final menuState = ref.read(menuTipoEspaciosProvider);
      ref
          .read(menuTipoEspaciosProvider.notifier)
          .asignaNuevaOpcionSeleccionada(
            ref,
            menuState.seleccionMenuTipoEspacios,
          );

      ref
          .read(menuTipoEspaciosProvider.notifier)
          .restableceOpcionActualSeleccionada(ref);

      // Nota: Si resetEspaciosCasasGet limpia la lista que el future carga,
      // verifica si debe ir antes de la asignación del future.
      // Por ahora se mantiene aquí para no alterar lógica de negocio.
      ref.read(espaciosCasaConListaFotosGetProvider.notifier).resetEspaciosCasasGet();
      // Inicializamos el Future una sola vez al inicio
      /*
      _futurePropiedades = ref
          .read(espaciosCasaConListaFotosGetProvider.notifier)
          .getPropiedadesCasaIdUser();*/
    });
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaTusEspacios dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrintLevels(1, "*** 3. PaginaTusEspacios build");

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    // Providers
    final userData = ref.watch(sessionProvider);
    // final menuTipoEspacios = ref.watch(menuTipoEspaciosProvider);

    final String idUsuario = (userData.sessionUserData.userId != "")
        ? userData.sessionUserData.userId
        : "";
    // Obtener estado promotor
    final bool esPromotor = userData.esPromotor;


    debugPrintLevels(1, "*** 3. PaginaTusEspacios build");
    debugPrintLevels(1, "*** 3. PaginaTusEspacios build idUsuario: $idUsuario");
    debugPrintLevels(
      1,
      "*** 3. PaginaTusEspacios build esPromotor: $esPromotor",
    );

    return Scaffold(
      key: scaffoldTipoEspacioKey,
      backgroundColor: appTheme.surface,
      body: CustomScrollView(
        slivers: [
          // 1. El Menú Superior (Que contiene el SliverAppBar)
          if ((idUsuario != "") && (esPromotor))
            const MenuSuperiorPaginaTipoDeEspacios(),

          // 2. El Contenido Principal
          // Usamos SliverToBoxAdapter para adaptar el contenido normal al ScrollView
          SliverToBoxAdapter(
            child: Container(
              color: appTheme.surface,
              padding: const EdgeInsets.only(bottom: 50),
              // child: SingleChildScrollView se elimina porque ya estamos dentro de un ScrollView (Sliver)
              child: _buildContenidoPrincipal(
                idUsuario,
                esPromotor,
                ref.read(menuTipoEspaciosProvider).etiqueta,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Lógica para decidir qué vista mostrar
  Widget _buildContenidoPrincipal(
    String idUsuario,
    bool esPromotor,
    String etiquetaMenu,
  ) {
    if (idUsuario.isNotEmpty && esPromotor) {
      return _vistaPromotor(etiquetaMenu);
    } else if (idUsuario.isNotEmpty) {
      return _vistaUsuarioNormal(etiquetaMenu);
    } else {
      return _vistaInvitado();
    }
  }

  // --- VISTAS ESPECÍFICAS ----------------------------------------------------

  // 1. VISTA PROMOTOR
  Widget _vistaPromotor(String etiquetaMenu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // BOTÓN COMPRA ESPACIOS
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.compraespacios,
              arguments: "",
            );
          },
          child: Center(
            child: Container(
              width: 500,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: appTheme.onPrimary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: appTheme.primary, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconoComprarEspacio.icono,
                    size: 23,
                    color: appTheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Compra de espacios",
                    style: TextStyle(
                      fontSize: fontSizeSubtituloPagina,
                      fontWeight: FontWeight.bold,
                      color: appTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // BOTÓN NUEVA PROPIEDAD FASE 0.1
        const SizedBox(height: 15),

        Center(
          child: Text(
            'Propiedades en espacios $etiquetaMenu',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              color: appTheme.secondary,
              fontSize: fontSizeTituloPagina,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 10),
        SingleChildScrollView(child: _generaListaDePropiedades()),
        const SizedBox(height: 30),
      ],
    );
  }

  // 2. VISTA USUARIO NORMAL
  Widget _vistaUsuarioNormal(String etiquetaMenu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(
          child: Text(
            'Propiedades guardadas $etiquetaMenu',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              color: appTheme.secondary,
              fontSize: fontSizeTituloPagina,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 30),
        // recuperar listas de propiedades guardadas
        const Center(child: Text("No hay propiedades a mostrar.")),
      ],
    );
  }

  // 3. VISTA INVITADO
  Widget _vistaInvitado() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Text(
          'No hay propiedades que mostrar',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Outfit',
            color: appTheme.secondary,
            fontSize: fontSizeTituloPagina,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        GestureDetector(
          onTap: () => dialogBoxFichaLogin(context, ref),
          child: Center(
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: appTheme.onPrimary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: appTheme.primary, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(iconoUsuario.icono, size: 23, color: appTheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Ingresa como promotor para publicar propiedades',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSizeSubtituloPagina,
                        fontWeight: FontWeight.bold,
                        color: appTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        GestureDetector(
          onTap: () => dialogBoxFichaLogin(context, ref),
          child: Center(
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: appTheme.onPrimary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: appTheme.primary, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(iconoUsuario.icono, size: 23, color: appTheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Ingresa como usuario para ver propiedades',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSizeSubtituloPagina,
                        fontWeight: FontWeight.bold,
                        color: appTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // --- LÓGICA DE LISTA DE PROPIEDADES ----------------------------------------
  Widget _generaListaDePropiedades() {
    debugPrintLevels(10, "--- PaginaTusEspacios generaListaDePropiedades");
    return Center(
      child: FutureBuilder<int>(
        // OPTIMIZACIÓN: Usamos la variable de estado inicializada en initState
        // en lugar de llamar a la función en cada renderizado.
        // future: _futurePropiedades,
        // OBTIENE LA LISTA DE PROPIDADES SIN FOTOS NI INDEX
        future: ref
            .read(espaciosCasaConListaFotosGetProvider.notifier)
            .getPropiedadesCasaIdUser(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return stateNone(
                widthCuadroFotoPropiedad,
                heightCuadroFotoPropiedad,
              );
            case ConnectionState.waiting:
              return stateWaiting(
                widthCuadroFotoPropiedad,
                heightCuadroFotoPropiedad,
              );
            case ConnectionState.active:
              return stateActive(
                widthCuadroFotoPropiedad,
                heightCuadroFotoPropiedad,
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return stateErrorFormat(
                  widthCuadroFotoPropiedad,
                  heightCuadroFotoPropiedad,
                  snapshot.error,
                );
              } else {
                // Aquí usamos watch para reaccionar a cambios en el provider
                // una vez que la carga inicial (future) ha terminado.
                // final espaciosData = ref.watch(espaciosCasaConListaFotosGetProvider);
                debugPrintLevels(
                  10,
                  "--- FutureBuilder done. Items: ${ref.read(espaciosCasaConListaFotosGetProvider).espaciosCasas.rows.length}",
                );
                // CASO: LA LISTA DE PROPIEDADES ESTA VACIA
                if (ref
                    .watch(espaciosCasaConListaFotosGetProvider)
                    .espaciosCasas
                    .rows
                    .isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      "No tienes espacios en ${ref.read(menuTipoEspaciosProvider).etiqueta}.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: appTheme.primary,
                        fontSize: fontSizeTituloPagina,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                  // CASO: LA LISTA DE PROPIEDADES NO ESTA VACIA
                } else {
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List<Widget>.generate(
                      ref
                          .watch(espaciosCasaConListaFotosGetProvider)
                          .espaciosCasas
                          .rows
                          .length,
                      (indexEspacios) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                            color: appTheme.surface,
                          width: 350,
                          child: CreaFichaCapturaPropiedad(
                            context,
                            indexEspacios,
                            ref
                                .watch(espaciosCasaConListaFotosGetProvider)
                                .espaciosCasas
                                .rows[indexEspacios]
                                .value,
                            () => setState(() {}),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
          }
        },
      ),
    );
  }
}

//------------------------------------------------------------------------------
