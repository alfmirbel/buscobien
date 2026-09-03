# Inventario de Componentes — 02_principal_screen

**Directorio:** `lib/02_principal_screen/`
**Archivos:** 5 archivos `.dart`
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo)

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| 02_principal_screen | `00_principales_opciones.dart` | Clase modelo + Variables top-level | `MenuOption`, `listaLandingPages[9]`, `menuOpciones[3]` | `nombreCorto`, `nombreLargo`, `descripcion`, `icono`, `imagePath` | `var_elementos_menus` iconos (vía imports `../03_vistas/*`) | — | — |
| 02_principal_screen | `principal_00_inicio.dart` | ConsumerStatefulWidget | `PageInicio` | — | `menuOpciones`, `listaLandingPages`, `appTheme`, `var_color_widget`, `derechosReservados` | `_PageInicioState` | `customCardServicios`, `customCardSmallServicios`, `_HoverScaleCard` |
| 02_principal_screen | `principal_00_inicio.dart` | ConsumerState | `PageInicioState` (`_PageInicioState`) | — | `appTheme` | `ScrollController _scrollController` | `Hero`, `Image`, `Container`, `Expanded`, `GestureDetector`, `Wrap`, `Stack` |
| 02_principal_screen | `principal_00_inicio.dart` | StatefulWidget | `_HoverScaleCard` | `Widget child`, `VoidCallback onTap` | — | `AnimationController _controller` (en `_HoverScaleCardState`) | `Transform.scale`, `GestureDetector` |
| 02_principal_screen | `principal_02_page_appbar.dart` | Funciones top-level | `appBarPrincipal`, `_buildUserButton`, `appBarTooltip`, `botonAccion`, `wdtTitulo` | `BuildContext`, `VoidCallback`, `String`, `WidgetRef` | 7 providers de menú, `homeNavigationProvider`, `sessionProvider`, `classUserAvatarProvider`, `loginExitoso`, `ubicacionState`, `asyncConeccion`, `imageBytes` | — | `AppBar`, `IconButton`, `Tooltip`, `CircleAvatar`, `NavigationDestination` |
| 02_principal_screen | `principal_03_page_drawer.dart` | ConsumerWidget | `MenuDrawer` | — | `AppRoutes`, `var_elementos_menus`, `debugPrintLevels`, `AppExitType`, `detecta_os` | — | `Drawer`, `ListView`, `ListTile`, `CircleAvatar`, `Divider`, `Image.asset` |
| 02_principal_screen | `principal_sliver_screen_menus_inicio.dart` | ConsumerStatefulWidget + TickerProvider | `PrincipalSliversMenuInicial` | — | 7 providers de menú, `homeNavigationProvider`, `sessionProvider`, `ubicacionActualProvider`, `classUserAvatarProvider`, `checaConeccionesProvider` | 7 `TabController` vía `TickerProviderStateMixin`, `ScrollController _scrollController`, `selectedDropDownMenuPrincipalValue` | `CustomScrollView`, `SliverAppBar`, `SliverList`, `ButtonsTabBar` |
| 02_principal_screen | `principal_sliver_screen_menus_inicio.dart` | ConsumerState | `_PrincipalSliversMenuInicialState` | — | como arriba | 7 controllers + `_isInitialized` implícito | `VistaContenidoDinamico` (helper) |
| 02_principal_screen | `principal_sliver_screen_menus_inicio.dart` | StatelessWidget | `VistaContenidoDinamico` | `HomeState navState` | — | — | `Center`, `Column`, `Text` |

---

## Tabla 2: Elementos (por archivo)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| 02_principal_screen | `00_principales_opciones.dart` | `listaLandingPages` (List<Widget>, 9 elementos), `menuOpciones` (List<MenuOption>, 3 elementos) | `MenuOption` | `nombreCorto`, `nombreLargo`, `descripcion`, `icono`, `imagePath` | Constructor factory | `var_elementos_menus` iconos (vía imports `../03_vistas/*`) | Imports: `pagina_asociaciones`, `hospedaje`, `inmobiliarias`, `market`, `propietarios`, `servicios`, `promotores`, `proveedores`, `usuarios` |
| 02_principal_screen | `principal_00_inicio.dart` | `codigoPostalBusquedaProvider` (Provider externo re-exportado), `warningApp` | `PageInicio` (ConsumerStatefulWidget) | — | `createState()` | `menuOpciones`, `listaLandingPages`, `appTheme` | `derechosReservadosObscuro()`, `_HoverScaleCard` |
| 02_principal_screen | `principal_00_inicio.dart` | — | `PageInicioState` (ConsumerState) | `ScrollController _scrollController` | `build()`: hero, grid 3 cards, footer | `appTheme`, `menuOpciones`, `var_color_widget` | `Hero`, `Image.asset`, `GestureDetector`, `Expanded`, `Wrap`, `Transform.scale` |
| 02_principal_screen | `principal_00_inicio.dart` | — | `_HoverScaleCard` (StatefulWidget) | `Widget child`, `VoidCallback onTap` | `createState()` | — | `Transform.scale` (en `_HoverScaleCardState.build()`) |
| 02_principal_screen | `principal_02_page_appbar.dart` | `screenWidth`, `asyncConeccion`, `ubicacionState`, `imageBytes`, `loginExitoso` (todas top-level, locales a su scope) | — | — | `appBarPrincipal(context, onMenuPressed, titulo, ref)`, `_buildUserButton(ref)`, `appBarTooltip()`, `botonAccion()`, `wdtTitulo()` | 7 providers menú, `sessionProvider`, `homeNavigationProvider`, `classUserAvatarProvider`, `ubicacionActualProvider`, `checaConeccionesProvider` | `AppBar`, `IconButton`, `Tooltip`, `CircleAvatar`, `NavigationDestination`, `Navigator.pushNamed`, `dialogBoxFichaLogin`, `Image.memory` |
| 02_principal_screen | `principal_03_page_drawer.dart` | `AppExitType` (enum externo), `SizedBox` (override alias) | `MenuDrawer` (ConsumerWidget) | — | `build()`, `_createDrawerItem()`, `_createHeader()`, `_createDrawerAbout()` | `AppRoutes`, `var_elementos_menus`, `debugPrintLevels` | `Drawer`, `ListView`, `ListTile`, `Navigator.pushReplacementNamed`, `Image.asset`, `CircleAvatar`, `Divider` |
| 02_principal_screen | `principal_sliver_screen_menus_inicio.dart` | `selectedDropDownMenuPrincipalValue` (String global, init `otrosTiposDeInmueble.first`) | `PrincipalSliversMenuInicial` (ConsumerStatefulWidget) | — | `createState()` | — | — |
| 02_principal_screen | `principal_sliver_screen_menus_inicio.dart` | — | `_PrincipalSliversMenuInicialState` (ConsumerState + TickerProviderStateMixin) | `ScrollController _scrollController` | `initState()`, `_inicializarSoloControladores()`, `_inicializarLogicaDeNegocio()`, `_triggerLocationUpdate()`, `build()`, `dispose()` | 7 providers menú, `sessionProvider`, `homeNavigationProvider`, `ubicacionActualProvider`, `classUserAvatarProvider`, `checaConeccionesProvider` | `CustomScrollView`, `SliverAppBar`, `ButtonsTabBar`, `PageInicio`, `PaginaBuscaEspacios`, `PaginaPrincipalListaLocalidades`, `PaginaTusEspacios`, `ConocidosView`, `GruposView`, `PaginaPerfilWidget`, `Navigator.pushNamed`, `dialogBoxFichaLogin`, `AppRoutes.sinconeccion` |
| 02_principal_screen | `principal_sliver_screen_menus_inicio.dart` | — | `VistaContenidoDinamico` (StatelessWidget) | `HomeState navState` | `build()` | — | `Center`, `Column`, `Text` |

---

## Notas

- **Orquestador único**: `PrincipalSliversMenuInicial` es el único widget que inicializa los 7 `TabController` (sincrónico en `initState`) y restaura la sesión en `postFrameCallback` (`getSessionValuesFromLocalStorage()` → `getUserDataByNameInSessionData()` → `recuperaDatosDelAvatar()`).
- **Patrón slivers condicional**: `build()` arma un `CustomScrollView` con slivers condicionales según `homeNavigationProvider.indiceInicial` (0=Inicio, 1=Propiedades, 2=Ubicación, 3=Mi Cuenta, 4=Perfil). Cambios de índice provocan reconstrucción del sliver correspondiente.
- **Listener de conectividad**: está vinculado a `checaConeccionesProvider`; al detectar "Sin conexión" navega a `AppRoutes.sinconeccion` y al recuperar, regresa vía `Navigator.pop()`.
- **`selectedDropDownMenuPrincipalValue`**: variable global de estado de UI para sincronizar el dropdown de tipos de inmueble.
- **Drawer estático**: 11 items, algunos marcados "Próximamente" sin navegación real; `_createDrawerItem()` resuelve rutas vía `Navigator.pushReplacementNamed(AppRoutes.xxx)`.
- **`_HoverScaleCard`**: animación hover (escala) para Web/Desktop — provee feedback táctil en pantallas con puntero.
- **`appBarPrincipal` es función, no widget**: composición funcional que retorna `PreferredSizeWidget`; lee `sessionProvider` y `classUserAvatarProvider` para alternar entre botón Login (sin sesión) y Avatar (con sesión).
