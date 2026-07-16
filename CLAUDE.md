## Model usage plan (Claude Code)

Reference: https://code.claude.com/docs/en/model-config

The project default is set to **`opusplan`** in `.claude/settings.json`. This is the documented hybrid alias: Opus does the plan-mode reasoning ("how should I approach this, what are the trade-offs, what's the structure"), and Claude Code automatically switches to Sonnet for the actual code generation. It's a clean fit for engine work, where most tasks split naturally into "think hard for two paragraphs" followed by "now write 200 lines of boilerplate."

Override at runtime with `/model <alias>` mid-session, or launch with `claude --model <alias>` for one session. Aliases: `haiku`, `sonnet`, `opus`, `opusplan`, `sonnet[1m]`, `opus[1m]`.

### Task → model mapping

**Haiku** — trivial, mechanical, low-stakes.

- Renames, formatting passes, fixing typos.
- Adding/removing imports, reordering struct fields.
- "What does this Odin error mean?" lookups.
- Tweaking a constant and re-running.

**Sonnet** — routine implementation. The default once a design is settled.

- Implementing the next milestone after we've discussed shape.
- Adding a new system/module that follows existing patterns
  (e.g. "add a `Projectile` archetype matching `Monster`").
- Writing isolated procs: input handling, asset loading, simple AI.
- Single shader pairs (vertex + fragment).
- Most debugging — compile errors, validation messages, behavioral bugs that reproduce reliably.
- Performance investigations once you've narrowed the suspect.

**Opus** — architectural / hard-reasoning / cross-cutting.

- "How should I structure X" — picking patterns, layer boundaries.
- Cross-cutting refactors that touch 4+ files at once.
- Performance work where you need to reason about pipeline state, descriptor sets, sync, and memory budgets _simultaneously_.
- Hot-reload boundary design (host EXE / `game.dll` split) — a single mistake here costs days.
- Stuck on a bug for 30+ minutes after Sonnet has tried twice.
- Choosing between two non-obvious approaches with real tradeoffs.

### Practical heuristics

- **Stay in `opusplan` by default.** It hands work to the right model automatically — only override when you want to be explicit.
- When you escalate to `opus` for a hard problem, **drop back to `sonnet`
  once you've decided the approach.** Implementation phase doesn't need it.
- For a long architectural conversation, **`opusplan` is fine** — plan mode uses Opus, so the thinking phase already gets the right model.
- If a session feels expensive and you're mostly mechanical edits,   `/model haiku` for that session.
- For "find me references to X across the codebase" or other large-context surveys, `sonnet[1m]` if the project has grown.

## How to use this brief

This is the project's permanent Claude Code context. It autoloads when you run `claude` in this folder.

The model plan above will route that question to Opus (planning) and the resulting implementation work to Sonnet automatically.

# BuscoBien — Red de Promoción Inmobiliaria

## Descripción del proyecto

Plataforma digital (app móvil + web) de promoción inmobiliaria en México.
Conecta compradores, vendedores, agentes y desarrolladores en un espacio de búsqueda, publicación y seguimiento de propiedades, con motor social integrado
(Mis Conocidos, Mis Grupos) y datos geográficos (CP, colonias, municipios).

## Stack tecnológico

- **App cliente**: Flutter (Dart) — iOS, Android, Web (WASM), Windows
- **Base de datos**: CouchDB con Mango queries
- **API / backend**: Node.js con Express — repositorio separado (endpoints REST, autenticación, notificaciones)

---

## Arquitectura general

```
Flutter App (iOS / Android / Web WASM / Windows)
    │
    │  ✗ Flutter NUNCA se conecta directo a CouchDB
    │  ✗ Flutter NUNCA tiene credenciales de CouchDB
    │  ✓ Flutter solo conoce la URL de la API Node.js
    │
    ▼
REST API (Node.js) ────► CouchDB (https://citigov.cloud:6984)
    │
    └── Notificaciones push (FCM)
```

---

## Reglas de la UI

- El archivo `D:\buscobien\_documentacion\antigravity_ui_rules.md` define las reglas
  a seguir en el diseño y desarrollo de los elementos de la UI.

---

## Documentación de arquitectura

- `D:\buscobien\documentacion\arquitectura_navegacion.md` — arquitectura principal de la app.
- `D:\buscobien\documentacion\especificacion_motor_social.md` — funciones de Red Social y Mis Conocidos.

---

## Servidor remoto

- **Alias SSH proyecto**: miservidor (usuario: deploy)
- **Alias SSH admin**: miservidor-root (usuario: root)
- **IP**: 190.92.151.34
- **Puerto SSH**: 7822
- **OS**: Linux 5.4.0 (server.citigov.site)
- **Hosting**: No administrado (requiere root para instalar/administrar)
- **Recursos**: RAM 1 GB, Disco 20 GB (18% usado)

### Configuración ~/.ssh/config (Windows)

```
Host miservidor
    HostName 190.92.151.34
    User deploy
    Port 7822
    IdentityFile ~/.ssh/id_ed25519

Host miservidor-root
    HostName 190.92.151.34
    User root
    Port 7822
    IdentityFile ~/.ssh/id_ed25519
```

### ssh-agent (ejecutar al inicio de cada sesión de trabajo)

```powershell
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519
```

> **IMPORTANTE — Claude Code**: usar siempre **PowerShell** (no Bash) para comandos SSH.
> El Bash tool no puede acceder al ssh-agent de Windows. La llave tiene passphrase,
> por lo que debe estar cargada en el agente antes de ejecutar cualquier comando remoto.

---

## CouchDB

- **URL**: https://citigov.cloud:6984
- **Usuario**: admin
- **Password**: (en .env como COUCHDB_PASSWORD — nunca en este archivo)

---

## Google Maps

- **SDK actual**: `google_maps_flutter` (iOS, Android, Web)
- **API Keys**: cargadas vía `--dart-define` en compilación (nunca hardcodeadas)
  - `GOOGLE_KEY` — clave general
  - `GOOGLE_MAPS_KEY` — clave de mapas
- **Acceso en código**: `lib/14_geolocalizacion/app_keys.dart`
  ```dart
  const String GOOGLE_KEY = String.fromEnvironment('GOOGLE_KEY');
  const String GOOGLE_MAPS_KEY = String.fromEnvironment('GOOGLE_MAPS_KEY');
  ```
- **Nota WASM**: `google_maps_flutter` usa platform views, lo que puede limitar compatibilidad
  WASM en Web. Si se requiere compilación WASM completa, evaluar `flutter_map` + tiles.

### Configuración requerida por plataforma

#### Android — `android/app/src/main/AndroidManifest.xml`

```xml
<meta-data
  android:name="com.google.android.geo.API_KEY"
  android:value="${GOOGLE_MAPS_API_KEY}"/>
```

#### iOS — `ios/Runner/AppDelegate.swift`

```swift
import GoogleMaps
GMSServices.provideAPIKey("${GOOGLE_MAPS_API_KEY}")
```

#### Web — `web/index.html` (en el `<head>`)

```html
<script src="https://maps.googleapis.com/maps/api/js?key=${GOOGLE_MAPS_API_KEY}"></script>
```

---

## Variables de entorno

### Estrategia por tipo de valor

| Tipo                                       | Mecanismo                       | Motivo                                                 |
| ------------------------------------------ | ------------------------------- | ------------------------------------------------------ |
| Credenciales sensibles (CouchDB, API Keys) | `--dart-define` en compilación  | El `.env` en Web es un archivo HTTP público — inseguro |
| Config no sensible en runtime              | `flutter_dotenv` + `.env` asset | Solo para móvil/desktop, nunca Web                     |

### Valores sensibles — `--dart-define-from-file` en tiempo de compilación

Definidos como constantes en el código (`lib/40_security/direccionip.dart`, `lib/14_geolocalizacion/app_keys.dart`):

```dart
const String GOOGLE_KEY      = String.fromEnvironment('GOOGLE_KEY');
const String GOOGLE_MAPS_KEY = String.fromEnvironment('GOOGLE_MAPS_KEY');
const String direccionip     = String.fromEnvironment('COUCHDB_URL');
const String username        = String.fromEnvironment('COUCHDB_USER');
const String password        = String.fromEnvironment('COUCHDB_PASSWORD');
```

Las credenciales se escriben **una sola vez** en `defines.json` (raíz del proyecto, nunca al repositorio):

```json
{
  "COUCHDB_URL": "https://citigov.cloud:6984",
  "COUCHDB_USER": "admin",
  "COUCHDB_PASSWORD": "tu-password",
  "GOOGLE_KEY": "tu-google-key",
  "GOOGLE_MAPS_KEY": "tu-google-maps-key"
}
```

### `.env` en raíz (nunca al repositorio)

Archivo legacy — las credenciales están en `defines.json`. Se mantiene en `.gitignore`.

### `.env.example` (va al repositorio — sin valores)

```
GOOGLE_KEY=
GOOGLE_MAPS_KEY=
```

### `api/.env` — repositorio backend Node.js (nunca al repositorio)

```
PORT=3000
NODE_ENV=development
COUCHDB_URL=https://citigov.cloud:6984
COUCHDB_USER=admin
COUCHDB_PASSWORD=tu-password-aqui
JWT_SECRET=un-string-largo-aleatorio-aqui
JWT_EXPIRES_IN=7d
FCM_SERVER_KEY=
GOOGLE_MAPS_KEY=tu-api-key-aqui
```

---

## Comandos frecuentes servidor

> Usar PowerShell para todos los comandos SSH (ver nota de ssh-agent arriba).

```powershell
# Verificar conexión al servidor
ssh miservidor "echo 'Conexión exitosa'"

# Verificar sistema operativo y recursos
ssh miservidor "uname -a"

# Verificar CouchDB
ssh miservidor "curl -s https://citigov.cloud:6984/"

# Listar bases de datos
ssh miservidor "curl -s -u admin:$COUCHDB_PASSWORD https://citigov.cloud:6984/_all_dbs"

# Estado del servicio CouchDB
ssh miservidor "sudo systemctl status couchdb"

# Ver logs CouchDB (últimas 50 líneas)
ssh miservidor "sudo journalctl -u couchdb --no-pager -n 50"

# Instalar paquetes (requiere root)
ssh miservidor-root "apt update && apt install -y nombre-paquete"

# Ver espacio en disco
ssh miservidor "df -h /"

# Ver memoria disponible
ssh miservidor "free -h"
```

---

## Comandos de compilación Flutter

Las credenciales se leen de `defines.json` — no hay que escribirlas en cada comando.

```powershell
# Desarrollo
flutter run -d chrome --wasm --dart-define-from-file=defines.json
flutter run -d windows        --dart-define-from-file=defines.json
flutter run                   --dart-define-from-file=defines.json   # Android/iOS

# Producción
flutter build web --wasm --dart-define-from-file=defines.json
flutter build apk          --dart-define-from-file=defines.json
flutter build ios          --dart-define-from-file=defines.json
flutter build windows      --dart-define-from-file=defines.json
```

---

## Flutter — Plataformas objetivo

- **Android**: API 21+ (Android 5.0 en adelante)
- **iOS**: iOS 12+
- **Web**: Chrome 112+, Edge 112+, Safari 16.4+ — compilado con WASM
- **Windows**: Windows 10+

### Consideraciones por plataforma

| Función             | Android                  | iOS                      | Web                         | Windows                       |
| ------------------- | ------------------------ | ------------------------ | --------------------------- | ----------------------------- |
| Mapas               | `google_maps_flutter`    | `google_maps_flutter`    | `google_maps_flutter_web`   | tiles HTTP                    |
| Geolocalización     | GPS nativo `geolocator`  | GPS nativo               | Geolocation API (HTTPS)     | API Windows / manual          |
| Notificaciones push | FCM                      | FCM                      | Web Push FCM                | `flutter_local_notifications` |
| Cámara / archivos   | `image_picker`           | `image_picker`           | `image_picker` (file input) | `file_picker`                 |
| Token JWT           | `flutter_secure_storage` | `flutter_secure_storage` | `shared_preferences`        | `shared_preferences`          |

---

## Estructura de carpetas del proyecto

```
d:\buscobien\                        ← raíz del proyecto (Flutter en raíz)
├── CLAUDE.md                        ← este archivo
├── pubspec.yaml                     ← dependencias Flutter
├── lib/
│   ├── main.dart
│   ├── 01_splash_screen/
│   ├── 01_home/                     ← home_navigation_provider.dart (estado global menús)
│   ├── 02_principal_screen/         ← pantalla principal con menús anidados
│   ├── 03_listas/
│   ├── 03_vistas/
│   ├── 04_provider/
│   ├── 05_provider_menus/           ← providers y widgets de menús superiores
│   ├── 07_routes/
│   ├── 08_pantallas/                ← todas las pantallas de la app
│   │   ├── propiedades/             ← listados, detalle, publicar propiedad
│   │   ├── ubicacion/               ← búsqueda por ubicación / mapa
│   │   └── tu_cuenta/
│   │       ├── conocidos/           ← Mis Conocidos (IMPLEMENTADO — 9 archivos)
│   │       └── grupos/              ← Mis Grupos (PROTOTIPO — en desarrollo)
│   ├── 10_user_login/               ← login y registro
│   ├── 12_localidades_user/
│   ├── 14_geolocalizacion/
│   ├── 20_var_globales/             ← colores (appTheme), opciones globales
│   ├── 22_imagenes/                 ← manejo de imágenes
│   ├── 40_security/
│   ├── 41_connectivity/
│   ├── 42_sistema_operativo/
│   └── 60_global_widgets/
├── android/
│   └── app/src/main/AndroidManifest.xml  ← Google Maps API Key Android
├── ios/Runner/AppDelegate.swift           ← Google Maps API Key iOS
├── web/index.html                         ← Google Maps script Web
├── assets/images/
├── assets/icon/
├── fonts/                           ← Urbanist, Comfortaa
├── .env                             ← NO al repositorio
├── .env.example                     ← SÍ al repositorio
├── _infraestructura/                ← documentos de infraestructura (local)
│
└── api/                             ← Node.js backend (pendiente scaffolding)
    ├── src/
    │   ├── routes/
    │   ├── controllers/
    │   ├── middleware/
    │   └── db/
    ├── .env                         ← NO al repositorio
    ├── .env.example                 ← SÍ al repositorio
    └── package.json
```

---

## Módulos del sistema (implementados)

### 1. Autenticación y perfil de usuario

- Login, registro (`lib/10_user_login/`)
- Sesión con JWT + FlutterSecureStorage
- Avatar de usuario (`lib/10_user_login/avatar/`)
- Perfil (`lib/08_pantallas/perfil/pagina_perfil.dart`)

### 2. Inicio — Búsqueda y listado de propiedades (`lib/08_pantallas/inicio/`)

- Feed de propiedades con filtros (tipo, espacios, características)
- Carga paginada 10 en 10 (`http_find_propiedades_10en10.dart`)
- Conteo de resultados por filtro (`http_view_count_filter_propiedades.dart`)
- Cards de propiedades (`widget_wrap_modern_card.dart`)

### 3. Propiedades (`lib/08_pantallas/propiedades/`)

- Detalle de propiedad (`pagina_detalle_propiedad.dart`)
- Vista PDF de propiedad (`pagina_detalle_propiedad_pdf.dart`)

### 4. Tus Espacios — Gestión de propiedades propias (`lib/08_pantallas/tu_cuenta/tus_espacios/`)

- Publicar nueva propiedad (`form_crea_ficha_captura_propiedad.dart`)
- Ver y actualizar tus propiedades (`pagina_tus_espacios.dart`)
- Módulo de compra de espacios (`compra_espacios/`)

### 5. Ubicación y mapas (`lib/08_pantallas/ubicacion/`, `lib/14_geolocalizacion/`)

- Búsqueda por CP, colonia, municipio (SEPOMEX)
- Mapa interactivo de propiedades (`google_map_mapa_propiedades.dart`)
- Geolocalización actual (`provider_actual_place.dart`)

### 6. Motor social

- **Mis Conocidos** — `lib/08_pantallas/tu_cuenta/conocidos/` (IMPLEMENTADO)
  - Descubrir usuarios, invitaciones, contactos, chat 1-a-1
  - CouchDB: `buscobien_invitaciones`, `buscobien_mensajes`
- **Mis Grupos** — `lib/08_pantallas/tu_cuenta/grupos/` (IMPLEMENTADO)
  - 5 pantallas: Mis Grupos, Descubrir, Invitaciones, Detalle, Chat grupal
  - CouchDB: `buscobien_grupos`, `buscobien_grupos_invitaciones`, `buscobien_grupos_mensajes`

---

## Inventario de componetes del sistema (implementados)

- `D:\buscobien\documentacion\resumen_modulos_inventariados.md` — inventario de módulos y componentes, ligas a archivos con el detalle.

---

## Convenciones Flutter / Dart

- State management: Riverpod 3.x (riverpod_generator + build_runner para código generado)
- HTTP client: Dio (con interceptor JWT automático)
- Navegación: Navigator + MaterialPageRoute — rutas definidas en `lib/07_routes/app_routes.dart`
  - `AppRoutes.routeGenerate(settings)` como `onGenerateRoute` en MaterialApp
  - Parámetros entre pantallas via `routes_parameters.dart`
- Modelos: Freezed + json_serializable (archivos `.freezed.dart` y `.g.dart` generados)
- Mapas: `google_maps_flutter` + `google_maps_flutter_web`
- API Keys Google Maps vía `--dart-define` en compilación (ver `lib/14_geolocalizacion/app_keys.dart`)
- URL strategy: `setPathUrlStrategy()` en main (URLs limpias en Web)
- Usar `const` constructors siempre que sea posible
- Widgets pequeños y composables — extraer a archivo propio si supera ~80 líneas
- Manejo de errores: `try/catch` en todos los llamados async, error state consistente
- Usar `Platform.isWindows`, `kIsWeb` para código específico por plataforma

## Convenciones Node.js (repositorio backend — separado)

- Node 18+, ES modules (`import`/`export`)
- `async/await` siempre, nunca callbacks ni `.then()` en cadena
- Respuesta de error consistente: `{ error: string, code: string }`
- Variables de entorno via `dotenv`
- Biblioteca CouchDB: `nano`
- CORS configurado para los dominios del proyecto

## Convenciones CouchDB

- IDs con prefijo semántico: `user:uuid`, `propiedad:uuid`, `mensaje:uuid`, `grupo:uuid`
- Bases con prefijo `buscobien_` (ej: `buscobien_invitaciones`, `buscobien_mensajes`)
- Design documents en `db/design/`
- URL de producción: `https://citigov.cloud:6984`
- Usar Mango queries para consultas (no MapReduce salvo necesidad)

---

## .gitignore (raíz del proyecto)

```
# Variables de entorno — nunca al repositorio
.env
.env.local
.env.production

# Node.js
node_modules/

# Python
__pycache__/
venv/
*.pyc

# Flutter
.dart_tool/
build/
.flutter-plugins
.flutter-plugins-dependencies

# Sistema
.DS_Store
Thumbs.db
```

---

## Reglas para Claude

- **SSH**: usar siempre **PowerShell** para comandos SSH (el Bash tool no accede al ssh-agent de Windows)
- Antes de conectar al servidor siempre verificar: `ssh miservidor "echo 'Conexión exitosa'"`
- Para cambios grandes en el servidor: mostrar el plan primero y esperar confirmación antes de ejecutar
- Antes de modificar CouchDB en producción: hacer backup primero
- Al escribir código Flutter: considerar siempre las 4 plataformas (iOS, Android, Web WASM, Windows)
- Google Maps API Key siempre desde `.env` o `--dart-define`, nunca hardcodeada
- Compilación web siempre con flag `--wasm`
- Verificar compatibilidad WASM de cualquier paquete nuevo antes de agregarlo
- Preferir editar archivos existentes sobre crear nuevos, salvo que sea claramente necesario
- Funciones pequeñas y de un solo propósito
- Comentarios solo para lógica no obvia
- Al escribir tests: ejecutarlos después de generarlos y corregir fallas
- Nunca incluir credenciales, tokens, API Keys ni archivos `.env` en commits
- Al tener dudas sobre la arquitectura: preguntar antes de asumir

- Cada vez que una instrucción use la palabra await, dentro de un Widget con estado (StatefulWidget), grábate a fuego que la siguiente línea de código que modifique la interfaz visual (UI) debe estar protegida por un if (!mounted) return;.
  Ejemplo:
  // Consultar a la API
  RespuestaFlowise respuesta = await analizarDocumentoFlowise(payloadText);
  // -----> AGREGA ESTA LÍNEA <-----
  if (!mounted) return;

---

## Fase actual de desarrollo

- [x] Configuración SSH y acceso al servidor
- [x] Scaffolding inicial Flutter (proyecto buscobien)
- [x] Login y registro de usuarios (JWT + FlutterSecureStorage)
- [x] Búsqueda y listado de propiedades (inicio/ — carga paginada, filtros)
- [x] Detalle de propiedad y vista PDF
- [x] Tus Espacios — publicar y gestionar propiedades propias
- [x] Ubicación — búsqueda por CP/colonia/municipio (SEPOMEX)
- [x] Geolocalización y mapa de propiedades (Google Maps)
- [x] Motor social — Mis Conocidos (invitaciones, contactos, chat 1-a-1)
- [x] Motor social — Mis Grupos (grupos, invitaciones, chat grupal)
- [ ] Verificar CouchDB en producción
- [ ] Configurar flutter_dotenv y variables de entorno (.env en runtime)
- [ ] Sistema de notificaciones push (FCM + flutter_local_notifications Windows)
- [ ] Backend Node.js (repositorio separado — pendiente)
- [ ] Dashboard / estadísticas
