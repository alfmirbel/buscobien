# Epic: Seguridad, Encriptación y Endpoints (40_security)

**Directorio:** `lib\40_security\`  
**Archivos:** `direccionip.dart`, `encriptar.dart`, `generate_hash.dart`, `generate_reset_token.dart`, `urls_endpoints_espacios.dart`  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Arquitectura segura: Flutter 0 credenciales DB | Usuario final | Datos protegidos (password hash, tokens, JWT en secure storage) | Hash SHA-256, tokens reset 1h, AES-256 (legacy) |
| | Backend (Node.js API) | Recibe credenciales solo vía headers Basic Auth / JWT | `direccionip.dart` creds por `--dart-define` |
| | Desarrollador | Endpoints tipados por tipo de espacio (5 categorías) | `urls_endpoints_espacios.dart` maps |

---

## User Story Mapping

```
App necesita credenciales / hash / token / endpoint
       │
       ▼
┌─────────────────────────────────────────────────────┐
│ lib\40_security\                                    │
│ - direccionip.dart: COUCHDB_USER/PASS/URL (env)     │
│ - encriptar.dart: AES-256 (deprecated → secure)     │
│ - generate_hash.dart: MD5/SHA1/SHA256 + validaPass  │
│ - generate_reset_token.dart: UUIDv4→SHA256 + expiry │
│ - urls_endpoints_espacios.dart: 5 tipos → DB names  │
└─────────────────────────────────────────────────────┘
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-SEC-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-SEC-001 | **Ubicuo** | El sistema **nunca** tendrá credenciales CouchDB en código — `username`, `password`, `direccionip` se inyectan en compile-time vía `--dart-define-from-file=defines.json` y se acceden con `String.fromEnvironment()`. | `lib\40_security\direccionip.dart:5-7` | En código |
| REQ-SEC-002 | **Ubicuo** | El sistema validará passwords comparando `SHA-256(password_input)` contra hash almacenado (nunca texto plano). | `lib\40_security\generate_hash.dart:20-25` `validaPassword` | En código |
| REQ-SEC-003 | **Evento** | Cuando se solicite recuperación de contraseña, el sistema generará token: `UUID v4 → SHA-256 hex` + `expiry = now(UTC) + 1 hora` ISO8601. | `lib\40_security\generate_reset_token.dart:10-25` | En código |
| REQ-SEC-004 | **Estado** | Mientras un token de reset no haya expirado (`isTokenValid` compara UTC now vs expiry), el sistema permitirá cambio de password. | `generate_reset_token.dart:27-32` | En código |
| REQ-SEC-005 | **Ubicuo** | El sistema mapeará **5 tipos de espacio** a nombres de bases CouchDB distintas para **captura** y **publicados**:<br>• Normales → `buscobien_casas_comprados_normales` / `buscobien_publicados_normales`<br>• Destacados → `buscobien_casas_comprados_destacados` / `buscobien_publicados_destacados`<br>• Superdestacados → `buscobien_casas_comprados_superdestacados` / `buscobien_publicados_superdestacados`<br>• Oportunidades → `buscobien_casas_comprados_oportunidades` / `buscobien_publicados_oportunidades`<br>• Remates → `buscobien_casas_comprados_remates` / `buscobien_publicados_remates` | `lib\40_security\urls_endpoints_espacios.dart:5-20` | En código |
| REQ-SEC-006 | **No Deseado** | Si `encriptar.dart` se use (funciones `@Deprecated`), el sistema usará **AES-256 con key/IV hardcoded** en memoria (`Key.fromSecureRandom(32)` pero `ivString` fijo) y `SharedPreferences` — **no seguro para producción**. | `lib\40_security\encriptar.dart:15-35` `@Deprecated` | Legacy / Riesgo |
| REQ-SEC-007 | **No Deseado** | Si `generate_hash.dart` use `MD5` o `SHA1` (disponibles), el sistema **no** lo impedirá — solo `SHA-256` debe usarse para passwords. | `generate_hash.dart:5-15` MD5/SHA1 expuestos | Riesgo |
| REQ-SEC-008 | **Complejo** | Mientras la app esté en móvil (android/ios), el sistema almacenará JWT en `flutter_secure_storage`; en Web/Windows usará `shared_preferences` (ver `session_storage.dart`). | `lib\10_user_login\usuario_login\session_storage.dart` | En código |
| REQ-SEC-009 | **Ubicuo** | El sistema expondrá `generateMD5Hash`, `generateSHA1Hash`, `generateSHA256Hash` como utilidades de hashing genérico (no solo passwords). | `generate_hash.dart:5-18` | En código |

---

## Trazabilidad a Código

| Componente | Archivo | Líneas |
|------------|---------|--------|
| Credenciales env (`String.fromEnvironment`) | `direccionip.dart` | 5-7 |
| AES-256 `Encrypter` + key/IV random | `encriptar.dart` | 10-25 |
| `@Deprecated` AES functions + SharedPrefs | `encriptar.dart` | 27-55 |
| MD5/SHA1/SHA256 + `validaPassword` | `generate_hash.dart` | 1-25 |
| `generateResetToken` (UUID→SHA256) | `generate_reset_token.dart` | 10-20 |
| `generateTokenExpiry` (UTC+1h ISO8601) | `generate_reset_token.dart` | 22-25 |
| `isTokenValid` (parse ISO8601 UTC) | `generate_reset_token.dart` | 27-32 |
| `endpointsCaptura` / `endpointsPublicados` maps | `urls_endpoints_espacios.dart` | 5-20 |

---

## Notas de Seguridad

- **Flutter nunca toca CouchDB**: Credencials solo en Node.js API (repo separado). `direccionip.dart` es solo para que Flutter sepa la URL base de la API.
- **AES en `encriptar.dart` está DEPRECADO**: Migración en curso a `flutter_secure_storage` (ver comentarios en código).
- **SHA-256 para passwords**: Único algoritmo aprobado para credenciales.
- **Tokens reset 1 hora**: Expiración corta por seguridad.
- **5 tipos de espacio = 10 DBs CouchDB**: Separación física por categoría de publicación.