# SDD - 01_home
**Directorio:** `lib/01_home`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `home_state.dart, home_navigation_provider.dart, home_state.freezed.dart, home_navigation_provider.g.dart`
- **Providers:** `homeNavigationProvider`
- **Modelos:** `HomeState`
- **Páginas/Rutas:** `Consumido por PrincipalSliversMenuInicial`
- **I/O externo:** No
- **Dependencias:** flutter_riverpod, freezed, riverpod_annotation
- **Riesgos:** Estado global acoplado a UI; depende de setters manuales.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá exponer el estado de navegación principal por tabs/secciones.

### REQ-EVT-001 — Event-Driven
Cuando el usuario selecciona una sección, el sistema deberá actualizar el índice correspondiente en HomeState.

### REQ-STATE-001 — State-Driven
Mientras la app esté activa, el sistema deberá mantener versiones reactivas para forzar reconstrucción de UI.

### REQ-CMP-001 — Complex
Mientras homeNavigationProvider esté disponible, cuando el shell principal monte, el sistema deberá suscribirse a cambios paraScroll inmediato al inicio.

### REQ-UNW-001 — Unwanted
Si el estado queda en índices inconsistentes, entonces el sistema deberá permitir reinicio desde PrincipalSliversMenuInicial.
