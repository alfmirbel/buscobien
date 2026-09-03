# SDD — Módulo `lib/01_splash_screen` — Especificación de Arquitectura
## Especificación General del Módulo de Pantalla de Bienvenida
**Módulo:** `lib/01_splash_screen/`
**Versión:** 1.0
**Metodología:** EARS — Easy Approach to Requirements Syntax
**Fecha:** 2026-08-06

---

## 1. Inventario de Archivos del Módulo

| Archivo | Tipo | Rol |
|---|---|---|
| `splash_page.dart` | Fuente — Widget con Estado Reactivo (`ConsumerStatefulWidget`) | Controla el temporizador de duración mínima, la escucha reactiva de conectividad, la lógica de navegación y la composición visual del splash screen |
| `glass_objects.dart` | Fuente — Helpers de UI y Widgets Sin Estado | Construye el fondo con degradado, figuras flotantes con imágenes de propiedades y los contenedores de efecto glassmorphism (`GlassMorphismContainer2`, `GlassMorphismContainer`, `GlassBox`) |
| `versiones.dart` | Fuente — Modelo de Datos y Datos Estáticos | Define el modelo `AppVersion`, el historial `historialDeVersiones` y el getter `versionActual` para mostrar la versión en el splash |
| `inventario_01_splash_screen.md` | Documentación | Inventario técnico de componentes, análisis de flujo y arquitectura visual del módulo |

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Aplican al módulo completo en todo momento mientras el splash screen esté activo.

**SDD-SPL-001**
El sistema deberá renderizar `SplashPage` como pantalla de bienvenida inmediatamente cuando la aplicación se inicialice en la ruta `/`.

**SDD-SPL-002**
El sistema deberá mantener el estado del splash screen mediante `ConsumerStatefulWidget` y reactividad de Riverpod, garantizando inmutabilidad de las banderas `_isNavigating` y `_minDurationPassed`.

**SDD-SPL-003**
El sistema deberá separar estrictamente las responsabilidades del módulo en tres capas:
- **Navegación y ciclo de vida** (`splash_page.dart`): temporizador, conectividad, routing.
- **Visual y responsive** (`glass_objects.dart`): fondos, figuras flotantes, glassmorphism.
- **Datos de versión** (`versiones.dart`): modelo `AppVersion`, historial y versión actual.

**SDD-SPL-004**
El sistema deberá garantizar que ningún archivo del módulo `01_splash_screen` importe widgets o lógica de capas superiores de navegación (`02_principal_screen`, `08_pantallas`, etc.).

**SDD-SPL-005**
El sistema deberá mantener `SplashPage` sin parámetros posicionales muertos; toda la configuración de duración y destino deberá proveerse exclusivamente mediante parámetros nombrados (`required this.duration`, `required this.goToPage`).

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

**SDD-SPL-010**
Cuando el widget `SplashPage` se monte por primera vez (`initState`), el sistema deberá invocar `_startSplashTimer()` para disparar un `Future.delayed` de `widget.duration` segundos.

**SDD-SPL-011**
Cuando el temporizador de duración mínima finalice, el sistema deberá establecer `_minDurationPassed = true` mediante `setState` y ejecutar `_attemptNavigation()`.

**SDD-SPL-012**
Cuando el `ref.listen` de `checaConeccionesProvider` detecte un estado `data` con `etiqueta == "Conectado"`, el sistema deberá ejecutar `_attemptNavigation()`.

**SDD-SPL-013**
Cuando el `ref.listen` de `checaConeccionesProvider` detecte un estado `error`, el sistema deberá ejecutar `_navigateToErrorPage()`.

**SDD-SPL-014**
Cuando `_attemptNavigation()` evalúe que existe conexión (`etiqueta == "Conectado"`), el sistema deberá invocar `Navigator.pushReplacementNamed(context, AppRoutes.principal, arguments: "")` y establecer `_isNavigating = true`.

**SDD-SPL-015**
Cuando `_attemptNavigation()` evalúe que no existe conexión y `_minDurationPassed == true`, el sistema deberá invocar `_navigateToErrorPage()`.

**SDD-SPL-016**
Cuando `_navigateToErrorPage()` se ejecute, el sistema deberá invocar `Navigator.pushNamed(context, AppRoutes.sinconeccion, arguments: "No se detectó conexión a Internet.")`.

**SDD-SPL-017**
Cuando el post-frame callback (`addPostFrameCallback`) se ejecute tras el primer render, el sistema deberá invocar `setCheckPlataformaProvider(ref)` para detectar el sistema operativo del dispositivo en segundo plano.

**SDD-SPL-018**
Cuando el post-frame callback lea `checaConeccionesProvider` y detecte `etiqueta == "Conectado"`, el sistema deberá tener la capacidad de iniciar la carga de ubicación en segundo plano sin bloquear el splash screen.

---

## 4. Requerimientos Controlados por Estados (State-Driven)

**SDD-SPL-020**
Mientras `_minDurationPassed == false`, el sistema deberá impedir cualquier navegación automática desde el splash screen, incluso si el proveedor de conectividad emite `Conectado`.

**SDD-SPL-021**
Mientras `_isNavigating == true`, el sistema deberá ignorar todas las evaluaciones adicionales de navegación, tanto del temporizador como del listener reactivo, para evitar pantallas duplicadas.

**SDD-SPL-022**
Mientras el splash screen esté montado (`mounted == true`), el sistema deberá mantener activas las suscripciones a `checaConeccionesProvider` y el temporizador de duración mínima.

**SDD-SPL-023**
Mientras `screenWidth < smallScreenMin` (600.0 px), el sistema deberá aplicar un factor de escala `0.75` a las dimensiones de las figuras flotantes en `buildBackgroundShapes`.

**SDD-SPL-024**
Mientras el contenedor central de glassmorphism (`GlassMorphismContainer2`) se renderice, el sistema deberá mantener estáticos los textos de bienvenida, el logo `logobuscobientblanco.png`, el nombre `nombrebuscobientblanco.png` y el `CircularProgressIndicator`.

**SDD-SPL-025**
Mientras el splash screen esté visible, el sistema deberá mostrar el número de versión actual en la esquina inferior derecha con tamaño de fuente 10 y opacidad 0.8.

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-SPL-030**
Si el temporizador finaliza pero el widget no está montado (`!mounted`), entonces el sistema deberá abortar la evaluación de navegación y no ejecutar `setState` ni `Navigator`.

**SDD-SPL-031**
Si `_attemptNavigation()` es invocada mientras `_isNavigating == true`, entonces el sistema deberá retornar inmediatamente sin ejecutar `Navigator` ni modificar el estado.

**SDD-SPL-032**
Si `_navigateToErrorPage()` es invocada mientras el widget no está montado (`!mounted`), entonces el sistema deberá retornar inmediatamente sin ejecutar `Navigator`.

**SDD-SPL-033**
Si el proveedor `checaConeccionesProvider` emite un estado de carga (`loading`), entonces el sistema deberá ignorar el evento en el `ref.listen` y continuar mostrando el splash screen.

**SDD-SPL-034**
Si el usuario abre la aplicación en una pantalla cuyo ancho es menor a `smallScreenMin`, entonces el sistema no debe recortar ni desplazar el contenedor de glassmorphism central fuera de los límites visibles.

**SDD-SPL-035**
Si el parámetro posicional `int i` del constructor `SplashPage` es diferente de cero o no utilizado, entonces el sistema deberá ignorar su valor y no afectar la lógica de navegación.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-SPL-040**
Donde el módulo `01_splash_screen` incluya la pantalla de versión, el sistema deberá mostrar `versionActual` (derivado de `historialDeVersiones[0].version`) en la esquina inferior derecha del splash screen con `fontSize: 10` y `alpha: 0.8`.

**SDD-SPL-041**
Donde se disponga de imágenes de fondo de propiedades (`casa_comedor.jpeg`, `casa_estudio2.jpg`, `casa_jardin.jpeg`, `casa_pasillo.jpeg`, `casa_panoramica.jpg`), el sistema deberá aplicar un `ColorFilter.mode(Colors.black.withValues(alpha: 0.3), BlendMode.srcOver)` sobre cada imagen para atenuar el fondo.

**SDD-SPL-042**
Donde `GlassMorphismContainer2` se utilice, el sistema deberá exponer el parámetro opcional `blurStrength` (default `15.0`) para controlar la intensidad del desenfoque sin modificar la implementación interna.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-SPL-050**
Mientras `_minDurationPassed == true`, cuando el `ref.listen` detecte `Conectado`, el sistema deberá ejecutar `Navigator.pushReplacementNamed(context, AppRoutes.principal)` y establecer `_isNavigating = true`, impidiendo el retroceso con el botón atrás.

**SDD-SPL-051**
Mientras `_minDurationPassed == true`, cuando el `ref.listen` detecte un estado no conectado o `error`, el sistema deberá ejecutar `_navigateToErrorPage()` y establecer `_isNavigating = true`.

**SDD-SPL-052**
Mientras el temporizador esté activo (`_minDurationPassed == false`), cuando el estado de conexión cambie de conectado a desconectado, el sistema deberá posponer la navegación hasta que el temporizador finalice, evaluando el estado de conexión vigente en ese momento.

**SDD-SPL-053**
Mientras el contenedor de glassmorphism se renderiza con `screenWidth < smallScreenMin`, cuando se calculen las dimensiones de las figuras flotantes, el sistema deberá escalar todos los elementos a un 75% de su tamaño original manteniendo la legibilidad de los textos superpuestos sin recortes.

**SDD-SPL-054**
Mientras la pantalla esté en modo de depuración, cuando se evalúe la navegación, el sistema deberá mantener el flujo idéntico al modo release sin afectar la duración del temporizador ni la lógica de conectividad.

---

## 8. Diagrama de Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                      SplashPage (build)                         │
│                                                                 │
│  ┌─────────────┐    ┌──────────────┐    ┌──────────────────┐  │
│  │ Post-frame  │    │   Timer      │    │ ref.listen       │  │
│  │ callback    │    │   (duration) │    │ (checaConex...)  │  │
│  │             │    │              │    │                  │  │
│  │ setCheck... │    │ _minDuration  │    │ data: "Conectado"│  │
│  │ Provider    │    │ Passed=true  │    │ → _attemptNav()  │  │
│  └─────────────┘    └──────┬───────┘    │                  │  │
│                            │            │ error: → _navErr │  │
│                            ▼            └──────────────────┘  │
│                     ┌─────────────┐                             │
│                     │ _attemptNav │                             │
│                     │ igation()   │                             │
│                     └──────┬──────┘                             │
│                            │                                   │
│               ┌────────────┴────────────┐                      │
│               │                         │                      │
│        Conectado                     No Conectado               │
│               │                         │                      │
│               ▼                         ▼                      │
│   pushReplacementNamed           _navigateToErrorPage()        │
│   (AppRoutes.principal)          (AppRoutes.sinconeccion)       │
│               │                         │                      │
│               ▼                         ▼                      │
│        _isNavigating=true         _isNavigating=true            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     buildBackgroundShapes()   │
              │  ┌─────────────────────────┐  │
              │  │ LinearGradient fondo    │  │
              │  │ Figuras flotantes       │  │
              │  │ (casa_*.jpg/jpeg)       │  │
              │  │ GlassMorphismContainer2 │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │        versiones.dart         │
              │  historialDeVersiones[0]      │
              │  → versionActual → UI footer  │
              └───────────────────────────────┘
```

---

## 9. Mapa de Correspondencia Elemento → Comportamiento

### Pantalla y Elementos Visuales

| Elemento | Archivo | Comportamiento |
|---|---|---|
| Degradado de fondo oscuro | `glass_objects.dart` | Renderiza `LinearGradient` con `Colors.deepPurple.shade900`, `Colors.blue.shade900` y `Colors.purple.shade700` |
| Figuras flotantes (5 imágenes) | `glass_objects.dart` | Posiciona `Container` con `AssetImage` de propiedades y `ColorFilter` negro alpha 0.3 |
| Escala responsiva | `glass_objects.dart` | Aplica `factor = 0.75` cuando `screenWidth < smallScreenMin` (600.0 px) |
| Contenedor glassmorphism | `glass_objects.dart` | `GlassMorphismContainer2`: `ClipRRect` + `BackdropFilter` + `Colors.white30` + borde `Colors.white30` |
| Logo BuscoBien | `splash_page.dart` | `Image.asset("assets/images/logobuscobientblanco.png")` ancho 150 |
| Nombre BuscoBien | `splash_page.dart` | `Image.asset("assets/images/nombrebuscobientblanco.png")` ancho 300 |
| Textos de bienvenida | `splash_page.dart` | `_buildText()` con `Colors.white.withValues(alpha)` y tamaños 14–18 |
| Indicador de carga | `splash_page.dart` | `CircularProgressIndicator(color: Colors.white)` |
| Etiqueta demo | `splash_page.dart` | `_buildText("SITIO DE PRUEBAS Y DEMO", size: 16, alpha: 1)` |
| Versión actual | `splash_page.dart` | `_buildText("V.$versionActual", size: 10, alpha: 0.8)` en `Positioned(bottom: 20, right: 20)` |

### Lógica de Navegación

| Estado | Condición | Acción |
|---|---|---|
| Conectado | `_minDurationPassed == true` + `etiqueta == "Conectado"` | `pushReplacementNamed` → `AppRoutes.principal` |
| No conectado | `_minDurationPassed == true` + `etiqueta != "Conectado"` | `pushNamed` → `AppRoutes.sinconeccion` con mensaje de error |
| Error provider | `checaConeccionesProvider` emite `error` | `_navigateToErrorPage()` |
| Timer activo | `_minDurationPassed == false` | Sin navegación, espera activa |
| Ya navegando | `_isNavigating == true` | Ignora evaluaciones adicionales |

---

## 10. Decisiones de Diseño Documentadas

| ID | Decisión | Justificación |
|---|---|---|
| DD-01 | `pushReplacementNamed` para `principal` | Elimina el splash screen del historial; el usuario no puede regresar con el botón atrás, evitando bucles de navegación. |
| DD-02 | `pushNamed` para `sinconeccion` | Permite al usuario regresar al splash screen desde la pantalla de error para reintentar la conexión. |
| DD-03 | Uso de `ref.listen` en `build()` | Garantiza reactividad ante cambios de conectividad después del temporizador, permitiendo corrección automática de la ruta de navegación. |
| DD-04 | Bandera `_isNavigating` | Previene navegación duplicada cuando el timer y el listener reactivo se disparan en el mismo ciclo de eventos. |
| DD-05 | Post-frame callback para `setCheckPlataformaProvider` | Ejecuta la detección de OS sin bloquear el primer frame de renderizado del splash screen. |
| DD-06 | `versionActual` lee `historialDeVersiones[0]` | La versión más reciente siempre está al inicio de la lista; no requiere lógica adicional de índices. |
| DD-07 | `GlassMorphismContainer2` usa `Colors.white30` | Cumple con la regla del proyecto de no hardcodear colores personalizados; usa el color semitransparente blanco estándar del tema Material 3. |
| DD-08 | Parámetro `int i` en constructor sin uso | Parámetro posicional heredado de refactorizaciones previas; se mantiene por compatibilidad de firma pero no afecta la lógica. |

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-06*
