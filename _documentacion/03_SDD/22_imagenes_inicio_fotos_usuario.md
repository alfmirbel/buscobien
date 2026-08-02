# SDD - 22_imagenes_inicio_fotos_usuario
**Directorio:** `lib/22_imagenes/inicio_fotos_usuario`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `pagina_carousel_fotos_usuario.dart`, `pagina_carousel_fotos_usuario_mini.dart`
- **Providers:** lectura desde sesión/avatar
- **Modelos:** `GetUserAvatar`
- **Páginas/Rutas:** Galería de fotos de usuario
- **I/O externo:** storage/avatar backend
- **Dependencias:** `carousel_slider`, `flutter_riverpod`
- **Riesgos:** Miniaturas pueden no cargar si storage falla.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá mostrar carousel de fotos de usuario.

### REQ-EVT-001 — Event-Driven
Cuando cambia el avatar, el sistema deberá refrescar carousel.

### REQ-STATE-001 — State-Driven
Mientras no hay fotos, el sistema deberá mostrar placeholder.

### REQ-UNW-001 — Unwanted
Si storage falla, entonces el sistema deberá mostrar fallback sin crash.
