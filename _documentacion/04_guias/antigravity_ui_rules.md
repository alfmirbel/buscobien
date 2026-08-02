_[ANTIGRAVITY RULES: MATERIAL DESIGN 3 & UI STANDARDS]_

**1. OBJETIVO PRINCIPAL**

Como asistente de desarrollo, tu objetivo en el Frontend es **preservar y potenciar el diseño existente**, nunca reescribirlo. Buscobien utiliza Material Design 3 (M3) de Flutter bajo una configuración de compilación web/WASM y móvil. Debes respetar estrictamente los archivos de variables globales y temas ya definidos por el usuario.

**2. LA REGLA DE ORO: CERO HARDCODING**

Todos lo elementos visuales (widgets) que generes deben cumplir de acuerdo con lo establecido en este documento, así como tener color y tamaño establecidos de acuerdo a las reglas y tipo de elemento.

Bajo ninguna circunstancia debes usar valores "duros" (hardcoded) para colores, tipografías o espaciados.

---

## 1. Estilos Globales:

Debes utilizar los estilos y variables globales definidos en los archivos del directorio \core_backend_services\20_var_globales según sean aplicables.

---

## 2. Esquema de colores appTheme como variable global:

El archivo \core_backend_services\20_var_globales\var_color_themes.dart, contiene el esquema de colores appTheme.
Usa appTheme para la asignación de colores.

La variable del ColorScheme appTheme es la única fuente que se utiliza para la asignación de colores a los widgets, siguiendo el estándar de Material Design 3.

---

## 3. Aplicación del esquema de colores:

Aplica rigurosamente el esquema de colores base, definidos en esta sección. Prohibido usar colores o tipografías "hardcodeadas".

### 3.1. Material Design 3 y Gestión de Color

#### Objetivo Principal

Revisar, auditar y refactorizar el código de la interfaz de usuario para que cumpla estrictamente con la semántica de roles de color de Material Design 3, descrita en la documentación oficial: https://m3.material.io/styles/color/roles.

#### Reglas de Implementación

1. **Uso Exclusivo de appTheme:**
   Todas las asignaciones de color en los componentes UI deben derivar obligatoriamente del esquema de colores definido en la variable ColorScheme`appTheme` (archivo \core_backend_services\20_var_globales\var_color_themes.dart).

2. **Prohibición de Colores Estáticos:**
   Queda estrictamente prohibido el uso de colores estáticos hardcodeados (ej. `Colors.red`, `Color(0xFF...)` o valores hexadecimales directos en los widgets). Cualquier color estático existente debe ser reemplazado por su equivalente semántico del `ColorScheme`.

3. **Mapeo Semántico Obligatorio (M3 Roles):**

**Guía de Reglas para la Paleta de Colores de Material 3 en Flutter**

En sistema Material 3 (M3) introduce **Roles de Color (Color Roles)**, un mapeo semántico que conecta los elementos de la interfaz de usuario (UI) con su función estructural y sus requisitos de accesibilidad.

Rglas arquitectónicas y técnicas para implementar correctamente la variable ColorScheme `appTheme`, dentro de `ThemeData` en Flutter basándose en la especificación oficial de M3.

---

## 4. Conceptos Universales y Semántica de Nomenclatura

Pilares semánticos del sistema de tokens de Material 3 (variables de `appTheme`):

- **`surface` (Superficie):** Utilizado para fondos generales del sistema y áreas grandes de bajo énfasis (ej. el fondo de la app o de un menú).
- **`primary`, `secondary`, `tertiary` (Colores de Acento):** Utilizados para enfatizar o desclasificar la importancia de los elementos en primer plano (_foreground_).
- **`container` (Contenedor):** Colores de relleno para componentes individuales (como botones o tarjetas). **Regla estricta:** Nunca deben usarse como color de texto o íconos pequeños por sí solos.
- **Prefijo `on...` (`onPrimary`, `onSurface`, etc.):** Colores destinados exclusivamente para texto e íconos que se posicionan _encima_ de su color padre correspondiente.
- **Sufijo `...Variant` (Variante):** Alternativas que ofrecen menor énfasis visual en comparación con su par no variante (ej. `outlineVariant` resalta menos que `outline`).

---

## 5. Clasificación y Reglas de Aplicación por Roles

### A. Roles de Acento (Énfasis y Acciones)

Determinan la jerarquía visual de las interacciones dentro de la aplicación.

| Rol de Color             | Uso y Semántica                                                                     | Componentes Típicos en Flutter                                                        |
| ------------------------ | ----------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| **`primary`**            | Alta prioridad. El color de marca principal y acciones críticas.                    | Botones principales (`ElevatedButton`), estados activos de `Switch` o `Checkbox`.     |
| **`onPrimary`**          | Texto/íconos sobre elementos `primary`.                                             | Texto dentro de un botón primario.                                                    |
| **`primaryContainer`**   | Relleno destacado que resalta contra el fondo pero tiene menos peso que `primary`.  | Botón de Acción Flotante (`FloatingActionButton`).                                    |
| **`onPrimaryContainer`** | Texto/íconos sobre `primaryContainer`.                                              | Ícono o etiqueta del `FloatingActionButton`.                                          |
| **`secondary`**          | Menor prominencia. Acciones secundarias o componentes cotidianos.                   | Chips de filtro (`FilterChip`), botones secundarios.                                  |
| **`secondaryContainer`** | Relleno para elementos recesivos o de soporte.                                      | Fondo de la pestaña o ícono seleccionado en una barra de navegación.                  |
| **`tertiary`**           | Acentos de contraste. Equilibra la paleta o dirige la atención a zonas específicas. | Indicadores de progreso, alertas internas, campos de entrada especiales.              |
| **`tertiaryContainer`**  | Relleno complementario para añadir expresión de color.                              | Fondos de campos de entrada (`InputDecorator`) o tarjetas destacadas de notificación. |

### B. Roles de Superficie y Contenedores Neutrales (Estructura)

Jerarquía basada en tonalidades de superficies.

- **`surface`**: Fondo predeterminado de la aplicación.
- **`onSurface`**: Texto principal y elementos estructurales interactivos sobre cualquier superficie.
- **`onSurfaceVariant`**: Texto secundario, descripciones cortas o elementos decorativos de bajo énfasis.

#### Los Niveles de Contenedores de Superficie

Variantes para estructurar layouts complejos, especialmente útiles en pantallas grandes (tabletas o escritorio):

1. **`surfaceContainerLowest`**: El nivel más bajo de énfasis (ej. el fondo detrás de una tarjeta en un tema claro).
2. **`surfaceContainerLow`**: Nivel bajo de énfasis.
3. **`surfaceContainer`**: El contenedor **por defecto** para componentes como barras de navegación inferiores (`NavigationBar`), menús desplegables y diálogos.
4. **`surfaceContainerHigh`**: Nivel alto de énfasis para destacar componentes de forma sutil.
5. **`surfaceContainerHighest`**: El nivel máximo de énfasis superficial antes de pasar a un color de acento.

> ⚠️ **Regla de Consistencia:** Las regiones de diseño (como la barra de navegación vs. el área del cuerpo) deben mantener exactamente los mismos roles de superficie independientemente del tamaño de la pantalla (móvil, tableta o escritorio).

### C. Roles de Estado de Error

- **`error` / `onError**`: Utilizado de forma exclusiva para comunicar alertas críticas, validaciones incorrectas o flujos destructivos (ej. texto de error en un `TextField`).
- **`errorContainer` / `onErrorContainer**`: Relleno de advertencia de gran tamaño (ej. el fondo de un banner de error).
- _Nota:_ Este grupo es estático por defecto; no cambia con el color dinámico del sistema operativo.

### D. Roles de Delineado (Bordes y Separadores)

- **`outline`**: Utilizado para límites estructurales importantes que requieren un contraste mínimo de 3:1 frente a la superficie. **Ejemplo:** El borde de un campo de texto deseleccionado o el contorno de un `OutlinedButton`.
- **`outlineVariant`**: Exclusivamente para elementos decorativos de menor jerarquía. **Ejemplo:** Líneas divisorias (`Divider`) o separadores de listas.

### E. Roles Inversos (Contrastes Agudos)

- **`inverseSurface` / `onInverseSurface`**: Invierten por completo la paleta del entorno para generar un impacto visual inmediato. Es el estándar para el fondo y texto de un **`SnackBar`**.
- **`inversePrimary`**: Acciones interactivas (como un botón de texto "Deshacer") ubicadas dentro de una superficie inversa.

---

## 6. Matriz de Combinaciones Correctas (Do's & Don'ts)

- **SÍ (Do):** Emparejar siempre los elementos según su jerarquía nativa. Si un contenedor usa `secondaryContainer`, su texto interno **debe** usar obligatoriamente `onSecondaryContainer`.
- **NO (Don't):** Nunca utilices un color `Container` (como `primaryContainer`) para pintar texto corrido o fuentes delgadas; usalo para rellenos sólidos, no trazos finos.
- **NO (Don't):** No uses `outline` para dibujar divisores de listas (`Divider`). Usa `outlineVariant`.
- **NO (Don't):** No uses `outlineVariant` para definir el borde de campos de entrada interactivas o botones.

### 6.1. Consumo Semántico en Widgets

Al construir componentes personalizados, evita usar colores planos (`Colors.blue`, `Colors.grey`).

1. **Regla de oro para iconos web:** Usar siempre iconos con codepoints en el rango clásico (`0xe000`–`0xe900`). Evitar iconos `_outlined` con codepoints en `0xee00+` o `0xef00+`.

#### Tarea a Ejecutar

1. Analiza el código objetivo proporcionado o relacionado con alguna instrucción.
2. Identifica cualquier desviación de las reglas de Material 3 mencionadas.
3. Devuelve el código refactorizado utilizando llamadas dinámicas al tema (ej. `appTheme.primary` y no `Theme.of(context).colorScheme.primary`).
4. Si detectas ambigüedad en qué rol de color asignar a un elemento particular, aplica la regla 60-30-10 de diseño y comenta tu decisión técnica.

### 6.2. Priorización de componentes y colores

Debes priorizar exclusivamente los componentes actualizados de Material 3.

- Botones: Usa FilledButton, FilledButton.tonal, OutlinedButton, ElevatedButton o TextButton. Nunca sugieras RaisedButton o botones depreciados.
- Navegación: Para barras inferiores usa NavigationBar (no BottomNavigationBar). Para navegación lateral en pantallas grandes (WASM/Escritorio) usa NavigationRail.
- Tarjetas y Contenedores: Las tarjetas (Card) deben usar los niveles de elevación de M3 o colores base como surfaceContainerLow a surfaceContainerHighest.
- Inputs: Los TextFormField deben mantener el diseño OutlineInputBorder estándar de la aplicación, utilizando los colores de validación nativos (colorScheme.error).

**4. INTEGRACIÓN DE VARIABLES GLOBALES**

Antes de proponer cualquier cambio en la interfaz gráfica, **debes localizar y leer los archivos de variables globales del usuario** (ej. appTheme, archivos de constantes de UI o paletas personalizadas).

- Si una pantalla existente tiene un estilo particular, clónalo visualmente usando las herramientas del tema, no intentes "mejorarlo" con rediseños genéricos no solicitados.

**5. RESPONSIVIDAD Y WASM**

La aplicación se compila para WebAssembly (WASM) y plataformas móviles.

- Evita errores de "Unbounded height/width". Envuelve listas dentro de vistas restringidas (ej. Expanded dentro de Column, o uso correcto de CustomScrollView / Slivers).
- Cuando construyas vistas con pestañas (Tabs), asegúrate de usar la librería buttons_tabbar si el usuario ya la ha implementado en la arquitectura original de contactos, o el TabBar nativo de M3, respetando el contenedor padre.

**6. SEPARACIÓN VISTA/ESTADO (RIVERPOD)**

- Las vistas son tontas (Dumb Views): La interfaz (Widget build) solo debe dedicarse a dibujar la pantalla basándose en el estado inmutable proporcionado por Riverpod.
- No incluyas lógica de negocio, validaciones complejas o formateo pesado dentro del árbol de widgets. Todo debe venir procesado desde los Notifiers o extensiones de los modelos Freezed.

**7. TAMAÑOS DE TEXTO POR TIPO DE WIDGET**

No uses valores hardcodeados para `fontSize`. Usa exclusivamente las variables globales definidas en `lib/20_var_globales/variables_globales.dart` y `lib/05_provider_menus/variables_menus.dart` según el tipo de widget.

### App interior (pantallas de propiedades, listas, grupos, localidades, formularios)

| Tipo de widget / contexto               | fontSize | Variable global                                     |
| --------------------------------------- | -------- | --------------------------------------------------- |
| Título de página o sección              | 14       | `fontSizeTituloPagina`                              |
| Subtítulo de página o sección           | 12       | `fontSizeSubtituloPagina`                           |
| Título de diálogo                       | 14       | `fontSizeDialogTitulo`                              |
| Campo o etiqueta en diálogo             | 12       | `fontSizeDialogCampo`                               |
| Texto cuerpo en tarjetas (denso)        | 11       | `fontSizeTextoCarta`                                |
| Texto genérico en tarjetas              | 12       | `fontSizeCard`                                      |
| Título en AppBar secundario             | 14       | Usar `appBarSecondPage()` o el mismo valor hardcode |
| Etiqueta de tab en AppBar               | 12       | `menuTabLabelSize` (vía `ButtonsTabBarLabelStyle`)  |
| Etiqueta de tab pequeña                 | 9        | `menuTabSmallLabelSize`                             |
| Etiqueta de NavigationBar               | 12       | `fontSizeMenuBar`                                   |
| Etiqueta de filtro / chip               | 11       | `textSizeFiltros`                                   |
| Texto de botón                          | 12-14    | Usar el menor que cumpla                            |
| Caption / metadata (fechas, contadores) | 10       | Sin global                                          |
| Texto de ayuda / hint / versión         | 8-10     | Sin global                                          |
| Banner de estado (precio, badge)        | 10       | `textSizeBanner` (constante local si existe)        |

### Landing pages promocionales (`lib/03_vistas/`)

| Tipo de widget / contexto | fontSize |
| ------------------------- | -------- |
| Título hero principal     | 36-42    |
| Nombre de sección         | 24-28    |
| Subtítulo hero            | 18       |
| Descripción / cuerpo      | 16       |
| Título de tarjeta         | 14-16    |
| Texto de tarjeta          | 12-14    |

### Reglas de aplicación

1. **Interior app primero**: Siempre prefiere las variables globales de `variables_globales.dart`. Hardcode solo si no existe variable y el contexto no está cubierto.
2. **Landing pages**: Los tamaños grandes (18+) no tienen variables globales. Hardcode permitido, mantén consistencia dentro de la misma landing.
3. **Diálogos**: `fontSizeDialogTitulo` (14) y `fontSizeDialogCampo` (12) son obligatorios en todos los diálogos sin excepción.
4. **No reutilices variables fuera de contexto**: No uses `fontSizeDialogCampo` para un subtítulo de página ni `fontSizeSubtituloPagina` para un campo de diálogo.
5. **Jerarquía visual mínima**: La diferencia entre niveles debe ser ≥ 2px (ej: título 14 → subtítulo 12 → cuerpo 10-11).
