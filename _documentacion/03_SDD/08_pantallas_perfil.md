# SDD - 08_pantallas_perfil
**Directorio:** `lib/08_pantallas/perfil`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `pagina_perfil.dart`
- **Providers:** `sessionProvider`, `classUserAvatarProvider`
- **Modelos:** `AuthState`, `GetUserData`, datos de usuario en sesión
- **Páginas/Rutas:** `/perfil -> PaginaPerfilWidget`
- **I/O externo:** CouchDB por sesión; avatar storage por plataforma
- **Dependencias:** `flutter_riverpod`, `file_picker`, `http`
- **Riesgos:** Dependencia directa de `sessionProvider.userData`; redirección a login si falta sesión.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá mostrar los datos de usuario desde la sesión activa.

### REQ-UBI-002 — Ubiquitous
El sistema deberá reflejar el estado de carga, vacío y error en pantalla.

### REQ-EVT-001 — Event-Driven
Cuando el usuario accede a gestión de avatar, el sistema deberá exponer selección y subida.

### REQ-EVT-002 — Event-Driven
Cuando el avatar se actualiza, el sistema deberá refrescar la imagen en perfil y en la sesión asociada.

### REQ-STATE-001 — State-Driven
Mientras no exista sesión, el sistema deberá redirigir a `/login` y no renderizar perfil.

### REQ-UNW-001 — Unwanted
Si `userData` es nulo o corrupto, entonces el sistema deberá mostrar fallback de sesión sin exponer stacktrace.

### REQ-OPT-001 — Optional Feature
Donde el usuario tenga avatar, el sistema deberá mostrar preview circular con fallback a iniciales.
