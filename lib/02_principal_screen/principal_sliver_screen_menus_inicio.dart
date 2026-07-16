import 'package:buscobien/10_user_login/usuario_login/provider_session.dart';
import '../10_user_login/avatar/provider_get_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../01_home/home_navigation_provider.dart';
import '../01_home/home_state.dart';
import '../03_listas/pagina_mis_listas.dart';
import '../05_provider_menus/appbar_menu_tu_cuenta.dart';
import '../05_provider_menus/appbar_menu_tu_cuenta_usuario.dart';
import '../05_provider_menus/appbar_sliver_menu_inicial.dart';
import '../05_provider_menus/appbar_sliver_menu_principal.dart';
import '../05_provider_menus/provider_menu_inicial.dart';
import '../05_provider_menus/provider_menu_nivel_gobierno.dart';
import '../05_provider_menus/provider_menu_principal.dart';
import '../05_provider_menus/provider_menu_tipo_de_transaccion.dart';
import '../05_provider_menus/provider_menu_tipo_espacio.dart';
import '../05_provider_menus/provider_menu_tu_cuenta.dart';
import '../05_provider_menus/provider_menu_tu_cuenta_usuario.dart';
import '../07_routes/app_routes.dart';
import '../08_pantallas/inicio/pagina_inicio_busca_espacios.dart';
import '../08_pantallas/perfil/pagina_perfil.dart';
import '../08_pantallas/tu_cuenta/conocidos/conocidos_view.dart';
import '../08_pantallas/tu_cuenta/grupos/grupos_view.dart';
import '../08_pantallas/tu_cuenta/tus_espacios/pagina_tus_espacios.dart';
import '../08_pantallas/tu_cuenta/tus_espacios/tabla_tipopropiedad_vs_campos.dart';
import '../08_pantallas/ubicacion/pagina_principal_localidades.dart';
import '../08_pantallas/ubicacion/provider_localidades_del_cp.dart';
import '../10_user_login/usuario_login/dialogbox_login.dart';
import '../14_geolocalizacion/provider_actual_place.dart';
import '../20_var_globales/var_color_themes.dart';
import '../20_var_globales/var_color_widget.dart';
import '../20_var_globales/var_elementos_menus.dart';
import '../20_var_globales/var_login.dart';
import '../20_var_globales/variables_globales.dart';
import '../41_connectivity/connectivitycheck_provider.dart';
import '../60_global_widgets/debugprint.dart';
import 'principal_00_inicio.dart';
import 'principal_02_page_appbar.dart';
import 'principal_03_page_drawer.dart';

// OPTIMIZADO 23 01 25

String selectedDropDownMenuPrincipalValue = otrosTiposDeInmueble.first;

class PrincipalSliversMenuInicial extends ConsumerStatefulWidget {
  const PrincipalSliversMenuInicial({super.key});

  @override
  ConsumerState<PrincipalSliversMenuInicial> createState() =>
      _PrincipalSliversMenuInicialState();
}

class _PrincipalSliversMenuInicialState
    extends ConsumerState<PrincipalSliversMenuInicial>
    with TickerProviderStateMixin {
  // Controlador de scroll para soportar Scrollbar en Web/Desktop
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // CORRECCIÓN CRÍTICA:
    // 1. Inicializamos los Controladores (TabControllers) INMEDIATAMENTE.
    //    El método build() los necesita para pintar los TabBars.
    _inicializarSoloControladores();

    // 2. La lógica que modifica el estado o selecciona opciones
    //    la dejamos para después del renderizado para evitar conflictos.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ✅ FASE 2: Recuperar sesión persistida ANTES de inicializar menús.
      // Esto restaura userId, userName, nombrePerfil y flags de rol
      // desde FlutterSecureStorage si el usuario ya inició sesión antes.
      await ref.read(sessionProvider.notifier).getSessionValuesFromLocalStorage();

      // FASE 3 (26-05-18): Si la sesión fue restaurada, precarga los datos
      // completos del usuario en segundo plano. Así PaginaPerfilWidget los
      // encuentra listos (isUserDataLoaded = true) sin hacer otra petición HTTP.
      if (ref.read(sessionProvider).isAuthenticated) {
        ref.read(sessionProvider.notifier).getUserDataByNameInSessionData();
        
        final currentUserId = ref.read(sessionProvider).sessionUserData.userId;
        ref.read(classUserAvatarProvider.notifier).recuperaDatosDelAvatar(currentUserId);
      }

      _inicializarLogicaDeNegocio();
    });

    // Iniciar ubicación en segundo plano
    _triggerLocationUpdate();
  }

  /// Paso 1: Inicialización Síncrona (Esencial para evitar LateInitializationError)
  void _inicializarSoloControladores() {
    debugPrintLevels(0, "- Inicializando Controladores Sincronamente");

    // Inicializa TabControllers usando 'this' (TickerProvider)
    ref.read(menuInicialProvider.notifier).inicializaController(this);
    ref.read(menuPrincipalProvider.notifier).inicializaController(this);
    ref.read(menuNivelDeGobiernoProvider.notifier).inicializaController(this);
    ref.read(menuTipoEspaciosProvider.notifier).inicializaController(this);
    ref.read(menuTipoDeTransaccionProvider.notifier).inicializaController(this);
    ref.read(menuTuCuentaProvider.notifier).inicializaController(this);
    ref.read(menuTuCuentaUsuarioProvider.notifier).inicializaController(this);
  }

  /// Paso 2: Lógica de Negocio Asíncrona (Safe state updates)
  void _inicializarLogicaDeNegocio() {
    debugPrintLevels(0, "- Inicializando Lógica de Negocio Post-Frame");

    // MENU INICIAL
    ref
        .read(menuInicialProvider.notifier)
        .asignaNuevaOpcionSeleccionada(
          ref,
          ref.read(menuInicialProvider).seleccionMenuInicial,
        );
    ref
        .read(menuInicialProvider.notifier)
        .restableceOpcionActualSeleccionada(ref);

    // MENU PRINCIPAL
    ref
        .read(menuPrincipalProvider.notifier)
        .asignaNuevaOpcionSeleccionada(
          ref,
          ref.read(menuPrincipalProvider).seleccionMenuPrincipal,
        );
    ref
        .read(menuPrincipalProvider.notifier)
        .restableceOpcionActualSeleccionada(ref);

    // MENU NIVEL DE GOBIERNO
    ref
        .read(menuNivelDeGobiernoProvider.notifier)
        .asignaNuevaOpcionSeleccionada(
          ref,
          ref.read(menuNivelDeGobiernoProvider).seleccionMenuNivelDeGobierno,
        );
    ref
        .read(menuNivelDeGobiernoProvider.notifier)
        .restableceOpcionActualSeleccionada(ref);

    // MENU TIPO DE ESPACIO
    ref
        .read(menuTipoEspaciosProvider.notifier)
        .asignaNuevaOpcionSeleccionada(
          ref,
          ref.read(menuTipoEspaciosProvider).seleccionMenuTipoEspacios,
        );
    ref
        .read(menuTipoEspaciosProvider.notifier)
        .restableceOpcionActualSeleccionada(ref);

    // MENU TIPO DE TRANSACCION
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

    // MENU TU CUENTA
    ref
        .read(menuTuCuentaProvider.notifier)
        .asignaNuevaOpcionSeleccionada(
          ref,
          ref.read(menuTuCuentaProvider).seleccionMenuTuCuenta,
        );
    ref
        .read(menuTuCuentaProvider.notifier)
        .restableceOpcionActualSeleccionada(ref);
    // MENU TU CUENTA USUARIO
    ref
        .read(menuTuCuentaUsuarioProvider.notifier)
        .asignaNuevaOpcionSeleccionada(
          ref,
          ref.read(menuTuCuentaUsuarioProvider).seleccionMenuTuCuentaUsuario,
        );
    ref
        .read(menuTuCuentaUsuarioProvider.notifier)
        .restableceOpcionActualSeleccionada(ref);
  }

  //-----------------------------------------------------------------------------
  @override
  void didChangeDependencies() {
    debugPrintLevels(1, " PaginaInicioUsuarios didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PrincipalSliversMenuInicial oldWidget) {
    debugPrintLevels(1, " PaginaInicioUsuarios didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    debugPrintLevels(1, " PaginaInicioUsuarios deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrintLevels(1, " PaginaInicioUsuarios dispose");
    _scrollController.dispose();
    super.dispose();
  }

  //-----------------------------------------------------------------------------

  // VARIABLES DEL NAVBAR
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool _locationRequested = false;

  // Variable para evitar abrir múltiples pantallas de error si la conexión parpadea
  bool _isErrorPageOpen = false;

  void _navigateToErrorPage() {
    if (!mounted) return;

    Navigator.pushNamed(
      context,
      AppRoutes.sinconeccion,
      arguments: "No se detectó conexión a Internet.",
    );
  }

  //---------------------------------
  Future<void> _triggerLocationUpdate() async {
    if (_locationRequested) return;
    _locationRequested = true;

    try {
      final locationNotifier = ref.read(ubicacionActualProvider.notifier);
      final status = await locationNotifier.determinePermisosUbicacion();

      if (status == 1 && mounted) {
        await locationNotifier.determinaUbicacion();

        if (mounted) {
          final postalCode = ref
              .read(localidadesPorCodigoPostalProvider)
              .codigoPostal;

          if (postalCode != 0 && mounted) {
            final result = await ref
                .read(localidadesPorCodigoPostalProvider.notifier)
                .fetchLocaliadesCodigoPostal();

            if (result == 200 && mounted) {
              // índice 3 = C.P. en elementosMenuNivelDeGobierno
              ref
                  .read(menuNivelDeGobiernoProvider.notifier)
                  .asignaNuevaOpcionSeleccionada(ref, 0);
              ref
                  .read(menuNivelDeGobiernoProvider.notifier)
                  .restableceOpcionActualSeleccionada(ref);
              ref
                  .read(homeNavigationProvider.notifier)
                  .actualizarNivelGobierno(3);
            }
          }
        }
      }
    } catch (e) {
      debugPrintLevels(10, "Error obteniendo ubicación en background: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------------------
    // LISTENER DE NAVEGACIÓN
    // ------------------------------------------------------------------------

    ref.listen(homeNavigationProvider, (previous, next) async {
      if ((previous!.indiceInicial != next.indiceInicial) ||
          (previous.indicePrincipal != next.indicePrincipal) ||
          (previous.indiceNivelGobierno != next.indiceNivelGobierno) ||
          (previous.indiceTipoEspacio != next.indiceTipoEspacio) ||
          (previous.indiceTipoTransaccion != next.indiceTipoTransaccion) ||
          (previous.indiceMiCuenta != next.indiceMiCuenta) ||
          (previous.indiceMiCuentaUsuario != next.indiceMiCuentaUsuario)) {
        // Scroll al inicio cuando cambia la navegación principal
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      }
    });

    // ------------------------------------------------------------------------
    // LISTENER DE CONEXIÓN
    // ------------------------------------------------------------------------
    ref.listen(checaConeccionesProvider, (previous, next) {
      next.when(
        data: (coneccion) {
          if (coneccion.etiqueta != "Conectado" && !_isErrorPageOpen) {
            _isErrorPageOpen = true;

            Navigator.pushNamed(
              context,
              AppRoutes.sinconeccion,
              arguments: "Se perdió la conexión a Internet.",
            ).then((_) {
              _isErrorPageOpen = false;
            });
          }
        },
        error: (_, __) => _navigateToErrorPage(),
        loading: () {},
      );
    });

    // ------------------------------------------------------------------------

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    // Obtener el estado de navegación
    final navState = ref.watch(homeNavigationProvider);
    final userSession = ref.watch(sessionProvider);

    return Scaffold(
      appBar: appBarPrincipal(context, () {}, appName, ref),
      drawer: const MenuDrawer(),

      body: Row(
        children: [
          // 2. Contenido Principal
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: CustomScrollView(
                scrollCacheExtent: ScrollCacheExtent.pixels(1500),
                controller: _scrollController,
                slivers: [
                  // --- MENÚ INICIAL (Siempre visible excepto flujo Propiedades) ---
                  if (navState.indiceInicial != 1) ...[
                    menuSuperiorMenuInicial(ref),
                  ],

                  // --- LÓGICA DE VISIBILIDAD DE MENÚS ---

                  // CASO 0: ÍNDICE INICIAL 0 (Inicio / Landing Pages)
                  if (navState.indiceInicial == 0) ...[
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: PageInicio(),
                    ),

                    // CASO 1: ÍNDICE INICIAL 1 (Flujo de Propiedades)
                  ] else if (navState.indiceInicial == 1) ...[
                    menuSuperiorMenuPrincipal(ref),

                    if (navState.indicePrincipal >= 0 &&
                        navState.indicePrincipal <= 3) ...[
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: PaginaBuscaEspacios(navState),
                      ),
                    ],

                    // CASO 2: ÍNDICE INICIAL 2 (Ubicación)
                  ] else if (navState.indiceInicial == 2) ...[
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: PaginaPrincipalListaLocalidades(),
                    ),

                    // CASO 3: ÍNDICE INICIAL 3 (Mi Cuenta)
                  ] else if (navState.indiceInicial == 3) ...[
                    if (userSession.nombrePerfil == "")
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _vistaSinUsuario(),
                      )
                    else if (userSession.esPromotor) ...[
                      MenuSuperiorPaginaTuCuenta(),
                      if (navState.indiceMiCuenta == 0)
                        SliverFillRemaining(
                          hasScrollBody: true,
                          child: PaginaTusEspacios(),
                        )
                      else if (navState.indiceMiCuenta == 1)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: PageMisListas(),
                        )
                      else if (navState.indiceMiCuenta == 2)
                        SliverFillRemaining(
                          hasScrollBody: true,
                          child: GruposView(
                            currentUserId: userSession.sessionUserData.userId,
                            currentUserName:
                                userSession.sessionUserData.userName,
                          ),
                        )
                      else if (navState.indiceMiCuenta == 3)
                        SliverFillRemaining(
                          hasScrollBody: true,
                          child: ConocidosView(
                            currentUserId: userSession.sessionUserData.userId,
                            currentUserName:
                                userSession.sessionUserData.userName,
                          ),
                        ),
                    ] else if (userSession.esUsuario) ...[
                      MenuSuperiorPaginaTuCuentaUsuario(),
                      if (navState.indiceMiCuentaUsuario == 0)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: PageMisListas(),
                        )
                      else if (navState.indiceMiCuentaUsuario == 1)
                        SliverFillRemaining(
                          hasScrollBody: true,
                          child: GruposView(
                            currentUserId: userSession.sessionUserData.userId,
                            currentUserName:
                                userSession.sessionUserData.userName,
                          ),
                        )
                      else if (navState.indiceMiCuentaUsuario == 2)
                        SliverFillRemaining(
                          hasScrollBody: true,
                          child: ConocidosView(
                            currentUserId: userSession.sessionUserData.userId,
                            currentUserName:
                                userSession.sessionUserData.userName,
                          ),
                        ),
                    ],

                    // CASO 4: ÍNDICE INICIAL 4 (Perfil)
                  ] else if (navState.indiceInicial == 4) ...[
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: PaginaPerfilWidget(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. VISTA INVITADO
  Widget _vistaSinUsuario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Text(
          'Crea listas, grupos o contactos',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Outfit',
            color: appTheme.secondary,
            fontSize: fontSizeTituloPagina,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
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
                      'Ingresa de acuerdo a tu perfil',
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
}

class VistaContenidoDinamico extends StatelessWidget {
  final HomeState navState;
  const VistaContenidoDinamico({super.key, required this.navState});

  @override
  Widget build(BuildContext context) {
    if ((navState.indicePrincipal >= 0) && (navState.indicePrincipal <= 3)) {
      return PaginaBuscaEspacios(navState);
    }
    return const SizedBox.shrink();
  }
}

// -----------------------------------------------------------------------------
