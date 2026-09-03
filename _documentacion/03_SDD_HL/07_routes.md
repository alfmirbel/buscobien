# SDD - 07_routes
**Directorio:** `lib/07_routes`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `app_routes.dart, deep_link_handler.dart, pagina_route_error.dart, routes_parameters.dart`
- **Providers:** `No`
- **Modelos:** `No`
- **Páginas/Rutas:** `Ver AppRoutes y routeGenerate`
- **I/O externo:** Deep links
- **Dependencias:** app_links
- **Riesgos:** Rutas declaradas sin implementación visible: generadatapropiedades, generadatausuarios, generadatapromotores.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá definir constantes de ruta para todas las pantallas activas.

### REQ-UBI-002 — Ubiquitous
El sistema deberá proveer navegación tipada por argumentos modelados en routes_parameters.dart.

### REQ-EVT-001 — Event-Driven
Cuando se abre un deep link /cambioPassword, el sistema deberá navegar a PageCambioPassword con token y perfil.

### REQ-STATE-001 — State-Driven
Mientras la app esté en Web, el sistema deberá mantener URLs limpias con setPathUrlStrategy.

### REQ-UNW-001 — Unwanted
Si routeGenerate recibe una ruta no declarada, entonces el sistema deberá retornar null y evitar crash.

### REQ-CMP-001 — Complex
Mientras se navegue desde splash, cuando se cumplan condiciones de duración y red, el sistema deberá rutear a PrincipalSliversMenuInicial y no a HomeScreen.
