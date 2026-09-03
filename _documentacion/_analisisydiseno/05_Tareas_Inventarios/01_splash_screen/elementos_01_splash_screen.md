# Inventario de Componentes — 01_splash_screen

**Directorio:** `lib/01_splash_screen/`
**Archivos:** `splash_page.dart`, `glass_objects.dart`, `versiones.dart`
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo)

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| 01_splash_screen | `splash_page.dart` | ConsumerStatefulWidget | `SplashPage` | `int i` (no usado), `required int duration`, `required Widget goToPage` | `checaConeccionesProvider`, `appTheme`, `versiones.versionActual`, `ref` | `_isNavigating: bool`, `_minDurationPassed: bool` | `GlassMorphismContainer2`, `buildBackgroundShapes`, `appTheme`, `debugPrintLevels` |
| 01_splash_screen | `splash_page.dart` | ConsumerState | `_SplashPageState` | — | `ref`, `duration`, `goToPage`, `checaConeccionesProvider`, `versionActual` | `_isNavigating`, `_minDurationPassed` | — |
| 01_splash_screen | `glass_objects.dart` | Función top-level | `buildBackgroundShapes()` | `BuildContext context` | `screenWidth`, `screenHeight`, `factor` (local), 6 imágenes assets, `Colors.*`, `ImageFilter.blur` | `factor: double` (local) | `Positioned`, `Container`, `BackdropFilter`, `ClipRRect`, `AssetImage`, `DecorationImage` |
| 01_splash_screen | `glass_objects.dart` | StatelessWidget | `GlassMorphismContainer2` | `required double width`, `required double height`, `required Widget child`, `double borderRadius = 25.0`, `double blurStrength = 15.0` | `Colors.white30`, `BorderSide` | — | `BackdropFilter`, `ImageFilter.blur`, `ClipRRect`, `Container`, `BoxDecoration`, `Border.all` |
| 01_splash_screen | `glass_objects.dart` | StatelessWidget | `GlassMorphismContainer` | `required double width`, `required double height`, `required Widget child`, `double borderRadius = 16.0`, `double blurStrength = 15.0` | `LinearGradient`, `BorderSide`, `Colors.white` | — | `Stack`, `BackdropFilter`, `ImageFilter.blur`, `ClipRRect`, `SizedBox`, `Container`, `BoxDecoration` |
| 01_splash_screen | `glass_objects.dart` | StatelessWidget | `GlassBox` | `required double width`, `required double height`, `required Widget child` | `borderRadius: 30` (const), `sigmaX=15`, `sigmaY=15` (const), `Colors.white` | — | `BackdropFilter`, `ImageFilter.blur`, `ClipRRect`, `SizedBox`, `Stack`, `Container`, `BoxDecoration` |
| 01_splash_screen | `versiones.dart` | Clase modelo (const) | `AppVersion` | `required String version`, `required String titulo`, `required DateTime fecha`, `required List<String> cambios`, `bool esCritica = false` | — | `version`, `titulo`, `fecha`, `cambios`, `esCritica` (todos `final`) | — |
| 01_splash_screen | `versiones.dart` | Variable top-level | `historialDeVersiones` | — | — | — | — |
| 01_splash_screen | `versiones.dart` | Variable top-level (derivada) | `versionActual` | — | `historialDeVersiones[0].version` | — | — |

---

## Tabla 2: Elementos (por archivo)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| 01_splash_screen | `splash_page.dart` | — | `SplashPage` (ConsumerStatefulWidget) | `i`, `duration`, `goToPage` | `createState() → _SplashPageState` | `checaConeccionesProvider`, `appTheme`, `versionActual` | `GlassMorphismContainer2`, `buildBackgroundShapes`, `debugPrintLevels` |
| 01_splash_screen | `splash_page.dart` | — | `_SplashPageState` extends `ConsumerState<SplashPage>` | `_isNavigating: bool`, `_minDurationPassed: bool` | `initState()`, `_startSplashTimer()`, `_attemptNavigation()`, `_navigateToErrorPage()`, `build()` | `ref`, `duration`, `goToPage`, `checaConeccionesProvider`, `versionActual` | `Future.delayed`, `Navigator.pushReplacementNamed`, `AppRoutes.principal`, `AppRoutes.sinconeccion`, `debugPrintLevels` |
| 01_splash_screen | `glass_objects.dart` | `screenWidth`, `screenHeight` (globales, asignadas en `buildBackgroundShapes`), `factor: double` (local) | — | — | `buildBackgroundShapes(BuildContext)` | `MediaQuery.of(context).size`, `smallScreenMin` (de `var_color_widget.dart`) | `Stack`, `Positioned`, `Container`, `AssetImage`, `BackdropFilter`, `ImageFilter.blur`, `ClipRRect`, `Colors.*` |
| 01_splash_screen | `glass_objects.dart` | — | `GlassMorphismContainer2` (StatelessWidget) | `width`, `height`, `child`, `borderRadius`, `blurStrength` | `build()` | `ClipRRect`, `BackdropFilter`, `ImageFilter.blur`, `Container` | `BoxDecoration`, `Border.all`, `Colors.white30` |
| 01_splash_screen | `glass_objects.dart` | — | `GlassMorphismContainer` (StatelessWidget) | `width`, `height`, `child`, `borderRadius`, `blurStrength` | `build()` | `Colors.white` | `Stack`, `SizedBox`, `BackdropFilter`, `Container`, `BoxDecoration`, `LinearGradient`, `BorderSide` |
| 01_splash_screen | `glass_objects.dart` | — | `GlassBox` (StatelessWidget) | `width`, `height`, `child` | `build()` | `BorderRadius.circular(30)`, `sigmaX=15`, `sigmaY=15` | `ClipRRect`, `SizedBox`, `BackdropFilter`, `Container`, `BoxDecoration`, `LinearGradient` |
| 01_splash_screen | `versiones.dart` | `historialDeVersiones: List<AppVersion>`, `versionActual: String` | `AppVersion` | `version`, `titulo`, `fecha`, `cambios`, `esCritica` | (inmutable, solo getters) | — | — |

---

## Notas

- **Assets utilizados en `buildBackgroundShapes`** (6 imágenes, ruta `assets/images/`): `casa_comedor.jpeg`, `casa_estudio2.jpg`, `casa_jardin.jpeg`, `casa_pasillo.jpeg`, `casa_panoramica.jpg`.
- **Responsive factor:** `smallScreenMin` se importa desde `lib/20_var_globales/var_color_widget.dart` y determina `factor = 0.75` en pantallas chicas.
- **Patrón dual (timer + conectividad):** `_startSplashTimer()` usa `Future.delayed`; `ref.listen` sobre `checaConeccionesProvider` notifica reactivamente cambios de conectividad.
- **Gate timer:** `_minDurationPassed` evita navegación prematura incluso con conectividad inmediata.
- **Navegación salida:** `Navigator.pushReplacementNamed(AppRoutes.principal)` (no `push`) para limpiar back stack.
- **`versions.dart`:** `AppVersion` es `const` (inmutable); `historialDeVersiones` ordenado descendente (más reciente primero); `versionActual = historialDeVersiones[0].version`.
