# SDD - 01_splash_screen
**Directorio:** `lib/01_splash_screen`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `splash_page.dart, glass_objects.dart, versiones.dart`
- **Providers:** `No`
- **Modelos:** `No`
- **Páginas/Rutas:** `/, /splash -> SplashPage`
- **I/O externo:** connectivity_plus
- **Dependencias:** flutter_riverpod
- **Riesgos:** Inicialización de ubicación comentada; duración fija.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá mostrar branding, logo y versión durante el arranque en frío.

### REQ-UBI-002 — Ubiquitous
El sistema deberá bloquear orientación a portrait durante el splash.

### REQ-EVT-001 — Event-Driven
Cuando termina la duración mínima del splash, el sistema deberá intentar navegar al flujo principal.

### REQ-STATE-001 — State-Driven
Mientras no haya conexión, el sistema deberá dirigir al usuario a la pantalla sin conexión.

### REQ-CMP-001 — Complex
Mientras el splash esté activo, cuando la duración mínima pase y la red esté disponible, el sistema deberá hacer pushReplacementNamed a /principal.

### REQ-UNW-001 — Unwanted
Si el chequeo de conexión falla por excepción, entonces el sistema deberá evitar loop infinito y mostrar fallback.
