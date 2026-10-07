# Inventario de Componentes — main.dart

**Directorio:** `lib/` (raíz)
**Archivo:** `main.dart`
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo)

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| (raíz) | `main.dart` | Función entry point | `main()` | `--dart-define-from-file=defines.json` (ruta a credenciales externas) | `lcwc`, `navigatorKey` | — | — |
| (raíz) | `main.dart` | StatefulWidget root | `BuscoBienApp` | `super.key` | `navigatorKey`, `lcwc` | `_BuscoBienAppState` | `ThemeData(useMaterial3: true, colorScheme: appTheme...)`, `NavigationBarThemeData`, `iconTheme` |
| (raíz) | `main.dart` | State | `_BuscoBienAppState` | — | `navigatorKey` | `initState` callback | — |

---

## Tabla 2: Elementos (por archivo)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| (raíz) | `main.dart` | `navigatorKey: GlobalKey<NavigatorState>`, `lcwc: int = 0` | `BuscoBienApp` (StatefulWidget) | `key` | `createState() → _BuscoBienAppState` | — | `ProviderScope`, `MaterialApp`, `app_routes.routeGenerate`, `initDeepLinkHandler` |
| (raíz) | `main.dart` | — | `_BuscoBienAppState` extends `State<BuscoBienApp>` | — | `initState()`, `build()` | `navigatorKey`, `lcwc` | `WidgetsFlutterBinding.ensureInitialized()`, `setPathUrlStrategy()`, `SystemChrome.setPreferredOrientations()`, `initDeepLinkHandler()`, `debugPrintLevels()` |

---

## Notas

- `lcwc` es un contador debug global declarado en `lib/20_var_globales/variables_globales.dart` (no es un campo de la clase).
- `navigatorKey` es `final GlobalKey<NavigatorState>` a nivel de librería, compartido con `app_routes.dart` y `deep_link_handler.dart`.
- La orientación portrait-only se aplica vía `SystemChrome.setPreferredOrientations`.
- La estrategia de URL limpia (path, no hash) se activa en `main()` antes de `runApp()` vía `setPathUrlStrategy()`.
- El `theme` usa `appTheme` (ColorScheme global definido en `lib/20_var_globales/var_color_themes.dart`); el `colorScheme:` comentado en línea 57 está desactivado.
