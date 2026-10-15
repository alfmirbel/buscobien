# Contrato de interfaces — estado actual

**Revisión de exactitud:** 2026-10-07, contrastado con `lib/` y `server/buscobien-mailer/`.  
**Alcance:** interfaces **realmente usadas** por el cliente Flutter. No existe aún un contrato OpenAPI de la API Node.js objetivo (repositorio separado, pendiente); cuando exista, debe enlazarse desde aquí.

## 1. CouchDB (acceso directo desde el cliente)

- **Base URL:** `COUCHDB_URL` (`--dart-define`, constante `direccionip` en `lib/40_security/direccionip.dart`).
- **Autenticación:** cabecera `Authorization: Basic base64(COUCHDB_USER:COUCHDB_PASSWORD)` en cada petición (pendiente de reemplazo por JWT; ver [`modelo_de_amenazas.md`](modelo_de_amenazas.md)).
- **Cliente HTTP:** paquete `http`.

### 1.1 Patrones de acceso

| Operación | Patrón | Ejemplo en el código |
| :--- | :--- | :--- |
| Leer documento | `GET {base}/{db}/{id}` | `responderInvitacion` (conocidos) |
| Crear documento | `POST {base}/{db}` con `_id` en el cuerpo | `agregarContactoAceptado`, `crearGrupo` |
| Actualizar documento | `PUT {base}/{db}/{id}` con `_rev` | recuperación de contraseña, `responderInvitacion` |
| Borrar documento | `DELETE {base}/{db}/{id}?rev=…` | `localidades_repository` |
| Consulta Mango | `POST {base}/{db}/_find` con `selector` | grupos, invitaciones, usuarios |
| Vista MapReduce | `GET {base}/{db}/_design/{dd}/_view/{vista}?key=…` | ver tabla 1.2 |
| Adjuntos | `PUT {base}/{db}/{id}/{archivo}?rev=…` | avatares |
| Cambios en vivo | `_changes` continuo | chat de grupo |

### 1.2 Vistas conocidas en el código

| Base | Design doc / vista | Uso |
| :--- | :--- | :--- |
| `codigospostales` | `_design/DDCP/_view/vistaCP?key={cp}` | Localidades por código postal (SEPOMEX) |
| `buscobien_user_localidad` | `_design/DDUL/_view/vistaUserID`, `vistaUserAsentamiento` | Localidades guardadas del usuario |
| `buscobien_avatares` | `_design/DDUSER/_view/vistaUserID?key={idUsuario}` | Avatar del usuario |
| `buscobien_fotos_ordenadas` | `_design/DDLISTAFOTOS/_view/idpropiedad?key={idPropiedad}` | Orden de fotos de una propiedad |
| `buscobien_usuarios*` | `_design/DDUSER/_view/vistaNOMBRE`, `vistaUserID`, `vistaIdUserPassByNAME`, … | Login y datos de usuario (script `server/setup_couchdb_propietarios.sh`) |

> Los design documents deberían versionarse en `db/design/` (convención del proyecto); hoy solo existe el script de `buscobien_usuarios_propietarios`.

### 1.3 Documento de usuario (según vistas y repositorio)

El documento de usuario agrupa sus datos bajo la clave `usuario`: `id_usuario`, `nombreusuario`, `claveacceso` (hash SHA-256), y durante la recuperación `reset_token` y `token_expiry`. La base depende del perfil (`buscobien_usuarios`, `buscobien_usuarios_promotores`, `buscobien_usuarios_propietarios`).

## 2. Microservicio `buscobien-mailer`

Código: `server/buscobien-mailer/` (Express 4, `nodemailer`, ES modules). Puerto: `PORT` o 3001. Ejecución con pm2; detrás de Apache (`ProxyPass /api/mailer → http://localhost:3001/api`).

### `POST /api/enviar-correo-recuperacion`

| Campo (JSON) | Tipo | Obligatorio |
| :--- | :--- | :--- |
| `email` | string | sí |
| `nombreUsuario` | string | sí |
| `resetToken` | string | sí |
| `perfil` | string | sí |

| Respuesta | Cuerpo |
| :--- | :--- |
| `200` | `{"success": true, "message": "Correo enviado"}` |
| `400` | `{"error": "Faltan campos requeridos", "code": "MISSING_FIELDS"}` |
| `500` | `{"error": "Error al enviar el correo", "code": "SMTP_ERROR"}` |

Genera el enlace `${DEEP_LINK_BASE}?token={resetToken}&perfil={perfil}` y envía la plantilla `templates/recovery-email.html`. El cliente invoca la URL `http://citigov.cloud:3001/api/enviar-correo-recuperacion` (constante `_mailerUrl` en `password_recovery_repository.dart`).

Variables de entorno: `PORT`, `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS`, `SMTP_FROM`, `DEEP_LINK_BASE`.

**Observaciones de seguridad:** el endpoint no exige autenticación, tiene CORS abierto (`cors()` sin restricción) y sustituye `nombreUsuario` en el HTML sin escapar. Ver [`modelo_de_amenazas.md`](modelo_de_amenazas.md).

## 3. Deep links

| Plataforma | Mecanismo | Estado de configuración (archivos del repositorio) |
| :--- | :--- | :--- |
| Android | App Links (`server/well-known/assetlinks.json`) | **Fuera de alcance** (decisión 2026-10-15: solo Web); archivo con valores de ejemplo, no se publica |
| iOS | Universal Links (`apple-app-site-association`) | **Fuera de alcance** (decisión 2026-10-15: solo Web) |
| Web | `Uri.base` al arrancar | Funcional en el código; requiere que el servidor Web devuelva `index.html` para `/recuperar` |

Detalle del manejo en la app: [`SDD_07_routes.md`](modulos_sdd/07_routes/SDD_07_routes.md).

## 4. Servicios de Google

- **Maps SDK** (`google_maps_flutter`): clave por `--dart-define` (`GOOGLE_MAPS_KEY`).
- **Geocoding REST:** `https://maps.googleapis.com/maps/api/geocode/json?latlng=…&key=…` desde `provider_actual_place.dart`.
