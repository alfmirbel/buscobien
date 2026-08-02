# SDD - 41_connectivity
**Directorio:** `lib/41_connectivity`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `connectivitycheck_provider.dart`, `pagina_sin_coneccion.dart`
- **Providers:** `checaConeccionesProvider`, `checaPlataformaProvider`
- **Modelos:** `ElementoDeConeccion`
- **Páginas/Rutas:** `/sinconeccion -> PaginaSinConeccion`
- **I/O externo:** `connectivity_plus`
- **Dependencias:** `flutter_riverpod`, `connectivity_plus`
- **Riesgos:** Reconexión puede disparar retry sin confirmación del usuario.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá monitorear conectividad en tiempo real.

### REQ-STATE-001 — State-Driven
Mientras no haya conexión, el sistema deberá mantener estado offline accesible.

### REQ-EVT-001 — Event-Driven
Cuando se restaura la conexión, el sistema deberá reintentar última operación fallida.

### REQ-UNW-001 — Unwanted
Si el stream de conectividad emite valores erróneos, entonces el sistema deberá mantener el último estado confiable.
