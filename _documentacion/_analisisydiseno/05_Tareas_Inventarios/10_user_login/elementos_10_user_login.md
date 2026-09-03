# Inventario de Componentes — 10_user_login

**Directorio:** `lib/10_user_login/`
**Subdirectorios:** `avatar/` (3 archivos), `data_models/` (5 archivos), `usuario_login/` (11 archivos)
**Total:** **19 archivos `.dart`** (sin incluir `.g.dart` ni `.freezed.dart` autogenerados)
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo)

### Subdirectorio `avatar/`

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| avatar | `data_user_avatar_get.dart` | Clases modelo | `GetUserAvatar`, `RowGetUserAvatar`, `ValueGetUserAvatar` | `id, rev, idFoto, idUsuario, avatar (base64), contentType, timestamp` | — | 7 campos `final` | — |
| avatar | `manejo_imagenes_avatar.dart` | ConsumerStatefulWidget | `GestionAvatares` | — | `classUserAvatarProvider`, `FilePicker`, `base64Encode`, `appTheme` | `_GestionAvataresState` | `appTheme`, `Image.memory`, `FilePicker`, `ElevatedButton` |
| avatar | `provider_get_avatar.dart` | Notifier (@riverpod) + FutureProvider | `ClassUserAvatarNotifier`, `classUserAvatarProvider`, `getAvatarImage` | — | `http`, `crypto`, `SessionStorage` | `state` | `http.put()`, `http.get()`, `sha256.convert()`, métodos: `guardaArchivoAvatar()`, `recuperaDatosDelAvatar()`, `updateUserAvatarFile()` |

### Subdirectorio `data_models/`

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| data_models | `auth_state.dart` | Clase inmutable con `copyWith` | `AuthState` | `SessionData?`, `GetIdUserPass?`, `GetUserData?`, 9 flags roles (`esPromotor`, `esPropietario`, `esInmobiliaria`, `esProveedor`, `esAsociacion`, `esHospedaje`, `esServicio`, `esMarket`), `isAuthenticated`, `isUserDataLoaded` | — | 14 campos `final` + `copyWith()`, factory `AuthState.initial()` | — |
| data_models | `data_get_id_user_pass.dart` | Clases respuesta (JSON serializable) | `GetIdUserPass`, `RowIdUserPass`, `ValueIdUserPass` | `userId, userName, userPass, idFoto` | — | 4 campos `final` (value), rows[], totalRows, offset | — |
| data_models | `data_get_user.dart` | Clases respuesta | `GetUserData`, `RowGetUserData`, `ValueGetUserData` → `Usuario` | `Usuario` completo | — | Nested con `data_usuarios.dart` | `getUserDataFromJson()` |
| data_models | `data_user_promotor.dart` | Clase extra para promotores | `UserDataPromotor` | `tipoUsuario, rfc, numCliente, inmobiliaria, contadores espacios` | — | 8 campos | — |
| data_models | `data_usuarios.dart` | Clases anidadas | `Usuario`, `UbicacionUserData`, `FechaDeNacimiento`, `LocalidadCp` | 20+ campos usuario + nested | — | Nested models | `usuarioFromJson()` |

### Subdirectorio `usuario_login/`

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| usuario_login | `data_session.dart` | Clase inmutable con `copyWith` | `SessionData` | `key, varName, valueToSave, userId, userName, userPass, esUsuario* (3 String), boolUsuario* (3 bool)` | — | 10+ campos `final` + `copyWith()` | — |
| usuario_login | `dialogbox_login.dart` | Función top-level | `dialogBoxFichaLogin` | `BuildContext, WidgetRef` | `LoginPage`, `sessionProvider` | — | `AlertDialog`, `LoginPage`, `Navigator.pop()` |
| usuario_login | `login_01_login_page.dart` | ConsumerStatefulWidget | `LoginPage` (+ `DropdownTipoUsuario` StatefulWidget anidado) | — | `sessionProvider`, `classUserAvatarProvider`, `SessionStorage`, `AppRoutes` | `_LoginPageState` | `Form`, `TextFormField`, `DropdownButton`, `FilledButton/ElevatedButton`, `appTheme` |
| usuario_login | `login_03_form_register_user.dart` | ConsumerStatefulWidget | `RegisterScreenUsers` (+ `CheckboxTerminoCondiciones` StatefulWidget anidado) | — | `sessionProvider`, `SessionRepository`, `SessionStorage`, PDF viewers (`open_filex`/`url_launcher`), `textos_tc_ap` | `_RegisterScreenUsersState` | `Form` (12 campos), `Checkbox` TyC/Privacidad, `appTheme` |
| usuario_login | `page_cambio_password.dart` | ConsumerStatefulWidget | `PageCambioPassword` | `String token, String perfil` | `password_recovery_repository`, strength meter (débil/media/fuerte) | `_PageCambioPasswordState` | `Form`, `TextFormField`, `ElevatedButton`, `appTheme` |
| usuario_login | `page_solicitar_recuperacion.dart` | ConsumerStatefulWidget | `PageSolicitarRecuperacion` | — | `password_recovery_repository`, `generate_reset_token` | `_PageSolicitarRecuperacionState` | `Form`, `DropdownButton` perfil, `ElevatedButton`, `appTheme` |
| usuario_login | `password_recovery_repository.dart` | Funciones HTTP top-level | `buscarUsuarioPorCorreo`, `guardarTokenRecuperacion`, `validarToken`, `actualizarPassword`, `enviarCorreoRecuperacion` | Varios | `http`, `Mango queries`, Node.js mailer URL (`citigov.cloud:3001`), `generateResetToken()` | — | `http.post()`, `http.put()`, `http.get()`, `generateResetToken()` (de `40_security`) |
| usuario_login | `provider_session.dart` | Notifier (@riverpod) | `SessionNotifier`, `sessionProvider`, `sessionStorageProvider` | — | `AuthState`, `SessionRepository`, `SessionStorage`, `SessionData`, `GetUserData`, `crypto` | `state` (AuthState) | **20+ métodos** (ver Tabla 2) |
| usuario_login | `session_repository.dart` | Clase HTTP puro | `SessionRepository` | — | `http`, `crypto` (SHA256), `direccionip`, `generate_hash.dart` | — | `http.get()`, `http.post()`; usa vistas CouchDB (`vistaNOMBRE`, `vistaNOMBREPASS`) |
| usuario_login | `session_storage.dart` | Interface + 2 impl + factory | `SessionStorage` (abstract), `MobileSessionStorage`, `WebSessionStorage`, `createSessionStorage()` | — | `flutter_secure_storage`, `shared_preferences`, `kIsWeb` | — | `FlutterSecureStorage`, `SharedPreferences.getInstance()` |
| usuario_login | `textos_tc_ap.dart` | Constantes String + Widget | `textoTerminosCondiciones` (13 secc), `textoAcuerdoPrivacidad` (7 secc), `VisorTerminosWidget` | `String texto` | regex parsing para estilos | — | `Text`, `Column`, `open_filex` (mobile) / `url_launcher` (web) |

---

## Tabla 2: Elementos (por archivo)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| avatar | `data_user_avatar_get.dart` | — | `GetUserAvatar`, `RowGetUserAvatar`, `ValueGetUserAvatar` | `id, rev, idFoto, idUsuario, avatar, contentType, timestamp` | Constructores + `fromJson`/`toJson` | — | — |
| avatar | `manejo_imagenes_avatar.dart` | — | `GestionAvatares` (ConsumerStatefulWidget), `_GestionAvataresState` | — | `createState()`, `build()`, `_pickImage()` (FilePicker), `_saveAvatar()` (base64 + provider), `_loadAvatar()` | `classUserAvatarProvider`, `FilePicker`, `base64Encode`, `appTheme` | `FilePicker.platform.pickFiles()`, `base64Encode()`, `ref.read(classUserAvatarProvider.notifier).guardaArchivoAvatar()`, `Image.memory` |
| avatar | `provider_get_avatar.dart` | `classUserAvatarProvider`, `getAvatarImage` (FutureProvider) | `ClassUserAvatarNotifier` | `state` | `guardaArchivoAvatar()`, `recuperaDatosDelAvatar()`, `updateUserAvatarFile()`, `getAvatarImage()` | `http`, `crypto`, `SessionStorage` (vía ref) | `http.put()`, `http.get()`, `sha256.convert()`, `direccionip` |
| data_models | `auth_state.dart` | — | `AuthState` | `sessionUserData (SessionData?)`, `initialIdUserPass (GetIdUserPass?)`, `userData (GetUserData?)`, 9 flags `bool`, `isAuthenticated: bool`, `isUserDataLoaded: bool` | `AuthState.initial()`, `copyWith()`, `==`, `hashCode`, `toString` | — | — |
| data_models | `data_get_id_user_pass.dart` | — | `GetIdUserPass`, `RowIdUserPass`, `ValueIdUserPass` | 4 campos en `ValueIdUserPass` | `getIdUserPassFromJson()` (top-level) | — | — |
| data_models | `data_get_user.dart` | — | `GetUserData`, `RowGetUserData`, `ValueGetUserData` | `Usuario value` | `getUserDataFromJson()` (top-level) | `data_usuarios.Usuario` | — |
| data_models | `data_user_promotor.dart` | — | `UserDataPromotor` | 8 campos | Constructor + `fromJson`/`toJson` | — | — |
| data_models | `data_usuarios.dart` | — | `Usuario`, `UbicacionUserData`, `FechaDeNacimiento`, `LocalidadCp` | 20+ campos `Usuario` + nested | `usuarioFromJson()` | — | — |
| usuario_login | `data_session.dart` | — | `SessionData` | `key, varName, valueToSave, userId, userName, userPass, esUsuarioComprador, esUsuarioPromotor, esUsuarioEspecialista, boolUsuario*/3` | Constructor `const + copyWith()` | — | — |
| usuario_login | `dialogbox_login.dart` | — | — | — | `dialogBoxFichaLogin(BuildContext, WidgetRef)` | `sessionProvider`, `LoginPage` | `showDialog`, `AlertDialog`, `Navigator.pop()`, `LoginPage` |
| usuario_login | `login_01_login_page.dart` | — | `LoginPage` (ConsumerStatefulWidget), `DropdownTipoUsuario` (StatefulWidget) | — | `createState()`, `_handleLogin()` (valida, persiste, navega), `DropdownTipoUsuario.onChanged` (compone → `setNombrePerfil`) | `sessionProvider`, `classUserAvatarProvider`, `SessionStorage`, `AppRoutes.principal`, `appTheme` | `Form`, `TextFormField`, `DropdownButtonFormField`, `FilledButton`, `ref.read(sessionProvider.notifier).getUserIdNamePassByName()`, `recuperaDatosDelAvatar()` |
| usuario_login | `login_03_form_register_user.dart` | — | `RegisterScreenUsers` (ConsumerStatefulWidget), `CheckboxTerminoCondiciones` (StatefulWidget) | — | `createState()`, `_registrarUsuario()` (valida, genera hash, POST), `_abrirPdfTyC()`, `_abrirPdfPrivacidad()` | `sessionProvider`, `SessionRepository`, `SessionStorage`, `textos_tc_ap`, `open_filex`, `url_launcher` | `Form`, `TextFormField` (12 campos), `Checkbox`, `open_filex.openFile()`, `url_launcher.launchUrl()` |
| usuario_login | `page_cambio_password.dart` | — | `PageCambioPassword`, `_PageCambioPasswordState` | — | `createState()`, `initState()` (valida token), `_cambiarPassword()` (strength meter, actualizar en CouchDB) | `password_recovery_repository.actualizarPassword()`, `password_recovery_repository.validarToken()`, `token`, `perfil` | `Form`, `TextFormField`, `ElevatedButton`, `appTheme` |
| usuario_login | `page_solicitar_recuperacion.dart` | — | `PageSolicitarRecuperacion`, `_PageSolicitarRecuperacionState` | — | `createState()`, `_solicitarRecuperacion()` (busca usuario, genera token, envía email) | `password_recovery_repository.buscarUsuarioPorCorreo()`, `guardarTokenRecuperacion()`, `enviarCorreoRecuperacion()`, `generateResetToken()` | `Form`, `DropdownButtonFormField`, `ElevatedButton`, `appTheme` |
| usuario_login | `password_recovery_repository.dart` | — | (sin clase, solo funciones) | — | `buscarUsuarioPorCorreo(email, perfil)`, `guardarTokenRecuperacion(token, expiry, userId, perfil)`, `validarToken(token, perfil)`, `actualizarPassword(newPass, userId, perfil)`, `enviarCorreoRecuperacion(email, token, perfil)` | `http`, `direccionip`, `generateResetToken()` (de `40_security`), Node.js mailer URL | `http.post()`, `http.put()`, `http.get()` |
| usuario_login | `provider_session.dart` | `sessionProvider`, `sessionStorageProvider` (ambos @riverpod) | `SessionNotifier extends _$SessionNotifier` | `state` (AuthState), `_storage` (getter→`sessionStorageProvider`), `_authHeaders` (getter→Basic Auth headers) | **24+ métodos**: `build()`, `resetInitialUserData(seccion)`, `saveVarValueToLocalStorage()`, `getSessionValuesFromLocalStorage()`, `deleteLocalSessionData()`, `setPerfilUsuarioByNombrePerfil()`, `setSessionVarValue()`, `setNombrePerfil()`, `setRoleFlag()`, `getSessionVarValue()`, `setUserData()`, `setCampoUserData()`, `getCampoUserData()`, `updateLocalidadEnSesion()`, `getUserDataByNameInSessionData()`, `getUserIdNamePassByName()`, `getUserIdNamePassByNameID()`, `writeUserToCouchDB()` | `AuthState`, `SessionRepository`, `SessionStorage`, `SessionData`, `crypto`, `Direccionip` | `SessionRepository.getUserDataByName()`, `SessionRepository.getUserIdNamePassByName()`, `SessionRepository.writeUserToCouchDB()`, `SessionStorage.save()`, `sha256.convert()` |
| usuario_login | `session_repository.dart` | — | `SessionRepository` | — | `getUserDataByName({userName, nombrePerfil, authHeaders})`, `getUserIdNamePassByName({...})`, `getUserIdNamePassByNameID({userId, nombrePerfil, ...})`, `writeUserToCouchDB({...})` (hash `_id`, verifica duplicado) | `http`, `crypto`, `direccionip`, `generate_hash.dart` | `http.get()`, `http.post()`, `sha256.convert()`, vistas CouchDB (`vistaNOMBRE`, `vistaNOMBREPASS`) |
| usuario_login | `session_storage.dart` | `createSessionStorage()` factory | `SessionStorage` (abstract), `MobileSessionStorage`, `WebSessionStorage` | — | `read({key})`, `write({key, value})`, `deleteAll()` | `flutter_secure_storage`, `shared_preferences`, `kIsWeb` | `FlutterSecureStorage()`, `SharedPreferences.getInstance()` |
| usuario_login | `textos_tc_ap.dart` | `textoTerminosCondiciones` (13 secciones String), `textoAcuerdoPrivacidad` (7 secciones String) | `VisorTerminosWidget` | `texto: String` | `build()` con regex parsing para estilos; `abrirPdfDesdeAssets()` (open_filex mobile / url_launcher web) | `open_filex`, `url_launcher`, regex | `Text`, `Column`, `open_filex.openFile()`, `url_launcher.launchUrl()` |

---

## Notas

- **Recuento correcto**: 19 archivos `.dart` no generados (3 en `avatar/`, 5 en `data_models/`, 11 en `usuario_login/`). Se excluyen `.g.dart` y `.freezed.dart` autogenerados.
- **Generación código**: `provider_session.dart` y `session_repository.dart` usan `@riverpod` (Riverpod Generator) → requieren `dart run build_runner build --delete-conflicting-outputs` tras cambios.
- **`SessionNotifier` es monolítico**: 24+ métodos, viola SRP — candidato a split en `AuthProvider`, `UserDataProvider`, `RecoveryProvider`.
- **3 DBs CouchDB según `nombrePerfil`**: `buscobien_usuarios` (Usuario), `buscobien_usuarios_promotores` (Promotor), `buscobien_usuarios_propietarios` (Propietario). La selección se hace en `session_repository.dart`.
- **`SessionStorage` factory pattern**: `kIsWeb` → `WebSessionStorage` (SharedPreferences); otros casos → `MobileSessionStorage` (FlutterSecureStorage). La elección **no incluye** Linux/macOS explícitamente — caen en `MobileSessionStorage` (`!kIsWeb`), que puede no ser óptimo.
- **Hash `_id` CouchDB**: `SHA256(userId + pass)` — riesgo de colisión no manejado (diferencia entre "usuario ya existe" y "error DB" returns 500 genérico).
- **Basic Auth headers**: `_authHeaders` getter construye `Basic <base64(user:pass)>`; JWT no se ve directamente en este archivo (parámetros `authHeaders` se reciben del caller).
- **TyC/Privacidad**: 13 + 7 secciones de texto constante + visor PDF. PDFs en `assets/pdfs/` (abrir con `open_filex` mobile, `url_launcher` web).
- **Node.js mailer URL hardcoded**: `http://citigov.cloud:3001/api/enviar-correo-recuperacion` en `password_recovery_repository.dart` — URL externa sin pasar por `direccionip.dart`.
- **`AuthState.initial()`**: factory que crea estado vacío (sin sesión) usado por `SessionNotifier.build()` al iniciar y tras `deleteLocalSessionData()`.
- **`setPerfilUsuarioByNombrePerfil()`**: switch de 9 roles que setea los flags `esXxx` booleanos en AuthState (vía `copyWith`).
- **No hay tests** de autenticación, hashing, recovery, ni persistencia.

## Deuda técnica detectada

1. **`SessionNotifier` monolítico** (24+ métodos) — viola SRP.
2. **URL mailer hardcoded** en `password_recovery_repository.dart` en lugar de `direccionip.dart`.
3. **`sessionStorage`** no distingue Linux/macOS (caen en `Mobile` implícitamente).
4. **Colisión `_id` SHA256** no diferenciada entre "usuario existe" y "error DB".
5. **`username`/`password`** como globales en `direccionip.dart` usados por `_authHeaders` — credenciales DB visibles en cliente (no JWT).
6. **PDF TyC/Privacidad** requiere assets físicos (`assets/pdfs/`) → si faltan, lanza excepción.
7. **Sin tests** unitarios ni de integración para auth.
