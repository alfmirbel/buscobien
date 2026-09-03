# SDD - 22_imagenes
**Directorio:** `lib/22_imagenes`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `variables_imagenes.dart`, `inicio_fotos_usuario/...`, `tus_espacios_fotos_propiedad/...`
- **Providers:** `provider_get_fotos_ids_user_propiedad.dart`, `provider_get_lista_fotos_ordenadas.dart`
- **Modelos:** `DataFotosCasa`, `FotosOrden`, `ImageFileStructure`
- **Páginas/Rutas:** `/agregamultiplesfotos`, `/fotospropiedad`, `/fotospropiedadpaginada`, `/carouselfotospropiedad`
- **I/O externo:** CouchDB attachments, storage local, file_picker, http
- **Dependencias:** `flutter_riverpod`, `http`, `flutter_image_compress`, `image_picker`
- **Riesgos:** Compresión/fusión consume memoria; manejo de fotos huérfanas.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá permitir agregar múltiples fotos a una propiedad.

### REQ-UBI-002 — Ubiquitous
El sistema deberá proveer avatar y carouseles ordenados.

### REQ-EVT-001 — Event-Driven
Cuando el usuario selecciona imágenes, el sistema deberá comprimirlas antes de subir.

### REQ-EVT-002 — Event-Driven
Cuando se recuperan fotos, el sistema deberá ordenarlas usando `FotosOrden`.

### REQ-STATE-001 — State-Driven
Mientras la foto se sube, el sistema deberá mostrar placeholder shimmer.

### REQ-UNW-001 — Unwanted
Si la compresión falla, entonces el sistema deberá reintentar en background sin bloquear UI.

### REQ-CMP-001 — Complex
Mientras se agregan fotos, cuando el conjunto exceda memoria segura, el sistema deberá procesar en lotes reducidos.
