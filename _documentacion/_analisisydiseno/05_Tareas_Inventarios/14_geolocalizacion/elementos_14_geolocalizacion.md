# Inventario de Componentes — 14_geolocalizacion

**Directorio:** `lib/14_geolocalizacion/`
**Archivos:** 4 `.dart`
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo)

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| 14_geolocalizacion | `app_keys.dart` | Constantes compile-time | `GOOGLE_KEY`, `GOOGLE_MAPS_KEY` | `String.fromEnvironment('GOOGLE_KEY')`, `String.fromEnvironment('GOOGLE_MAPS_KEY')` | `--dart-define-from-file=defines.json` | — | — |
| 14_geolocalizacion | `google_map_mapa_propiedades.dart` | ConsumerStatefulWidget | `PaginaMapaPropiedades` | `EspaciosCasaGet espaciosCasaGet` (argumentos de ruta) | `google_maps_flutter`, `geolocator`, `geocoding`, `appTheme`, `EspaciosCasaGet` | `_PaginaMapaPropiedadesState` | `GoogleMap`, `Marker`, `BitmapDescriptor.fromBytes()`, `Canvas` (custom marker) |
| 14_geolocalizacion | `google_map_place_data.dart` | Clases modelo (manual, no Freezed) | `GooglemapPlace`, `PlusCode`, `Result`, `AddressComponent`, `Geometry`, `Viewport`, `NortheastClass`, `NavigationPoint`, `NavigationPointLocation` | JSON Geocoding API response | — | Nested classes con `fromJson`/`toJson` manuales | — |
| 14_geolocalizacion | `provider_actual_place.dart` | Notifier + State class + FutureProviders | `DatosDeLaUbicacionActual`, `ClassLocalidadesNotifierProvider`, `ubicacionActualProvider`, `getUbicacionActuaFuturelProvider`, `solicitaAccesoUbicacionFutureProvider` | `geolocator`, `geocoding`, `http` (REST), `MaterialSymbols`, `localidadesPorCodigoPostalProvider` | `state` (DatosDeLaUbicacionActual) | `determinePermisosUbicacion`, `getAddressFromLatLng`, `getPlaceFromCoordinates` (REST), `determinaUbicacion` (platform switch), `_procesarResultadoGeocodingAPI`, `_notify`, `addMarker`, `onMapCreated`, `disposeMapController`, `getUserCurrentLocation` |

---

## Tabla 2: Elementos (por archivo)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| 14_geolocalizacion | `app_keys.dart` | `GOOGLE_KEY`, `GOOGLE_MAPS_KEY` (top-level const) | — | — | — | `String.fromEnvironment()` | — |
| 14_geolocalizacion | `google_map_mapa_propiedades.dart` | — | `PaginaMapaPropiedades` (ConsumerStatefulWidget), `_PaginaMapaPropiedadesState` | `espaciosCasaGet` (EspaciosCasaGet) | `createState()`, `initState()` (carga markers + cámara), `_cargarMarcadores()`, `_createCustomMarkerBitmap()` (Canvas drawRect + drawText precio), `_ajustarCamaraPorNombreNivelGobierno()` (geocoding nativo/REST + animateCamera), `build()` (GoogleMap con markers), `dispose()` (mapController.dispose) | `google_maps_flutter`, `geolocator`, `geocoding`, `appTheme` | `GoogleMapController`, `Marker`, `BitmapDescriptor.fromBytes()`, `Canvas.drawRect()`, `Canvas.drawText()`, `animateCamera()`, `LatLngBounds.fromPoints()`, `geolocator.placemarkFromCoordinates()`, `http.get(maps.googleapis.com)` |
| 14_geolocalizacion | `google_map_place_data.dart` | `googlemapPlaceFromJson()`, `googlemapPlaceToJson()` (top-level helpers) | `GooglemapPlace`, `PlusCode`, `Result`, `AddressComponent`, `Geometry`, `Viewport`, `NortheastClass`, `NavigationPoint`, `NavigationPointLocation` | Campos según JSON Geocoding API (ver notas) | Constructores `const`, `fromJson` manual, `toJson` manual | `dart:convert` | — |
| 14_geolocalizacion | `provider_actual_place.dart` | `ubicacionActualProvider` (NotifierProvider), `getUbicacionActuaFuturelProvider`, `solicitaAccesoUbicacionFutureProvider` | `DatosDeLaUbicacionActual` (state class, **no Freezed**), `ClassLocalidadesNotifierProvider extends Notifier<DatosDeLaUbicacionActual>` | `DatosDeLaUbicacionActual`: `marcadores: Set<Marker>`, `postalCode`, `addressGM`, `permisodelocalizacion`, `estadoDeLaConeccion`, `resultadoPermisoUbicacion`, `latitud`, `longitud`, `currentAddress`, `placemarksList`, `actualAddress`, `setState`, `userLocation: GooglemapPlace`, `posicionCamara: CameraPosition`, `actualPosition: Position`, `place: Placemark`, `mapController: GoogleMapController?`, `controller: Completer<GoogleMapController>` | `build()`, `inicializaMarcadores()`, `addMarker()`, `onMapCreated()`, `disposeMapController()`, `getUserCurrentLocation()`, `determinePermisosUbicacion()`, `getAddressFromLatLng()`, `getPlaceFromCoordinates()` (REST), `determinaUbicacion()` (platform switch), `_procesarResultadoGeocodingAPI()`, `_notify()` (recrea instancia) | `geolocator`, `geocoding`, `http`, `MaterialSymbols`, `localidadesPorCodigoPostalProvider`, `detecta_os` | `Geolocator.requestPermission()`, `Geolocator.getCurrentPosition()`, `placemarkFromCoordinates()`, `http.get(maps.googleapis.com)`, `googlemapPlaceFromJson()`, `ref.read(localidadesPorCodigoPostalProvider.notifier).setCodigoPostal()` |

---

## Notas

- **4 archivos totales**: `app_keys.dart` (2 constantes), `google_map_mapa_propiedades.dart` (mapa + markers), `google_map_place_data.dart` (8 modelos anidados para Geocoding API), `provider_actual_place.dart` (provider de ubicación actual + geocodificación dual).
- **Keys seguras**: `GOOGLE_KEY` y `GOOGLE_MAPS_KEY` inyectadas vía `--dart-define-from-file=defines.json` → `String.fromEnvironment()` en `app_keys.dart`. Nunca en código fuente.
- **Dual geocoding strategy**:
  - **Android/iOS**: `geolocator` + `geocoding` nativo (`determinePermisosUbicacion()` → `getAddressFromLatLng()`).
  - **Web/Windows**: REST API `maps.googleapis.com/maps/api/geocode/json` (`getPlaceFromCoordinates()` → `_procesarResultadoGeocodingAPI()`).
  - **Linux/macOS/Fuchsia**: no soportados (log warning, no acción).
  - Selector: `kIsWeb` + `defaultTargetPlatform` en `determinaUbicacion()`.
- **`DatosDeLaUbicacionActual` NO es @freezed**: es clase mutable con `_notify()` que crea **nueva instancia** copiando todos los campos para que Riverpod detecte cambio (patrón manual de inmutabilidad simulada).
- **Markers personalizados en mapa**: `_createCustomMarkerBitmap()` usa `Canvas` para dibujar rectángulo coloreado + texto del precio formateado. Color según tipo de transacción (Venta=azul, Renta=verde, Venta/Renta=naranja, Traspaso=morado, etc.). Evita assets por cada precio.
- **Fallback Web bounds**: si geocodificación REST falla, `_ajustarCamaraPorNombreNivelGobierno()` usa `LatLngBounds.fromPoints(markers visibles)` — no centra en propiedad individual, solo en conjunto visible.
- **CP propagación**: tanto `getAddressFromLatLng()` (nativo) como `_procesarResultadoGeocodingAPI()` (REST) extraen `postal_code` y propagan a `localidadesPorCodigoPostalProvider` (en `08_pantallas/ubicacion/`). Este provider alimenta tabs dinámicas del menú Nivel Gobierno.
- **Modelos manuales**: `google_map_place_data.dart` no usa Freezed — clases planas con `fromJson`/`toJson` manuales. Usa `num` casting seguro para lat/lng (API puede devolver int o double).
- **Permisos**: `determinePermisosUbicacion()` maneja 3 casos: servicio deshabilitado, permiso denegado, permiso denegado permanentemente. Setea `permisodelocalizacion` (0/1) y `resultadoPermisoUbicacion` (String mensaje).
- **`_notify()` crítico**: crea nueva instancia `DatosDeLaUbicacionActual()` copiando **todos** los campos del state anterior — cualquier campo omitido se pierde. Deuda: refactor a @freezed para `copyWith` automático.
- **FutureProviders**: `getUbicacionActuaFuturelProvider` (async determinaUbicacion) y `solicitaAccesoUbicacionFutureProvider` (async determinePermisosUbicacion) para uso reactivo en UI.
- **Deuda técnica**:
  1. `DatosDeLaUbicacionActual` mutable + `_notify()` manual → propenso a bugs de olvido de campos.
  2. `google_map_place_data.dart` manual → mantenimiento pesado si API cambia.
  3. Linux/macOS/Fuchsia sin estrategia de geocoding.
  4. No tests de markers, geocoding, ni permisos.
  5. Hardcoded zoom=12 y center LatLng(0,0) inicial — debería usar ubicación usuario si disponible.