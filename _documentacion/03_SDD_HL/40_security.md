# SDD - 40_security
**Directorio:** `lib/40_security`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `urls_endpoints_espacios.dart`, `direccionip.dart`, `generate_hash.dart`, `generate_reset_token.dart`, `encriptar.dart`, `couchdb_errors.dart`
- **Providers:** No
- **Modelos:** No
- **Páginas/Rutas:** No
- **I/O externo:** Node API / CouchDB endpoints
- **Dependencias:** `http`, `crypto`, `flutter_dotenv`
- **Riesgos:** Endpoints hardcodeados; secretos pueden filtrarse en logs.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá exponer endpoints centralizados para operaciones de propiedades.

### REQ-UBI-002 — Ubiquitous
El sistema deberá hashear contraseñas antes de almacenar/transmitir.

### REQ-EVT-001 — Event-Driven
Cuando se solicita recuperación, el sistema deberá generar token seguro.

### REQ-UNW-001 — Unwanted
Si la respuesta incluye credenciales, entonces el sistema deberá sanitizar antes de logs.

### REQ-OPT-001 — Optional Feature
Donde existan claves API, el sistema deberá leerlas desde `--dart-define`.
