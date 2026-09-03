# SDD - 60_global_widgets
**Directorio:** `lib/60_global_widgets`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `dialogbox_mensaje_general.dart`, `future_builder_state_widgets.dart`, `bottom_fijo.dart`, `genera_cantidad_monetaria.dart`, `derechos_reservados.dart`, `debugprint.dart`
- **Providers:** No
- **Modelos:** No
- **Páginas/Rutas:** Consumido por toda la app
- **I/O externo:** No
- **Dependencias:** `flutter`
- **Riesgos:** `debugprint.dart` puede filtrar información sensible en producción si no se controla nivel.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá proveer constructores reutilizables de diálogos y estados.

### REQ-UBI-002 — Ubiquitous
El sistema deberá proveer formateador de cantidades monetarias centralizado.

### REQ-EVT-001 — Event-Driven
Cuando una operación async falla, el sistema deberá exponer el widget de error con reintento.

### REQ-EVT-002 — Event-Driven
Cuando un diálogo se confirma, el sistema deberá continuar o cancelar la acción evaluada.

### REQ-STATE-001 — State-Driven
Mientras `debugPrintLevels` esté activo, el sistema deberá limitar salida por nivel.

### REQ-UNW-001 — Unwanted
Si `debugPrintLevels` se usa en producción con datos sensibles, entonces el sistema deberá registrar a nivel reducido.
