# User Stories — Autenticación, Sesión, Registro y Recuperación (10_user_login)

**Directorio:** `lib/10_user_login/`
**Subdirectorios:** `avatar/` (3), `data_models/` (5), `usuario_login/` (11) — Total: 19 archivos `.dart`
**Fecha:** 2026-08-12
**Formato:** 3 C's (Card, Conversation, Confirmation)

---

## US-AUTH-001: Login Multi-Rol con Secure Storage y Restauración de Sesión

**Card:**
Como **usuario (cualquier rol: Usuario, Promotor, Propietario)**
Quiero **loguearme con user/pass y persistir sesión segura**
Para **no re-login cada vez que abro la app, manteniendo credenciales fuera del alcance del código UI**

**Conversation:**
`LoginPage` (ConsumerStatefulWidget en `login_01_login_page.dart`) presenta un `Form` con `TextFormField` para `userName` y `userPass`, más `DropdownTipoUsuario` (StatefulWidget anidado) que invoca `ref.read(sessionProvider.notifier).setNombrePerfil(perfil)` y dispara `setPerfilUsuarioByNombrePerfil()` (switch que setea 9 flags en `AuthState`). Al enviar, `_handleLogin()` llama a `SessionRepository.getUserIdNamePassByName({userName, nombrePerfil, authHeaders})` → consulta vista CouchDB `vistaNOMBREPASS` con Basic Auth headers (`direccionip.dart:username:password`). Si las credenciales coinciden, `SessionNotifier` ejecuta `deleteLocalSessionData()` (limpia storage previo), `getUserDataByNameInSessionData()` (carga datos completos), guarda en `SessionStorage` los campos `userId`, `userName`, `nombrePerfil`, `userPassHash` (SHA-256), invoca `recuperaDatosDelAvatar(currentUserId)` y navega a `AppRoutes.principal` con `pushReplacementNamed`. `SessionStorage` factory selecciona `MobileSessionStorage` (`FlutterSecureStorage`) o `WebSessionStorage` (`SharedPreferences`) según `kIsWeb`. En el siguiente arranque, `getSessionValuesFromLocalStorage()` reconstruye `AuthState` sin re-login (ver `Beta 0.07.047`).

**Confirmation:**
- [ ] `LoginPage` muestra `DropdownTipoUsuario` con 9 roles (Usuario, Promotor, Propietario y 6 deshabilitados)
- [ ] `getUserIdNamePassByName()` valida credenciales vía HTTP GET a vista CouchDB
- [ ] Si credenciales inválidas → SnackBar de error sin navegar
- [ ] Si credenciales válidas → `deleteLocalSessionData()` limpia storage previo
- [ ] Se guardan en storage: `userId`, `userName`, `nombrePerfil`, `userPassHash` (SHA-256)
- [ ] En móvil → `FlutterSecureStorage`; en Web → `SharedPreferences`
- [ ] `recuperaDatosDelAvatar(currentUserId)` carga avatar tras login
- [ ] Navegación a `AppRoutes.principal` con `pushReplacementNamed` (limpia back stack)
- [ ] Al reabrir app, `getSessionValuesFromLocalStorage()` restaura `isAuthenticated=true` sin interacción
- [ ] Si `FlutterSecureStorage` falla en móvil → excepción propagada (no hay fallback)

---

## US-AUTH-002: Registro Multi-Rol con TyC/Privacidad PDF y Anti-Duplicado

**Card:**
Como **nuevo usuario (cualquier rol)**
Quiero **registrarme con 12 campos, aceptar Términos y Condiciones + Aviso de Privacidad (PDF), y validar que mi usuario no exista**
Para **empezar a usar Buscobien con consentimiento legal sin generar duplicados en la BD**

**Conversation:**
`RegisterScreenUsers` (ConsumerStatefulWidget en `login_03_form_register_user.dart`) presenta un `Form` con 12 `TextFormField` (userName, userPass, confirmUserPass, email, celular, nombres, apellidos, RFC si Promotor, etc.), dos `CheckboxTerminoCondiciones` (StatefulWidget anidado) con visor PDF invocable (`_abrirPdfTyC()` y `_abrirPdfPrivacidad()`). Al enviar, `_registrarUsuario()` valida `userPass == confirmUserPass` y que ambos checkboxes estén marcados; genera `_id = SHA256(userId + pass)` (anti-colisión literal); verifica duplicado con `getUserIdNamePassByNameID`; si no existe, envía documento a la DB correspondiente según `nombrePerfil` (`buscobien_usuarios` / `buscobien_usuarios_promotores` / `buscobien_usuarios_propietarios`) vía `SessionRepository.writeUserToCouchDB()` con auth headers. PDFs en `assets/pdfs/`, abiertos con `open_filex` (mobile) / `url_launcher` (web). Textos TyC (13 secciones) y Privacidad (7 secciones) en `textos_tc_ap.dart`.

**Confirmation:**
- [ ] Formulario con los 12 campos requeridos, cada uno con validación específica (regex email, longitud pass, RFC si Promotor)
- [ ] `confirmUserPass !== userPass` → mensaje de error y no envía
- [ ] Checkboxes TyC y Privacidad bloquean el envío si no están marcados
- [ ] Botón "Ver TyC" abre PDF (`open_filex.openFile()` en mobile, `url_launcher.launchUrl()` en web)
- [ ] Botón "Ver Privacidad" abre PDF idem
- [ ] `_id = SHA256(userId + pass)` generado como ID de documento CouchDB
- [ ] Verificación de duplicado con `getUserIdNamePassByNameID` antes de guardar
- [ ] Selección de DB correcta según `nombrePerfil`
- [ ] Si duplicado → SnackBar "Usuario ya existe"
- [ ] Si éxito → SnackBar "Registro exitoso" y navega a Login
- [ ] Hipotética colisión SHA256 → retorno 500 genérico (riesgo conocido)

---

## US-AUTH-003: Recuperación de Password vía Email con Token 1 Hora y Deep Link

**Card:**
Como **usuario que olvidé mi password**
Quiero **solicitar recuperación por email, recibir un enlace válido por 1 hora, y cambiar mi password dentro de la app**
Para **recuperar acceso sin intervención de soporte, desde cualquier plataforma**

**Conversation:**
`PageSolicitarRecuperacion` (ConsumerStatefulWidget en `page_solicitar_recuperacion.dart`) presenta `Form` con `email` (TextFormField con regex) + `DropdownButtonFormField` para `nombrePerfil`. Al enviar, `_solicitarRecuperacion()` invoca `buscarUsuarioPorCorreo(email, perfil)` (Mango query en DB correspondiente); si encuentra, `generateResetToken()` (en `40_security/generate_reset_token.dart`) genera `token = SHA256(UUIDv4)` + `expiry = UTC+1h ISO8601`; `guardarTokenRecuperacion(token, expiry, userId, perfil)` hace PUT en `buscobien_recuperacion_contrasena`; `enviarCorreoRecuperacion(email, token, perfil)` hace POST `http://citigov.cloud:3001/api/enviar-correo-recuperacion` (Node.js mailer). Email contiene enlace `/recuperar?token=X&perfil=Y` que abre la app vía App Link (Android) / Universal Link (iOS) / URI (Web). `deep_link_handler.dart` parsea y navega a `/cambiopassword` con `arguments={token, perfil}`. `PageCambioPassword` (`page_cambio_password.dart`) recibe los argumentos, en `initState` invoca `validarToken(token, perfil)` (existe, no expirado, coincide perfil); si válido, muestra `Form` nuevo password con **strength meter** (débil/media/fuerte) y al confirmar `actualizarPassword(newPass, userId, perfil)` hashea el nuevo pass con SHA-256 y actualiza en CouchDB.

**Confirmation:**
- [ ] Pantalla `/solicitarrecuperacion` muestra email + dropdown perfil
- [ ] Email inválido → validación regex bloquea envío
- [ ] Usuario no encontrado → SnackBar "Correo no registrado"
- [ ] Usuario encontrado → token SHA256(UUIDv4) generado + expiry UTC+1h
- [ ] Documento guardado en `buscobien_recuperacion_contrasena`
- [ ] Email enviado vía Node.js mailer (POST HTTP, no falla aunque mailer no responda — log de error)
- [ ] Enlace recibido tiene formato `/recuperar?token=X&perfil=Y`
- [ ] Abrir enlace en Android App Link / iOS Universal Link / Web → navega a `/cambiopassword`
- [ ] `validarToken` verifica: existe en DB, no expirado, `perfil` coincide
- [ ] Token expirado > 1h → mensaje "Token expirado, solicite nuevo"
- [ ] Token inválido / no coincide perfil → mensaje "Token inválido"
- [ ] Formulario nuevo pass con strength meter (3 niveles: débil rojo, media ámbar, fuerte verde)
- [ ] Confirmación → `actualizarPassword` hashea nuevo pass y PUT actualiza en DB correspondiente
- [ ] Tras cambio exitoso → navega a Login con mensaje "Contraseña actualizada"

---

## US-AUTH-004: Gestión de Avatar con FilePicker, Base64 y Persistencia en CouchDB

**Card:**
Como **usuario autenticado**
Quiero **subir una imagen de mi galería, previsualizarla y guardarla como avatar**
Para **personalizar mi perfil y verse en el AppBar del shell principal**

**Conversation:**
`GestionAvatares` (ConsumerStatefulWidget en `avatar/manejo_imagenes_avatar.dart`) expone botón "Cambiar avatar" que invoca `_pickImage()` (FilePicker con tipo `image`, máximo 1 archivo). Tras seleccionar, lee bytes, `base64Encode()` para codificar, construye `ValueGetUserAvatar(`avatar: base64, contentType: ...)` y muestra `Image.memory(bytes)` como preview. Si usuario confirma, `_saveAvatar()` invoca `ref.read(classUserAvatarProvider.notifier).guardaArchivoAvatar(valueAvatar)` — hace PUT nativo a CouchDB en `buscobien_usuarios` con auth headers, documento `_id = user:avatar:$userId`. Tras guardar, `recuperaDatosDelAvatar()` GET a vista CouchDB refresca el state y el avatar se muestra en `appBarPrincipal` (vía `classUserAvatarProvider` watcher). `getAvatarImage` (FutureProvider) expone una future cacheable por si solo se necesita la imagen.

**Confirmation:**
- [ ] Botón "Cambiar avatar" abre FilePicker con tipo image, maxFiles=1
- [ ] Imagen seleccionada se previsualiza vía `Image.memory`
- [ ] Codificación base64 con `contentType` detectado
- [ ] PUT a CouchDB con `_id = user:avatar:$userId`, Basic Auth headers
- [ ] Si el documento ya existe → `_rev` actualizado (no duplica)
- [ ] Tras guardar, `recuperaDatosDelAvatar()` GET a vista refresca state
- [ ] Avatar visible en `CircleAvatar` del `appBarPrincipal` (shell principal)
- [ ] Si selecciona sin confirmar → no se guarda (botón cancelar rollback preview)
- [ ] Imagen muy grande → sin compresión previa (riesgo de payload excesivo — no implementado)
- [ ] Errores HTTP → SnackBar y mantiene preview previa

---

## US-AUTH-005: Logout con Limpieza de Sesión Local y Estado Auth Restaurado a Initial

**Card:**
Como **usuario autenticado que quiere cerrar sesión**
Quiero **que se limpien mis credenciales del storage local y se resete el estado AuthState"
Para **que la siguiente apertura me pida login nuevamente**

**Conversation:**
`PaginaPerfilWidget` (en `08_pantallas/perfil/pagina_perfil.dart`) tiene un botón "Cerrar Sesión" que invoca `ref.read(sessionProvider.notifier).deleteLocalSessionData()` — método que llama a `SessionStorage.deleteAll()` (limpia `FlutterSecureStorage` en mobile o `SharedPreferences.clear()` en web), y luego `state = AuthState.initial()` (resetea todos los flags `esXxx`, `isAuthenticated=false`, `isUserDataLoaded=false`, vacía `SessionData`, `GetIdUserPass`, `GetUserData`). Tras limpiar, navega a `AppRoutes.login` con `pushReplacementNamed`. Importante: no revoca JWT en server (no hay endpoints de revocación), solo limpia el side del cliente.

**Confirmation:**
- [ ] Botón "Cerrar Sesión" presente en `PaginaPerfilWidget`
- [ ] Al pulsar → `deleteLocalSessionData()`:
  - [ ] `SessionStorage.deleteAll()` limpia todas las claves en storage
  - [ ] `state = AuthState.initial()` resetea todos los flags
- [ ] `isAuthenticated` pasa a `false`
- [ ] Todos los flags `esXxx` pasan a `false`
- [ ] `isUserDataLoaded` pasa a `false` (importante para evitar cache huérfano)
- [ ] Navegación a `/login` con `pushReplacementNamed` (sin back stack al splash)
- [ ] Reabrir app → requiere login (no restaura sesión)
- [ ] JWT en server NO se revoca (limpieza solo local)
- [ ] Si `deleteLocalSessionData()` falla (ej. storage corrupto) → excepción propagada

---

## Notas

- Estas US reemplazan a las consolidadas en `04_User_Stories/03_listas.md` (US-AUTH-001 a US-AUTH-004) con formato 3 C's completo (Card + Conversation + Confirmation) e incluyen la nueva US-AUTH-005 (logout).
- Complementan la Epic en `02_Epics_EARS/10_user_login.md` y los escenarios Gherkin en `03_Features_BDD/10_user_login/autenticacion_sesion.feature`.
- Para detalles por archivo (19 archivos, 2 tablas + notas): ver `05_Tareas_Inventarios/10_user_login/elementos_10_user_login.md`.
- USS-AUTH-006 (Cambio de password tras login, no recovery) no se documenta porque el código no implementa ese flujo (solo recovery con token) — deuda de producto identificado.
