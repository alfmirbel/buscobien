# SDD - 04_provider
**Directorio:** `lib/04_provider`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `pagina_colores.dart, provider_preferencias.dart`
- **Providers:** `provider_preferencias`
- **Modelos:** `Preferencias`
- **Páginas/Rutas:** `/preferencias -> PaginaColores`
- **I/O externo:** No
- **Dependencias:** flutter_riverpod
- **Riesgos:** Widgets con colores hardcodeados fuera de appTheme.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá exponer preferencias temáticas centralizadas.

### REQ-EVT-001 — Event-Driven
Cuando el usuario cambia un token visual, el sistema deberá notificar a los widgets suscritos.
