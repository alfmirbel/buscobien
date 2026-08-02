# SDD - 20_var_globales
**Directorio:** `lib/20_var_globales`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `var_color_themes.dart`, `var_login.dart`, `var_*globales*` (ver directorio)
- **Providers:** No
- **Modelos:** No
- **Páginas/Rutas:** Consumido por toda la app
- **I/O externo:** No
- **Dependencias:** `flutter`, `material_symbols_icons`
- **Riesgos:** Variables globales pueden entrometer testing y concurrencia.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá exponer `appTheme` y tokens de color centralizados.

### REQ-UBI-002 — Ubiquitous
El sistema deberá proveer `appName`, `versionActual`, constantes de color y tipografía.

### REQ-EVT-001 — Event-Driven
Cuando cambia el tema, el sistema deberá reconstruir `MaterialApp` con nuevos tokens.

### REQ-UNW-001 — Unwanted
Si un token no está definido, entonces el sistema deberá usar fallback seguro sin crash.

### REQ-OPT-001 — Optional Feature
Donde el usuario cambie preferencias, el sistema deberá reflejar preferencias sin reiniciar la app.
