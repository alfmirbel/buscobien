import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../01_home/home_navigation_provider.dart';
import '../05_provider_menus/provider_menu_inicial.dart';
import '../05_provider_menus/provider_menu_principal.dart';
import '../05_provider_menus/variables_menus.dart';
import '../07_routes/app_routes.dart';
import '../07_routes/pagina_route_error.dart';
import '../07_routes/routes_parameters.dart';
import '../10_user_login/avatar/data_user_avatar_get.dart';
import '../10_user_login/avatar/manejo_imagenes_avatar.dart';
import '../10_user_login/avatar/provider_get_avatar.dart';
import '../10_user_login/usuario_login/dialogbox_login.dart';
import '../10_user_login/usuario_login/provider_session.dart';
import '../14_geolocalizacion/provider_actual_place.dart';
import '../20_var_globales/var_color_themes.dart';
import '../20_var_globales/var_color_widget.dart';
import '../20_var_globales/var_login.dart';
import '../20_var_globales/variables_globales.dart';
import '../41_connectivity/connectivitycheck_provider.dart';
import '../60_global_widgets/debugprint.dart';

// Asegúrate de importar tus providers, temas y widgets globales
// import 'provider_get_avatar.dart'; // Tu nuevo provider generado
// import '...';

AppBar appBarPrincipal(
  BuildContext context,
  VoidCallback onTab, // Tipado más estricto para callbacks
  String titulo,
  WidgetRef ref,
) {
  final screenWidth = MediaQuery.of(context).size.width;
  // final screenHeight = MediaQuery.of(context).size.height; // No usado actualmente

  // 1. OBTENER EL ESTADO REACTIVO
  final asyncConeccion = ref.watch(checaConeccionesProvider);
  final ubicacionState = ref.watch(ubicacionActualProvider);

  // Observamos los datos del usuario para reactividad en el icono y tooltips
  //final userDataState = ref.watch(sessionProvider,); // Si es necesario para nombreusuario

  // Observamos el estado del avatar (Nuevo Provider Generado)

  // Derivamos datos de usuario para facilitar la lectura
  String idUsuario = "";
  String nombreUsuario = "";

  //if (ref.watch(sessionProvider).sessionUserData.rows.isNotEmpty) {
  idUsuario = ref.read(sessionProvider).sessionUserData.userId;
  nombreUsuario = ref.read(sessionProvider).sessionUserData.userName;
  //}

  // Opcional: Si el nombre viene de otro provider, ajústalo aquí
  // if (userDataState.rows.isNotEmpty) ...

  debugPrintLevels(
    20,
    "--------------------------------------------------------",
  );
  debugPrintLevels(20, "-- 1. appBarPrincipal inicializa la barra superior");

  List<Widget> listaBotones = [
    //- BOTON CONEXION A INTERNET ---------------------------------------------
    asyncConeccion.when(
      loading: () => Padding(
        padding: const EdgeInsets.all(2),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: appTheme.primary,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (error, stack) => IconButton(
        icon: Icon(Symbols.signal_wifi_bad, color: appTheme.error),
        iconSize: menuTabIconSize,
        color: appTheme.primary,
        padding: const EdgeInsets.all(2),
        constraints: BoxConstraints.loose(Size(menuTabHeight, menuTabHeight)),
        tooltip: "Error al verificar conexión",
        onPressed: () {
          parameterPaginaChecaConeccion["ref"] = ref;
          Navigator.pushNamed(
            context,
            AppRoutes.checaconeccion,
            arguments: parameterPaginaChecaConeccion,
          );
        },
      ),
      data: (coneccion) => IconButton(
        color: (coneccion.etiqueta == "Conectado")
            ? appTheme.primary
            : appTheme.error,
        iconSize: menuTabIconSize,
        padding: const EdgeInsets.fromLTRB(2, 0, 3, 2),
        constraints: BoxConstraints.loose(Size(menuTabHeight, menuTabHeight)),
        icon: Icon(coneccion.icono, size: menuTabIconSize),
        tooltip: coneccion.etiqueta,
        onPressed: () {
          debugPrintLevels(0, "*** appBarPrincipal Navigator /checaconeccion");
          parameterPaginaChecaConeccion["ref"] = ref;
          Navigator.pushNamed(
            context,
            AppRoutes.checaconeccion,
            arguments: parameterPaginaChecaConeccion,
          );
        },
      ),
    ),

    //- BOTON LOCALIDADES ------------------------------------------------------
    botonAccion(Symbols.pin_drop, () {
      parameterPaginaChecaConeccion["ref"] = ref;
      debugPrintLevels(
        0,
        "*** ubicación: ${ubicacionState.permisodelocalizacion}",
      );
      (ubicacionState.permisodelocalizacion == 0)
          ? PaginaDeError("Activa los permisos de ubicación")
          : Navigator.pushNamed(
              context,
              AppRoutes
                  .localidades, // lib\12_localidades\pagina_localidades.dart
              arguments: "",
            );
      //PaginaPrincipalListaLocalidades(),
      //Navigator.of(context).pushNamed('/buscalocalidad', arguments: "");
    }, "Ubicación"),

    //- BOTON FILTROS ----------------------------------------------------------
    (screenWidth > smallScreenMin)
        ? botonAccion(Symbols.filter_list, () {}, "(des)Activar filtros")
        : const SizedBox(width: 0),

    //- BOTON NOTIFICACIONES ---------------------------------------------------
    botonAccion(Symbols.notifications, () {
      // Tu lógica de navegación a notificaciones
    }, "Notificaciones"),

    //- BOTON BUSCAR------------------------------------------------------------
    (screenWidth > smallScreenMin)
        ? botonAccion(Symbols.search, () {}, "Buscar")
        : const SizedBox(width: 0),

    //- BOTON AYUDA ------------------------------------------------------------
    botonAccion(Symbols.help_outline, () {}, "Ayuda"),

    //- BOTON USUARIO (Icono o Avatar) -----------------------------------------
    _buildUserButton(
      context,
      ref,
      idUsuario,
      nombreUsuario,
      ref.watch(sessionProvider).esPromotor,
      ref.watch(classUserAvatarProvider),
    ),
  ];

  return AppBar(
    toolbarHeight: menuToolbarHeight,
    backgroundColor: appTheme.surface,
    primary: true,
    centerTitle: false,
    titleSpacing: 0,
    leading: appBarTooltip("Menu"),
    title: wdtTitulo(context, titulo),
    scrolledUnderElevation: 0.0,
    elevation: 0.0,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(0.0),
      child: Container(),
    ),
    shadowColor: appTheme.onPrimary,
    actions: [Row(children: listaBotones)],
  );
}

// -----------------------------------------------------------------------------
// Widgets Auxiliares Refactorizados
// -----------------------------------------------------------------------------

Widget _buildUserButton(
  BuildContext context,
  WidgetRef ref,
  String idUsuario,
  String nombreUsuario,
  bool esPromotor,
  GetUserAvatar avatarState,
) {
  // Lógica para determinar qué widget mostrar (Icono o Imagen)
  Widget userIconWidget;

  if (idUsuario.isEmpty) {
    // Caso 1: No hay usuario logueado
    userIconWidget = Icon(iconNoUser, size: iconSizeFiltros);
  } else {
    // Caso 2: Usuario logueado, verificamos si hay avatar
    if (avatarState.rows.isNotEmpty &&
        avatarState.rows[0].value.avatar.isNotEmpty) {
      // Intentamos convertir la data base64
      try {
        // Usamos la función auxiliar convierteData2Imagen que ya tienes
        final imageBytes = convierteData2Imagen(
          avatarState.rows[0].value.avatar,
        );
        if (imageBytes.isNotEmpty) {
          userIconWidget = CircleAvatar(
            maxRadius: 13,
            minRadius: 10,
            backgroundImage: MemoryImage(imageBytes),
          );
        } else {
          userIconWidget = Icon(iconUser, size: iconSizeFiltros);
        }
      } catch (e) {
        userIconWidget = Icon(iconUser, size: iconSizeFiltros);
      }
    } else {
      // Usuario logueado pero sin avatar
      userIconWidget = Icon(iconUser, size: iconSizeFiltros);
    }
  }

  return IconButton(
    color: appTheme.primary,
    padding: const EdgeInsets.all(1),
    icon: userIconWidget,
    tooltip: (ref.read(sessionProvider).sessionUserData.userId == "")
        ? "Sin usuario"
        : (ref.watch(sessionProvider).sessionUserData.userName),
    onPressed: () async {
      debugPrintLevels(0, "*** appBarPrincipal Usuario onPressed");
      if (ref.read(sessionProvider).sessionUserData.userId == "") {
        // ── Sin sesión: mostrar el diálogo de login ──────────────────────────
        final loginExitoso = await dialogBoxFichaLogin(context, ref);
        // Verificar que el contexto sigue válido después del await
        if (!context.mounted) return;
        //----------------------------------------------------------------------
        if (loginExitoso == true) {
          // PUNTO 1: Login exitoso → "Mi Cuenta" (índice 3) dentro del menú
          debugPrintLevels(0, "*** Login exitoso → Mi Cuenta (3)");
          ref
              .read(menuInicialProvider.notifier)
              .asignaNuevaOpcionSeleccionada(ref, 3);
          ref.read(homeNavigationProvider.notifier).actualizarInicial(3);
        } else {
          // PUNTO 2: Cancelado o "Salir" → "Propiedades" (índice 1)
          debugPrintLevels(0, "*** Login cancelado → Propiedades (1)");
          ref
              .read(menuInicialProvider.notifier)
              .asignaNuevaOpcionSeleccionada(ref, 1);
          ref.read(homeNavigationProvider.notifier).actualizarInicial(1);
          ref
              .read(menuPrincipalProvider.notifier)
              .asignaNuevaOpcionSeleccionada(ref, 0);
          ref.read(homeNavigationProvider.notifier).actualizarPrincipal(0);
        }
        // Recargamos la pantalla principal para que el AppBar muestre el avatar
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.principal,
          arguments: "",
        );
      } else {
        // ── Con sesión activa: ir a "Perfil" (índice 4) dentro de la pantalla ─
        // PUNTO 3: No reemplazamos la ruta, solo cambiamos el índice del menú
        debugPrintLevels(0, "*** Usuario logueado → Perfil (4)");
        ref
            .read(menuInicialProvider.notifier)
            .asignaNuevaOpcionSeleccionada(ref, 4);
        // Sincronizar el TabController visualmente con el nuevo índice
        ref
            .read(menuInicialProvider.notifier)
            .restableceOpcionActualSeleccionada(ref);
        ref.read(homeNavigationProvider.notifier).actualizarInicial(4);
      }
      //--------------------------------------------------
    },
  );
}

Builder appBarTooltip(String toolTip) {
  return Builder(
    builder: (BuildContext context) {
      return IconButton(
        icon: Icon(Symbols.menu, color: appTheme.primary),
        iconSize: menuTabIconSize + 4,
        color: appTheme.primary,
        padding: const EdgeInsets.all(2),
        constraints: BoxConstraints.loose(Size(menuTabHeight, menuTabHeight)),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        tooltip: toolTip,
      );
    },
  );
}

IconButton botonAccion(IconData icono, VoidCallback onTab, String tip) {
  return IconButton(
    icon: Icon(icono, color: appTheme.primary),
    iconSize: menuTabIconSize,
    color: appTheme.primary,
    padding: const EdgeInsets.all(2),
    constraints: BoxConstraints.loose(Size(menuTabHeight, menuTabHeight)),
    tooltip: tip,
    onPressed: onTab,
  );
}

Text wdtTitulo(BuildContext context, String appName) {
  return Text(
    appName,
    style: TextStyle(
      fontSize: menuTabLabelSize,
      fontFamily: "Comfortaa",
      fontWeight: FontWeight.bold,
      height: 1,
      color: appTheme.primary,
    ),
  );
}
