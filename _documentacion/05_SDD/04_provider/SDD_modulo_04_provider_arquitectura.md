# SDD — Módulo `lib/04_provider` — Especificación de Arquitectura
## Especificación General del Módulo de Preferencias de Tema
**Módulo:** `lib/04_provider/`
**Versión:** 1.0
**Metodología:** EARS — Easy Approach to Requirements Syntax
**Fecha:** 2026-08-07

---

## 1. Inventario de Archivos del Módulo

| Archivo | Tipo | Rol |
|---|---|---|
| `pagina_colores.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Pantalla de selección de esquema de colores; renderiza 9 opciones con `Radio` buttons, actualiza `appTheme` globalmente |
| `provider_preferencias.dart` | Fuente — Riverpod `StateProvider` | Gestiona el estado de preferencia de color mediante `SelectColorProvider` (índice + etiqueta) |

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Aplican al módulo completo en todo momento mientras la pantalla de preferencias de colores esté activa.

**SDD-PRO-001**
El sistema deberá renderizar `PaginaColores` como pantalla de preferencias de tema, permitiendo al usuario seleccionar entre 9 esquemas de color predefinidos.

**SDD-PRO-002**
El sistema deberá gestionar el estado de preferencia de color exclusivamente mediante `coloresProvider`, un `StateProvider<SelectColorProvider>` que almacena el índice del tema seleccionado y su etiqueta descriptiva.

**SDD-PRO-003**
El sistema deberá actualizar la variable global `appTheme` (definida en `var_color_themes.dart`) cuando el usuario seleccione un nuevo esquema de colores, garantizando que toda la aplicación refleje el cambio inmediatamente.

**SDD-PRO-004**
El sistema deberá mantener la separación entre la lógica de estado (`provider_preferencias.dart`) y la presentación (`pagina_colores.dart`), sin mezclar responsabilidades de negocio en la capa de UI.

**SDD-PRO-005**
El sistema deberá garantizar que `PaginaColores` pueda recibir un parámetro `backpage` para identificar la pantalla de origen, aunque en la implementación actual este parámetro no se utilice para lógica de navegación.

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

**SDD-PRO-010**
Cuando `PaginaColores` se monte (`createState`), el sistema deberá ejecutar `debugPrintLevels` para registrar la creación del estado en modo debug.

**SDD-PRO-011**
Cuando el usuario presione cualquier `Radio` button de opción de color, el sistema deberá ejecutar `setState` para actualizar la UI local y modificar `coloresProvider` con el nuevo índice.

**SDD-PRO-012**
Cuando `coloresProvider` se actualice con un nuevo índice, el sistema deberá asignar `appTheme` al `ColorScheme` correspondiente:
- `0` → `lightINE` (Rosa)
- `1` → `lightMC` (Naranja)
- `2` → `lightMOR` (Guinda)
- `3` → `lightPAN` (Azul)
- `4` → `lightPRD` (Amarillo)
- `5` → `lightPRI` (Rojo)
- `6` → `lightPT` (Rojo Fuerte)
- `7` → `lightPVEM` (Verde)
- `8` → `darkINE` (Obscuro)

**SDD-PRO-013**
Cuando el usuario presione el botón "Regresar", el sistema deberá ejecutar `Navigator.of(context).pop()` para cerrar la pantalla de preferencias.

**SDD-PRO-014**
Cuando se renderice la `AppBar` de `PaginaColores`, el sistema deberá mostrar el título "Esquema de Colores" con `backgroundColor: appTheme.error`, `toolbarHeight: 40.0`, `elevation: 4` y `automaticallyImplyLeading: false`.

---

## 4. Requerimientos Controlados por Estados (State-Driven)

**SDD-PRO-020**
Mientras se renderiza `PaginaColores`, el sistema deberá mostrar un `Scaffold` con `backgroundColor: appTheme.surface` y un `SingleChildScrollView` con scroll vertical.

**SDD-PRO-021**
Mientras el usuario está en la pantalla de colores, el sistema deberá mostrar un texto "Selecciona el esquema de colores" centrado en color `appTheme.primary`, fuente bold, tamaño 16.

**SDD-PRO-022**
Mientras `coloresProvider.color` tenga un valor entre 0 y 8, el sistema deberá mostrar el `Radio` button correspondiente con `activeColor: appTheme.primary` y `groupValue` sincronizado con el estado del provider.

**SDD-PRO-023**
Mientras el usuario interactúa con los radio buttons, el sistema deberá mantener el foco en la opción seleccionada y actualizar visualmente el estado de los 9 radios sin recargar la pantalla.

**SDD-PRO-024**
Mientras se renderiza el botón "Regresar", el sistema deberá mostrar un `TextButton` con estilo `ElevatedButton.styleFrom(backgroundColor: appTheme.primary)` y texto en color `appTheme.onPrimary`.

**SDD-PRO-025**
Mientras `appTheme` cambie, el sistema deberá notificar a todos los widgets suscritos al `ColorScheme` para que se reconstruyan con los nuevos colores.

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-PRO-030**
Si el usuario presiona un radio button con `value` fuera del rango 0-8, entonces el sistema deberá ignorar el evento y no modificar `coloresProvider` ni `appTheme`.

**SDD-PRO-031**
Si `coloresProvider` retorna un valor de índice inválido (negativo o mayor a 8), entonces el sistema deberá fallback a `iniciaColor` (índice 0, "Rosa") para evitar crashes en la UI.

**SDD-PRO-032**
Si el usuario presiona el botón "Regresar" mientras la pantalla está en proceso de rebuild, entonces el sistema deberá ejecutar `Navigator.pop()` de forma segura sin lanzar excepciones de contexto.

**SDD-PRO-033**
Si `appTheme` es null o no está inicializado al momento de renderizar `PaginaColores`, entonces el sistema deberá usar `lightPAN` como fallback para evitar errores de null reference.

**SDD-PRO-034**
Si el parámetro `backpage` es null o vacío, entonces el sistema deberá renderizar la pantalla de todas formas sin afectar la lógica de selección de colores.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-PRO-040**
Donde el módulo `04_provider` incluya la pantalla de preferencias de colores, el sistema deberá exponer `coloresProvider` como un `StateProvider` global para que cualquier widget pueda leer el tema seleccionado mediante `ref.watch(coloresProvider)`.

**SDD-PRO-041**
Donde el usuario cambie el esquema de colores, el sistema deberá persistir la preferencia en `SharedPreferences` o `FlutterSecureStorage` para restaurarla en futuras sesiones.

> **Nota:** Esta funcionalidad no está implementada en la versión actual; el tema se resetea al valor por defecto al reiniciar la aplicación.

**SDD-PRO-042**
Donde `PaginaColores` se renderice en modo oscuro, el sistema deberá mostrar el radio button de "Obscuro" preseleccionado si `coloresProvider.color == 8`.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-PRO-050**
Mientras el usuario esté en `PaginaColores`, cuando presione un radio button de cualquier opción de color, el sistema deberá actualizar `coloresProvider` con el nuevo índice, asignar `appTheme` al `ColorScheme` correspondiente y notificar a todos los widgets suscritos para que se reconstruyan con el nuevo tema, todo dentro del mismo ciclo de `setState`.

**SDD-PRO-051**
Mientras el usuario esté en `PaginaColores` y presione "Regresar", cuando `Navigator.pop()` se ejecute, el sistema deberá retornar a la pantalla anterior preservando el tema seleccionado, sin resetear `coloresProvider` ni `appTheme`.

**SDD-PRO-052**
Mientras el usuario cambie el tema desde `PaginaColores`, cuando `appTheme` se actualice, el sistema deberá reflejar el cambio en tiempo real en la propia pantalla de preferencias (AppBar, botones, textos) sin necesidad de recargar la pantalla.

---

## 8. Diagrama de Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                    PaginaColores (build)                        │
│                                                                 │
│  ┌─────────────┐    ┌──────────────┐    ┌──────────────────┐  │
│  │ AppBar      │    │  Radio       │    │  Botón Regresar  │  │
│  │             │    │  Buttons     │    │                  │  │
│  │ - Título    │    │              │    │  - Navigator.pop │  │
│  │ - Fondo     │    │ - groupValue │    │                  │  │
│  │   error     │    │   desde      │    │                  │  │
│  │             │    │   coloresProv│    │                  │  │
│  │             │    │ - onChanged  │    │                  │  │
│  │             │    │   actualiza  │    │                  │  │
│  │             │    │   appTheme   │    │                  │  │
│  └─────────────┘    └──────────────┘    └──────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     coloresProvider           │
              │  ┌─────────────────────────┐  │
              │  │ SelectColorProvider     │  │
              │  │ color: int (0-8)        │  │
              │  │ etiqueta: String        │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     appTheme (global)         │
              │  ┌─────────────────────────┐  │
              │  │ lightINE  (Rosa)        │  │
              │  │ lightMC   (Naranja)     │  │
              │  │ lightMOR  (Guinda)      │  │
              │  │ lightPAN  (Azul)        │  │
              │  │ lightPRD  (Amarillo)    │  │
              │  │ lightPRI  (Rojo)        │  │
              │  │ lightPT   (Rojo Fuerte) │  │
              │  │ lightPVEM (Verde)       │  │
              │  │ darkINE   (Obscuro)     │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     Rebuild Global            │
              │  Todos los widgets usan       │
              │  appTheme.xxx se actualizan   │
              │  automáticamente              │
              └───────────────────────────────┘
```

---

## 9. Mapa de Correspondencia Elemento → Comportamiento

### Pantalla de Preferencias de Colores

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `PaginaColores` | `pagina_colores.dart` | `ConsumerStatefulWidget` que recibe `String backpage` |
| `AppBar` | `pagina_colores.dart` | Título "Esquema de Colores", fondo `appTheme.error`, texto `appTheme.onError`, toolbarHeight 40, elevation 4 |
| `Radio` buttons | `pagina_colores.dart` | 9 opciones (0-8), `groupValue` desde `coloresProvider`, `activeColor: appTheme.primary` |
| `onChanged` radio | `pagina_colores.dart` | Actualiza `coloresProvider.color` y asigna `appTheme` al tema correspondiente |
| Botón "Regresar" | `pagina_colores.dart` | `TextButton` con `Navigator.of(context).pop()` |
| Texto instrucción | `pagina_colores.dart` | "Selecciona el esquema de colores", centrado, `appTheme.primary`, bold, fontSize 16 |

### Provider de Preferencias

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `coloresProvider` | `provider_preferencias.dart` | `StateProvider<SelectColorProvider>` inicializado con `iniciaColor` |
| `SelectColorProvider` | `provider_preferencias.dart` | Clase con campos `color` (int) y `etiqueta` (String) |
| `iniciaColor` | `provider_preferencias.dart` | Valor inicial: `SelectColorProvider(0, "Rosa")` |

### Esquemas de Color Disponibles

| Índice | Nombre | Variable | Tema |
|---|---|---|---|
| 0 | Rosa | `lightINE` | `ColorScheme` claro |
| 1 | Naranja | `lightMC` | `ColorScheme` claro |
| 2 | Guinda | `lightMOR` | `ColorScheme` claro |
| 3 | Azul | `lightPAN` | `ColorScheme` claro |
| 4 | Amarillo | `lightPRD` | `ColorScheme` claro |
| 5 | Rojo | `lightPRI` | `ColorScheme` claro |
| 6 | Rojo Fuerte | `lightPT` | `ColorScheme` claro |
| 7 | Verde | `lightPVEM` | `ColorScheme` claro |
| 8 | Obscuro | `darkINE` | `ColorScheme` oscuro |

---

## 10. Decisiones de Diseño Documentadas

| ID | Decisión | Justificación |
|---|---|---|
| DD-01 | Uso de `StateProvider` en lugar de `NotifierProvider` | `coloresProvider` solo necesita almacenar un índice y una etiqueta; `StateProvider` es más simple y suficiente para este caso de uso |
| DD-02 | Variable global `appTheme` mutable | Permite que el cambio de tema sea global y reactivo sin necesidad de un provider anidado o contexto |
| DD-03 | 9 temas predefinidos en `var_color_themes.dart` | Centraliza todas las paletas de color en un solo archivo, facilitando mantenimiento y consistencia |
| DD-04 | `Radio` buttons nativos de Flutter | No requiere dependencias externas; proporciona accesibilidad built-in |
| DD-05 | `backpage` como parámetro sin uso | Se mantiene por compatibilidad de firma del constructor; podría utilizarse en el futuro para lógica de navegación condicional |
| DD-06 | AppBar con fondo `appTheme.error` | Proporciona un contraste visual fuerte para la pantalla de preferencias, diferenciándola de otras pantallas |
| DD-07 | `toolbarHeight: 40.0` | Altura reducida para la AppBar de preferencias, consistente con pantallas secundarias |
| DD-08 | `setState` + actualización directa de `appTheme` | Garantiza que la UI se actualice inmediatamente al cambiar el tema, sin esperar a que el provider notifique |
| DD-09 | Sin persistencia en versión actual | La preferencia de tema se resetea al cerrar la app; se registra como mejora futura en `SDD-PRO-041` |
| DD-10 | `ConsumerStatefulWidget` en lugar de `ConsumerWidget` | Se requiere `setState` para forzar el rebuild local al cambiar el tema |

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-07*
