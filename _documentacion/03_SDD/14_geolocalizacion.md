# SDD - 14_geolocalizacion
**Directorio:** `lib/14_geolocalizacion`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `google_map_mapa_propiedades.dart`, `google_map_place_data.dart`, `provider_actual_place.dart`, `app_keys.dart`
- **Providers:** `provider_actual_place.dart`
- **Modelos:** `GoogleMapPlaceData`
- **Páginas/Rutas:** `/mapapropiedades -> PaginaMapaPropiedades`
- **I/O externo:** Google Maps/geocoding, JSON local
- **Dependencias:** `google_maps_flutter`, `geocoding`
- **Riesgos:** `app_keys.dart` puede contener referencias sensibles; mapa en web requiere bounds ajustados.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá renderizar marcadores de propiedades en Google Maps.

### REQ-UBI-002 — Ubiquitous
El sistema deberá exponer place actual del usuario.

### REQ-EVT-001 — Event-Driven
Cuando se carga la lista de propiedades, el sistema deberá centrar el mapa en bounds útiles.

### REQ-STATE-001 — State-Driven
Mientras el permiso de ubicación esté denegado, el sistema deberá deshabilitar geolocalización.

### REQ-UNW-001 — Unwanted
Si la API key falta o es inválida, entonces el sistema deberá mostrar fallback sin mapa.

### REQ-OPT-001 — Optional Feature
Donde la plataforma sea web, el sistema deberá ajustar bounds del mapa con gestos.
