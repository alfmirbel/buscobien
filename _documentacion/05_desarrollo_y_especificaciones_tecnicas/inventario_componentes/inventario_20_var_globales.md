# Inventario de Componentes - Sección `var_globales` (D:\buscobien\lib\20_var_globales)

Este directorio actúa como el motor central de configuración y parametrización estática de toda la aplicación. No implementa interfaces visuales directamente, sino que define tokens de diseño, temas polícromos (claro y oscuro), umbrales de adaptabilidad de pantalla, mapeo de errores HTTP de bases de datos CouchDB, tipografías globales y descriptores de menús compartidos de manera unificada.

---

## Tabla de Inventario de Variables y Parámetros Globales

| Subdirectorio | Nombre del archivo | Tipo de componentes | Nombre del componente | Parámetros que requiere | Variables que utiliza (externas/globales) | Variables internas / Estado | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| N/A | `couchdb_errors.dart` | Clases de Datos / Colecciones Map y List | `CouchdbCodigo`, `codigoCouchDB`, `listaCodigosCouchDB`, `listaCodigosCouchDBEn` | Constructor clásico (`codigo`, `label`, `description`) | Ninguno | Mapeo de códigos de respuesta HTTP CouchDB (ej. `200`, `201`, `409`, `500`) en español e inglés | N/A |
| N/A | `var_color_themes.dart` | Colección de Esquemas de Colores (`ColorScheme`) | `appTheme`, `tabBarTheme`, esquemas de color polícromos (`lightPAN`, `darkPAN`, `lightINE`, `darkINE`, `lightMC`, `darkMC`, `lightMOR`, `darkMOR`, `lightPRD`, `darkPRD`, `lightPRI`, `darkPRI`, `lightPT`, `darkPT`, `lightPVEM`, `darkPVEM`, `darkALL`) | Ninguno | `ColorScheme` de Flutter | Dimensiones fijas de fichas (`widthFicha`, `heightFicha`) y esquemas de colores responsivos | N/A |
| N/A | `var_color_widget.dart` | Variables de Dimensionamiento / Funciones Helper | `screenWidth`, `screenHeight`, rangos de pantalla (`smallScreenMin`, `mediumScreenMin`, etc.), `isMobile`, `isTablet` | `context` (BuildContext) para funciones helper | `MediaQuery` de Flutter | Puntos de ruptura responsivos y cálculo rápido del factor de forma | N/A |
| N/A | `var_de_estilo_widgets.dart` | Estilos de Texto / Funciones Generadoras de AppBar | `ButtonsTabBarLabelStyle`, `ButtonsTabBarUnselectedLabelStyle`, `appBarSecondPage`, `appBarSecondPageBottons`, `appBarSecondPageActions` | `titulo` (String), `bottons` (TabBar), `accions` (List\<Widget\>) para constructores | `appTheme`, `menuTabLabelSize` | Estilos tipográficos reusables y configuradores rápidos de AppBar | `appTheme.primary`, `appTheme.onPrimary` |
| N/A | `var_elementos_menus.dart` | Clases de Datos / Instancias de Iconos y Menús | `ElementosMenus`, `ElementoSeleccionado`, y listado enorme de iconos estáticos (ej. `iconoCasas`, `iconoWiFi`, `elementosPlataforma`) | Constructor clásico | `Icons` de Flutter, `etiquetasMenuInicial` | Descriptores estáticos de texto e iconos para navegación, conectividad, gobierno y grupos | N/A |
| N/A | `var_login.dart` | Variables de Estado de Sesión Básicas | `appName`, `iconNoUser`, `iconUser`, `userTooltip` | Ninguno | `Icons` de Flutter | Constantes de soporte para el estado visual del usuario | N/A |
| N/A | `variables_globales.dart` | Constantes Numéricas / Flags Booleanos Globales | Constantes de tamaño, tipografías, paddings de tarjetas, flags de visibilidad de filtros | Ninguno | Ninguno | Múltiples variables globales de dimensiones (ej. `fontSizeCard`, `boxHeightFiltros`) y estados booleanos de filtros (ej. `boolEstado`, `showFiltros`) | N/A |

---

## Análisis Técnico y Decisiones de Arquitectura

1. **Tokens de Diseño Dinámicos Reutilizables:**
   * La aplicación implementa un diseño sumamente flexible mediante el objeto global `appTheme`. Este objeto no es una constante inmutable, sino una variable reasignable de tipo `ColorScheme` que puede tomar esquemas de color altamente especializados para diferentes identidades cromáticas o de marca política (ej. `lightPAN` azul, `lightINE` rosa magenta, `lightMOR` guinda, `lightPVEM` verde). Esto permite un cambio de marca en tiempo de ejecución extremadamente limpio.

2. **Adaptabilidad Responsiva Descentralizada (`var_color_widget.dart`):**
   * En lugar de anidar múltiples condicionales complejos en la interfaz visual, el archivo expone rangos de puntos de ruptura estandarizados en base a píxeles lógicos (ej. `smallScreenMin = 600.0`, `mediumScreenMin = 904.0`). Las funciones flecha inline `isMobile` y `isTablet` reducen drásticamente la verbosidad en el árbol de widgets:
     `width: isMobile(context) ? screenWidth : screenWidth * 0.7`

3. **Mapeo de Errores CouchDB Amigable (`couchdb_errors.dart`):**
   * Centraliza las excepciones arrojadas por la base de datos CouchDB. Al mapear el código de estado devuelto por el servidor HTTP (ej. `201`, `409`, `500`) con un objeto `CouchdbCodigo`, la UI puede renderizar de forma instantánea mensajes localizados explicativos en diálogos amigables para el usuario sin saturar la capa lógica de repositorios.
