# Epic: Variables Globales, Temas M3 y Estilos Compartidos (20_var_globales)

**Directorio:** `lib\20_var_globales\`  
**Archivos:** `couchdb_errors.dart`, `format_chat_timestamp.dart`, `ui_exceptions.dart`, `var_color_themes.dart`, `var_color_widget.dart`, `var_de_estilo_widgets.dart`, `var_elementos_menus.dart`, `var_login.dart`, `variables_globales.dart`  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Consistencia visual M3 estricta (0 colores hardcoded) | Desarrollador | Una sola fuente de verdad `appTheme` (ColorScheme) + breakpoints responsivos + TextStyles + AppBar factories | 9 archivos de configuración global |
| | Usuario final | UI coherente en Web/WASM, Windows, Android, iOS con temas intercambiables | 18 ColorScheme predefinidos + selector runtime |
| | Sistema | Manejo estandarizado de errores CouchDB, timestamps chat, excepciones UI documentadas | Utilidades transversales |

---

## User Story Mapping

```
Desarrollador escribe widget
       │
       ▼
┌─────────────────────────────────────────────────────┐
│ Importa de lib\20_var_globales\                     │
│ - appTheme (ColorScheme activo)                     │
│ - breakpoints: isMobile/isTablet/isDesktop          │
│ - TextStyles: ButtonsTabBarLabelStyle, etc.         │
│ - AppBar factories: appBarSecondPage*               │
│ - Menús: 150+ ElementosMenus con Symbols icons      │
│ - Constantes UI: fontSizeMenuBar, navBarHeight...   │
│ - Excepciones color: ui_exceptions.dart (solo 1)    │
└──────────────┬──────────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────────────┐
│ Widget usa SOLO appTheme.xxx — NUNCA Colors.xxx     │
│ Responsive via var_color_widget.dart breakpoints    │
│ Iconos = Symbols.xxx (0xe000-0xe900)                │
└─────────────────────────────────────────────────────┘
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-VAR-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-VAR-001 | **Ubicuo** | El sistema expondrá `ColorScheme appTheme` como variable global **única** fuente de color para toda la UI (inicializada a `lightPAN`). | `lib\20_var_globales\var_color_themes.dart:63` | En código |
| REQ-VAR-002 | **Ubicuo** | El sistema definirá **18 ColorScheme const** (9 light + 9 dark): `lightINE/darkINE`, `lightMC/darkMC`, `lightMOR/darkMOR`, `lightPAN/darkPAN`, `lightPRD/darkPRD`, `lightPRI/darkPRI`, `lightPT/darkPT`, `lightPVEM/darkPVEM`, `darkALL` — cada uno con 29 propiedades M3. | `var_color_themes.dart:5-60` | En código |
| REQ-VAR-003 | **Ubicuo** | El sistema proveerá breakpoints responsivos M3 estándar: `xSmallScreenMax=599`, `smallScreenMin=600`, `smallScreenMax=903`, `mediumScreenMin=904`, `mediumScreenMax=1239`, `largeScreenMin=1240`, `largeScreenMax=1439`, `desktopContentMaxWidth=1280` + helpers `isMobile/isTablet/isDesktop(context)`. | `lib\20_var_globales\var_color_widget.dart:10-35` | En código |
| REQ-VAR-004 | **Ubicuo** | El sistema definirá ~30 constantes de dimensiones UI globales: `fontSizeMenuBar=14`, `iconSizeMenuBar=24`, `navBarHeight=60`, `socialAppBarHeight=56`, `cardPadding`, `boxHeightFiltros`, etc. | `lib\20_var_globales\variables_globales.dart:5-35` | En código |
| REQ-VAR-005 | **Estado** | Mientras `variables_globales.dart` tenga variables mutables top-level (`selectMenuNivelGobierno`, `showFiltros`, `boolEstado`...), el sistema **compartirá estado implícito** entre widgets (riesgo de bugs). | `variables_globales.dart:37-80` 40+ vars mutables | Deuda técnica |
| REQ-VAR-006 | **Ubicuo** | El sistema proveerá `TabBarThemeData tabBarTheme` y `TextStyle` factories (`ButtonsTabBarLabelStyle`, `ButtonsTabBarUnselectedLabelStyle`) para consistencia de tabs. | `var_de_estilo_widgets.dart:5-15`, `var_color_themes.dart:65-80` | En código |
| REQ-VAR-007 | **Ubicuo** | El sistema proveerá factories de `AppBar`: `appBarSecondPage(titulo)`, `appBarSecondPageBottons(titulo,TabBar)`, `appBarSecondPageActions(titulo,List<Widget>)`. | `var_de_estilo_widgets.dart:17-45` | En código |
| REQ-VAR-008 | **Ubicuo** | El sistema definirá **150+ instancias `ElementosMenus`** (etiqueta + Symbols icon) organizadas en listas por menú: Inicial (10), Principal (8), Tipo Propiedad (6), Tipo Espacio (5), Tipo Transacción (5+5 Solid), Conocidos, Grupos, Solicitudes, Ubicación, Niveles Gobierno, Acciones. | `lib\20_var_globales\var_elementos_menus.dart` (500+ líneas) | En código |
| REQ-VAR-009 | **Ubicuo** | El sistema proveerá `formatChatTimestamp(String iso)` → "HH:MM" (hoy), "ayer HH:MM", "DD/MM HH:MM" (otro), con fallback `""` en error. | `lib\20_var_globales\format_chat_timestamp.dart` | En código |
| REQ-VAR-010 | **Ubicuo** | El sistema mapeará **19 códigos HTTP CouchDB** a descripciones ES/EN via `CouchdbCodigo` (200,201,202,304,400,401,403,404,405,406,409,412,413,415,416,417,500,503). | `lib\20_var_globales\couchdb_errors.dart` | En código |
| REQ-VAR-011 | **No Deseado** | Si un widget use `Colors.blue` o `Color(0xFF...)` directo, el sistema **no** lo impedirá en compile-time (solo lint/documentación en `ui_exceptions.dart`). Excepción registrada: `loginPrimaryBrand = Color(0xFF415AA9)` para `var_login.dart`. | `ui_exceptions.dart` | Documentado |
| REQ-VAR-012 | **Opcional** | Donde se necesite branding login, el sistema usará `loginPrimaryBrand` (única excepción documentada 2026-07-13). | `var_login.dart:8`, `ui_exceptions.dart:10` | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `appTheme` global + 18 ColorScheme | `var_color_themes.dart` | 1-80 |
| Breakpoints + helpers responsive | `var_color_widget.dart` | 1-35 |
| 30+ constantes UI + 40+ vars mutables | `variables_globales.dart` | 1-80 |
| TextStyles + AppBar factories | `var_de_estilo_widgets.dart` | 1-50 |
| 150+ ElementosMenus (Symbols) | `var_elementos_menus.dart` | 1-550 |
| `formatChatTimestamp` | `format_chat_timestamp.dart` | 1-25 |
| CouchDB error codes ES/EN | `couchdb_errors.dart` | 1-60 |
| UI exceptions doc + loginPrimaryBrand | `ui_exceptions.dart` | 1-15 |
| `appName`, icons login | `var_login.dart` | 1-10 |

---

## Deuda Técnica Crítica

1. **40+ variables mutables top-level en `variables_globales.dart`**: Estado global implícito compartido — fuente de bugs sutiles. Deben migrarse a providers Riverpod.
2. **`var_elementos_menus.dart` 500+ líneas hardcoded**: Menús definidos como datos, no configurables. Dificulta A/B testing o localización.
3. **`appTheme` mutable global**: Cambio de tema via `coloresProvider` muta variable top-level — no reactivo por sí solo (funciona porque widgets leen `appTheme` en build).