# SDD — Módulo `lib/08_pantallas/perfil` — Especificación de Arquitectura
## Especificación General del Módulo de Pantalla de Perfil
**Módulo:** `lib/08_pantallas/perfil/`
**Versión:** 1.0
**Metodología:** EARS — Easy Approach to Requirements Syntax
**Fecha:** 2026-08-07

---

## 1. Inventario de Archivos del Módulo

| Archivo | Tipo | Rol |
|---|---|---|
| `pagina_perfil.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Pantalla de perfil de usuario; muestra datos personales, dirección, perfil profesional (si es promotor), avatar y botón de cierre de sesión |

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Aplican al módulo completo en todo momento mientras la pantalla de perfil esté activa.

**SDD-PER-001**
El sistema deberá renderizar `PaginaPerfilWidget` como pantalla de perfil de usuario, gestionando la carga de datos, la visualización de información personal y el cierre de sesión.

**SDD-PER-002**
El sistema deberá determinar el estado de autenticación del usuario mediante `sessionProvider.sessionUserData`, evaluando si `userId` y `userName` están vacíos para mostrar la vista de invitado o la vista de perfil.

**SDD-PER-003**
El sistema deberá mostrar la información del usuario desde `sessionProvider.userData.rows[0].value.usuario` cuando los datos estén disponibles, evitando consultas HTTP innecesarias si `isUserDataLoaded == true`.

**SDD-PER-004**
El sistema deberá mostrar el avatar del usuario desde `classUserAvatarProvider.rows`, utilizando `MemoryImage` si existe avatar guardado o el icono `Symbols.person` como fallback.

**SDD-PER-005**
El sistema deberá mostrar la sección "Perfil Profesional" condicionalmente solo cuando `sessionData.esPromotor == true`, ocultándola para usuarios con perfil "Usuario" o "Propietario".

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

**SDD-PER-010**
Cuando `PaginaPerfilWidget` se monte (`initState`), el sistema deberá leer `sessionProvider.isUserDataLoaded` y, si es `false`, invocar `getUserDataByNameInSessionData()` para cargar los datos del usuario.

**SDD-PER-011**
Cuando `getUserDataByNameInSessionData()` complete exitosamente, el sistema deberá actualizar `_gatDatosCompletosUsuario` y el `FutureBuilder` deberá mostrar `_buildUserProfileView()`.

**SDD-PER-012**
Cuando el usuario presione el botón de editar avatar (icono `Symbols.edit`), el sistema deberá navegar a `AppRoutes.gestionavatar` con `Navigator.pushNamed`.

**SDD-PER-013**
Cuando el usuario presione el botón "Iniciar Sesión" en la vista de invitado, el sistema deberá abrir `dialogBoxFichaLogin(context, ref)` y, tras el login, actualizar el estado de sesión.

**SDD-PER-014**
Cuando el usuario presione el botón "Cerrar Sesión Actual", el sistema deberá abrir `_showLogoutDialog` con el título "Termina sesión" y el mensaje "¿Quiéres salir de la sesión?".

**SDD-PER-015**
Cuando el usuario presione "Si" en el diálogo de cierre de sesión, el sistema deberá ejecutar `deleteLocalSessionData()`, `resetInitialUserData(0)`, `resetclassUserAvatarProvider()` y resetear los 4 providers de menú (`menuInicialProvider`, `menuPrincipalProvider`, `menuNivelDeGobiernoProvider`, `menuTipoDeTransaccionProvider`) a sus valores por defecto.

**SDD-PER-016**
Cuando el usuario presione "No" en el diálogo de cierre de sesión, el sistema deberá cerrar el diálogo con `Navigator.pop()` y mantener la sesión activa.

**SDD-PER-017**
Cuando el cierre de sesión se complete exitosamente, el sistema deberá navegar a `AppRoutes.principal` mediante `pushReplacementNamed` con `arguments: ""`, posicionando los menús en `indiceInicial=1`, `indicePrincipal=0`, `indiceNivelGobierno=0`, `indiceTipoTransaccion=0`.

---

## 4. Requerimientos Controlados por Estados (State-Driven)

**SDD-PER-020**
Mientras `isUserLoggedIn == false`, el sistema deberá mostrar `_buildNoUserView()` con el icono `Symbols.person_off_rounded`, el texto "No has iniciado sesión" y el botón "Iniciar Sesión".

**SDD-PER-021**
Mientras `isUserLoggedIn == true` y `_gatDatosCompletosUsuario` está en estado `waiting` o `none`, el sistema deberá mostrar `stateWaiting` como indicador de carga centrado.

**SDD-PER-022**
Mientras `_gatDatosCompletosUsuario` está en estado `done` y `hasError == true`, el sistema deberá mostrar `stateErrorFormat` con el mensaje de error.

**SDD-PER-023**
Mientras `_gatDatosCompletosUsuario` está en estado `done` y `sessionProvider.userData.rows.isEmpty`, el sistema deberá mostrar `_buildNoUserView()`.

**SDD-PER-024**
Mientras `_gatDatosCompletosUsuario` está en estado `done` y `userData.rows` tiene datos, el sistema deberá mostrar `_buildUserProfileView()` con toda la información del usuario.

**SDD-PER-025**
Mientras `sessionData.esPromotor == true`, el sistema deberá mostrar la sección "Perfil Profesional" con los campos Inmobiliaria, RFC y No. Cliente.

**SDD-PER-026**
Mientras `sessionData.esPromotor == false`, el sistema deberá ocultar la sección "Perfil Profesional" y no mostrar los campos de datos profesionales.

**SDD-PER-027**
Mientras el avatar exista (`avatarRow.isNotEmpty && avatarRow[0].value.avatar.isNotEmpty`), el sistema deberá mostrar `MemoryImage` en el `CircleAvatar`.

**SDD-PER-028**
Mientras el avatar no exista, el sistema deberá mostrar `Icon(Symbols.person)` en color gris dentro del `CircleAvatar`.

**SDD-PER-029**
Mientras cualquier campo de perfil esté vacío o sea "0", el sistema deberá mostrar "No registrado" en lugar del valor vacío.

**SDD-PER-030**
Mientras el usuario esté autenticado, el sistema deberá mostrar el botón "Cerrar Sesión Actual" con fondo `appTheme.error` e icono `Symbols.logout` en color blanco.

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-PER-030**
Si `getUserDataByNameInSessionData()` falla, entonces el sistema deberá mostrar `stateErrorFormat` con el error y no intentar mostrar `_buildUserProfileView()`.

**SDD-PER-031**
Si `sessionProvider.userData.rows` está vacío después de una carga exitosa, entonces el sistema deberá mostrar `_buildNoUserView()` en lugar de `_buildUserProfileView()`.

**SDD-PER-032**
Si el usuario presiona "Iniciar Sesión" pero cancela el login, entonces el sistema deberá mantener `_buildNoUserView()` visible y no cambiar a `_buildUserProfileView()`.

**SDD-PER-033**
Si el avatar guardado en `classUserAvatarProvider` está corrupto o vacío, entonces el sistema deberá mostrar el icono `Symbols.person` como fallback sin crashear.

**SDD-PER-034**
Si el usuario presiona "Si" en el diálogo de cierre de sesión pero `deleteLocalSessionData()` falla, entonces el sistema deberá igualmente ejecutar el reseteo de providers y navegación para garantizar la salida del usuario.

**SDD-PER-035**
Si `sessionProvider` no tiene datos cuando se intenta acceder a `userData.rows[0]`, entonces el sistema deberá manejar el caso sin lanzar excepciones, posiblemente mostrando la vista de invitado.

**SDD-PER-036**
Si el usuario navega a "Perfil" mientras ya está en "Perfil", entonces el sistema no debe crear una nueva instancia del widget ni realizar una nueva petición HTTP si `isUserDataLoaded == true`.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-PER-040**
Donde el usuario tenga perfil "Promotor", el sistema deberá mostrar la sección "Perfil Profesional" con campos de negocio (Inmobiliaria, RFC, No. Cliente).

**SDD-PER-041**
Donde el usuario tenga avatar guardado, el sistema deberá mostrar el botón de edición circular con icono `Symbols.edit` sobre el avatar, permitiendo navegar a `AppRoutes.gestionavatar`.

**SDD-PER-042**
Donde el usuario no tenga avatar, el sistema deberá mostrar el icono `Symbols.person` en color gris dentro del `CircleAvatar` sin botón de edición superpuesto.

**SDD-PER-043**
Donde el usuario presione "Cerrar Sesión Actual", el sistema deberá resetear 4 providers de menú (`menuInicialProvider`, `menuPrincipalProvider`, `menuNivelDeGobiernoProvider`, `menuTipoDeTransaccionProvider`) a sus valores por defecto antes de navegar a `principal`.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-PER-050**
Mientras el usuario esté autenticado con `isUserDataLoaded == false`, cuando navegue a "Perfil", el sistema deberá invocar `getUserDataByNameInSessionData()`, mostrar `stateWaiting` durante la carga y, al completar, mostrar `_buildUserProfileView()` con todas las secciones de información.

**SDD-PER-051**
Mientras el usuario esté autenticado como promotor, cuando navegue a "Perfil", el sistema deberá mostrar las secciones de Información Personal, Dirección Registrada y Perfil Profesional; mientras sea usuario, solo mostrará las primeras dos secciones.

**SDD-PER-052**
Mientras el usuario presione "Cerrar Sesión Actual", cuando confirme en el diálogo, el sistema deberá ejecutar secuencialmente `deleteLocalSessionData()`, `resetInitialUserData(0)`, `resetclassUserAvatarProvider()`, reseteo de 4 providers de menú y `pushReplacementNamed` a `AppRoutes.principal` con argumentos vacíos.

**SDD-PER-053**
Mientras el avatar exista en `classUserAvatarProvider`, cuando el usuario presione el botón de editar, el sistema deberá navegar a `AppRoutes.gestionavatar` manteniendo el contexto del perfil para regresar sin perder los datos cargados.

---

## 8. Diagrama de Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                    PaginaPerfilWidget                           │
│                                                                 │
│  ┌─────────────┐    ┌──────────────┐    ┌──────────────────┐  │
│  │ initState   │    │  FutureBuild │    │  Conditional UI  │  │
│  │             │    │              │    │                  │  │
│  │ - isLoaded? │    │ - waiting    │    │  isUserLoggedIn  │  │
│  │ - getUser   │    │   → stateWait│    │  false → NoUser  │  │
│  │   Data...   │    │ - done       │    │  true → Profile  │  │
│  │             │    │   → done/err │    │                  │  │
│  └─────────────┘    └──────────────┘    └──────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     sessionProvider            │
              │  ┌─────────────────────────┐  │
              │  │ isUserDataLoaded: bool  │  │
              │  │ sessionUserData         │  │
              │  │ userData.rows[]         │  │
              │  │ esPromotor: bool        │  │
              │  │ nombrePerfil: String    │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
      ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
      │classUserAvatar│ │menuProviders│ │dialogBoxFich│
      │Provider      │ │             │ │aLogin       │
      │ rows[]       │ │             │ │             │
      │ avatar       │ │             │ │             │
      └─────────────┘ └─────────────┘ └─────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     _buildUserProfileView      │
              │  ┌─────────────────────────┐  │
              │  │ Header:                 │  │
              │  │ - Container fondo       │  │
              │  │   appTheme.primary      │  │
              │  │ - CircleAvatar radio 55 │  │
              │  │ - Nombre completo       │  │
              │  │ - Rol en chip           │  │
              │  │ - Botón editar avatar   │  │
              │  ├─────────────────────────┤  │
              │  │ Sección 1:              │  │
              │  │ Información Personal    │  │
              │  │ - Nombre Usuario        │  │
              │  │ - Correo                │  │
              │  │ - Celular               │  │
              │  │ - Fecha Nacimiento      │  │
              │  ├─────────────────────────┤  │
              │  │ Sección 2:              │  │
              │  │ Dirección Registrada    │  │
              │  │ - Estado/Municipio      │  │
              │  │ - Colonia/Asentamiento  │  │
              │  │ - Calle y Número        │  │
              │  ├─────────────────────────┤  │
              │  │ Sección 3 (condicional):│  │
              │  │ Perfil Profesional      │  │
              │  │ - Inmobiliaria/RFC/No.  │  │
              │  │   Cliente               │  │
              │  ├─────────────────────────┤  │
              │  │ Botón Cerrar Sesión     │  │
              │  │ ElevatedButton.icon     │  │
              │  │ "Cerrar Sesión Actual"  │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     _showLogoutDialog          │
              │  ┌─────────────────────────┐  │
              │  │ Título: "Termina sesión"│  │
              │  │ Mensaje: "¿Quiéres..."  │  │
              │  │ Botones: "No" / "Si"    │  │
              │  └─────────────────────────┘  │
                              │
              ▼
              ┌───────────────────────────────┐
              │     Flujo de Logout            │
              │  1. deleteLocalSessionData()   │
              │  2. resetInitialUserData(0)    │
              │  3. resetclassUserAvatar()     │
              │  4. Reset 4 menu providers     │
              │  5. pushReplacementNamed       │
              │     → AppRoutes.principal      │
              └───────────────────────────────┘
```

---

## 9. Mapa de Correspondencia Elemento → Comportamiento

### Pantalla de Perfil

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `PaginaPerfilWidget` | `pagina_perfil.dart` | `ConsumerStatefulWidget` que gestiona carga de datos y vistas condicionales |
| `scaffoldPerfilKey` | `pagina_perfil.dart` | `GlobalKey<ScaffoldState>` para control del scaffold |
| `_gatDatosCompletosUsuario` | `pagina_perfil.dart` | `Future<int>` que carga datos del usuario si no están en caché |
| `isUserLoggedIn` | `pagina_perfil.dart` | `bool` que determina si mostrar vista de invitado o perfil |
| `initState` | `pagina_perfil.dart` | Verifica `isUserDataLoaded`, carga datos si es necesario |
| `build` | `pagina_perfil.dart` | Watches `sessionProvider.sessionUserData`, determina `isUserLoggedIn` |
| `_buildNoUserView` | `pagina_perfil.dart` | Vista de invitado con icono, texto y botón de login |
| `_buildUserProfileView` | `pagina_perfil.dart` | Vista completa con header, información personal, dirección y perfil profesional |
| `_buildHeaderSection` | `pagina_perfil.dart` | Header con avatar, nombre completo y rol |
| `_buildSectionTitle` | `pagina_perfil.dart` | Título de sección con divider |
| `_buildInfoCard` | `pagina_perfil.dart` | Card contenedora de filas de información |
| `_buildProfileRow` | `pagina_perfil.dart` | Fila individual con icono, label y valor |
| `_buildDivider` | `pagina_perfil.dart` | Divisor vertical con indent |
| `_showLogoutDialog` | `pagina_perfil.dart` | Diálogo de confirmación de cierre de sesión |

### Secciones del Perfil

| Sección | Campos | Condición |
|---|---|---|
| Información Personal | Nombre Usuario, Correo, Celular, Fecha Nacimiento | Siempre visible |
| Dirección Registrada | Estado/Municipio, Colonia/Asentamiento (CP), Calle y Número | Siempre visible |
| Perfil Profesional | Inmobiliaria/Independiente, RFC, No. Cliente | Solo si `esPromotor == true` |

### Botones y Navegación

| Elemento | Comportamiento |
|---|---|
| Botón "Iniciar Sesión" | Abre `dialogBoxFichaLogin(context, ref)` |
| Botón editar avatar | Navega a `AppRoutes.gestionavatar` |
| Botón "Cerrar Sesión Actual" | Abre `_showLogoutDialog` |
| Botón "Si" (logout) | Ejecuta limpieza de sesión y navega a `principal` |
| Botón "No" (logout) | Cierra diálogo con `Navigator.pop()` |

---

## 10. Decisiones de Diseño Documentadas

| ID | Decisión | Justificación |
|---|---|---|
| DD-01 | `ConsumerStatefulWidget` para `PaginaPerfilWidget` | Requiere `setState` para actualizar `isUserLoggedIn` tras login/logout |
| DD-02 | `FutureBuilder` para carga de datos | Maneja estados asíncronos (loading, error, done) de forma declarativa |
| DD-03 | Cache con `isUserDataLoaded` | Evita peticiones HTTP redundantes si los datos ya fueron precargados en la pantalla principal |
| DD-04 | `_gatDatosCompletosUsuario` como `Future<int>` | El tipo `int` probablemente representa un código de estado HTTP (200 = éxito) |
| DD-05 | Vistas separadas `_buildNoUserView` y `_buildUserProfileView` | Separa claramente la lógica de usuario invitado vs autenticado |
| DD-06 | Avatar con `MemoryImage` | Carga imágenes en memoria desde base64 sin necesidad de archivos temporales |
| DD-07 | Botón de editar avatar superpuesto con `Stack` | Proporciona acceso rápido a la gestión de avatar sin salir del perfil |
| DD-08 | Sección profesional condicional con `if (sessionData.esPromotor) ...` | Muestra datos de negocio solo para promotores, manteniendo la UI limpia para compradores |
| DD-09 | Diálogo de logout con `AlertDialog` personalizado | Proporciona confirmación explícita antes de cerrar sesión, previniendo cierres accidentales |
| DD-10 | Reset de 4 providers de menú al cerrar sesión | Garantiza que la navegación vuelva a su estado inicial tras el logout |
| DD-11 | `pushReplacementNamed` al cerrar sesión | Elimina el perfil del historial, evitando que el usuario regrese con el botón atrás |
| DD-12 | Campo "No registrado" para valores vacíos | Proporciona feedback claro al usuario sobre datos faltantes en su perfil |
| DD-13 | `SingleChildScrollView` con `BouncingScrollPhysics` | Permite scroll en dispositivos pequeños con feedback visual nativo |
| DD-14 | `SafeArea` como wrapper principal | Evita que el contenido se superponga con áreas de sistema (notch, barra de navegación) |
| DD-15 | Avatar con `CircleAvatar` radio 55 | Tamaño suficiente para legibilidad sin ocupar demasiado espacio vertical |

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-07*
