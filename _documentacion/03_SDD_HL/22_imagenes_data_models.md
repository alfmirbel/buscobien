# SDD - 22_imagenes_data_models
**Directorio:** `lib/22_imagenes/data_models`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `image_file_structure.dart`, `data_find_propiedades.dart`, JSON locales asociados
- **Providers:** No
- **Modelos:** estructuras de foto/metadata, `DataFotosCasa`
- **Páginas/Rutas:** Consumido por upload/galería
- **I/O externo:** storage local, JSON
- **Dependencias:** `flutter`
- **Riesgos:** Estructura puede divergir de attachments reales.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá definir estructura de archivo imagen/metadata consistente.

### REQ-EVT-001 — Event-Driven
Cuando se guarda foto, el sistema deberá escribir metadata en storage local.

### REQ-UNW-001 — Unwanted
Si la estructura no coincide con backend, entonces el sistema deberá mapear y normalizar antes de subir.
