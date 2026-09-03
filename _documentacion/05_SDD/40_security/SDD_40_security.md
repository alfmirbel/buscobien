# SDD — Módulo 40_security (BuscoBien)
## Especificación de Requerimientos (EARS)
**Directorio fuente:** `lib/40_security`  
**Arquitectura:** Flutter + CouchDB + Crypto  
**Propósito:** Gestión de seguridad de la aplicación: credenciales, hashing, cifrado, tokens de reset y endpoints

---

## 1. Requerimientos Ubicuos

### 1.1 Credenciales de CouchDB
- **REQ-SEC-001:** El sistema deberá obtener las credenciales de CouchDB desde variables de entorno definidas en tiempo de compilación.
- **REQ-SEC-002:** El sistema deberá exponer constantes globales para `username`, `password` y `direccionip`.
- **REQ-SEC-003:** El sistema deberá utilizar `String.fromEnvironment()` para inyectar credenciales sin hardcodearlas.

### 1.2 Funciones de Hash
- **REQ-SEC-004:** El sistema deberá soportar generación de hashes MD5, SHA1 y SHA256.
- **REQ-SEC-005:** El sistema deberá validar passwords comparando hashes SHA256.
- **REQ-SEC-006:** El sistema deberá generar hashes de 32 caracteres para MD5, 40 para SHA1 y 64 para SHA256.

### 1.3 Cifrado AES
- **REQ-SEC-007:** El sistema deberá soportar cifrado y descifrado AES-256 con IV de 128 bits.
- **REQ-SEC-008:** El sistema deberá generar claves de 32 bytes y IV de 16 bytes de forma segura.

### 1.4 Tokens de Reset
- **REQ-SEC-009:** El sistema deberá generar tokens de reset usando UUID v4 + hash SHA256.
- **REQ-SEC-010:** El sistema deberá generar tokens con expiración de 1 hora en formato ISO8601 UTC.

---

## 2. Requerimientos Controlados por Eventos

### 2.1 Obtención de Credenciales
- **REQ-CRED-001:** Cuando la aplicación se compila con `--dart-define=COUCHDB_USER=admin`, el sistema deberá exponer `username = "admin"`.
- **REQ-CRED-002:** Cuando la aplicación se compila con `--dart-define=COUCHDB_PASSWORD=secret`, el sistema deberá exponer `password = "secret"`.
- **REQ-CRED-003:** Cuando la aplicación se compila con `--dart-define=COUCHDB_URL=https://citigov.cloud:6984`, el sistema deberá exponer `direccionip = "https://citigov.cloud:6984"`.
- **REQ-CRED-004:** Cuando el sistema no recibe las variables de entorno, el sistema deberá exponer cadenas vacías.

### 2.2 Generación de Hashes
- **REQ-HASH-001:** Cuando el sistema necesita generar un hash MD5, el sistema deberá codificar la entrada en UTF8 y aplicar `md5.convert()`.
- **REQ-HASH-002:** Cuando el sistema necesita generar un hash SHA1, el sistema deberá codificar la entrada en UTF8 y aplicar `sha1.convert()`.
- **REQ-HASH-003:** Cuando el sistema necesita generar un hash SHA256, el sistema deberá codificar la entrada en UTF8 y aplicar `sha256.convert()`.
- **REQ-HASH-004:** Cuando el sistema necesita validar un password, el sistema deberá generar el hash SHA256 del password ingresado y compararlo con el hash almacenado.
- **REQ-HASH-005:** Cuando el sistema valida un password correcto, el sistema deberá retornar `true`.
- **REQ-HASH-006:** Cuando el sistema valida un password incorrecto, el sistema deberá retornar `false`.

### 2.3 Cifrado AES
- **REQ-AES-001:** Cuando el sistema inicializa cifrado AES, el sistema deberá crear una clave de 32 bytes con `Key.fromSecureRandom(32)`.
- **REQ-AES-002:** Cuando el sistema inicializa cifrado AES, el sistema deberá crear un IV de 16 bytes con `IV.fromSecureRandom(16)`.
- **REQ-AES-003:** Cuando el sistema cifra texto plano, el sistema deberá usar `encrypter.encrypt(plainText, iv: iv16)`.
- **REQ-AES-004:** Cuando el sistema descifra texto, el sistema deberá usar `encrypter.decrypt(encrypted, iv: iv16)`.

### 2.4 Tokens de Reset
- **REQ-TOK-001:** Cuando el sistema genera un token de reset, el sistema deberá generar un UUID v4 con `Uuid().v4()`.
- **REQ-TOK-002:** Cuando el sistema genera un token de reset, el sistema deberá aplicar hash SHA256 al UUID.
- **REQ-TOK-003:** Cuando el sistema calcula la expiración, el sistema deberá sumar 1 hora a la fecha actual UTC.
- **REQ-TOK-004:** Cuando el sistema valida un token, el sistema deberá parsear la fecha de expiración y compararla con la fecha actual UTC.
- **REQ-TOK-005:** Cuando el token está vigente, el sistema deberá retornar `true`.
- **REQ-TOK-006:** Cuando el token está expirado, el sistema deberá retornar `false`.
- **REQ-TOK-007:** Cuando el token tiene formato inválido, el sistema deberá capturar la excepción y retornar `false`.

### 2.5 Endpoints de Espacios
- **REQ-END-001:** Cuando el sistema necesita operar con espacios "Normales", el sistema deberá obtener el endpoint `buscobien_casas_comprados_normal`.
- **REQ-END-002:** Cuando el sistema necesita operar con espacios "Destacados", el sistema deberá obtener el endpoint `buscobien_casas_comprados_destacado`.
- **REQ-END-003:** Cuando el sistema necesita operar con espacios "Superdestacados", el sistema deberá obtener el endpoint `buscobien_casas_comprados_super`.
- **REQ-END-004:** Cuando el sistema necesita operar con espacios "Oportunidades", el sistema deberá obtener el endpoint `buscobien_casas_comprados_oportunidad`.
- **REQ-END-005:** Cuando el sistema necesita operar con espacios "Remates", el sistema deberá obtener el endpoint `buscobien_casas_comprados_remate`.
- **REQ-END-006:** Cuando el sistema necesita publicar espacios "normales", el sistema deberá obtener el endpoint `buscobien_publicados_normal`.
- **REQ-END-007:** Cuando el sistema necesita publicar espacios "destacados", el sistema deberá obtener el endpoint `buscobien_publicados_destacado`.
- **REQ-END-008:** Cuando el sistema necesita publicar espacios "superdestacados", el sistema deberá obtener el endpoint `buscobien_publicados_super`.
- **REQ-END-009:** Cuando el sistema necesita publicar espacios "oportunidades", el sistema deberá obtener el endpoint `buscobien_publicados_oportunidad`.
- **REQ-END-010:** Cuando el sistema necesita publicar espacios "remates", el sistema deberá obtener el endpoint `buscobien_publicados_remate`.

---

## 3. Requerimientos Controlados por Estados

### 3.1 Estado: Cifrado AES Activo
- **REQ-CIF-ACT-001:** Mientras el sistema tiene una clave AES y IV activos, el sistema deberá poder cifrar y descifrar textos.
- **REQ-CIF-ACT-002:** Mientras el sistema tiene un encrypter activo, el sistema deberá mantener el modo AES-CBC.

### 3.2 Estado: Token Vigente
- **REQ-TOK-VIG-001:** Mientras el token de reset no ha expirado, el sistema deberá permitir el cambio de contraseña.
- **REQ-TOK-VIG-002:** Mientras el token es válido, el sistema deberá retornar `true` en `isTokenValid()`.

### 3.3 Estado: Token Expirado
- **REQ-TOK-EXP-001:** Mientras el token de reset ha expirado, el sistema deberá denegar el cambio de contraseña.
- **REQ-TOK-EXP-002:** Mientras el token está expirado, el sistema deberá retornar `false` en `isTokenValid()`.

### 3.4 Estado: Migración de Seguridad
- **REQ-MIG-001:** Mientras el sistema mantiene funciones AES legacy, el sistema deberá marcarlas como `@Deprecated`.
- **REQ-MIG-002:** Mientras el sistema migra a `flutter_secure_storage`, el sistema debera mantener compatibilidad con las funciones legacy.

---

## 4. Requerimientos de Comportamiento No Deseado

### 4.1 Errores de Parsing
- **REQ-FAL-001:** Si el token de reset tiene formato inválido, entonces el sistema deberá capturar la excepción de `DateTime.parse` y retornar `false`.
- **REQ-FAL-002:** Si la fecha de expiración no es parseable, entonces el sistema deberá considerar el token como inválido.

### 4.2 Errores de Cifrado
- **REQ-FAL-003:** Si la clave AES es incorrecta al descifrar, entonces el sistema deberá retornar texto que no coincide con el original.
- **REQ-FAL-004:** Si el IV es incorrecto, entonces el sistema deberá fallar al descifrar.

### 4.3 Errores de Endpoints
- **REQ-FAL-005:** Si el tipo de espacio consultado no existe en el mapa, entonces el sistema deberá retornar `null`.
- **REQ-FAL-006:** Si el tipo de publicación consultado no existe, entonces el sistema deberá retornar `null`.

---

## 5. Requerimientos de Funciones Opcionales

### 5.1 Cifrado AES Legacy
- **REQ-OPT-001:** Donde el sistema mantenga compatibilidad con versiones anteriores, el sistema deberá exponer funciones AES legacy (`encryptWithAES`, `decryptWithAES`).
- **REQ-OPT-002:** Donde el sistema usa `flutter_secure_storage`, el sistema deberá almacenar credenciales en el keychain/keystore del sistema operativo.

### 5.2 Tokens de Reset
- **REQ-OPT-003:** Donde el sistema implemente recuperación de contraseña, el sistema deberá generar tokens con expiración de 1 hora.
- **REQ-OPT-004:** Donde el sistema valide tokens, el sistema deberá comparar la fecha de expiración con la fecha actual UTC.

---

## 6. Requerimientos Complejos

### 6.1 Flujo de Autenticación Completo
- **REQ-COM-001:** Mientras el usuario inicia sesión, cuando el sistema recibe credenciales, entonces deberá generar hash SHA256 del password, compararlo con el hash almacenado, y si coincide, permitir el acceso.

### 6.2 Flujo de Reset de Contraseña
- **REQ-COM-002:** Mientras el usuario solicita reset, cuando el sistema genera el token, entonces deberá generar UUID v4, aplicar SHA256, calcular expiración de 1 hora, almacenar el token y enviarlo al usuario.

### 6.3 Flujo de Migración de Seguridad
- **REQ-COM-003:** Mientras el sistema migra de AES legacy a `flutter_secure_storage`, cuando el usuario actualiza la app, entonces deberá migrar las credenciales almacenadas al nuevo sistema seguro.

---

## 7. Modelos de Datos

### 7.1 Credenciales CouchDB
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `username` | String | Usuario de CouchDB desde `COUCHDB_USER` |
| `password` | String | Contraseña de CouchDB desde `COUCHDB_PASSWORD` |
| `direccionip` | String | URL base de CouchDB desde `COUCHDB_URL` |

### 7.2 Token de Reset
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `token` | String | Hash SHA256 de UUID v4 |
| `expiry` | String | Fecha de expiración en ISO8601 UTC |
| `valid` | bool | Validez del token |

---

## 8. Funciones de Seguridad

### 8.1 generate_hash.dart
| Función | Entrada | Salida | Descripción |
|---------|---------|--------|-------------|
| `generateMD5Hash(input)` | String | String (32 chars) | Hash MD5 |
| `generateSHA1Hash(input)` | String | String (40 chars) | Hash SHA1 |
| `generateSHA256Hash(input)` | String | String (64 chars) | Hash SHA256 |
| `validaPassword(password, hashPassword)` | String, String | bool | Valida password contra hash |

### 8.2 generate_reset_token.dart
| Función | Entrada | Salida | Descripción |
|---------|---------|--------|-------------|
| `generateResetToken()` | - | String (64 chars) | UUID v4 + SHA256 |
| `generateTokenExpiry()` | - | String (ISO8601) | Fecha actual + 1 hora UTC |
| `isTokenValid(tokenExpiry)` | String | bool | Valida si token no ha expirado |

### 8.3 encriptar.dart
| Función | Entrada | Salida | Descripción |
|---------|---------|--------|-------------|
| `encryptWithAES(key, plainText)` | String, String | Encrypted | Cifra texto (legacy) |
| `decryptWithAES(key, encryptedData)` | String, Encrypted | String | Descifra texto (legacy) |

### 8.4 direccionip.dart
| Constante | Fuente | Descripción |
|-----------|--------|-------------|
| `username` | `COUCHDB_USER` | Usuario CouchDB |
| `password` | `COUCHDB_PASSWORD` | Contraseña CouchDB |
| `direccionip` | `COUCHDB_URL` | URL base del servidor |

---

## 9. Reglas de Negocio

- **RN-001:** Las credenciales de CouchDB nunca deben hardcodearse; siempre se obtienen de variables de entorno.
- **RN-002:** Los passwords nunca se almacenan en texto plano; siempre se guardan como hash SHA256.
- **RN-003:** Los tokens de reset tienen una validez máxima de 1 hora.
- **RN-004:** La clave AES debe ser de 256 bits (32 bytes) y el IV de 128 bits (16 bytes).
- **RN-005:** Se recomienda usar `flutter_secure_storage` en lugar de cifrado AES manual.
- **RN-006:** Los endpoints de CouchDB se definen en mapas constantes según el tipo de espacio.
- **RN-007:** La autenticación HTTP utiliza Basic Auth con base64 de `username:password`.

---

## 10. Endpoints CouchDB por Tipo de Espacio

### 10.1 Endpoints de Captura
| Tipo de Espacio | Endpoint |
|-----------------|----------|
| Normales | `buscobien_casas_comprados_normal` |
| Destacados | `buscobien_casas_comprados_destacado` |
| Superdestacados | `buscobien_casas_comprados_super` |
| Oportunidades | `buscobien_casas_comprados_oportunidad` |
| Remates | `buscobien_casas_comprados_remate` |

### 10.2 Endpoints de Publicados
| Tipo de Espacio | Endpoint |
|-----------------|----------|
| normales | `buscobien_publicados_normal` |
| destacados | `buscobien_publicados_destacado` |
| superdestacados | `buscobien_publicados_super` |
| oportunidades | `buscobien_publicados_oportunidad` |
| remates | `buscobien_publicados_remate` |

---

## 11. Estructura de Archivos

```
lib/40_security/
├── direccionip.dart                    # Variables de entorno COUCHDB_USER, COUCHDB_PASSWORD, COUCHDB_URL
├── generate_hash.dart                  # MD5, SHA1, SHA256, validación de passwords
├── generate_reset_token.dart           # Tokens de reset con UUID v4 + SHA256, expiración 1h
├── encriptar.dart                      # AES-256 legacy (deprecated), migrate a flutter_secure_storage
└── urls_endpoints_espacios.dart        # Mapa de endpoints CouchDB por tipo de espacio
```

---

## 12. Dependencias Técnicas

- **Crypto:** `package:crypto` para MD5, SHA1, SHA256
- **UUID:** `package:uuid/uuid.dart` para generación de UUID v4
- **Encriptación:** `package:encrypt` para AES (legacy, deprecated)
- **Almacenamiento seguro:** `flutter_secure_storage` (recomendado)
- **Variables de entorno:** `String.fromEnvironment()` para inyección en compile-time

---

## 13. Consideraciones de Seguridad

- **Compile-time injection:** Las credenciales se inyectan en compile-time, no en runtime.
- **No hardcoding:** No se almacenan secretos en el código fuente.
- **Hashing:** Los passwords se hashean con SHA256 (en producción se recomienda bcrypt/argon2).
- **Token expiry:** Los tokens de reset expiran en 1 hora para minimizar riesgo.
- **AES migration:** Se marca como deprecated el cifrado manual en favor de almacenamiento seguro del sistema operativo.
