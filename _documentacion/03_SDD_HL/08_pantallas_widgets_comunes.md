# SDD - 08_pantallas_widgets_comunes
**Directorio:** `lib/08_pantallas/widgets_comunes`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `widget_letrero_tipo_transaccion.dart`
- **Providers:** No
- **Modelos:** No
- **Páginas/Rutas:** Consumido por vistas de propiedad y filtros
- **I/O externo:** No
- **Dependencias:** `flutter`, `material_symbols_icons`
- **Riesgos:** Widget único; si crece, requiere categorización.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá mostrar el tipo de transacción activo con estilo M3.

### REQ-EVT-001 — Event-Driven
Cuando cambia el filtro de transacción, el sistema deberá repintar el letrero con el nuevo valor.
