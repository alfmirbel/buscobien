# SDD - 08_pantallas_inicio
**Directorio:** `lib/08_pantallas/inicio`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `pagina_inicio_busca_espacios.dart`, `inicio_propiedades_providers.dart`, `.g.dart`, `clase_busqueda_estado.dart`, `clase_busqueda_estado.g.dart`, `data_espacios_casas.dart`, `data_espacios_casas_get.dart`, `data_get_valores_menus.dart`, `http_find_propiedades_10en10.dart`, `.g.dart`, `http_view_count_filter_propiedades.dart`, `.g.dart`, `catalogo_otras_caracteristicas.dart`, `widget_wrap_modern_card.dart`, `data_count_view_documentos.dart`
- **Providers:** `inicio_propiedades_providers.dart`, `homeNavigationProvider`, `currentQueryProvider`
- **Modelos:** `EspaciosCasaGet`, `EspaciosCasa`, `ValueEspaciosCasaGet`, `Datosadicionalescasa`, `Datosdelcontactocasa`, `Ubicacioncasa`, `LocalidadCp`, `VariablesViewQuery`
- **Páginas/Rutas:** `PaginaInicioBuscaEspacios` -> `/principal` + filtros; FAB a `/mapapropiedades`; detalle a detalle; QR/shortcode share integrado
- **I/O externo:** CouchDB HTTP, JSON local, routing a detalle propiedad/usuario
- **Dependencias:** `flutter_riverpod`, `http`, `google_maps_flutter`, `geocoding`
- **Riesgos:** Paginación acoplada a query params generados; manejo inconsistente de errores HTTP.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá presentar un listado paginado de propiedades desde CouchDB.

### REQ-UBI-002 — Ubiquitous
El sistema deberá renderizar cards modernas con `widget_wrap_modern_card`.

### REQ-EVT-001 — Event-Driven
Cuando cambian los filtros, el sistema deberá invalidar providers y recargar página 1.

### REQ-EVT-002 — Event-Driven
Cuando el usuario abre el detalle, el sistema deberá navegar a `PaginaDetallePropiedad`.

### REQ-EVT-003 — Event-Driven
Cuando el usuario comparte por QR/código corto, el sistema deberá exponer el flujo de escaneo/lectura.

### REQ-STATE-001 — State-Driven
Mientras no haya resultados, el sistema deberá mostrar el estado vacío en `_buildSinPropiedades`.

### REQ-STATE-002 — State-Driven
Mientras `checaConeccionesProvider` indique offline, el sistema deberá suspender nuevas búsquedas y mostrar indicador offline.

### REQ-UNW-001 — Unwanted
Si la consulta falla por red o por CouchDB, entonces el sistema deberá mostrar estado de error con opción a reintentar.

### REQ-UNW-002 — Unwanted
Si el parámetro `skip` es inconsistente con `limit`, entonces el sistema deberá recuperar paginación desde `viewCountFilterPropiedades`.

### REQ-CMP-001 — Complex
Mientras el usuario aplica filtros, cuando cambie cualquier filtro activo, el sistema deberá actualizar `currentQueryProvider` y recargar la página 1 con 10 resultados exactos.

### REQ-OPT-001 — Optional Feature
Donde el usuario mantenga filtros locales previos, el sistema deberá restaurar `clase_busqueda_estado` al reabrir la búsqueda.
