# SDD - 22_imagenes_tus_espacios_fotos_propiedad
**Directorio:** `lib/22_imagenes/tus_espacios_fotos_propiedad`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `manejo_de_fotos/funciones_compress_image.dart`, `http_funciones_gestion_foto.dart`, `provider_get_fotos_ids_user_propiedad.dart`, `provider_get_lista_fotos_ordenadas.dart`, `manejo_de_fotos/fotos_de_la_propiedad/pagina_agrega_multiples_fotos.dart`, `opciones_menu_fotos/...`, `lista_fotos_ordenadas/...`, `lista_ids_fotos/...`, `opciones_menu_fotos/...`, `datos_fotos/json/*`
- **Providers:** `provider_get_fotos_ids_user_propiedad.dart`, `provider_get_lista_fotos_ordenadas.dart`
- **Modelos:** `DataFotosCasa`, `FotosOrden`, `ImageFileStructure`
- **Páginas/Rutas:** `/agregamultiplesfotos`, `/fotospropiedad`, `/fotospropiedadpaginada`, `/carouselfotospropiedad`, opciones/fotos ordenadas/ids
- **I/O externo:** CouchDB attachments, storage local
- **Dependencias:** `flutter_riverpod`, `http`, `flutter_image_compress`, `image_picker`
- **Riesgos:** Memoria/performance por compresión; fotos huérfanas; JSON puede desincronizarse.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá agregar y asociar múltiples fotos a una propiedad.

### REQ-UBI-002 — Ubiquitous
El sistema deberá conservar orden explícito de fotos.

### REQ-EVT-001 — Event-Driven
Cuando el usuario selecciona imágenes, el sistema deberá comprimirlas antes del upload.

### REQ-EVT-002 — Event-Driven
Cuando se elimina una foto, el sistema deberá quitar attachment y actualizar orden.

### REQ-STATE-001 — State-Driven
Mientras se procesan fotos, el sistema deberá mostrar shimmer/loading por ítem.

### REQ-UNW-001 — Unwanted
Si compresión falla, entonces el sistema deberá reintentar en background sin bloquear UI.

### REQ-UNW-002 — Unwanted
Si JSON de orden/fotos queda corrupto, entonces el sistema deberá regenerar desde CouchDB.

### REQ-CMP-001 — Complex
Mientras se agregan fotos, cuando el lote supere umbral de memoria, el sistema deberá procesar en batches reducidos antes de escribir adjuntos.
