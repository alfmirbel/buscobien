# Epic: Geolocalización y Google Maps (14_geolocalizacion)

**Directorio:** `lib\14_geolocalizacion\`  
**Archivos:** `app_keys.dart`, `google_map_mapa_propiedades.dart`, `google_map_place_data.dart`, `provider_actual_place.dart`  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Visualización geoespacial de propiedades | Usuario final | Ve propiedades en mapa con markers de precio, navega a ubicación, busca por lugar | Mapa interactivo + geocodificación + place picker |
| | Promotor | Ubica sus propiedades en mapa al publicarlas | Integración con formulario captura |

---

## User Story Mapping

```
Usuario navega a /mapapropiedades (con EspaciosCasaGet arg)
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│ PaginaMapaPropiedades (ConsumerStatefulWidget)              │
│ - Carga propiedades → _cargarMarcadores()                   │
│ - Markers personalizados: precio + color por transacción    │
│ - _createCustomMarkerBitmap() (Canvas drawText + rect)      │
└────────────────────────┬────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
   Geocodificación   Permisos          Place Data
   - _ajustarCamara  - determine        - Models:
     PorNombre()       PermisosUbicacion   GooglemapPlace,
     - Fallback Web   - getAddress       Result, AddressComponent,
     bounds           - getPlace         Geometry, Viewport
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-GEO-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-GEO-001 | **Ubicuo** | El sistema inyectará `GOOGLE_KEY` y `GOOGLE_MAPS_KEY` en compile-time vía `--dart-define-from-file=defines.json` (acceso con `String.fromEnvironment`). | `lib\14_geolocalizacion\app_keys.dart:5-7` | En código |
| REQ-GEO-002 | **Ubicuo** | El sistema proveerá `PaginaMapaPropiedades` que recibe `EspaciosCasaGet` (lista propiedades) y renderiza `GoogleMap` con markers personalizados: precio formateado, color por tipo transacción (venta=azul, renta=verde, etc.). | `google_map_mapa_propiedades.dart:50-200` | En código |
| REQ-GEO-003 | **Evento** | Cuando el mapa cargue, el sistema ejecutará `_cargarMarcadores()` iterando propiedades, creando bitmap con `Canvas` (fondo color + texto precio) y añadiendo `Marker` con `onTap` → detalle. | `google_map_mapa_propiedades.dart:100-180` | En código |
| REQ-GEO-004 | **Evento** | Cuando se requiera centrar mapa en propiedad, el sistema invocará `_ajustarCamaraPorNombreNivelGobierno()`: geocodifica nombre (calle + localidad + municipio + estado) → nativo `geocoding` (Android/iOS) o REST API (Web/Windows) → `animateCamera` a bounds. | `google_map_mapa_propiedades.dart:200-300` | En código |
| REQ-GEO-005 | **No Deseado** | Si geocodificación nativa falle en Web/Windows, el sistema hará fallback a cálculo de bounds manual con `LatLngBounds.fromPoints` (markers visibles) — **sin zoom a propiedad específica**. | `google_map_mapa_propiedades.dart:280-300` Web fallback | Parcial |
| REQ-GEO-006 | **Ubicuo** | El sistema definirá modelos completos respuesta Geocoding API: `GooglemapPlace`, `PlusCode`, `Result`, `AddressComponent`, `Geometry`, `Viewport`, `NortheastClass`, `NavigationPoint` (Freezed-style manual). | `lib\14_geolocalizacion\google_map_place_data.dart` | En código |
| REQ-GEO-007 | **Ubicuo** | El sistema expondrá `ClassLocalidadesNotifierProvider` (`DatosDeLaUbicacionActual` state) con: `determinePermisosUbicacion()`, `getAddressFromLatLng()`, `getPlaceFromCoordinates()` (REST), `determinaUbicacion()` (switch platform: Web/Win→REST, Android/iOS→nativo), `_procesarResultadoGeocodingAPI()`, `_notify()` (recrea estado). | `lib\14_geolocalizacion\provider_actual_place.dart` | En código |
| REQ-GEO-008 | **Estado** | Mientras la app necesite ubicación actual, el sistema usará `determinaUbicacion()` que elige estrategia por plataforma: **Web/Windows** → REST Geocoding API (`maps.googleapis.com`), **Android/iOS** → `geolocator` + `geocoding` nativo. | `provider_actual_place.dart:60-120` | En código |
| REQ-GEO-009 | **No Deseado** | Si permisos de ubicación denegados, el sistema mantendrá estado `permisosUbicacion = false` y no intentará geocodificar (UI debe manejar). | `provider_actual_place.dart:40-50` | En código |
| REQ-GEO-010 | **Complejo** | Mientras el usuario esté en mapa, cuando cambie tipo de transacción en filtro, el sistema recargará markers con nuevos colores/precios vía `_cargarMarcadores()` reactivo a providers de filtro. | `google_map_mapa_propiedades.dart` + providers | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| `GOOGLE_KEY` / `GOOGLE_MAPS_KEY` | `app_keys.dart` | 5-7 |
| `PaginaMapaPropiedades` | `google_map_mapa_propiedades.dart` | 1-350 |
| `_cargarMarcadores` + custom bitmap | `google_map_mapa_propiedades.dart` | 100-180 |
| `_ajustarCamaraPorNombreNivelGobierno` | `google_map_mapa_propiedades.dart` | 200-300 |
| Modelos Geocoding API | `google_map_place_data.dart` | 1-200 |
| `ClassLocalidadesNotifierProvider` | `provider_actual_place.dart` | 1-180 |
| `determinaUbicacion` (platform switch) | `provider_actual_place.dart` | 60-120 |

---

## Notas de Arquitectura

- **Dual geocoding strategy**: Platform-aware (nativo vs REST) — correcto para Web/Windows sin GPS nativo.
- **Markers dinámicos**: Canvas runtime para precio — evita assets por cada precio.
- **Fallback Web bounds**: Limitación conocida — no centra en propiedad individual en Web si geocoding falla.
- **Keys en `defines.json`**: Nunca en código — `String.fromEnvironment` obligatorio.
- **Modelos manuales**: `google_map_place_data.dart` no usa Freezed — clases planas con `fromJson` implícito.