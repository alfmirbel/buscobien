# SDD - 08_pantallas_propiedades
**Directorio:** `lib/08_pantallas/propiedades`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `pagina_detalle_propiedad.dart`, `pagina_detalle_propiedad_pdf.dart`, `data_find_propiedades.dart`
- **Providers:** lectura local desde argumento `ValueEspaciosCasaGet`; no provider remoto dedicado en este directorio
- **Modelos:** `ValueEspaciosCasaGet`, `EspaciosCasa`, documento de propiedad en detalle
- **Páginas/Rutas:** detalle desde busqueda; PDF export desde detalle
- **I/O externo:** Ninguno en este directorio; depende de modelo recibido
- **Dependencias:** `printing`, `pdf`, `http`
- **Riesgos:** Export PDF depende de base64 y attachments; no hay fallback si imágenes faltan.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá mostrar datos técnicos, ubicación y contacto en la ficha de detalle.

### REQ-UBI-002 — Ubiquitous
El sistema deberá exponer acciones like/guardar lista desde detalle.

### REQ-EVT-001 — Event-Driven
Cuando el usuario solicita PDF, el sistema deberá generar y descargar el PDF.

### REQ-STATE-001 — State-Driven
Mientras la propiedad no tenga foto principal, el sistema deberá mostrar placeholder en vista y PDF.

### REQ-STATE-002 — State-Driven
Mientras la galería tenga menos de 1 imagen, el sistema deberá omitir sección de galería en PDF.

### REQ-UNW-001 — Unwanted
Si `recuperaFotoPorIdFoto` falla, entonces el sistema deberá continuar con siguiente imagen y registrar error sin detener flujo.

### REQ-CMP-001 — Complex
Mientras se genera PDF, cuando la imagen principal o galería tengan base64 inválido, el sistema deberá omitirlos y continuar generando el PDF sin crash.

### REQ-OPT-001 — Optional Feature
Donde se solicite compartir QR desde detalle, el sistema deberá incluir clave de propiedad y datos mínimos.
