# SDD - 08_pantallas_tu_cuenta_tus_espacios
**Directorio:** `lib/08_pantallas/tu_cuenta/tus_espacios`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `pagina_tus_espacios.dart`, `provider_espacios_casa_get.dart`, `form_crea_ficha_captura_propiedad.dart`, `form_update_espacio_comprado.dart`, `http_publica_propiedad.dart`, `tabla_tipopropiedad_vs_campos.dart`
- **Providers:** `provider_espacios_casa_get.dart`
- **Modelos:** `EspaciosCasa`, `ValueEspaciosCasaGet`
- **Páginas/Rutas:** `/editaespacio -> PaginaEditaEspacio`
- **I/O externo:** CouchDB HTTP
- **Dependencias:** `flutter_riverpod`, `http`, `file_picker`
- **Riesgos:** Formulario grande; campos condicionales concentrados en arrays; metadata de compra/edición combinada.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá listar propiedades publicadas por el usuario con sus fotos.

### REQ-UBI-002 — Ubiquitous
El sistema deberá soportar crear y editar con campos condicionales por tipo de inmueble.

### REQ-EVT-001 — Event-Driven
Cuando el usuario publica/despublica, el sistema deberá persistir el cambio.

### REQ-STATE-001 — State-Driven
Mientras el usuario edita, el sistema deberá ocultar o mostrar campos según `tabla_tipopropiedad_vs_campos`.

### REQ-UNW-001 — Unwanted
Si un campo requerido está vacío al guardar, entonces el sistema deberá mostrar error inline sin cerrar formulario.

### REQ-CMP-001 — Complex
Mientras el usuario cambia tipo de propiedad, cuando seleccione “Otros inmuebles”, el sistema deberá mostrar dropdown adicional y actualizar campos condicionales antes del submit.
