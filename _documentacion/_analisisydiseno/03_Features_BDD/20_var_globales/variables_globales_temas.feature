# language: es
Característica: Variables Globales, Temas M3 y Estilos Compartidos

  Como desarrollador de Buscobien
  Quiero una única fuente de verdad para UI (colores, dimensiones, menús)
  Para garantizar consistencia visual M3 en toda la app

  Antecedentes:
    Dado que appTheme (ColorScheme) es variable global única en var_color_themes.dart
    Y 18 ColorScheme const predefinidos (9 light + 9 dark)
    Y breakpoints M3 estándar en var_color_widget.dart
    Y 150+ ElementosMenus con Symbols en var_elementos_menus.dart

  Escenario: Cambio de tema global reactivo
    Dado que coloresProvider actualiza appTheme = lightINE
    Cuando cualquier widget lee appTheme.primary
    Entonces obtiene color del nuevo tema (verde INE)
    Y reconstruye con nuevos colores M3

  Escenario: Breakpoints responsivos M3 estándar
    Dado que var_color_widget define xSmallScreenMax=599, smallScreenMin=600...
    Cuando isMobile(context) / isTablet(context) / isDesktop(context) se evalúan
    Entonces retornan true/false según MediaQuery.size
    Y layout se adapta (ej. grid 1/2/3 columnas)

  Escenario: 30+ constantes UI globales
    Dado que variables_globales.dart expone fontSizeMenuBar=14, navBarHeight=60...
    Cuando un widget usa fontSizeMenuBar
    Entonces obtiene valor consistente en toda la app

  Escenario: 150+ items de menú con Symbols icons
    Dado que var_elementos_menus.dart define listas por menú
    Cuando menuInicialProvider necesita iconos
    Entonces usa iconoInicio, iconoVerPropiedades, iconoUbicacion...
    Y Symbols.xxx (rango 0xe000-0xe900) — NO _outlined variants

  Escenario: AppBar factories consistentes
    Dado que var_de_estilo_widgets.dart provee appBarSecondPage(titulo)...
    Cuando una pantalla usa appBarSecondPage("Detalle")
    Entonces obtiene AppBar con estilo M3 estándar (elevation, colors, title)

  Escenario: Formato timestamp chat
    Dado que formatChatTimestamp("2026-08-12T15:30:00Z") se invoca
    Cuando es hoy
    Entonces retorna "15:30"
    Cuando es ayer
    Entonces retorna "ayer 15:30"
    Cuando es otro día
    Entonces retorna "12/08 15:30"

  Escenario: Códigos error CouchDB mapeados ES/EN
    Dado que codigoCouchDB[404] se consulta
    Cuando error 404 ocurre
    Entonces retorna CouchdbCodigo(404, "No encontrado", "Not Found")

  Escenario: Excepción color documentada (loginPrimaryBrand)
    Dado que ui_exceptions.dart registra Color(0xFF415AA9) para var_login.dart
    Cuando lint detecta Colors.xxx hardcoded
    Entonces SOLO esta excepción es permitida (con comentario // EXCEPCION_COLOR_ESPECIFICO)

  Escenario: 40+ variables mutables top-level (deuda técnica)
    Dado que variables_globales.dart tiene selectMenuNivelGobierno, showFiltros, boolEstado...
    Cuando múltiples widgets leen/escriben estas variables
    Entonces comparten estado implícito (riesgo bugs sutiles)