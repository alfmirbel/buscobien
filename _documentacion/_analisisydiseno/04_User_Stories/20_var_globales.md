# User Stories — Variables Globales, Temas M3 y Estilos Compartidos (20_var_globales)

**Directorio:** `lib/20_var_globales/`
**Archivos:** `couchdb_errors.dart`, `format_chat_timestamp.dart`, `ui_exceptions.dart`, `var_color_themes.dart`, `var_color_widget.dart`, `var_de_estilo_widgets.dart`, `var_elementos_menus.dart`, `var_login.dart`, `variables_globales.dart` — Total: 9 archivos `.dart`
**Fecha:** 2026-08-12
**Formato:** 3 C's (Card, Conversation, Confirmation)

---

## US-VAR-001: appTheme — Única Fuente de Color M3 (0 Hardcoded Colors)

**Card:**
Como **desarrollador de Buscobien**
Quiero **un solo `ColorScheme` global (`appTheme`) como única fuente de color para toda la UI**
Para **garantizar consistencia visual Material Design 3 en todas las plataformas y permitir cambio de tema runtime**

**Conversation:**
`var_color_themes.dart` define 18 `ColorScheme const` (9 light + 9 dark: INE, MC, MOR, PAN, PRD, PRI, PT, PVEM + `darkALL`) con 29 propiedades M3 cada uno. La variable global `var appTheme = lightPAN` es la **única** fuente de color permitida en la app. `coloresProvider` (en `04_provider`) al seleccionar un tema muta `appTheme = temaSeleccionado[index]`; todos los widgets que leen `appTheme.primary`, `appTheme.surface`, etc. en su `build()` reconstruyen con los nuevos colores. `ui_exceptions.dart` documenta la **única excepción**: `loginPrimaryBrand = Color(0xFF415AA9)` en `var_login.dart` (para branding login específico). Lint configurado para detectar `Colors.xxx` y `Color(0xFF...)` hardcoded.

**Confirmation:**
- [ ] `appTheme` (variable global mutable) es la única fuente de color en toda la app
- [ ] 18 `ColorScheme const` predefinidos: 9 light + 9 dark (INE, MC, MOR, PAN, PRD, PRI, PT, PVEM, ALL)
- [ ] Cada `ColorScheme` tiene 29 propiedades M3 (primary, onPrimary, primaryContainer, onPrimaryContainer, secondary, ..., outlineVariant, scrim)
- [ ] Cambio de tema via `coloresProvider` → `appTheme = nuevoTema` → widgets reconstruyen con nuevos colores
- [ ] `flutter analyze` reporta 0 warnings de colores hardcoded (con excepción documentada)
- [ ] `ui_exceptions.dart` registra `loginPrimaryBrand` como única excepción (fecha 2026-07-13)
- [ ] NO hay `Colors.blue`, `Colors.red`, `Color(0xFF...)` en código de widgets (verificado por grep)

---

## US-VAR-002: Breakpoints Responsivos M3 Estándar + Helpers

**Card:**
Como **desarrollador construyendo layouts adaptativos**
Quiero **breakpoints M3 estándar + helpers `isMobile/isTablet/isDesktop(context)`**
Para **adaptar grids, navegación y tamaños a móvil/tablet/desktop sin magic numbers**

**Conversation:**
`var_color_widget.dart` define 8 constantes breakpoints alineados con Material 3: `xSmallScreenMax=599`, `smallScreenMin=600`, `smallScreenMax=903`, `mediumScreenMin=904`, `mediumScreenMax=1239`, `largeScreenMin=1240`, `largeScreenMax=1439`, `desktopContentMaxWidth=1280`. Tres helpers top-level: `isMobile(context)` (width < 600), `isTablet(context)` (600 <= width < 1240), `isDesktop(context)` (width >= 1240). Usados extensivamente: grids responsive (1/2/3 columnas), `NavigationBar` vs `NavigationRail`, `SliverAppBar` pinned/floating, `fontSizeMenuBar` escalado, `Wrap` vs `Row`.

**Confirmation:**
- [ ] `isMobile(context)` → true si `MediaQuery.width < 600`
- [ ] `isTablet(context)` → true si `600 <= width < 1240`
- [ ] `isDesktop(context)` → true si `width >= 1240`
- [ ] Breakpoints constantes: xSmall=599, SmallMin=600, SmallMax=903, MediumMin=904, MediumMax=1239, LargeMin=1240, LargeMax=1439
- [ ] `desktopContentMaxWidth=1280` limita contenido en desktop ancho
- [ ] Grid propiedades: 1 col (mobile), 2 col (tablet), 3 col (desktop) via helpers
- [ ] `NavigationBar` en mobile, `NavigationRail` en desktop via `isDesktop`
- [ ] `SliverAppBar.pinned` en mobile, `floating` en desktop via helpers
- [ ] Sin `MediaQuery.of(context).size.width < 600` hardcoded en widgets (usa helpers)

---

## US-VAR-003: 150+ Elementos de Menú con Symbols Icons (Rango 0xe000-0xe900)

**Card:**
Como **desarrollador implementando navegación**
Quiero **items de menú predefinidos con etiqueta + Symbols icon consistentes**
Para **no buscar/calcular iconos en cada pantalla y mantener coherencia visual M3**

**Conversation:**
`var_elementos_menus.dart` (500+ líneas) define clase `ElementosMenus(etiqueta, icono)` y 12+ listas organizadas por menú: `elementosMenuInicial[10]` (Inicio, Ver Propiedades, Ubicación, Mi Cuenta, Perfil...), `elementosMenuPrincipal[8]` (Todas, Casas, Departamentos, Otros...), `elementosMenuTipoPropiedad[6]`, `elementosMenuTipoEspacio[5]`, `elementosMenuTipoTransaccion[5]`, `elementosMenuTipoTransaccionSolid[5]`, `elementosMenuConocidos`, `elementosMenuGrupos`, `elementosMenuSolicitudes`, `elementosMenuUbicacion`, `elementosMenuNivelesGobierno`, `elementosMenuAcciones`. Todos los iconos son `Symbols.xxx` (Material Symbols) en rango Unicode `0xe000-0xe900` — **NO** se usan variantes `_outlined` (`0xee00+`) que no renderizan en Web/WASM. Consumidos por providers de menú (`05_provider_menus`) y `ButtonsTabBar`.

**Confirmation:**
- [ ] `ElementosMenus` clase con `etiqueta: String`, `icono: IconData`
- [ ] 12+ listas por menú: Inicial, Principal, TipoPropiedad, TipoEspacio, TipoTransacción, Conocidos, Grupos, Solicitudes, Ubicación, NivelesGobierno, Acciones
- [ ] Total 150+ instancias `ElementosMenus`
- [ ] Icons `Symbols.xxx` en rango `0xe000-0xe900` (Material Symbols estándar)
- [ ] **NO** hay `Icons.xxx` (Material Icons clásico) ni `Symbols.xxx_outlined` (`0xee00+`)
- [ ] Consumidos por `menuInicialProvider`...`menuTuCuentaUsuarioProvider` via `elementosMenuX[index].icono`
- [ ] `ButtonsTabBar` renderiza `Tab(icon: Icon(elemento.icono), text: elemento.etiqueta)`
- [ ] Cambio de icono = editar una línea en `var_elementos_menus.dart` (single source of truth)

---

## US-VAR-004: Constantes UI Globales (30+ Dimensiones) + AppBar Factories

**Card:**
Como **desarrollador estandarizando dimensiones y AppBars**
Quiero **constantes centrales para tamaños (navBarHeight=60, fontSizeMenuBar=14, etc.) + factories de AppBar consistentes**
Para **evitar magic numbers y repetir código de AppBar en 20+ pantallas**

**Conversation:**
`variables_globales.dart` expone 30+ `const double/int`: `fontSizeMenuBar=14`, `iconSizeMenuBar=24`, `navBarHeight=60`, `socialAppBarHeight=56`, `cardPadding`, `boxHeightFiltros`, `boxHeightFiltrosColapsed`, `dialogWidth`, `dialogMaxHeight`, `avatarSize`, `logoSize`, etc. `var_de_estilo_widgets.dart` provee 3 factories `AppBar`: `appBarSecondPage(titulo)` (estándar), `appBarSecondPageBottons(titulo, TabBar)` (con tab bar inferior), `appBarSecondPageActions(titulo, List<Widget> actions)` (con acciones custom). También `ButtonsTabBarLabelStyle`, `ButtonsTabBarUnselectedLabelStyle` (TextStyles para tabs) y `tabBarTheme` (TabBarThemeData con `appTheme`). Usados en `02_principal_screen`, `03_vistas`, `05_provider_menus`, `08_pantallas/*`.

**Confirmation:**
- [ ] 30+ constantes dimensiones UI en `variables_globales.dart` (todas `const`)
- [ ] `navBarHeight=60`, `socialAppBarHeight=56`, `fontSizeMenuBar=14`, `iconSizeMenuBar=24`
- [ ] `appBarSecondPage("Título")` → `AppBar` M3 estándar (elevation, backgroundColor=appTheme.surface, title style=appTheme.onSurface)
- [ ] `appBarSecondPageBottons("Título", tabBar)` → AppBar con `bottom: tabBar`
- [ ] `appBarSecondPageActions("Título", [IconButton, PopupMenuButton])` → AppBar con actions
- [ ] `ButtonsTabBarLabelStyle` / `UnselectedLabelStyle` usan `appTheme.primary` / `appTheme.onSurfaceVariant`
- [ ] `tabBarTheme` aplica indicatorColor=appTheme.primary, labelColor=appTheme.primary
- [ ] 20+ pantallas usan estas factories (no AppBars manuales repetidos)

---

## US-VAR-005: Formato Timestamp Chat + Códigos Error CouchDB ES/EN

**Card:**
Como **usuario viendo chat o desarrollador manejando errores**
Quiero **timestamps legibles ("15:30", "ayer 15:30", "12/08 15:30") + errores CouchDB en español**
Para **entender cuándo llegaron mensajes y qué significan errores de BD**

**Conversation:**
`format_chat_timestamp.dart` expone `formatChatTimestamp(String iso)` → parsea ISO8601 UTC, compara con `DateTime.now()`: si hoy → "HH:MM"; si ayer → "ayer HH:MM"; otro día → "DD/MM HH:MM"; error parse → `""` (fallback silencioso). Usado en `08_pantallas/tu_cuenta/conocidos/page_chat_privado.dart` y `page_chat_grupo.dart` para burbujas de mensaje. `couchdb_errors.dart` define `CouchdbCodigo(code, descripcionES, descripcionEN)` y `codigoCouchDB` Map con 19 entradas: 200/201/202/304 (éxito), 400/401/403/404/405/406/409/412/413/415/416/417 (cliente), 500/503 (servidor). Usado en providers para traducir HTTP status a mensaje user-friendly.

**Confirmation:**
- [ ] `formatChatTimestamp("2026-08-12T15:30:00Z")` hoy → "15:30"
- [ ] `formatChatTimestamp("2026-08-11T15:30:00Z")` ayer → "ayer 15:30"
- [ ] `formatChatTimestamp("2026-08-10T15:30:00Z")` otro → "10/08 15:30"
- [ ] Parse error (string inválido) → retorna `""` (no crashea)
- [ ] `codigoCouchDB[404].descripcionES` → "No encontrado"
- [ ] `codigoCouchDB[401].descripcionES` → "No autorizado"
- [ ] `codigoCouchDB[500].descripcionES` → "Error interno del servidor"
- [ ] 19 códigos: 200,201,202,304,400,401,403,404,405,406,409,412,413,415,416,417,500,503
- [ ] Usado en providers (`provider_me_gusta`, `provider_listas_*`, etc.) para SnackBar de error

---

## US-VAR-006: Excepción de Color Documentada y Controlada (loginPrimaryBrand)

**Card:**
Como **equipo de desarrollo/seguridad**
Quiero **una única excepción documentada y fechada a la regla "0 colores hardcoded"**
Para **permitir branding específico de login sin romper la gobernanza de colores**

**Conversation:**
`ui_exceptions.dart` registra la **única excepción** permitida: `loginPrimaryBrand = Color(0xFF415AA9)` definida en `var_login.dart` (usada en `dialogbox_login.dart` y `login_01_login_page.dart` para botones/acento del formulario de login). La excepción incluye comentario `// EXCEPCION_COLOR_ESPECIFICO` con fecha `2026-07-13`. El lint personalizado (o revisión manual en PR) permite SOLO este uso; cualquier otro `Colors.xxx` o `Color(0xFF...)` en widgets es flaggeado. Esto evita "exception creep" (añadir más excepciones sin control).

**Confirmation:**
- [ ] `ui_exceptions.dart` existe y documenta `EXCEPCION_COLOR_ESPECIFICO`
- [ ] `var_login.dart: loginPrimaryBrand = Color(0xFF415AA9)` (única excepción)
- [ ] Comentario `// EXCEPCION_COLOR_ESPECIFICO` con fecha `2026-07-13`
- [ ] Usado SOLO en `dialogbox_login.dart` y `login_01_login_page.dart` (form login)
- [ ] Lint/revisión PR rechaza cualquier otro `Colors.xxx` o `Color(0xFF...)` en widgets
- [ ] No hay otras excepciones registradas (auditado 2026-08-12)

---

## Notas

- Estas US reemplazan a US-VAR-001/002/003 consolidadas en `04_User_Stories/03_listas.md` con formato 3 C's completo (Conversation incluida) y añaden US-VAR-004, US-VAR-005, US-VAR-006.
- Complementan la Epic en `02_Epics_EARS/20_var_globales.md` y los escenarios Gherkin en `03_Features_BDD/20_var_globales/variables_globales_temas.feature`.
- Para detalles por archivo (9 archivos, 2 tablas + notas + deuda técnica): ver `05_Tareas_Inventarios/20_var_globales/elementos_20_var_globales.md`.

### Deuda Técnica Documentada (sin acción inmediata)

1. **`variables_globales.dart`**: 40+ `var` mutables top-level → estado global implícito compartido → migrar a providers Riverpod.
2. **`appTheme` mutable global**: no reactivo per se; funciona por lectura en `build()` pero no notifica.
3. **`var_elementos_menus.dart`**: 500+ líneas hardcoded → menús no configurables (i18n, A/B testing difícil).
4. **`var_de_estilo_widgets.dart` factories**: acoplan estilo a archivo; considerar `ThemeExtension` M3 para temas dinámicos.