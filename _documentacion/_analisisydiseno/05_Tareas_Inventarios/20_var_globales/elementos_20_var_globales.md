# Inventario de Componentes — 20_var_globales

**Directorio:** `lib/20_var_globales/`
**Archivos:** 9 `.dart`
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo)

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| 20_var_globales | `var_color_themes.dart` | Constantes ColorScheme + variable global | `appTheme` (variable mutable), 18 `ColorScheme const` (lightINE, darkINE, lightMC, darkMC, lightMOR, darkMOR, lightPAN, darkPAN, lightPRD, darkPRD, lightPRI, darkPRI, lightPT, darkPT, lightPVEM, darkPVEM, darkALL) | — | `Color` (0xFF...), `Brightness` | `appTheme = lightPAN` (default) | — |
| 20_var_globales | `var_color_widget.dart` | Constantes breakpoints + helpers | `xSmallScreenMax=599`, `smallScreenMin=600`, `smallScreenMax=903`, `mediumScreenMin=904`, `mediumScreenMax=1239`, `largeScreenMin=1240`, `largeScreenMax=1439`, `desktopContentMaxWidth=1280` + `isMobile(context)`, `isTablet(context)`, `isDesktop(context)` | `BuildContext context` (helpers) | `MediaQuery.of(context).size.width` | — | — |
| 20_var_globales | `variables_globales.dart` | 30+ constantes UI + 40+ vars mutables top-level | `fontSizeMenuBar=14`, `iconSizeMenuBar=24`, `navBarHeight=60`, `socialAppBarHeight=56`, `cardPadding`, `boxHeightFiltros`, `boxHeightFiltrosColapsed`... + mutables: `selectMenuNivelGobierno`, `showFiltros`, `boolEstado`, `dondeEstoy`, `colorFondo`, `lcwc`... | — | — | — | — |
| 20_var_globales | `var_de_estilo_widgets.dart` | TextStyles + AppBar factories | `ButtonsTabBarLabelStyle`, `ButtonsTabBarUnselectedLabelStyle`, `tabBarTheme`, `appBarSecondPage(titulo)`, `appBarSecondPageBottons(titulo,TabBar)`, `appBarSecondPageActions(titulo,List<Widget>)` | `String titulo`, `TabBar`, `List<Widget> actions` | `appTheme` | — | `AppBar`, `TabBar`, `TextStyle` |
| 20_var_globales | `var_elementos_menus.dart` | 150+ instancias `ElementosMenus` | `ElementosMenus` (clase), `ElementoSeleccionado` (clase), listas por menú: `elementosMenuInicial[10]`, `elementosMenuPrincipal[8]`, `elementosMenuTipoPropiedad[6]`, `elementosMenuTipoEspacio[5]`, `elementosMenuTipoTransaccion[5]`, `elementosMenuTipoTransaccionSolid[5]`, `elementosMenuConocidos`, `elementosMenuGrupos`, `elementosMenuSolicitudes`, `elementosMenuUbicacion`, `elementosMenuNivelesGobierno`, `elementosMenuAcciones` | — | `Symbols` icons (rango 0xe000-0xe900) | — | — |
| 20_var_globales | `var_login.dart` | Constantes login | `appName="buscobien"`, `iconNoUser=Symbols.no_accounts`, `iconUser=Symbols.account_circle`, `userTooltip="Sin usuario"`, `loginPrimaryBrand=Color(0xFF415AA9)` | — | `Symbols` | — | — |
| 20_var_globales | `format_chat_timestamp.dart` | Función top-level | `formatChatTimestamp(String iso)` | `String iso` (ISO8601 UTC) | `DateTime.parse`, `DateTime.now()` | — | — |
| 20_var_globales | `couchdb_errors.dart` | Clase + Map | `CouchdbCodigo` (class), `codigoCouchDB` (Map<int, CouchdbCodigo>) | — | Códigos HTTP: 200,201,202,304,400,401,403,404,405,406,409,412,413,415,416,417,500,503 | `CouchdbCodigo` (code, es, en) | — |
| 20_var_globales | `ui_exceptions.dart` | Documentación excepción | `EXCEPCION_COLOR_ESPECIFICO` (comentario), referencia a `var_login.dart:loginPrimaryBrand` | — | — | — | — |

---

## Tabla 2: Elementos (por archivo)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| 20_var_globales | `var_color_themes.dart` | `appTheme` (mutable global), 18 `ColorScheme const` | — | — | — | `Color`, `Brightness` | — |
| 20_var_globales | `var_color_widget.dart` | 8 constantes breakpoints | — | — | `isMobile(context)`, `isTablet(context)`, `isDesktop(context)` | `MediaQuery.of(context).size.width` | — |
| 20_var_globales | `variables_globales.dart` | 30+ `const` UI + 40+ `var` mutables top-level | — | — | — | — | — |
| 20_var_globales | `var_de_estilo_widgets.dart` | 2 `TextStyle` factories, 1 `TabBarThemeData`, 3 `AppBar` factories | — | — | `ButtonsTabBarLabelStyle`, `ButtonsTabBarUnselectedLabelStyle`, `tabBarTheme`, `appBarSecondPage(titulo)`, `appBarSecondPageBottons(titulo, tabBar)`, `appBarSecondPageActions(titulo, actions)` | `appTheme` | `AppBar`, `TabBar`, `TextStyle`, `WidgetStateTextStyle.resolveWith`, `WidgetStateProperty.resolveWith` |
| 20_var_globales | `var_elementos_menus.dart` | 12+ listas `List<ElementosMenus>` (500+ líneas) | `ElementosMenus`, `ElementoSeleccionado` | `ElementosMenus`: `etiqueta`, `icono`; `ElementoSeleccionado`: `etiqueta`, `icono`, `boolSeleccionado` | Constructor | `Symbols` | — |
| 20_var_globales | `var_login.dart` | 5 constantes | — | — | — | `Symbols`, `Color` | — |
| 20_var_globales | `format_chat_timestamp.dart` | — | — | — | `formatChatTimestamp(String iso) → String` | `DateTime.parse`, `DateTime.now()` | `Duration`, `DateTime` |
| 20_var_globales | `couchdb_errors.dart` | `codigoCouchDB` (Map<int, CouchdbCodigo> con 19 entradas) | `CouchdbCodigo` | `code: int`, `descripcionES: String`, `descripcionEN: String` | Constructor, `toString()` | — | — |
| 20_var_globales | `ui_exceptions.dart` | Comentario documentación `EXCEPCION_COLOR_ESPECIFICO` | — | — | — | — | — |

---

## Notas

- **9 archivos totales**: todos son configuración global (sin UI, sin lógica de negocio).
- **`appTheme` es variable MUTABLE global** (`var appTheme = lightPAN`) — el cambio de tema via `coloresProvider` muta esta variable; widgets que leen `appTheme` en `build()` reconstruyen con nuevos colores. **No es reactivo por sí solo** (no usa Riverpod/ChangeNotifier).
- **Breakpoints M3 estándar**: alineados con Material 3 (xSmall <600, Small 600-903, Medium 904-1239, Large 1240-1439, XLarge >1440). Helpers `isMobile/isTablet/isDesktop` usan `MediaQuery`.
- **`var_elementos_menus.dart` (500+ líneas)**: define 12+ listas de menús con `ElementosMenus(etiqueta, Symbols.icono)`. Icons en rango `0xe000-0xe900` (Material Symbols estándar, NO `_outlined` que usan `0xee00+`).
- **`variables_globales.dart` — DEUDA TÉCNICA CRÍTICA**: 40+ variables `var` mutables top-level (`selectMenuNivelGobierno`, `showFiltros`, `boolEstado`, `dondeEstoy`, `colorFondo`, `lcwc`, etc.) crean **estado global implícito compartido** entre widgets — fuente de bugs sutiles de race condition y dependencias ocultas. Candidatas a migración a providers Riverpod.
- **`var_de_estilo_widgets.dart`**: factories de `AppBar` (`appBarSecondPage*`) y `TextStyle` para tabs — usado extensivamente en `05_provider_menus` SliverAppBars.
- **`formatChatTimestamp`**: "HH:MM" (hoy), "ayer HH:MM", "DD/MM HH:MM" (otros) — fallback `""` en error parse.
- **`couchdb_errors.dart`**: 19 códigos HTTP CouchDB mapeados a ES/EN via `CouchdbCodigo` — usado en providers para mensajes de error user-friendly.
- **`ui_exceptions.dart`**: documenta la **única excepción** permitida a "NO Colors.xxx hardcoded": `loginPrimaryBrand = Color(0xFF415AA9)` en `var_login.dart` (comentario `// EXCEPCION_COLOR_ESPECIFICO` con fecha 2026-07-13).
- **`var_login.dart`**: `appName`, icons login, `loginPrimaryBrand` (la excepción).
- **No tests** de breakpoints, format timestamp, ni error codes.

## Deuda Técnica Crítica

1. **40+ variables mutables top-level en `variables_globales.dart`** — estado global implícito → migrar a providers Riverpod.
2. **`appTheme` mutable global** — cambio no reactivo per se; funciona porque widgets leen en `build()`, pero no notifica listeners.
3. **`var_elementos_menus.dart` 500+ líneas hardcoded** — menús como datos fijos, no configurables (A/B testing, i18n difícil).
4. **`var_de_estilo_widgets.dart` factories** — útiles pero acoplan estilo a este archivo; considerar `ThemeExtension` M3.