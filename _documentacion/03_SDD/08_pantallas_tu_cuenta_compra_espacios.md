# SDD - 08_pantallas_tu_cuenta_compra_espacios
**Directorio:** `lib/08_pantallas/tu_cuenta/tus_espacios/compra_espacios`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `form_compra_espacios.dart`, `provider_compra_espacios.dart`, `data_compra_espacios.dart`, `data_compra_espacios_get.dart`
- **Providers:** `compraDeEspaciosProvider`
- **Modelos:** `CompraEspaciosData`, datos de publicación/espacio
- **Páginas/Rutas:** `/compraespacios -> PaginaCompraEspacios`
- **I/O externo:** CouchDB HTTP
- **Dependencias:** `flutter_riverpod`, `http`
- **Riesgos:** Cálculo de totales puede desincronizarse si cambia precio en background.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá exponer selección de medio de pago y cálculo de totales.

### REQ-UBI-002 — Ubiquitous
El sistema deberá permitir revisar resumen antes de confirmar compra.

### REQ-EVT-001 — Event-Driven
Cuando el usuario confirma la compra, el sistema deberá escribir el documento en CouchDB.

### REQ-EVT-002 — Event-Driven
Cuando cambia la cantidad de espacios, el sistema deberá recalcular totales inmediatamente.

### REQ-STATE-001 — State-Driven
Mientras la compra está pendiente, el sistema deberá deshabilitar reenvío hasta respuesta.

### REQ-UNW-001 — Unwanted
Si el cálculo pierde sincronización, entonces el sistema deberá recalcular antes de confirmar.

### REQ-OPT-001 — Optional Feature
Donde el backend envíe promociones, el sistema deberá mostrar descuentos aplicables.
