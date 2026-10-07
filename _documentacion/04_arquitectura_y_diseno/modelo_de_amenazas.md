# Modelo de amenazas (STRIDE) — estado actual

**Revisión de exactitud:** 2026-10-07. Cada hallazgo se verificó en el código (`lib/`, `server/`); la columna *Evidencia* indica dónde.  
**Alcance:** cliente Flutter, acceso a CouchDB, microservicio de correo y flujo de recuperación de contraseña. La configuración real del servidor (firewall, CORS de CouchDB, usuarios y roles de CouchDB, copias de seguridad) **no se pudo verificar desde el repositorio** y queda como pendiente de confirmar.  
**Contexto:** la migración a *nginx + API Node.js + JWT* está pendiente; varias amenazas desaparecen con ella (marcadas ⟶ *mitiga la migración*).

## 1. Activos

| Activo | Dónde vive |
| :--- | :--- |
| Credenciales de administrador de CouchDB | Compiladas en la app (`COUCHDB_USER` / `COUCHDB_PASSWORD`) |
| Datos personales de usuarios (nombre, correo, celular, RFC, dirección) | Bases `buscobien_usuarios*` |
| Hash de contraseña y token de recuperación | Documento del usuario (`usuario.claveacceso`, `usuario.reset_token`) |
| Mensajes privados y de grupo | `buscobien_mensajes`, `buscobien_grupos_mensajes` |
| Catálogo de propiedades y fotos | Bases de propiedades y de fotos |

## 2. Hallazgos por categoría STRIDE

| # | Cat. | Amenaza | Evidencia | Severidad | Mitigación propuesta |
| :--- | :--- | :--- | :--- | :--- | :--- |
| T1 | **E**levation / **I**nfo | Cualquiera que extraiga las credenciales del binario o del bundle Web obtiene acceso de administrador a CouchDB y puede leer, modificar o borrar todas las bases | 34 archivos usan `direccionip`, `username`, `password` con Basic Auth (`lib/40_security/direccionip.dart`) | **Crítica** | Migrar a API + JWT; credenciales de CouchDB solo en el servidor. ⟶ *mitiga la migración* |
| T2 | **S**poofing | Un atacante con acceso directo a CouchDB puede suplantar a cualquier usuario escribiendo documentos con sus ids | Los permisos dependen solo de la credencial de administrador compartida | **Crítica** | Autorización por usuario en la API; validar `senderId` contra el JWT |
| T3 | **T**ampering | La autenticación se hace en el cliente: consulta la vista y compara el hash SHA-256 | `session_repository.dart`, `generate_hash.dart` | Alta | Autenticar en el servidor; usar un algoritmo de derivación (bcrypt/argon2) con sal |
| T4 | **I**nfo | Hash SHA-256 sin sal expuesto a quien lea la vista de usuarios (`claveacceso`) | Vistas `vistaUserPass`, `vistaIdUserPassByNAME` emiten `claveacceso` | Alta | No exponer el hash por vistas; sal por usuario |
| T5 | **S**poofing | El endpoint de correo no tiene autenticación: cualquiera puede pedir enviar un correo de recuperación con un token y destinatario arbitrarios (phishing con dominio legítimo) | `server/buscobien-mailer/routes/recovery.js`, `server.js` (`cors()` abierto) | Alta | Autenticación entre servicios (clave/JWT), limitar origen y tasa |
| T6 | **T**ampering | `nombreUsuario` se inserta en la plantilla HTML del correo sin escapar | `recovery.js` (`html.replace(/{{nombreUsuario}}/g, …)`) | Media | Escapar HTML en el servidor |
| T7 | **I**nfo | La app llama al mailer por `http://citigov.cloud:3001` (sin TLS): el token de recuperación viaja en claro | `_mailerUrl` en `password_recovery_repository.dart` | Alta | Usar HTTPS detrás del proxy (nginx/Apache) |
| T8 | **R**epudiation | No hay bitácora de auditoría de operaciones de negocio (la base `buscobien_auditoria` del diccionario no se usa en el cliente) | Sin referencias en `lib/` | Media | Registro en servidor por usuario autenticado |
| T9 | **I**nfo | En Web la sesión se guarda en `shared_preferences` (almacenamiento del navegador, accesible a scripts de la página) | `session_storage.dart` (`WebSessionStorage`) | Media | Cookies `HttpOnly` con JWT de vida corta |
| T10 | **I**nfo | `routeGenerate` registra nombre y argumentos de cada navegación; los argumentos pueden contener datos de propiedades o del token | `app_routes.dart` (`debugPrintLevels(1, …)`) | Baja | Desactivar logs en producción; no registrar argumentos sensibles |
| T11 | **D**enial | Sin límite de intentos de login ni de solicitudes de recuperación | Sin control en `session_repository.dart` / mailer | Media | *Rate limiting* en nginx/API |
| T12 | **I**nfo | Datos de contacto de ejemplo escritos en `routes_parameters.dart` (posible dato personal real en el repositorio) | `lib/07_routes/routes_parameters.dart:94-100` | Media | Sustituir por valores ficticios y revisar el historial de git |
| T13 | **S**poofing | App Links / Universal Links sin configurar: paquete `com.example.buscobien`, huella y `TEAM_ID` con valores de ejemplo | `server/well-known/*`, `android/app/build.gradle*` | Media | Definir paquete definitivo y huellas reales |

Nota: al cambiar la contraseña, `actualizarPassword` elimina `reset_token` y `token_expiry` del documento (verificado), por lo que el token no se reutiliza.

## 3. Prioridad

1. T1–T4 (acceso directo y autenticación en el cliente) → resuelve la migración a API + JWT.
2. T5–T7 (mailer): se pueden corregir de forma independiente de la migración (TLS, autenticación, escape).
3. T12–T13: limpieza de repositorio y configuración de enlaces.
4. T8–T11: con la API.

## 4. Pendientes de verificar en el servidor

- Roles y permisos reales en CouchDB (¿existe un usuario de solo lectura por base?).
- Si el puerto 6984 está expuesto a Internet, reglas de firewall y CORS de CouchDB.
- Copias de seguridad y su frecuencia (ver [`runbook_operacion.md`](../08_operacion_guias_y_despliegue/runbook_operacion.md)).
