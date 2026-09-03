# SDD - 10_user_login
**Directorio:** `lib/10_user_login`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `login_01_login_page.dart`, `login_03_form_register_user.dart`, `page_solicitar_recuperacion.dart`, `page_cambio_password.dart`, `provider_session.dart`, `.g.dart`, `session_repository.dart`, `.g.dart`, `session_storage.dart`, `data_session.dart`, `data_models/auth_state.dart`, `data_get_user.dart`, `data_usuarios.dart`, `data_get_id_user_pass.dart`, `data_user_promotor.dart`, `dialogbox_login.dart`, `avatar/*`
- **Providers:** `sessionProvider`, `classUserAvatarProvider`
- **Modelos:** `Usuario`, `AuthState`, `GetUserData`, `GetUserAvatar`, `UsuarioPromotor`
- **Páginas/Rutas:** `/login`, `/loginuser`, `/registro`, `/solicitarrecuperacion`, `/cambiopassword`, `/gestionavatar`
- **I/O externo:** CouchDB HTTP, correo Node mailer, storage por plataforma
- **Dependencias:** `flutter_riverpod`, `http`, `flutter_secure_storage`, `shared_preferences`, `file_picker`
- **Riesgos:** Variables globales username/password; password como texto plano temporal.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá solicitar usuario, contraseña y perfil para autenticación.

### REQ-UBI-002 — Ubiquitous
El sistema deberá persistir sesión en storage diferenciado por plataforma.

### REQ-EVT-001 — Event-Driven
Cuando el usuario solicita recuperación, el sistema deberá enviar token por correo.

### REQ-EVT-002 — Event-Driven
Cuando el deep link abre `/cambioPassword`, el sistema deberá verificar token y navegar a cambio.

### REQ-STATE-001 — State-Driven
Mientras la sesión esté activa, el sistema deberá restaurar `AuthState` al reiniciar.

### REQ-STATE-002 — State-Driven
Mientras la sesión esté vencida, el sistema deberá redirigir a login.

### REQ-UNW-001 — Unwanted
Si el token expiró, entonces el sistema deberá denegar cambio de contraseña.

### REQ-UNW-002 — Unwanted
Si el storage está corrupto, entonces el sistema deberá limpiar sesión y redirigir a login.

### REQ-CMP-001 — Complex
Mientras el usuario se autentica, cuando las credenciales sean válidas, el sistema deberá establecer sesión y redirigir al shell principal sin crash.

### REQ-OPT-001 — Optional Feature
Donde el usuario quiera cambiar avatar, el sistema deberá exponer selección, subida y actualización.
