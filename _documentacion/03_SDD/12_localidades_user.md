# SDD - 12_localidades_user
**Directorio:** `lib/12_localidades_user`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `data_user_localidad.dart`, `.freezed.dart`, `.g.dart`, `data_user_localidad_get.dart`, `.freezed.dart`, `.g.dart`, `localidades_repository.dart`, `provider_get_localidades_usuario.dart`
- **Providers:** `provider_get_localidades_usuario.dart`
- **Modelos:** `UsuarioLocalidades`, Freezed
- **Páginas/Rutas:** Consumido por flujos de edición y ubicación
- **I/O externo:** CouchDB HTTP
- **Dependencias:** `flutter_riverpod`, `http`, `freezed`
- **Riesgos:** Repositorio puede ocultar errores HTTP y propagar vacío como éxito.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá persistir localidades asociadas al usuario.

### REQ-EVT-001 — Event-Driven
Cuando el usuario agrega una localidad, el sistema deberá escribir el documento en CouchDB.

### REQ-STATE-001 — State-Driven
Mientras la operación remota está en curso, el sistema deberá mantener loader visible.

### REQ-UNW-001 — Unwanted
Si la respuesta HTTP no es 200/201/202, entonces el sistema deberá mapear error CouchDB y exponer fallback.

### REQ-CMP-001 — Complex
Mientras el usuario guarda, cuando la escritura remota finalice, el sistema deberá sincronizar cache local y refrescar providers.
