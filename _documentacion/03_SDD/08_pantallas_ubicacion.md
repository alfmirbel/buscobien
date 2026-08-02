# SDD - 08_pantallas_ubicacion
**Directorio:** `lib/08_pantallas/ubicacion`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `pagina_principal_localidades.dart`, `pagina_busca_localidades_gmaps.dart`, `screen_maestro_localidades.dart`, `data_localidad_find.dart`, `data_sepomex_localidades.dart`, `.freezed.dart`, `.g.dart`, `data_sepomex_localidades_get_cp.dart`, `provider_localidades_del_cp.dart`
- **Providers:** `provider_localidades_del_cp.dart`
- **Modelos:** `FindLocalidadXcp`, `LocalidadCp`, `LocalityEntry`, `PostalCodeLookupResult`, `SepomexLocalidades`
- **Páginas/Rutas:** `/localidades -> PaginaBuscaLocalidadGMaps`; `/listalocalidades -> LocalidadesListScreen`; maestro internal a edición
- **I/O externo:** JSON local SEPOMEX, Google Maps/geocoding
- **Dependencias:** `flutter_riverpod`, `google_maps_flutter`, `geocoding`, `http`
- **Riesgos:** Validaciones insuficientes en índices CouchDB; fallback por municipio puede perder precisión.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá permitir búsqueda de localidades por código postal, estado, municipio y asentamiento.

### REQ-UBI-002 — Ubiquitous
El sistema deberá permitir selección en mapa con anotación por precio/metadata.

### REQ-EVT-001 — Event-Driven
Cuando el usuario selecciona una localidad, el sistema deberá persistir la asociación en sesión/usuario.

### REQ-EVT-002 — Event-Driven
Cuando el geocoding retorna múltiples candidatos, el sistema deberá permitir elegir uno.

### REQ-STATE-001 — State-Driven
Mientras el usuario permanece en maestro, el sistema deberá conservar filtros aplicados.

### REQ-UNW-001 — Unwanted
Si el geocoding falla, entonces el sistema deberá usar fallback por municipio sin detener navegación.

### REQ-UNW-002 — Unwanted
Si los datos de CouchDB vienen incompletos o sin índice, entonces el sistema deberá mostrar aviso sin detener flujo.

### REQ-CMP-001 — Complex
Mientras el usuario busca por CP, cuando llegue respuesta vacía, el sistema deberá limpiar lista y mostrar estado vacío por 2s antes de reintentar automáticamente una vez.
