# SDD — Módulo 20_var_globales (BuscoBien)
## Especificación de Requerimientos (EARS)
**Directorio fuente:** `lib/20_var_globales`  
**Arquitectura:** Flutter + Material Design 3  
**Propósito:** Variables globales, temas de color, breakpoints responsivos, elementos de menú, estilos de widgets, excepciones UI, formatos de chat y catálogo de errores CouchDB

---

## 1. Requerimientos Ubicuos

### 1.1 Variables Globales de Estilo
- **REQ-VAR-001:** El sistema deberá exponer constantes de tamaño de fuente para títulos de página, subtítulos, botones, texto de cartas, AppBar, tarjetas, filtros, diálogos y barra de navegación.
- **REQ-VAR-002:** El sistema deberá exponer constantes de padding y altura para tarjetas, tiles, filtros y cajas de texto.
- **REQ-VAR-003:** El sistema deberá exponer variables globales de selección de menú, nivel de gobierno y barra de navegación.
- **REQ-VAR-004:** El sistema deberá exponer booleanos de filtros (`boolSector`, `boolEstado`, `boolMunicipio`, `boolLocalidad`, `boolPoder`, `boolGrupo`, `showFiltros`).

### 1.2 Variables de Dimensiones
- **REQ-VAR-005:** El sistema deberá calcular `heightFicha` como `widthFicha / 1.618` (proporción áurea).
- **REQ-VAR-006:** El sistema deberá calcular `heightFichaChica` como `widthFichaChica / 1.618`.
- **REQ-VAR-007:** El sistema deberá exponer `navBarHeight = 56.0` y `socialAppBarHeight = 40.0`.

### 1.3 Variables de Login
- **REQ-VAR-008:** El sistema deberá exponer el nombre de la aplicación `appName = "buscobien"`.
- **REQ-VAR-009:** El sistema deberá exponer iconos de usuario autenticado (`account_circle`) y no autenticado (`no_accounts`).

---

## 2. Requerimientos Controlados por Eventos

### 2.1 Tema de Color
- **REQ-TEMA-001:** Cuando el sistema carga la interfaz, el sistema deberá aplicar `lightPAN` como `ColorScheme` activo por defecto.
- **REQ-TEMA-002:** Cuando el usuario cambia a modo oscuro, el sistema deberá cambiar el `ColorScheme` activo a la variante oscura correspondiente de la marca seleccionada.
- **REQ-TEMA-003:** Cuando el usuario selecciona una marca política, el sistema deberá aplicar el `ColorScheme` correspondiente (INE, MC, MORENA, PRD, PRI, PT, PVEM, PAN).

### 2.2 Diseño Responsivo
- **REQ-RESP-001:** Cuando el sistema evalúa el ancho de pantalla, el sistema deberá clasificar el dispositivo como móvil si `width < 600`, tablet si `600 <= width < 904`, y desktop si `width >= 904`.
- **REQ-RESP-002:** Cuando el sistema detecta pantalla desktop, el sistema deberá limitar el ancho máximo del contenido a `desktopContentMaxWidth = 1280.0`.
- **REQ-RESP-003:** Cuando el sistema evalúa un ancho de 1920px, el sistema deberá clasificarlo como desktop y limitar el contenido a 1280px.

### 2.3 Elementos de Menú
- **REQ-MENU-001:** Cuando el sistema renderiza el menú principal, el sistema deberá mostrar las opciones: Inicio, Propiedades, Propietarios, Anfitriones, Promotores, Tienda, Servicios, Proveedores, Inmobiliarias.
- **REQ-MENU-002:** Cuando el sistema renderiza el submenú de tipo de propiedad, el sistema deberá mostrar: Casas, Departamentos, Oficinas, Locales, Terrenos, Otros.
- **REQ-MENU-003:** Cuando el sistema renderiza el submenú de transacciones, el sistema deberá mostrar: Todas, Venta, Renta, Venta/Renta, Traspaso.
- **REQ-MENU-004:** Cuando el sistema renderiza el submenú de Mi Cuenta, el sistema deberá mostrar: Mis Espacios, Mis Listas, Mis Grupos, Mis Conocidos.
- **REQ-MENU-005:** Cuando el sistema renderiza el submenú de solicitudes, el sistema deberá mostrar: Solicitudes a Grupos, Invitaciones de Grupos, Solicitudes, Invitaciones.
- **REQ-MENU-006:** Cuando el sistema evalúa la conectividad, el sistema deberá mostrar "Conectado" con icono `wifi` o "Sin conexión" con icono `wifi_off`.

### 2.4 Formato de Chat
- **REQ-CHAT-001:** Cuando el sistema formatea una marca de tiempo de chat, el sistema deberá comparar la fecha del mensaje con la fecha actual.
- **REQ-CHAT-002:** Cuando el mensaje es del día actual, el sistema deberá mostrar solo la hora en formato `HH:MM`.
- **REQ-CHAT-003:** Cuando el mensaje es del día anterior, el sistema deberá mostrar `ayer HH:MM`.
- **REQ-CHAT-004:** Cuando el mensaje es de días anteriores, el sistema deberá mostrar `DD/MM HH:MM`.

### 2.5 Errores CouchDB
- **REQ-ERR-001:** Cuando el sistema recibe un código HTTP de CouchDB, el sistema deberá buscar el código en el catálogo `codigoCouchDB`.
- **REQ-ERR-002:** Cuando el código existe en el catálogo, el sistema deberá mostrar la etiqueta y descripción en español.
- **REQ-ERR-003:** Cuando el código no existe en el catálogo, el sistema deberá manejar el caso sin descripción disponible.

---

## 3. Requerimientos Controlados por Estados

### 3.1 Estado: Modo Claro
- **REQ-CLARO-001:** Mientras el sistema opera en modo claro, el sistema deberá aplicar un `ColorScheme` con `brightness: Brightness.light`.
- **REQ-CLARO-002:** Mientras el sistema opera en modo claro, el sistema deberá mostrar textos oscuros sobre fondos claros.

### 3.2 Estado: Modo Oscuro
- **REQ-OSCURO-001:** Mientras el sistema opera en modo oscuro, el sistema deberá aplicar un `ColorScheme` con `brightness: Brightness.dark`.
- **REQ-OSCURO-002:** Mientras el sistema opera en modo oscuro, el sistema deberá mostrar textos claros sobre fondos oscuros.

### 3.3 Estado: Pantalla Móvil
- **REQ-MOVIL-001:** Mientras el ancho de pantalla es menor a 600px, el sistema deberá considerar el dispositivo como móvil.
- **REQ-MOVIL-002:** Mientras el dispositivo es móvil, el sistema deberá mostrar la barra de navegación inferior (`NavigationBar`).

### 3.4 Estado: Pantalla Tablet
- **REQ-TABLET-001:** Mientras el ancho de pantalla está entre 600px y 903px, el sistema deberá considerar el dispositivo como tablet.
- **REQ-TABLET-002:** Mientras el dispositivo es tablet, el sistema deberá mostrar la navegación lateral (`NavigationRail`).

### 3.5 Estado: Pantalla Desktop
- **REQ-DESKTOP-001:** Mientras el ancho de pantalla es mayor o igual a 904px, el sistema deberá considerar el dispositivo como desktop.
- **REQ-DESKTOP-002:** Mientras el dispositivo es desktop, el sistema deberá limitar el contenido a 1280px de ancho máximo.
- **REQ-DESKTOP-003:** Mientras el dispositivo es desktop, el sistema deberá mostrar la navegación lateral (`NavigationRail`).

### 3.6 Estado: TabBar
- **REQ-TAB-001:** Mientras el usuario visualiza un TabBar, el sistema deberá mostrar la etiqueta seleccionada en `appTheme.onPrimary` con peso bold.
- **REQ-TAB-002:** Mientras el usuario visualiza un TabBar, el sistema deberá mostrar las etiquetas no seleccionadas en `appTheme.primary` con peso normal.
- **REQ-TAB-003:** Mientras el usuario visualiza un TabBar, el sistema deberá usar `TabBarIndicatorSize.tab` como tamaño del indicador.

---

## 4. Requerimientos de Comportamiento No Deseado

### 4.1 Errores de Formato
- **REQ-FAL-001:** Si la marca de tiempo ISO8601 tiene formato inválido, entonces el sistema deberá retornar una cadena vacía.
- **REQ-FAL-002:** Si la marca de tiempo es null o vacía, entonces el sistema deberá retornar una cadena vacía.

### 4.2 Errores de CouchDB
- **REQ-FAL-003:** Si el código HTTP recibido no existe en el catálogo `codigoCouchDB`, entonces el sistema deberá manejar el caso sin descripción.
- **REQ-FAL-004:** Si el servidor CouchDB no responde, entonces el sistema deberá mostrar un mensaje de error genérico.
- **REQ-FAL-005:** Si la respuesta HTTP tiene un código de error 500, entonces el sistema deberá mostrar "Código del servidor interno".
- **REQ-FAL-006:** Si la respuesta HTTP tiene un código de error 503, entonces el sistema deberá mostrar "Servicio no disponible".

### 4.3 Errores de Tema
- **REQ-FAL-007:** Si el tema activo no coincide con ninguna marca definida, entonces el sistema deberá aplicar `lightPAN` como fallback.
- **REQ-FAL-008:** Si el `ColorScheme` activo es null, entonces el sistema deberá aplicar `lightPAN` como fallback.

---

## 5. Requerimientos de Funciones Opcionales

### 5.1 Modo Oscuro
- **REQ-OPT-001:** Donde el usuario active el modo oscuro, el sistema deberá aplicar el `ColorScheme` oscuro correspondiente a la marca seleccionada.
- **REQ-OPT-002:** Donde el usuario seleccione una marca con variante oscura (INE, MC, MORENA, PRD, PRI, PT, PVEM, PAN), el sistema deberá aplicar dicha variante.

### 5.2 Personalización de Marca
- **REQ-OPT-003:** Donde el usuario seleccione una marca política, el sistema deberá aplicar el `ColorScheme` completo de esa marca incluyendo primary, secondary, tertiary, surface, error y sus variantes `on*`.
- **REQ-OPT-004:** Donde la aplicación requiera un color de branding específico fuera del `ColorScheme` estándar, el sistema deberá utilizar las excepciones registradas en `ui_exceptions.dart`.

### 5.3 Navegación Adaptativa
- **REQ-OPT-005:** Donde el dispositivo sea tablet o desktop, el sistema deberá mostrar `NavigationRail` en lugar de `NavigationBar`.
- **REQ-OPT-006:** Donde el dispositivo sea móvil, el sistema deberá mostrar `NavigationBar` en lugar de `NavigationRail`.

---

## 6. Requerimientos Complejos

### 6.1 Flujo de Tema y Marca
- **REQ-COM-001:** Mientras el usuario opera en modo claro, cuando selecciona la marca INE, entonces el sistema deberá aplicar `lightINE` como `ColorScheme` activo.

### 6.2 Flujo de Navegación Responsiva
- **REQ-COM-002:** Mientras el usuario cambia el tamaño de la ventana de la aplicación, cuando el ancho cruza el breakpoint de 904px, entonces el sistema deberá cambiar de `NavigationBar` a `NavigationRail` y limitar el contenido a 1280px.

### 6.3 Flujo de Formato de Chat
- **REQ-COM-003:** Mientras el usuario visualiza una conversación de chat, cuando el sistema procesa cada mensaje, entonces deberá comparar la fecha del mensaje con la fecha actual, mostrar `HH:MM` para hoy, `ayer HH:MM` para ayer, y `DD/MM HH:MM` para mensajes antiguos.

### 6.4 Flujo de Manejo de Errores CouchDB
- **REQ-COM-004:** Mientras el usuario realiza una operación que consulta CouchDB, cuando el servidor responde con un código HTTP, entonces el sistema deberá buscar el código en el catálogo, mostrar la etiqueta y descripción en español, o manejar el caso si el código no existe.

### 6.5 Flujo de AppBar Contextual
- **REQ-COM-005:** Mientras el usuario navega por pantallas secundarias, cuando el sistema renderiza un AppBar, entonces deberá aplicar el estilo correspondiente: `appBarSecondPage` para pantallas simples, `appBarSecondPageBottons` para pantallas con TabBar, o `appBarSecondPageActions` para pantallas con acciones personalizadas.

---

## 7. Modelos de Datos

### 7.1 ElementosMenus
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `etiqueta` | String | Texto visible del elemento de menú |
| `icono` | IconData | Icono Material Symbols asociado |

### 7.2 ElementoSeleccionado
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `index` | int | Índice del elemento seleccionado |
| `etiqueta` | String | Texto del elemento |
| `icono` | IconData | Icono del elemento |
| `buttonSelectOpcion` | List<bool> | Estados de selección de botones |

### 7.3 CouchdbCodigo
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `codigo` | int | Código HTTP |
| `label` | String | Etiqueta del código |
| `description` | String | Descripción detallada |

---

## 8. Temas de Color (ColorSchemes)

### 8.1 PAN (Partido Acción Nacional)
- `lightPAN`: primary `#415AA9`, surface `#E2E1EC`, onSurface `#000096`
- `darkPAN`: primary `#B5C4FF`, surface `#1B1B1F`, onSurface `#E4E2E6`

### 8.2 INE (Instituto Nacional Electoral)
- `lightINE`: primary `#BC004B`, surface `#FFFFFBFF`, onSurface `#201A1B`
- `darkINE`: primary `#FFB2BE`, surface `#201A1B`, onSurface `#ECE0E0`

### 8.3 MC (Movimiento Ciudadano)
- `lightMC`: primary `#954A00`, surface `#FFFFFBFF`, onSurface `#201A17`
- `darkMC`: primary `#FFB785`, surface `#201A17`, onSurface `#ECE0DA`

### 8.4 MORENA (Movimiento Regeneración Nacional)
- `lightMOR`: primary `#AD2D4B`, surface `#FFFFFBFF`, onSurface `#201A1B`
- `darkMOR`: primary `#FFB2BB`, surface `#201A1B`, onSurface `#ECE0E0`

### 8.5 PRD (Partido de la Revolución Democrática)
- `lightPRD`: primary `#775A00`, surface `#FFFFFBFF`, onSurface `#1E1B16`
- `darkPRD`: primary `#F6BF22`, surface `#1E1B16`, onSurface `#E9E1D9`

### 8.6 PRI (Partido Revolucionario Institucional)
- `lightPRI`: primary `#C00100`, surface `#FFFFFBFF`, onSurface `#201A19`
- `darkPRI`: primary `#FFB4A8`, surface `#201A19`, onSurface `#EDE0DD`

### 8.7 PT (Partido del Trabajo)
- `lightPT`: primary `#BF0028`, surface `#FFFFFBFF`, onSurface `#201A1A`
- `darkPT`: primary `#FFB3B1`, surface `#201A1A`, onSurface `#EDE0DF`

### 8.8 PVEM (Partido Verde Ecologista de México)
- `lightPVEM`: primary `#026E00`, surface `#FCFDF6`, onSurface `#1A1C18`
- `darkPVEM`: primary `#04E600`, surface `#1A1C18`, onSurface `#E2E3DC`

### 8.9 darkALL (Tema oscuro genérico)
- `darkALL`: primary `#373737`, surface `#1D1919`, onSurface `#EDECEC`

---

## 9. Breakpoints Responsivos

| Breakpoint | Valor | Clasificación |
|------------|-------|---------------|
| `xSmallScreenMax` | 599.0 | Móvil (xs) |
| `smallScreenMin` | 600.0 | Tablet (sm) |
| `smallScreenMax` | 903.0 | Tablet (sm) |
| `mediumScreenMin` | 904.0 | Desktop (md) |
| `mediumScreenMax` | 1239.0 | Desktop (md) |
| `largeScreenMin` | 1240.0 | Desktop (lg) |
| `largeScreenMax` | 1439.0 | Desktop (lg) |
| `desktopContentMaxWidth` | 1280.0 | Ancho máximo de contenido desktop |

### Funciones Helper
- `isMobileWidth(width)`: `width < 600`
- `isTabletWidth(width)`: `600 <= width < 904`
- `isDesktopWidth(width)`: `width >= 904`
- `isMobile(context)`: `screenWidth < 600`
- `isTablet(context)`: `screenWidth >= 600`

---

## 10. Variables Globales de Tamaño

### 10.1 Fuentes
| Variable | Valor | Uso |
|----------|-------|-----|
| `fontSizeTituloPagina` | 14 | Títulos de pantallas |
| `fontSizeSubtituloPagina` | 12 | Subtítulos |
| `fontSizeBotonPregunta` | 12 | Botones de pregunta |
| `fontSizeTextoCarta` | 11 | Texto de cartas/fichas |
| `textoSizeAppBar` | 18.0 | Título de AppBar |
| `fontSizeCard` | 12.0 | Texto de tarjetas |
| `fontSizeDialogTitulo` | 14 | Títulos de diálogos |
| `fontSizeDialogCampo` | 12 | Campos de diálogos |
| `fontSizeMenuBar` | 12.0 | Menú bar |
| `fontSizeTabLabelSize` | 12 | Etiquetas de TabBar |
| `textSizeFiltros` | 11.0 | Texto de filtros |
| `tamanoLetra` | 14 | Tamaño general de letra |

### 10.2 Alturas
| Variable | Valor | Uso |
|----------|-------|-----|
| `navBarHeight` | 56.0 | Barra de navegación inferior |
| `socialAppBarHeight` | 40.0 | AppBar de pantallas sociales |
| `boxHeightFiltros` | 32.0 | Altura de cajas de filtro |
| `boxHeightSeleccion` | 32.0 | Altura de cajas de selección |
| `textBoxHeight` | 30 | Altura de cajas de texto |
| `tabBarIndWeight` | 4.0 | Peso del indicador de TabBar |

### 10.3 Anchuras
| Variable | Valor | Uso |
|----------|-------|-----|
| `widthFicha` | 250 | Ancho de ficha PAN |
| `widthFichaChica` | 50 | Ancho de ficha chica |
| `boxWeigthFiltros` | 175.0 | Ancho de cajas de filtro |

### 10.4 Iconos
| Variable | Valor | Uso |
|----------|-------|-----|
| `iconSizeMenuBar` | 26.0 | Iconos de barra de menú |
| `iconSizeFiltros` | 18.0 | Iconos de filtros |
| `iconSizeAppBar` | 14 | Iconos de AppBar |

### 10.5 Padding
| Variable | Valor | Uso |
|----------|-------|-----|
| `cardPadding` | 6.0 | Padding de tarjetas |
| `paddingTile` | 12 | Padding de tiles |

---

## 11. Reglas de Excepción UI

- **REQ-EXC-001:** El sistema deberá prohibir el uso de colores tipográficos o estilos con literales directos (`Colors...`, `Color(0xFF...)`, `TextStyle(fontSize: ..., color: ...)`).
- **REQ-EXC-002:** El sistema deberá exigir que todo estilo pase por `appTheme`, variables globales o widgets helpers reutilizables.
- **REQ-EXC-003:** Donde la interfaz requiera un color específico por marca o contraste técnico indispensable, el sistema deberá permitir la excepción con comentario obligatorio: `EXCEPCION_COLOR_ESPECIFICO`, `ARCHIVO`, `FECHA`.
- **REQ-EXC-004:** Donde se registre una excepción, el sistema deberá incluirla en el catálogo de `ui_exceptions.dart`.
- **REQ-EXC-005:** El color `loginPrimaryBrand = Color(0xFF415AA9)` está registrado como excepción permitida para botones de login por branding institucional.

---

## 12. Formato de Chat

### 12.1 Reglas de Formato
- **REQ-CHAT-EST-001:** Mientras el mensaje es del día actual, el sistema deberá mostrar `HH:MM` con cero inicial.
- **REQ-CHAT-EST-002:** Mientras el mensaje es del día anterior, el sistema deberá mostrar `ayer HH:MM`.
- **REQ-CHAT-EST-003:** Mientras el mensaje es de días anteriores, el sistema deberá mostrar `DD/MM HH:MM` con cero inicial en día, mes, hora y minuto.

### 12.2 Manejo de Errores
- **REQ-CHAT-ERR-001:** Si la marca de tiempo no se puede parsear como ISO8601, entonces el sistema deberá retornar cadena vacía.
- **REQ-CHAT-ERR-002:** Si la marca de tiempo es null, entonces el sistema deberá retornar cadena vacía.

---

## 13. Catálogo de Errores CouchDB

| Código | Etiqueta (ES) | Descripción |
|--------|---------------|-------------|
| 200 | OK | Solicitud completada correctamente. |
| 201 | Creado | Documento creado con éxito. |
| 202 | Aceptado | Request aceptado, operación en segundo plano. |
| 304 | No modificado | Contenido no modificado. |
| 400 | Solicitud errónea | Mala estructura de la solicitud. |
| 401 | No autorizado | Autorización no proporcionada o inválida. |
| 403 | Prohibido | Artículo u operación prohibida. |
| 404 | No encontrado | Contenido solicitado no disponible. |
| 405 | Método no permitido | Tipo de solicitud HTTP inválido. |
| 409 | Conflicto | Conflicto de actualización. |
| 412 | Condición previa fallida | Headers del cliente y capacidades del servidor no coinciden. |
| 413 | Entidad demasiado grande | Documento supera límite de tamaño. |
| 415 | Tipo de medio no admitido | Content-type no compatible. |
| 416 | Rango solicitado no satisfactorio | Rango no puede ser satisfecho. |
| 417 | Expectativa fallida | Carga masiva falló. |
| 500 | Código del servidor interno | JSON inválido o información inválida. |
| 503 | Servicio no disponible | Servicio sobrecargado o en mantenimiento. |

---

## 14. Estructura de Archivos

```
lib/20_var_globales/
├── variables_globales.dart              # Constantes de tamaño, padding, alturas, anchuras, booleanos
├── var_color_themes.dart                # ColorSchemes por marca y modo (light/dark)
├── var_color_widget.dart                # Breakpoints responsivos y helpers de ancho
├── var_elementos_menus.dart             # Clases ElementosMenus y listas de menú
├── var_login.dart                       # Nombre de app, iconos de login
├── var_de_estilo_widgets.dart           # Estilos de AppBar y TabBar reutilizables
├── ui_exceptions.dart                   # Reglas y catálogo de excepciones UI
├── format_chat_timestamp.dart           # Formateador de marcas de tiempo de chat
└── couchdb_errors.dart                  # Catálogo de códigos de error HTTP CouchDB
```

---

## 15. Dependencias Técnicas

- **Flutter Material:** `ColorScheme`, `TextStyle`, `AppBar`, `TabBar`, `NavigationBar`, `NavigationRail`
- **Material Symbols Icons:** `package:material_symbols_icons/symbols.dart`
- **Geometría:** Proporción áurea (1.618) para cálculo de alturas de fichas

---

## 16. Reglas de Negocio

- **RN-001:** El tema activo por defecto es `lightPAN`.
- **RN-002:** La proporción de las fichas es áurea: `height = width / 1.618`.
- **RN-003:** El ancho máximo de contenido en desktop es 1280px.
- **RN-004:** Los breakpoints responsivos son: xs < 600, sm 600-903, md 904-1239, lg 1240-1439, xl >= 1440.
- **RN-005:** Los iconos del menú deben usar Material Symbols en rango `0xe000`–`0xe900`.
- **RN-006:** El formato de chat debe usar cero inicial en horas y minutos (`padLeft(2, '0')`).
- **RN-007:** Las excepciones de color UI deben estar registradas en `ui_exceptions.dart` con motivo, archivo y fecha.
- **RN-008:** El catálogo de errores CouchDB incluye códigos del 200 al 503 en español e inglés.
