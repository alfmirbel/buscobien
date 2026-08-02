# SDD - 10_user_login_usuario_login
**Directorio:** `lib/10_user_login/usuario_login`
**Fecha:** 2026-07-25

## Estructura técnica
- **Archivos:** `login_01_login_page.dart`, `login_03_form_register_user.dart`, `page_solicitar_recuperacion.dart`, `page_cambio_password.dart`
- **Providers:** `sessionProvider`
- **Modelos:** `AuthState`
- **Páginas/Rutas:** `/login`, `/registro`, `/solicitarrecuperacion`, `/cambiopassword`
- **I/O externo:** CouchDB HTTP, correo Node mailer
- **Dependencias:** `flutter_riverpod`, `http`
- **Riesgos:** Validación client-side insuficiente; deep link sin validación robusta.

## Requerimientos EARS

### REQ-UBI-001 — Ubiquitous
El sistema deberá exponer login, registro, solicitud de recuperación y cambio de contraseña.

### REQ-EVT-001 — Event-Driven
Cuando el usuario envía recuperación, el sistema deberá solicitar endpoint de correo con token.

### REQ-EVT-002 — Event-Driven
Cuando se abre `/cambioPassword` por deep link, el sistema deberá navegar con token y perfil.

### REQ-STATE-001 — State-Driven
Mientras la sesión esté activa, el sistema deberá evitar mostrar login.

### REQ-UNW-001 — Unwanted
Si el token expiró, entonces el sistema deberá denegar cambio y pedir nuevo flujo.

### REQ-CMP-001 — Complex
Mientras el usuario cambia contraseña, cuando el backend confirme éxito, el sistema deberá cerrar sesión y navegar a login.
