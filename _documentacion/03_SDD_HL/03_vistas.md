# SDD - 03_vistas
**Directorio:** `lib/03_vistas`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `pagina_asociaciones.dart, pagina_hospedaje.dart, pagina_inmobiliarias.dart, pagina_market.dart, pagina_promotores.dart, pagina_propietarios.dart, pagina_proveedores.dart, pagina_servicios.dart, pagina_usuarios.dart`
- **Providers:** `No`
- **Modelos:** `No`
- **Páginas/Rutas:** `Landing por perfil/rol`
- **I/O externo:** No
- **Dependencias:** flutter_riverpod
- **Riesgos:** 9 vistas estáticas; navegación depende de MenuOption + indices.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá ofrecer landing pages diferenciadas por perfil/rol.

### REQ-UBI-002 — Ubiquitous
El sistema deberá mapear 9 perfiles a su vista correspondiente.

### REQ-OPT-001 — Optional Feature
Donde el landing incluya fichas, el sistema deberá redirigir a la vista del perfil seleccionado.
