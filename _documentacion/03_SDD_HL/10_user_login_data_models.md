# SDD - 10_user_login_data_models
**Directorio:** `lib/10_user_login/data_models`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `auth_state.dart`, `data_get_user.dart`, `data_usuarios.dart`, `data_get_id_user_pass.dart`, `data_user_promotor.dart`
- **Providers:** No
- **Modelos:** `AuthState`, `Usuario`, `GetUserData`, `UsuarioPromotor`
- **Páginas/Rutas:** Consumido por login y sesión
- **I/O externo:** No
- **Dependencias:** `freezed_annotation`, `json_annotation`
- **Riesgos:** Inconsistencias entre `data_usuarios` y `data_get_user`.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá definir modelos serializables para auth y usuarios.

### REQ-EVT-001 — Event-Driven
Cuando la sesión se restaura, el sistema deberá rehidratar `AuthState` desde storage.

### REQ-UNW-001 — Unwanted
Si el modelo viene incompleto, entonces el sistema deberá marcar sesión como inválida.
