# SDD — Módulo 10_user_login (BuscoBien)
## Especificación de Requerimientos (EARS)
**Directorio fuente:** `lib/10_user_login`  
**Arquitectura:** Flutter + Riverpod + CouchDB + almacenamiento local  
**Bases de datos:** `buscobien_usuarios`, `buscobien_usuarios_promotores`

---

## 1. Requerimientos Ubicuos

### 1.1 Autenticación
- **REQ-AUTH-001:** El sistema deberá autenticar usuarios mediante nombre de usuario y contraseña.
- **REQ-AUTH-002:** El sistema deberá soportar múltiples perfiles de usuario: Usuario, Promotor, Propietario, Anfitrión, Vendedor, Especialista, Proveedor, Asociación, Inmobiliaria.
- **REQ-AUTH-003:** El sistema deberá determinar la base de datos de usuarios según el perfil seleccionado.

### 1.2 Seguridad
- **REQ-SEC-001:** El sistema deberá almacenar las contraseñas como hash SHA-256, nunca en texto plano.
- **REQ-SEC-002:** El sistema deberá generar el ID de usuario como hash SHA-256 de `nombreusuario + claveacceso + timestamp`.
- **REQ-SEC-003:** El sistema deberá autenticar todas las peticiones HTTP mediante encabezado `Authorization: Basic`.

### 1.3 Sesión
- **REQ-SES-001:** El sistema deberá mantener el estado de sesión en un proveedor Riverpod inmutable (`AuthState`).
- **REQ-SES-002:** El sistema deberá persistir la sesión en almacenamiento local seguro (`FlutterSecureStorage` en móvil, `SharedPreferences` en web).
- **REQ-SES-003:** El sistema deberá resetear todos los flags de rol al cerrar sesión.

---

## 2. Requerimientos Controlados por Eventos

### 2.1 Pantalla: Login
- **REQ-LOGIN-001:** Cuando el usuario abra la pantalla de login, el sistema deberá mostrar campos de usuario, contraseña y dropdown de perfil.
- **REQ-LOGIN-002:** Cuando el usuario presione "Entrar" sin completar campos, el sistema deberá mostrar un SnackBar con "Escriba usuario y contraseña".
- **REQ-LOGIN-003:** Cuando el usuario presione "Entrar" con credenciales válidas, el sistema deberá consultar CouchDB para validar el usuario.
- **REQ-LOGIN-004:** Cuando el usuario presione "Entrar" con credenciales válidas, el sistema deberá obtener el ID y datos del usuario.
- **REQ-LOGIN-005:** Cuando el login sea exitoso, el sistema deberá marcar `isAuthenticated = true`.
- **REQ-LOGIN-006:** Cuando el login sea exitoso, el sistema deberá guardar `userId`, `userName`, `nombrePerfil` y `userPassHash` en almacenamiento local.
- **REQ-LOGIN-007:** Cuando el login sea exitoso, el sistema deberá recuperar los datos completos del usuario por nombre y perfil.
- **REQ-LOGIN-008:** Cuando el login sea exitoso, el sistema deberá iniciar la recuperación del avatar en background.
- **REQ-LOGIN-009:** Cuando el login falle por credenciales incorrectas, el sistema deberá mostrar un diálogo "Usuario o contraseña incorrectos".
- **REQ-LOGIN-010:** Cuando ocurra un error inesperado durante login, el sistema deberá mostrar un SnackBar con el detalle del error.
- **REQ-LOGIN-011:** Cuando el usuario presione "¿Olvidaste tu clave?", el sistema deberá navegar a la pantalla de recuperación.
- **REQ-LOGIN-012:** Cuando el usuario presione "Regístrate", el sistema deberá navegar a la pantalla de registro.
- **REQ-LOGIN-013:** Mientras se procesa el login, el sistema deberá mostrar un indicador de carga circular y ocultar el teclado.

### 2.2 Diálogo de Login
- **REQ-DLG-001:** Cuando el usuario abra el diálogo de login, el sistema deberá verificar si el flag `warningApp` está activo.
- **REQ-DLG-002:** Cuando el flag `warningApp` esté activo, el sistema deberá mostrar un aviso importante de prueba y demostración.
- **REQ-DLG-003:** Cuando el usuario presione "Salir" en el diálogo, el sistema deberá resetear los datos iniciales y cerrar el diálogo.

### 2.3 Dropdown de Perfil
- **REQ-DROP-001:** Cuando el usuario cambie el perfil en el dropdown, el sistema deberá actualizar `nombrePerfil` en el estado.
- **REQ-DROP-002:** Cuando el usuario cambie el perfil, el sistema deberá actualizar los flags de rol correspondientes (`esUsuario`, `esPromotor`, etc.).
- **REQ-DROP-003:** Cuando el usuario seleccione "Promotor", el sistema deberá establecer `esPromotor = true` y `boolUsuarioPromotor = true`.

### 2.4 Registro de Usuario
- **REQ-REG-001:** Cuando el usuario abra la pantalla de registro, el sistema deberá mostrar el formulario con campos según el perfil.
- **REQ-REG-002:** Cuando el perfil sea "Promotor", el sistema deberá mostrar el campo RFC.
- **REQ-REG-003:** Cuando el usuario presione el botón de registro sin aceptar términos y condiciones, el sistema deberá impedir el envío.
- **REQ-REG-004:** Cuando el usuario envíe el formulario de registro válido, el sistema deberá generar el hash SHA-256 de la contraseña.
- **REQ-REG-005:** Cuando el usuario se registre exitosamente, el sistema deberá crear el documento en CouchDB (`buscobien_usuarios` o `buscobien_usuarios_promotores`).
- **REQ-REG-006:** Cuando el registro sea exitoso, el sistema deberá navegar a la pantalla de login.
- **REQ-REG-007:** Cuando el nombre de usuario ya exista, el sistema deberá retornar código 501 y no crear el usuario.

### 2.5 Recuperación de Contraseña
- **REQ-REC-001:** Cuando el usuario abra la pantalla de recuperación, el sistema deberá mostrar campos de correo y perfil.
- **REQ-REC-002:** Cuando el usuario presione "Enviar enlace", el sistema deberá buscar el usuario por correo y perfil en CouchDB.
- **REQ-REC-003:** Cuando el usuario no exista, el sistema deberá mostrar un mensaje "No se encontró una cuenta con ese correo y perfil".
- **REQ-REC-004:** Cuando el usuario exista, el sistema deberá generar un token único de recuperación.
- **REQ-REC-005:** Cuando el usuario exista, el sistema deberá calcular la fecha de expiración del token (1 hora).
- **REQ-REC-006:** Cuando el usuario exista, el sistema deberá guardar el token en CouchDB.
- **REQ-REC-007:** Cuando el token se guarde exitosamente, el sistema deberá enviar un correo con el enlace de recuperación.
- **REQ-REC-008:** Cuando el enlace se envíe exitosamente, el sistema deberá mostrar un mensaje de confirmación.
- **REQ-REC-009:** Cuando ocurra un error al guardar el token, el sistema deberá mostrar un mensaje de error.
- **REQ-REC-010:** Cuando ocurra un error al enviar el correo, el sistema deberá mostrar un mensaje de advertencia.

### 2.6 Cambio de Contraseña
- **REQ-CAM-001:** Cuando el usuario abra el enlace de recuperación, el sistema deberá validar el token contra CouchDB.
- **REQ-CAM-002:** Cuando el token sea inválido o haya expirado, el sistema deberá mostrar un mensaje de error y navegar a login.
- **REQ-CAM-003:** Cuando el token sea válido, el sistema deberá mostrar el formulario de nueva contraseña.
- **REQ-CAM-004:** Cuando el usuario escriba una contraseña, el sistema deberá calcular y mostrar el nivel de fortaleza.
- **REQ-CAM-005:** Cuando el usuario presione "Guardar", el sistema deberá validar que las contraseñas coincidan.
- **REQ-CAM-006:** Cuando el usuario guarde exitosamente, el sistema deberá generar el hash SHA-256 de la nueva contraseña.
- **REQ-CAM-007:** Cuando el usuario guarde exitosamente, el sistema deberá actualizar la contraseña en CouchDB.
- **REQ-CAM-008:** Cuando el cambio sea exitoso, el sistema deberá navegar a la pantalla de login.
- **REQ-CAM-009:** Cuando ocurra un error al actualizar, el sistema deberá mostrar un mensaje de error.

---

## 3. Requerimientos Controlados por Estados

### 3.1 Estado: No Autenticado
- **REQ-NOAUTH-001:** Mientras el usuario no esté autenticado, el sistema deberá mostrar la pantalla de login.
- **REQ-NOAUTH-002:** Mientras el usuario no esté autenticado, `isAuthenticated` deberá ser `false`.
- **REQ-NOAUTH-003:** Mientras el usuario no esté autenticado, todos los flags de rol deberán ser `false`.

### 3.2 Estado: Autenticado
- **REQ-AUTH-ST-001:** Mientras el usuario esté autenticado, `isAuthenticated` deberá ser `true`.
- **REQ-AUTH-ST-002:** Mientras el usuario esté autenticado, el sistema deberá mantener los datos de sesión en el estado.
- **REQ-AUTH-ST-003:** Mientras el usuario esté autenticado, el sistema deberá permitir acceso a las pantallas protegidas.

### 3.3 Estado: Cargando
- **REQ-CAR-001:** Mientras el sistema procesa el login, el sistema deberá mostrar un indicador de carga circular.
- **REQ-CAR-002:** Mientras el sistema valida el token de recuperación, el sistema deberá mostrar un indicador de carga circular.
- **REQ-CAR-003:** Mientras el sistema actualiza la contraseña, el sistema deberá mostrar un indicador de carga circular.

### 3.4 Estado: Perfil
- **REQ-PERF-001:** Mientras el perfil sea "Usuario", el sistema deberá establecer `esUsuario = true` y `esUsuarioComprador = true`.
- **REQ-PERF-002:** Mientras el perfil sea "Promotor", el sistema deberá establecer `esPromotor = true`, `esUsuarioPromotor = true` y cargar los datos de promotor.
- **REQ-PERF-003:** Mientras el perfil sea "Propietario", el sistema deberá establecer `esPropietario = true`.
- **REQ-PERF-004:** Mientras el perfil sea "Anfitrión", el sistema deberá establecer `esAnfrition = true`.
- **REQ-PERF-005:** Mientras el perfil sea "Vendedor", el sistema deberá establecer `esVendedor = true`.
- **REQ-PERF-006:** Mientras el perfil sea "Especialista", el sistema deberá establecer `esEspecialista = true` y `esUsuarioEspecialista = true`.
- **REQ-PERF-007:** Mientras el perfil sea "Proveedor", el sistema deberá establecer `esProveedor = true`.
- **REQ-PERF-008:** Mientras el perfil sea "Asociación", el sistema deberá establecer `esAsociacion = true`.
- **REQ-PERF-009:** Mientras el perfil sea "Inmobiliaria", el sistema deberá establecer `esInmobiliaria = true`.

---

## 4. Requerimientos de Comportamiento No Deseado

### 4.1 Errores de Red y Servidor
- **REQ-FAL-001:** Si la base de datos de usuarios no existe, el sistema deberá manejar el error y mostrar mensaje apropiado.
- **REQ-FAL-002:** Si ocurre una excepción de red durante login, el sistema deberá mostrar "Error inesperado: [detalle]".
- **REQ-FAL-003:** Si ocurre una excepción al guardar datos locales, el sistema deberá registrar el error sin impedir el login.
- **REQ-FAL-004:** Si el servidor de correo no está disponible, el sistema deberá mostrar un mensaje de advertencia pero guardar el token.
- **REQ-FAL-005:** Si CouchDB retorna un código diferente a 200, el sistema deberá manejar el error según el código.

### 4.2 Validaciones
- **REQ-VAL-001:** Si el usuario deja campos vacíos en login, el sistema deberá mostrar "Escriba usuario y contraseña".
- **REQ-VAL-002:** Si el usuario no acepta términos y condiciones en registro, el sistema deberá impedir el envío.
- **REQ-VAL-003:** Si el usuario no acepta el aviso de privacidad en registro, el sistema deberá impedir el envío.
- **REQ-VAL-004:** Si las contraseñas no coinciden en cambio de contraseña, el sistema deberá mostrar error de validación.
- **REQ-VAL-005:** Si el correo en recuperación está vacío, el sistema deberá mostrar error de validación.

### 4.3 Datos Ausentes
- **REQ-AUS-001:** Si el usuario no existe en CouchDB, el sistema deberá retornar código 501.
- **REQ-AUS-002:** Si el token de recuperación no existe o expiró, el sistema deberá mostrar mensaje de enlace inválido.
- **REQ-AUS-003:** Si no hay sesión guardada al iniciar la app, el sistema deberá mantener el estado no autenticado.

---

## 5. Requerimientos de Funciones Opcionales

### 5.1 Avatar
- **REQ-OPT-001:** Donde el módulo de avatar esté incluido, el sistema deberá recuperar los datos del avatar después del login exitoso.
- **REQ-OPT-002:** Donde el usuario tenga avatar, el sistema deberá mostrar la imagen en la interfaz.

### 5.2 Recuperación de Contraseña
- **REQ-OPT-003:** Donde el flujo de recuperación esté activo, el sistema deberá generar tokens con expiración de 1 hora.
- **REQ-OPT-004:** Donde el flujo de recuperación esté activo, el sistema deberá enviar correos electrónicos con enlaces de recuperación.

### 5.3 Sesión Persistente
- **REQ-OPT-005:** Donde el almacenamiento local esté disponible, el sistema deberá persistir la sesión entre aperturas de la app.
- **REQ-OPT-006:** Donde la sesión persista, el sistema deberá usar `FlutterSecureStorage` en móvil y `SharedPreferences` en web.

---

## 6. Requerimientos Complejos

### 6.1 Flujo de Login con Carga de Datos
- **REQ-COM-001:** Mientras el usuario ingresa credenciales válidas, cuando el sistema valide el usuario, entonces el sistema deberá obtener el ID, marcar como autenticado, guardar en almacenamiento local, recuperar datos completos del usuario y cargar el avatar en background.

### 6.2 Flujo de Registro con Validación
- **REQ-COM-002:** Mientras el usuario completa el formulario de registro, cuando el usuario envíe el formulario, entonces el sistema deberá validar campos obligatorios, verificar aceptación de términos y condiciones, hashear la contraseña, verificar que el nombre de usuario no exista y crear el documento en CouchDB.

### 6.3 Flujo de Recuperación con Token
- **REQ-COM-003:** Mientras el usuario solicita recuperación, cuando el sistema encuentre el usuario, entonces el sistema deberá generar token, calcular expiración, guardar token en CouchDB y enviar correo; cuando el usuario abra el enlace, entonces el sistema deberá validar el token y permitir el cambio de contraseña.

### 6.4 Flujo de Cambio de Contraseña con Fortaleza
- **REQ-COM-004:** Mientras el usuario cambia su contraseña, cuando el usuario escriba la nueva contraseña, entonces el sistema deberá calcular la fortaleza y mostrarla; cuando el usuario guarde, entonces el sistema deberá validar coincidencia, hashear la contraseña y actualizarla en CouchDB.

---

## 7. Modelos de Datos

### 7.1 AuthState (Estado de Sesión)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `sessionUserData` | SessionData | Datos básicos de sesión (userId, userName, userPass hash) |
| `initialIdUserPass` | GetIdUserPass | ID y credenciales iniciales del usuario |
| `userData` | GetUserData | Datos completos del usuario |
| `esUsuario` | bool | Flag de perfil Usuario |
| `esPromotor` | bool | Flag de perfil Promotor |
| `esPropietario` | bool | Flag de perfil Propietario |
| `esAnfrition` | bool | Flag de perfil Anfitrión |
| `esVendedor` | bool | Flag de perfil Vendedor |
| `esEspecialista` | bool | Flag de perfil Especialista |
| `esProveedor` | bool | Flag de perfil Proveedor |
| `esAsociacion` | bool | Flag de perfil Asociación |
| `esInmobiliaria` | bool | Flag de perfil Inmobiliaria |
| `nombrePerfil` | String | Nombre del perfil seleccionado |
| `isAuthenticated` | bool | Estado de autenticación |
| `isUserDataLoaded` | bool | Indica si los datos del usuario están cargados |
| `jwtToken` | String? | Token JWT (opcional) |
| `esUsuarioComprador` | String | Flag de usuario comprador |
| `esUsuarioPromotor` | String | Flag de usuario promotor |
| `esUsuarioEspecialista` | String | Flag de usuario especialista |

### 7.2 Usuario (CouchDB)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `_id` | String | ID del documento |
| `_rev` | String | Revisión CouchDB |
| `id_usuario` | String | ID único (hash SHA-256) |
| `nombreusuario` | String | Nombre de usuario único |
| `claveacceso` | String | Hash SHA-256 de la contraseña |
| `nombres` | String | Nombre(s) del usuario |
| `apellidopaterno` | String | Apellido paterno |
| `apellidomaterno` | String | Apellido materno |
| `correoelectronico` | String | Correo electrónico |
| `numerocelular` | String | Número de celular |
| `avatar` | String | ID o ruta del avatar |
| `ubicacionUserData` | UbicacionUserData | Datos de ubicación |
| `fecha_de_nacimiento` | FechaDeNacimiento | Fecha de nacimiento |
| `timestamp` | String | Marca de tiempo |
| `datospromotor` | UserDataPromotor | Datos específicos de promotor |

### 7.3 UserDataPromotor
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `tipodeusuario` | String | Tipo de usuario promotor |
| `rfc` | String | RFC del promotor |
| `numerodecliente` | String | Número de cliente |
| `inmobiliaria` | String | Nombre de la inmobiliaria |
| `espacionormal` | int | Espacios normales contratados |
| `espaciodestacados` | int | Espacios destacados contratados |
| `espaciosuperdestacados` | int | Espacios superdestacados contratados |
| `espaciosoportunidad` | int | Espacios oportunidades contratados |
| `espaciosremate` | int | Espacios remates contratados |

---

## 8. Proveedores Riverpod

| Proveedor | Tipo | Descripción |
|-----------|------|-------------|
| `sessionProvider` | StateNotifierProvider | Estado global de autenticación y sesión |
| `sessionStorageProvider` | Provider | Proveedor de almacenamiento de sesión |
| `sessionRepositoryProvider` | Provider | Repositorio HTTP para operaciones de sesión |
| `classUserAvatarProvider` | Provider | Proveedor para recuperación de avatar |

---

## 9. Reglas de Negocio

- **RN-001:** La contraseña nunca se almacena en texto plano; siempre se guarda como hash SHA-256.
- **RN-002:** El ID de usuario se genera como hash SHA-256 de `nombreusuario + claveacceso + timestamp`.
- **RN-003:** El nombre de usuario debe ser único en la base de datos.
- **RN-004:** El correo electrónico se usa para recuperación de contraseña y debe ser único por perfil.
- **RN-005:** El token de recuperación tiene una validez de 1 hora.
- **RN-006:** Al cambiar de perfil, se actualizan todos los flags de rol correspondientes.
- **RN-007:** La sesión se persiste en almacenamiento local seguro (`FlutterSecureStorage` en móvil, `SharedPreferences` en web).
- **RN-008:** Al cerrar sesión, se eliminan todos los datos locales y se resetea el estado.
- **RN-009:** Los datos de promotor solo se cargan cuando el perfil es "Promotor".
- **RN-010:** El campo RFC es obligatorio solo para el perfil de Promotor.

---

## 10. Almacenamiento Local

### 10.1 Variables Persistidas
| Variable | Descripción |
|----------|-------------|
| `userId` | ID del usuario autenticado |
| `userName` | Nombre de usuario |
| `nombrePerfil` | Perfil seleccionado |
| `userPassHash` | Hash SHA-256 de la contraseña para reautenticación |

### 10.2 Implementación por Plataforma
| Plataforma | Implementación |
|------------|---------------|
| Móvil (iOS/Android) | `FlutterSecureStorage` |
| Web | `SharedPreferences` |
| Windows | `SharedPreferences` |

---

## 11. Diagrama de Flujo de Autenticación

```text
┌─────────────────     ┌─────────────────     ┌─────────────────
│   Login Page    │────▶│  Validación    │────▶│  CouchDB       │
│                 │     │  Credenciales  │     │  (usuarios)    │
└─────────────────     └─────────────────     └─────────────────
         │                       │                       │
         │                       │                       ▼
         │                       │               ┌─────────────────
         │                       │               │  Session State  │
         │                       │               │  (Riverpod)     │
         │                       │               └─────────────────
         │                       │                       │
         │                       ▼                       ▼
         │               ┌─────────────────     ┌─────────────────
         │               │ Local Storage   │     │  Avatar/User    │
         │               │ (Secure/Prefs)  │     │  Data Load      │
         │               └─────────────────     └─────────────────
         │                       │                       │
         └───────────────────────┴───────────────────────┘
                         │
                         ▼
                 ┌─────────────────
                 │  Pantalla       │
                 │  Principal      │
                 └─────────────────
```
