# SDD - 10_user_login_avatar
**Directorio:** `lib/10_user_login/avatar`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `manejo_imagenes_avatar.dart`
- **Providers:** `classUserAvatarProvider`
- **Modelos:** `GetUserAvatar`
- **Páginas/Rutas:** `/gestionavatar -> GestionAvatares`
- **I/O externo:** CouchDB attachments / storage
- **Dependencias:** `flutter_riverpod`, `file_picker`, `http`
- **Riesgos:** Permisos de storage por plataforma; avatar huérfano.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá permitir seleccionar, subir, actualizar y recuperar avatar.

### REQ-EVT-001 — Event-Driven
Cuando el usuario confirma imagen, el sistema deberá subir avatar.

### REQ-STATE-001 — State-Driven
Mientras la subida está en curso, el sistema deberá mostrar loader.

### REQ-UNW-001 — Unwanted
Si la imagen es inválida o muy grande, entonces el sistema deberá rechazar con mensaje claro.

### REQ-OPT-001 — Optional Feature
Donde exista avatar previo, el sistema deberá mostrar preview antes de reemplazar.
