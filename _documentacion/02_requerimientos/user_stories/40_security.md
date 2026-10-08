# User Stories — Seguridad, Encriptación y Endpoints (40_security)

> **Nota de exactitud (2026-10-07):** donde este documento menciona Dio, interceptor JWT o que Flutter no toca CouchDB, describe la arquitectura **objetivo**. El código actual usa el paquete `http`, Basic Auth contra CouchDB con credenciales compiladas (`--dart-define`) y no obtiene ni envía JWT; `SessionStorage` usa `flutter_secure_storage` en Android/iOS/Windows y `shared_preferences` solo en Web. Ver [arquitectura general](../../04_arquitectura_y_diseno/arquitectura_general_buscobien.md).

**Directorio:** `lib\40_security\` (5 archivos `.dart`)
**Epic asociado:** [`02_requerimientos/epics_ears/40_security.md`](../epics_ears/40_security.md)
**Feature BDD:** [`03_analisis_funcional/features_analisis/seguridad_endpoints.feature`](../../03_analisis_funcional/features_analisis/40_security/seguridad_endpoints.feature)
**Inventario:** [`05_desarrollo_y_especificaciones_tecnicas/inventario_elementos/elementos_40_security.md`]()
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

> **Nota de corrección:** este archivo fue reescrito el 2026-08-12. Anteriormente estaba contaminado dentro del consolidado `03_listas.md`. Este archivo documenta únicamente `40_security`.

---

## US-SEC-001: Credenciales CouchDB nunca en código Flutter (inyección compile-time)

### Card
**Como** arquitecto de seguridad
**Quiero** que el código Flutter nunca contenga credenciales de CouchDB ni de la API
**Para** prevenir filtración de secretos al compilar o desensamblar el bundle.

### Conversation
- `direccionip.dart` (3 líneas) accede a los valores:
  - `username = String.fromEnvironment('COUCHDB_USER')`
  - `password = String.fromEnvironment('COUCHDB_PASSWORD')`
  - `direccionip = String.fromEnvironment('COUCHDB_URL')` (URL base de la API Node.js)
- Las credenciales viven en `defines.json` (archivo en `.gitignore`, **no en el repo**) y se inyectan en compile-time vía `--dart-define-from-file=defines.json` (ver `AGENTS.md`).
- **Crucial:** Flutter **nunca** se conecta a CouchDB directamente. El valor `direccionip` apunta a la URL de la API Node.js, no al puerto 6984 de CouchDB (ese lo abre la API en el servidor).
- Sin `--dart-define-from-file=defines.json`, los valores quedan como `String.empty` — la app no podrá autenticarse pero no expone secretos en el bundle.

### Confirmation
- ✓ Al descompilar el bundle Flutter no aparecen cadenas con `username` / `password` reales — sólo placeholders vacíos.
- ✓ Sin `defines.json`, los calls a la API fallan (401/403) y no exponen credenciales.
- ✓ El archivo `defines.json` está en `.gitignore` y nunca se commitea.
- ✓ El build command (`flutter build web --wasm --dart-define-from-file=defines.json`) requiere el archivo — si falta, build falla en runtime.

**Trazabilidad:** `REQ-SEC-001` · Archivos: `direccionip.dart`

---

## US-SEC-002: Validar passwords con SHA-256 (nunca texto plano)

### Card
**Como** usuario
**Quiero** que el sistema compare mi contraseña con un hash SHA-256, nunca con texto plano
**Para** que si la base de datos se compromete, mi contraseña no se filtre.

### Conversation
- `generate_hash.dart` (32 líneas) expone 3 hashers genéricos: `generateMD5Hash`, `generateSHA1Hash`, `generateSHA256Hash` — todos disponibles, pero **sólo SHA-256** se usa para passwords por política.
- `validaPassword(passwordPlano, hashed)` calcula `generateSHA256Hash(passwordPlano)` y lo compara con `hashed` — **constante-time compare** deseable pero la implementación actual usa `==` plain (deuda menor).
- Al registrarse, el password se convierte a `SHA-256(userId + pass)` y se almacena en `buscobien_usuarios` (ver `10_user_login/usuario_registro`). Para login, el hash del input se compara con el almacenado.
- Los IDs de usuario (sea `_id` CouchDB) se construyen con `SHA-256(userId + pass)` para prevenir duplicados exactos (dos usuarios con mismas credenciales).
- **Comentario crítico de seguridad:** MD5 y SHA1 se exponen para usos no-security (ej. dedup de blobs, cache keys). Política: nunca usarlos para passwords.

### Confirmation
- ✓ Login: el input se hashea SHA-256 y se compara con el hash almacenado.
- ✓ Registro: el `_id` CouchDB del usuario es `SHA-256(userId + pass)` (anti-dup).
- ✓ Nunca se persiste el password en texto plano en CouchDB ni en storage local.
- ✓ MD5/SHA1 están disponibles pero no se usan en flujos de autenticación.

**Trazabilidad:** `REQ-SEC-002`, `REQ-SEC-007`, `REQ-SEC-009` · Archivos: `generate_hash.dart`, interacciona con `10_user_login/usuario_login/*`

---

## US-SEC-003: Generar token de recuperación con expiración 1 hora

### Card
**Como** usuario que olvidé mi password
**Quiero** que la app genere un token seguro con validez de 1 hora
**Para** cambiar mi contraseña mediante un enlace único y temporizado.

### Conversation
- `generate_reset_token.dart` (23 líneas) expone:
  - `generateResetToken()` → `SHA-256(UUID v4 hex)` (128-bit token random crypto-fuerte).
  - `generateTokenExpiry()` → `DateTime.now().toUtc().add(Duration(hours:1)).toIso8601String()` (ISO 8601 UTC).
  - `isTokenValid(tokenExpiry)` → parsea `DateTime.parse(tokenExpiry)` y compara con `DateTime.now().toUtc()` — true si expiry > now.
- Flujo (`10_user_login/PageSolicitarRecuperacion`):
  1. Usuario ingresa email + perfil.
  2. `buscarUsuarioPorCorreo()` Mango query valida que existe.
  3. Genera token + expiry; guarda `reset_token` y `token_expiry` dentro del documento del usuario (base según perfil).
  4. Node.js mailer envía email con deep link (`citigov.cloud:3001`).
  5. Usuario abre link → app valida `isTokenValid(expiry)` → permite cambio.
- **Comentario crítico de seguridad:** el token se guarda en el documento del usuario; si se reenvía el correo, el token anterior se sobrescribe. El tiempo de validez (1h) es deliberadamente corto para minimizar ventanas de abuso.

### Confirmation
- ✓ `generateResetToken()` produce un SHA-256 hex de 64 caracteres derivado de UUID v4.
- ✓ `generateTokenExpiry()` produce ISO 8601 UTC + 1 hora.
- ✓ `isTokenValid` retorna false si el expiry ya pasó.
- ✓ El token se persiste dentro del documento del usuario (`usuario.reset_token`, `usuario.token_expiry`); no existe una base separada de recuperación.
- ✓ Feature BDD: `seguridad_endpoints.feature` escenario "Recuperación de password con token 1h".

**Trazabilidad:** `REQ-SEC-003`, `REQ-SEC-004` · Archivos: `generate_reset_token.dart`, interacciona con `10_user_login/PageSolicitarRecuperacion`, mailer service

---

## US-SEC-004: Tipificar 5 tipos de espacio → 10 bases CouchDB segregadas

### Card
**Como** sistema
**Quiero** mapear 5 tipos de espacio (normales, destacados, etc.) a 10 bases CouchDB distintas (captura + publicados)
**Para** segmentar consultas y optimizar performance por categoría de publicación.

### Conversation
- `urls_endpoints_espacios.dart` (16 líneas) define 2 `Map<String, String>`:
  - `endpointsCaptura` → DBs de captura (donde el usuario promotor edita sus propiedades).
  - `endpointsPublicados` → DBs publicadas (donde se muestran al público en el catálogo).
- Mapeo (5 tipos × 2 fases = 10 DBs):
  - Normales → `buscobien_casas_comprados_normal` / `buscobien_publicados_normal`
  - Destacados → `buscobien_casas_comprados_destacado` / `buscobien_publicados_destacado`
  - Superdestacados → `buscobien_casas_comprados_super` / `buscobien_publicados_super`
  - Oportunidades → `buscobien_casas_comprados_oportunidad` / `buscobien_publicados_oportunidad`
  - Remates → `buscobien_casas_comprados_remate` / `buscobien_publicados_remate`
- Los consumidores (`08_pantallas/propiedades/*`, `03_listas/pagina_detalle_listas.dart` fallback) usan `endpointsPublicados['destacados']` para obtener el nombre de DB correcto.
- **Comentario crítico:** la segregación física por tipo maximiza el rendimiento de consultas por categoría, pero dificulta consultas transversales ("dame todos los destacados Y remates"). Se simula con múltiples queries o un fanout a nivel API si se necesita.

### Confirmation
- ✓ `endpointsCaptura['Destacados'] == 'buscobien_casas_comprados_destacado'`.
- ✓ `endpointsPublicados['destacados'] == 'buscobien_publicados_destacado'`.
- ✓ El fallback en `pagina_detalle_listas.dart` consulta primero `endpointsPublicados` y si falla reintenta con `endpointsCaptura`.
- ✓ 10 bases CouchDB distintas documentadas.

**Trazabilidad:** `REQ-SEC-005` · Archivos: `urls_endpoints_espacios.dart`

---

## US-SEC-005: AES-256 legacy y storage de JWT por plataforma (deuda migración)

### Card
**Como** arquitecto del sistema
**Quiero** documentar que las funciones AES-256 están deprecadas y que el JWT se almacena en `flutter_secure_storage` en móvil y `shared_preferences` en Web (Windows usa `flutter_secure_storage`)
**Para** que el equipo sepa la transición pendiente y por qué se hacen storage diferenciado.

### Conversation
- `encriptar.dart` (51 líneas) tiene funciones marcadas `@Deprecated("use flutter_secure_storage")` que cifran/descifran AES-256 con `Key.fromSecureRandom(32)` + IV fijo `ivString` y persisten en `SharedPreferences`. **Inseguro** para producción (IV fijo permite ataques conocidos-plaintext). Funciona porque la migración a `flutter_secure_storage` está parcialmente completa.
- En móvil (`10_user_login/usuario_login/session_storage.dart`), el JWT se guarda en `flutter_secure_storage` (keychain iOS / keystore Android).
- En Web/WASM/Windows, `flutter_secure_storage` no tiene equivalente seguro → se cae a `shared_preferences` (NO seguro, pero no hay alternativa sin browser API específica).
- **Comentario crítico:**政策和债务:
  - Política: **no usar `encriptar.dart` para datos sensibles** — usar los storage nativos.
  - Deuda: en Web, los JWT quedan en `shared_preferences` (sin cifrar). Riesgo aceptable si HTTPS siempre y el token expira corto. Mitigación futura: usar WebCrypto API con token corto + refresh tokens.
- `direccionip.dart` ya es seguro por compile-time (`String.fromEnvironment`).

### Confirmation
- ✓ `encriptar.dart` tiene anotaciones `@Deprecated` en funciones AES.
- ✓ En Android/iOS, `session_storage.dart` usa `flutter_secure_storage`.
- ✓ En Web (Windows usa `flutter_secure_storage`), cae a `shared_preferences` (deuda documentada).
- ✓ Documentar en `08_pantallas` que el JWT fluye por Dio interceptor (`addInterceptors` adds Authorization header).

**Trazabilidad:** `REQ-SEC-006`, `REQ-SEC-008` · Archivos: `encriptar.dart`, interacciona con `10_user_login/usuario_login/session_storage.dart`, `02_principal_screen` Dio interceptor

---

## Notas de deuda técnica

1. **`encriptar.dart` AES-256 IV fijo**: inseguro. Migración a `flutter_secure_storage` en curso; removal del archivo planificado.
2. **`shared_preferences` para JWT en Web (Windows usa `flutter_secure_storage`)**: no es seguro. Mitigación WebCrypto API en roadmap.
3. **`validaPassword` comparación `==`** (no constant-time): vulnerable a timing attacks teóricos. Refactor a comparación constant-time trivial.
4. **MD5/SHA1 expuestos en `generate_hash.dart`**: por política no se usan para passwords, pero el código no impide su uso. Analizar lint rule que prohíba usos en auth context.
5. **Token reset guardado con `_id = SHA256(userId + token)`**: si se reenvía email, el `_id` cambia y crea un nuevo doc (no sobrescribe el anterior). Deuda: cleanup periódico de tokens expirados.
6. **End-points maps en minúsculas/mayúsculas inconsistentes**: `endpointsCaptura['Destacados']` (D mayúscula) vs `endpointsPublicados['destacados']` (minúscula). Causa bugs sutiles — estandarizar.
7. **Sin tests** de hashing, token validity, ni endpoints mapping.
