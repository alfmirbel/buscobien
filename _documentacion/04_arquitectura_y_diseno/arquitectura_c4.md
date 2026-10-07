# Arquitectura C4 — Contexto y Contenedores

**Revisión de exactitud:** 2026-10-07, contrastado con `lib/`, `pubspec.yaml` y `server/`.  
**Alcance:** muestra la arquitectura **real** y la **objetivo** (pendiente de nginx + JWT). El detalle de capas está en [`arquitectura_general_buscobien.md`](arquitectura_general_buscobien.md).

## 1. Nivel 1 — Contexto

```mermaid
flowchart LR
    U["Persona usuaria<br>(compradora, promotora, propietaria, etc.)"] --> APP["BuscoBien<br>(app Flutter: Android, iOS, Web WASM, Windows)"]
    APP --> CDB[("CouchDB<br>citigov.cloud:6984")]
    APP --> MAIL["Microservicio buscobien-mailer<br>(Node.js, puerto 3001)"]
    APP --> GM["Google Maps / Geocoding"]
    MAIL --> SMTP["Servidor SMTP"]
    SMTP -.->|"correo con enlace /recuperar"| U
```

| Sistema externo | Uso verificado en el código |
| :--- | :--- |
| CouchDB | Todas las bases `buscobien_*` y `codigospostales` (ver [`bases_de_datos_en_codigo.md`](../06_modelo_de_datos_y_bd/bases_de_datos_en_codigo.md)). |
| `buscobien-mailer` | `POST http://citigov.cloud:3001/api/enviar-correo-recuperacion` (recuperación de contraseña). |
| Google Maps | `google_maps_flutter` y llamada a `maps.googleapis.com/maps/api/geocode` desde `14_geolocalizacion`. |
| FCM / notificaciones push | **No implementado**; solo `flutter_local_notifications` declarado en `pubspec.yaml`. |

## 2. Nivel 2 — Contenedores (estado real)

```mermaid
flowchart TB
    subgraph Cliente["Dispositivo / navegador"]
        FL["App Flutter<br>Riverpod 3 · Freezed · http"]
        SS["SessionStorage<br>flutter_secure_storage (Android/iOS/Windows)<br>shared_preferences (Web)"]
        FL --- SS
    end
    subgraph Servidor["Servidor 190.92.151.34"]
        CDB[("CouchDB 6984 (TLS)")]
        ML["buscobien-mailer<br>Express · nodemailer · pm2 · puerto 3001"]
        AP["Apache (reverse proxy)"]
    end
    FL -->|"HTTP + Basic Auth<br>(credenciales compiladas)"| CDB
    FL -->|"POST /api/enviar-correo-recuperacion<br>(HTTP, sin autenticación)"| ML
    AP --> ML
```

## 3. Nivel 2 — Contenedores (objetivo, pendiente)

```mermaid
flowchart TB
    FL["App Flutter<br>Dio + interceptor JWT"] -->|HTTPS| NG["nginx"]
    NG --> API["API Node.js<br>(nano, JWT)"]
    API --> CDB[("CouchDB")]
    API --> ML["buscobien-mailer"]
```

La migración del estado real al objetivo está **pendiente** de la configuración de nginx y JWT. Hasta entonces no deben escribirse documentos que afirmen que el cliente no toca CouchDB. Riesgos asociados: [`modelo_de_amenazas.md`](modelo_de_amenazas.md).

## 4. Nivel 3 — Componentes de la app (por capas de `lib/`)

```mermaid
flowchart TD
    subgraph Arranque
        M["main.dart"] --> R["07_routes<br>routeGenerate + deep links"]
        M --> SP["01_splash_screen"]
    end
    R --> PR["02_principal_screen / 01_home<br>(shell y navegación por estado)"]
    PR --> PA["08_pantallas<br>inicio · propiedades · ubicación · perfil · tu_cuenta"]
    PA --> FE["03_listas · 22_imagenes · 12_localidades_user · 14_geolocalizacion · 10_user_login"]
    FE --> ST["Providers Riverpod<br>04_provider · 05_provider_menus"]
    ST --> SEC["40_security<br>direccionip · hash · endpoints"]
    SEC --> CDB[("CouchDB")]
    PA --> GW["60_global_widgets · 20_var_globales<br>(tema M3 y widgets comunes)"]
    PR --> PLAT["41_connectivity · 42_sistema_operativo"]
```
