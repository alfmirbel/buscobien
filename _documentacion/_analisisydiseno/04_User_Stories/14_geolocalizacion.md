# User Stories — Geolocalización y Google Maps (14_geolocalizacion)

**Directorio:** `lib/14_geolocalizacion/`
**Archivos:** `app_keys.dart`, `google_map_mapa_propiedades.dart`, `google_map_place_data.dart`, `provider_actual_place.dart` — Total: 4 archivos `.dart`
**Fecha:** 2026-08-12
**Formato:** 3 C's (Card, Conversation, Confirmation)

---

## US-GEO-001: Mapa de Propiedades con Markers Personalizados (Precio + Color Transacción)

**Card:**
Como **usuario buscando propiedades**
Quiero **ver un mapa interactivo con markers que muestren el precio y color según el tipo de transacción**
Para **comparar visualmente opciones geográficamente y elegir la mejor**

**Conversation:**
`PaginaMapaPropiedades` (ConsumerStatefulWidget) recibe `EspaciosCasaGet` (lista de propiedades) como argumento de ruta (`/mapapropiedades`). En `initState`, `_cargarMarcadores()` itera `espaciosCasaGet.rows` y por cada propiedad invoca `_createCustomMarkerBitmap()`: usa `Canvas` para dibujar un rectángulo de color (según `tipoTransaccion`: Venta=azul, Renta=verde, Venta/Renta=naranja, Traspaso=morado, etc.) y escribe el precio formateado (ej. "$1,200,000") con `drawText`. El bitmap resultante se pasa a `BitmapDescriptor.fromBytes()` y se crea un `Marker` con `onTap` que navega a `PaginaDetalleWidget`. `GoogleMap` se configura con `mapController`, `myLocationEnabled`, y cámara inicial en `LatLng(0,0)` zoom 12 (luego ajustada). En `dispose()` se libera `mapController`.

**Confirmation:**
- [ ] Mapa recibe `EspaciosCasaGet` vía argumentos de ruta
- [ ] `_cargarMarcadores()` crea un `Marker` por propiedad en la lista
- [ ] `_createCustomMarkerBitmap()` dibuja: rectángulo color + texto precio formateado
- [ ] Color por tipo transacción: Venta=azul, Renta=verde, V/R=naranja, Traspaso=morado
- [ ] `onTap` marker → navega a `PaginaDetalleWidget` con datos de la propiedad
- [ ] `mapController` se obtiene en `onMapCreated` y se libera en `dispose()`
- [ ] `myLocationEnabled: true` muestra botón "Mi ubicación"
- [ ] Sin dependencia de assets para markers (generación runtime vía Canvas)

---

## US-GEO-002: Geocodificación Dual Plataforma (Nativo Android/iOS + REST Web/Windows)

**Card:**
Como **usuario en cualquier plataforma (Web, Windows, Android, iOS)**
Quiero **que el mapa centre la cámara en la propiedad que busco por nombre/ubicación**
Para **ver la ubicación precisa sin escribir coordenadas manualmente**

**Conversation:**
`_ajustarCamaraPorNombreNivelGobierno()` construye query string: `"calle, localidad, municipio, estado, México"` y geocodifica para centrar la cámara:
- **Android/iOS**: `geocoding.placemarkFromCoordinates(lat, lng)` nativo → `animateCamera` a bounds del resultado.
- **Web/Windows**: REST API `https://maps.googleapis.com/maps/api/geocode/json?latlng=...&key=GOOGLE_MAPS_KEY` → `getPlaceFromCoordinates()` → `_procesarResultadoGeocodingAPI()` parsea `GooglemapPlace` → extrae `formattedAddress`, `postal_code` y `viewport` → `animateCamera` a bounds.
- **Fallback Web**: si REST falla o status != "OK", usa `LatLngBounds.fromPoints(markers visibles)` → `animateCamera` al bounding box de markers (no centra en propiedad individual).
- **Linux/macOS/Fuchsia**: log warning "plataforma no soportada" — no geocodifica.
`provider_actual_place.dart` expone `determinaUbicacion()` que encapsula el selector de plataforma (`kIsWeb` + `defaultTargetPlatform`) y actualiza `posicionCamara` y `marcadores` (añade "Mi Ubicación" salvo en Windows).

**Confirmation:**
- [ ] Android: `geolocator.getCurrentPosition()` + `placemarkFromCoordinates()` → geocodificación nativa
- [ ] iOS: idem Android (nativo)
- [ ] Web: REST Geocoding API (`maps.googleapis.com`) con `GOOGLE_MAPS_KEY` inyectado
- [ ] Windows: REST Geocoding API (misma ruta Web)
- [ ] Linux/macOS/Fuchsia: log warning, sin acción
- [ ] Éxito geocoding → `animateCamera` a `viewport` / bounds del resultado
- [ ] Fallo Web → fallback `LatLngBounds.fromPoints(markers)` (todos los markers visibles)
- [ ] `postal_code` extraído y propagado a `localidadesPorCodigoPostalProvider` (puebla tabs menú Gobierno)
- [ ] `determinaUbicacion()` añade marker "Mi Ubicación" (salvo Windows) y actualiza `posicionCamara`
- [ ] `getUbicacionActuaFuturelProvider` expone Future para UI reactiva

---

## US-GEO-003: Gestión de Permisos de Ubicación con Estados Explícitos

**Card:**
Como **usuario que valora mi privacidad**
Quiero **controlar si la app accede a mi ubicación y ver mensaje claro si la deniego**
Para **decidir informadamente sin bloqueos silenciosos**

**Conversation:**
`determinePermisosUbicacion()` (en `provider_actual_place.dart`) orquesta el flujo:
1. `Geolocator.isLocationServiceEnabled()` → si false: `permisodelocalizacion=0`, mensaje "La localización está deshabilitada."
2. `Geolocator.checkPermission()` → si `denied`: solicita con `Geolocator.requestPermission()`.
3. Si tras solicitar sigue `denied`: `permisodelocalizacion=0`, mensaje "Permiso de localización denegado."
4. Si `deniedForever`: `permisodelocalizacion=0`, mensaje "Localización negada permanentemente."
5. Si concedido: `Geolocator.getCurrentPosition()` → guarda en `actualPosition`, `latitud`, `longitud`, `permisodelocalizacion=1`, mensaje "La localización esta habilitada."
El estado `permisodelocalizacion` (0/1) y `resultadoPermisoUbicacion` (String) se exponen en `DatosDeLaUbicacionActual` para que la UI reaccione (mostrar banner, deshabilitar botones, etc.). `solicitaAccesoUbicacionFutureProvider` expone Future<int> para consumo reactivo.

**Confirmation:**
- [ ] Servicio GPS deshabilitado → mensaje claro "La localización está deshabilitada."
- [ ] Permiso denegado temporal → solicita permiso; si sigue denegado → mensaje "Permiso de localización denegado."
- [ ] Permiso denegado permanentemente → mensaje "Localización negada permanentemente" (no vuelve a pedir)
- [ ] Permiso concedido → obtiene posición actual, setea `latitud`/`longitud`, `permisodelocalizacion=1`
- [ ] UI reacciona a `permisodelocalizacion` y `resultadoPermisoUbicacion` (no bloqueo silencioso)
- [ ] `solicitaAccesoUbicacionFutureProvider` permite UI `FutureBuilder` esperando permiso
- [ ] No hay auto-reintento tras `deniedForever` (respeta decisión usuario)

---

## US-GEO-004: Inyección Segura de API Keys Google Maps en Compile-Time

**Card:**
Como **equipo de desarrollo/seguridad**
Quiero **que las API Keys de Google Maps nunca estén en código fuente ni en repositorio**
Para **evitar fugas de credenciales y rotar keys sin rebuild de código**

**Conversation:**
`app_keys.dart` define dos `const String`: `GOOGLE_KEY` y `GOOGLE_MAPS_KEY`, ambos inicializados con `String.fromEnvironment('GOOGLE_KEY')` y `String.fromEnvironment('GOOGLE_MAPS_KEY')`. Las claves reales se pasan **solo en build/run** vía `--dart-define-from-file=defines.json` (archivo en `.gitignore`). Ejemplo `defines.json`: `{"GOOGLE_KEY": "AIza...", "GOOGLE_MAPS_KEY": "AIza..."}`. En `provider_actual_place.dart`, `getPlaceFromCoordinates()` usa `$GOOGLE_MAPS_KEY` interpolado en la URL REST. En `main.dart` y `google_map_mapa_propiedades.dart`, el `GoogleMap` widget usa la key vía `GoogleMap(apiKey: GOOGLE_MAPS_KEY)` (si se configura) o la key inyectada en `AndroidManifest.xml` / `ios/Runner/AppDelegate.swift` para plataformas nativas.

**Confirmation:**
- [ ] `app_keys.dart` usa `String.fromEnvironment()` — NO hay strings literales de keys
- [ ] `defines.json` en `.gitignore` — nunca committeado
- [ ] Build/run requiere `--dart-define-from-file=defines.json`
- [ ] `GOOGLE_MAPS_KEY` usado en URL REST (`provider_actual_place.dart`) y nativo (Android/iOS config)
- [ ] Rotación de keys = editar `defines.json` + rebuild (sin tocar código)
- [ ] CI/CD inyecta secrets en build time (no en repo)

---

## Notas

- Estas US reemplazan a US-GEO-001 y US-GEO-002 consolidadas en `04_User_Stories/03_listas.md` con formato 3 C's completo (Conversation incluida) y añaden US-GEO-003 (permisos) y US-GEO-004 (keys seguras).
- Complementan la Epic en `02_Epics_EARS/14_geolocalizacion.md` y los escenarios Gherkin en `03_Features_BDD/14_geolocalizacion/mapa_geolocalizacion.feature`.
- Para detalles por archivo (4 archivos, 2 tablas + notas): ver `05_Tareas_Inventarios/14_geolocalizacion/elementos_14_geolocalizacion.md`.
- **Patrón `_notify()` manual**: `DatosDeLaUbicacionActual` no es @freezed; `_notify()` crea nueva instancia copiando 20+ campos — cualquier campo omitido se pierde. Candidata a refactor @freezed.
- **Modelos Geocoding manuales**: `google_map_place_data.dart` tiene 8 clases anidadas con `fromJson`/`toJson` manuales — 200+ líneas de boilerplate. Candidata a `json_serializable` + Freezed.
- **Fallback Web bounds**: limitación conocida — en Web/Windows sin geocoding exitoso, el mapa muestra todos los markers pero no centra en la propiedad buscada individualmente.