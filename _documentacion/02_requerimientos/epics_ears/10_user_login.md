# Epic: Autenticación, Sesión, Registro y Recuperación (10_user_login)

> **Nota de exactitud (2026-10-07):** donde este documento menciona Dio, interceptor JWT o que Flutter no toca CouchDB, describe la arquitectura **objetivo**. El código actual usa el paquete `http`, Basic Auth contra CouchDB con credenciales compiladas (`--dart-define`) y no obtiene ni envía JWT; `SessionStorage` usa `flutter_secure_storage` en Android/iOS/Windows y `shared_preferences` solo en Web. Ver [arquitectura general](../../04_arquitectura_y_diseno/arquitectura_general_buscobien.md).

**Directorio:** `lib\10_user_login\`  
**Subdirectorios:** `avatar/` (4), `data_models/` (5), `usuario_login/` (14) — **Total: 23 archivos**  
**Fecha:** 2026-08-12  
**Fuente:** Ingeniería inversa

---

## Impact Mapping

| Objetivo de Negocio | Actor | Impacto | Entregable |
|---------------------|-------|---------|------------|
| Acceso seguro multi-rol (usuario, promotor, propietario) | Usuario final | Login con user/pass, registro con validación, recuperación password por email, avatar | Flujo completo auth + perfil |
| | Promotor/Propietario | Registro con campos extra (RFC, inmobiliaria, contadores espacios) | `RegisterScreenUsers` con checkbox TyC/Privacidad PDF |
| | Sistema | JWT en secure storage (mobile) / shared_preferences (web), hash SHA-256 pass, tokens reset 1h | `SessionStorage` factory + `generate_hash.dart` + `generate_reset_token.dart` |

---

## User Story Mapping

```
Usuario abre app → /login (dialogBoxFichaLogin)
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│ LoginPage: Form user/pass + DropdownTipoUsuario             │
│ - _handleLogin() → getUserIdNamePassByName()                │
│   → valida credenciales → guarda sessionStorage             │
│   (userId, userName, nombrePerfil, userPassHash)            │
│   → recupera avatar → navega a Principal                    │
└────────────────────────┬────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
   Registro          Recuperación      Cambio Pass
   (RegisterScreen)  (SolicitarRecup)  (PageCambioPass)
   - 12 campos       - Email + perfil  - Token validación
   - TyC/Privacidad  - Mango query     - Strength meter
   - PDF viewer      - generateToken   - actualizarPass
   - writeUserToDB   - Node.js mailer  - SHA256 hash
```

---

## Especificación SDD / EARS

**Prefijo IDs:** `REQ-AUTH-XXX`

| ID | Tipo EARS | Requerimiento | Evidencia | Estado |
|----|-----------|---------------|-----------|--------|
| REQ-AUTH-001 | **Ubicuo** | El sistema expondrá `SessionNotifier` (`@riverpod`) como **estado central de sesión** (`AuthState` inmutable unificando SessionData, GetIdUserPass, GetUserData + flags roles + `isAuthenticated`). | `lib\10_user_login\usuario_login\provider_session.dart` | En código |
| REQ-AUTH-002 | **Evento** | Cuando el usuario envíe credenciales en `LoginPage`, el sistema ejecutará `getUserIdNamePassByName()` → si válido: `deleteLocalSessionData()` → `getUserDataByNameInSessionData()` → guarda en storage: `userId`, `userName`, `nombrePerfil`, `userPassHash` (SHA-256) → `recuperaDatosDelAvatar()` → navega a principal. | `login_01_login_page.dart:80-150`, `provider_session.dart:200-280` | En código |
| REQ-AUTH-003 | **Evento** | Cuando el usuario complete `RegisterScreenUsers` (12 campos + TyC/Privacidad checkboxes), el sistema validará `pass == confirmPass`, hasheará `SHA256(userId+pass)` como `_id` CouchDB, verificará duplicado, guardará en `buscobien_usuarios` / `buscobien_usuarios_promotores` / `buscobien_usuarios_propietarios` según `nombrePerfil`. | `login_03_form_register_user.dart:160-318`, `session_repository.dart:79-119` | En código |
| REQ-AUTH-004 | **Evento** | Cuando el usuario solicite recuperación en `PageSolicitarRecuperacion`, el sistema buscará usuario por email (`buscarUsuarioPorCorreo` Mango query), generará `resetToken = SHA256(UUIDv4)`, `expiry = UTC+1h`, guardará `usuario.reset_token` y `usuario.token_expiry` en el documento del usuario (`buscobien_usuarios`, `buscobien_usuarios_promotores` o `buscobien_usuarios_propietarios` según el perfil) y enviará email vía Node.js mailer (`http://citigov.cloud:3001/api/enviar-correo-recuperacion`). | `page_solicitar_recuperacion.dart`, `password_recovery_repository.dart` | En código |
| REQ-AUTH-005 | **Estado** | Mientras el usuario acceda a `/cambiopassword?token=X&perfil=Y` (deep link), el sistema validará token (`validarToken` → existe, no expirado, coincide perfil) y permitirá cambio de password con strength meter. | `page_cambio_password.dart`, `password_recovery_repository.dart:60-80` | En código |
| REQ-AUTH-006 | **Ubicuo** | El sistema proveerá `SessionStorage` factory que retorna `WebSessionStorage` (`shared_preferences`) cuando `kIsWeb` es verdadero y `MobileSessionStorage` (`flutter_secure_storage`) en cualquier otra plataforma (Android, iOS, Windows, Linux, macOS); la decisión usa solo `kIsWeb`. | `lib\10_user_login\usuario_login\session_storage.dart` | En código |
| REQ-AUTH-007 | **Ubicuo** | El sistema definió `AuthState` (Freezed-style inmutable con `copyWith`) unificando: SessionData, GetIdUserPass, GetUserData, flags (`esUsuario`, `esPromotor`, `esPropietario`, `esAnfrition`, `esVendedor`, `esEspecialista`, `esProveedor`, `esAsociacion`, `esInmobiliaria`, `esUsuarioComprador`, `esUsuarioPromotor`, `esUsuarioEspecialista`), `isAuthenticated`, `isUserDataLoaded`. | `lib\10_user_login\data_models\auth_state.dart` | En código |
| REQ-AUTH-008 | **No Deseado** | Si `flutter_secure_storage` falla en móvil (permiso denegado, storage corrupto), el sistema propagará excepción (sin fallback a shared_preferences en móvil). | `session_storage.dart:MobileSessionStorage` try-catch ausente | Riesgo |
| REQ-AUTH-009 | **No Deseado** | Si `writeUserToCouchDB()` detecta `_id` duplicado (hash colisión), el sistema retornará error genérico sin diferenciar "usuario ya existe" vs "error DB". | `session_repository.dart:99-109` | Parcial |
| REQ-AUTH-010 | **Complejo** | Mientras la sesión sea válida, cuando `SessionNotifier.getSessionValuesFromLocalStorage()` restaure datos, el sistema reconstruirá `AuthState` completo y disparará `setPerfilUsuarioByNombrePerfil()` (switch 9 roles) para setear flags correctos. | `provider_session.dart:120-180` | En código |
| REQ-AUTH-011 | **Ubicuo** | El sistema soportará 9 perfiles de usuario (Usuario, Promotor, Propietario, Anfitrión, Vendedor, Especialista, Proveedor, Asociación, Inmobiliaria); el perfil elegido en el dropdown determina la base de usuarios (`buscobien_usuarios`, `buscobien_usuarios_promotores` o `buscobien_usuarios_propietarios`) y los flags de rol de `AuthState`. | `password_recovery_repository.dart:21-25`, `data_models/auth_state.dart:19-43`; SDD_10_user_login §1.1, §3.4 | En código |
| REQ-AUTH-012 | **Evento** | Cuando el usuario abra el diálogo de login y el flag `warningApp` esté activo, el sistema mostrará un aviso de aplicación en pruebas/demostración antes del formulario; «Salir» restablece los datos iniciales y cierra el diálogo. | `usuario_login/dialogbox_login.dart`; SDD_10_user_login §2.2 | En código |

---

## Trazabilidad a Código — Avatar

| Componente | Archivo | Función |
|------------|---------|---------|
| `ClassUserAvatarNotifier` (@riverpod) | `avatar/provider_get_avatar.dart` | `guardaArchivoAvatar()` (PUT nativo), `recuperaDatosDelAvatar()` (GET vista), `updateUserAvatarFile()`, `getAvatarImage` (FutureProvider) |
| `GestionAvatares` widget | `avatar/manejo_imagenes_avatar.dart` | FilePicker → base64 → preview → save via provider |
| Modelos avatar | `avatar/data_user_avatar_get.dart` | `GetUserAvatar`, `ValueGetUserAvatar` (id, rev, idFoto, idUsuario, avatar base64, contentType) |

---

## Trazabilidad a Código

La evidencia de cada requerimiento (archivo y líneas) está en la columna **Evidencia** de la tabla anterior. Archivos adicionales no citados en ella:

| Modelo | Archivo | Entidad |
|--------|---------|---------|
| `GetIdUserPass` / `ValueIdUserPass` | `data_models/data_get_id_user_pass.dart` | Login response |
| `GetUserData` / `ValueGetUserData` / `Usuario` | `data_models/data_get_user.dart` | Usuario completo |
| `UserDataPromotor` | `data_models/data_user_promotor.dart` | Campos extra promotor |
| `Usuario` + submodelos | `data_models/data_usuarios.dart` | Usuario, UbicacionUserData, FechaDeNacimiento, LocalidadCp |

---

## Trazabilidad a Código

La evidencia de cada requerimiento (archivo y líneas) está en la columna **Evidencia** de la tabla anterior. Archivos adicionales no citados en ella:

| Componente | Archivo | Función clave |
|------------|---------|---------------|
| `SessionData` | `usuario_login/data_session.dart` | Estado sesión inmutable |
| `textos_tc_ap.dart` | `usuario_login/textos_tc_ap.dart` | TyC (13 secc) + Privacidad (7) + Visor PDF |

---

## Notas de Arquitectura

- **Provider central monolítico**: `SessionNotifier` tiene 20+ métodos — viola SRP; candidata a split (`AuthProvider`, `UserDataProvider`, `AvatarProvider`).
- **3 DBs usuarios**: `buscobien_usuarios`, `buscobien_usuarios_promotores`, `buscobien_usuarios_propietarios` — selección por `nombrePerfil` en registro.
- **PDF TyC/Privacidad en assets**: `abrirPdfDesdeAssets()` con `open_filex` (mobile) / `url_launcher` (web) — archivos en `assets/pdfs/`.
- **Hash `_id` CouchDB**: `SHA256(userId + pass)` — colisiones teóricas posibles (no manejadas).
- **Deep link recovery**: Único flujo que usa `navigatorKey` fuera de widget tree (`deep_link_handler.dart`).