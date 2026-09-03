# Inventario de Elementos — Seguridad, Encriptación y Endpoints (40_security)

**Directorio:** `lib\40_security\`
**Total archivos `.dart` fuente:** 5
**Epic asociado:** [`02_Epics_EARS/40_security.md`](../../02_Epics_EARS/40_security.md)
**Features BDD:** [`03_Features_BDD/40_security/seguridad_endpoints.feature`](../../03_Features_BDD/40_security/seguridad_endpoints.feature)
**User Stories:** [`04_User_Stories/40_security.md`](../../04_User_Stories/40_security.md) (5 US)
**Fecha:** 2026-08-12
**Fuente:** Ingeniería inversa

> **Nota de corrección:** este archivo fue reescrito el 2026-08-12. Anteriormente estaba contaminado con contenido de `41_connectivity` y `42_sistema_operativo`. Este archivo documenta únicamente `40_security`.

---

## Tabla 1 — Resumen de componentes por rol funcional

| # | Componente | Archivo | Tipo | Rol funcional | US-SEC |
|---|-------------|---------|------|----------------|--------|
| 1 | `username`, `password`, `direccionip` | `direccionip.dart` | Constantes compile-time | Credenciales inyectadas vía `--dart-define` | US-SEC-001 |
| 2 | `generateMD5Hash`, `generateSHA1Hash`, `generateSHA256Hash`, `validaPassword`, `myText`, `hash` | `generate_hash.dart` | Funciones puras | Hashing genérico + validación password | US-SEC-002 |
| 3 | `generateResetToken`, `generateTokenExpiry`, `isTokenValid` | `generate_reset_token.dart` | Funciones puras | Token recuperación + expiry UTC 1h | US-SEC-003 |
| 4 | `endpointsCaptura`, `endpointsPublicados` | `urls_endpoints_espacios.dart` | `Map<String, String>` const | Mapeo 5 tipos → 10 DBs CouchDB | US-SEC-004 |
| 5 | `ivAES`, `keyAES`, `decryptWithAES`, `initStringLocalStorage`, `encryptWithAES` | `encriptar.dart` | Funciones `@Deprecated` | AES-256 legacy (no usar, deuda migración) | US-SEC-005 |

---

## Tabla 2 — Detalle por archivo

| # | Archivo | Símbolos / Funciones | Líneas | Dependencias | Estado | Comentario / Deuda |
|---|---------|----------------------|--------|---------------|--------|--------------------|
| 1 | `direccionip.dart` | `username`, `password`, `direccionip` (todas `const String.fromEnvironment`) | 3 | — | ✓ ok | 3 constantes compile-time. Vacías por defecto (seguras); el build `-dart-define-from-file=defines.json` las rellena. **`direccionip` sigue mal llamado**: apunta a la URL de la API Node.js, no a CouchDB directamente (ver AGENTS.md "Flutter nunca conecta a CouchDB") |
| 2 | `generate_hash.dart` | `generateMD5Hash`, `generateSHA1Hash`, `generateSHA256Hash`, `validaPassword`, (+ constants `myText`, `hash` que parecen tests inline) | 38 | `crypto`, `convert` | ✓ ok / ⚠ deuda | `validaPassword` compara con `==` (no constant-time) — vulnerable a timing attacks teóricos. `myText`/`hash` son código demo inline que deben eliminarse. MD5/SHA1 disponibles para usos no-security pero **política** prohíbe su uso para passwords |
| 3 | `generate_reset_token.dart` | `generateResetToken()`, `generateTokenExpiry()`, `isTokenValid(tokenExpiry)` | 23 | `crypto`, `uuid`, `convert` | ✓ ok | Token = `SHA256(UUID v4)`. Expiry UTC ISO8601 + 1h. `isTokenValid` parsea y compara UTC now vs expiry. Pequeño (23 líneas) — atomic, bien diseñado |
| 4 | `urls_endpoints_espacios.dart` | `endpointsCaptura` (Map), `endpointsPublicados` (Map) | 16 | — | ⚠ inconsistencia | Mapeo 5 tipos → 10 DBs. **Inconsistencia mayúsculas**: `endpointsCaptura['Destacados']` (D mayúscula) vs `endpointsPublicados['destacados']` (minúscula). Causa bugs sutiles al no encontrar key. Estandarizar a minúsculas |
| 5 | `encriptar.dart` | `ivAES` (const), `keyAES` (const), `decryptWithAES`, `encryptWithAES`, `initStringLocalStorage`, `getFromLocalStorage` (todas `@Deprecated`) | 55 | `encrypt`, `shared_preferences`, `flutter_secure_storage` | ✗ deprecated | **IV fijo y key hardcoded** — inseguro. Migración a `flutter_secure_storage` en curso. Removal planificado. Pendiente el borrado completo cuando el último consumidor deje de usarlo |

---

## Notas críticas

- **Carpeta de seguridad concentra riesgo crítico** —есмотря al tamaño pequeño (5 archivos, 135 líneas totales), es el corazón de seguridad: cualquier bug aquí comprometería a todos los usuarios.
- **`encriptar.dart` es deuda prioritaria**: el IV fijo AES es matemáticamente roto para cifrado de múltiples mensajes idénticos. Burn-down: eliminar el archivo cuando `10_user_login` y `08_pantallas/tu_cuenta` ya no lo importen.
- **`direccionip` nombre equívoco**: llama a la constante como si fuera la IP de CouchDB, pero es la URL de la API Node.js. Renombrar a `apiBaseUrl` (breaking change, requires update a consumidores).
- **Inconsistencia keys endpoints**: documentar y estandarizar. Bug latente en `pagina_detalle_listas.dart` fallback donde intenta leer `'destacados'` en ambos mapas — si uno tiene key incorrecta después del rename, falla silenciosamente al fallback.
- **`validaPassword` security bug menor**: comparación `==` de hashes permite timing attack teórico. Refactor: `crypto.timingSafeEquals` o bucle de XOR.
- **`myText` y `hash` en `generate_hash.dart`** (líneas 28-30): código demo/test inline en producción — debe eliminarse.
- **`generate_reset_token.dart` es el archivo más limpio**: 23 líneas, atomic, sin deuda aparente. Modelo para los demás.
- **Sin tests**: ninguna función de validación de password, generación de token, ni de maps endpoints tiene test unitario. Crítico por la naturaleza del módulo.
- **`defines.json` en `.gitignore`**: confirmar que efectivamente está ahí — una fuga al repo sería catastrófica.
