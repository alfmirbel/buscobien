# SDD — Módulo `lib/08_pantallas/propiedades` — Especificación de Arquitectura
## Especificación General del Módulo de Detalle de Propiedades
**Módulo:** `lib/08_pantallas/propiedades/`
**Versión:** 1.0
**Metodología:** EARS — Easy Approach to Requirements Syntax
**Fecha:** 2026-08-07

---

## 1. Inventario de Archivos del Módulo

| Archivo | Tipo | Rol |
|---|---|---|
| `pagina_detalle_propiedad.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Pantalla de detalle de propiedad; muestra foto principal, galería, datos de propiedad, precios, ubicación, contacto, características adicionales y botón Me Gusta |
| `pagina_detalle_propiedad_pdf.dart` | Fuente — Servicio (`PdfGeneratorService`) | Genera y descarga PDF de la propiedad con formato carta, incluyendo imágenes, datos y galería |
| `data_find_propiedades.dart` | Fuente — Modelo de Datos | Define modelos para búsqueda y obtención de propiedades |

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Aplican al módulo completo en todo momento mientras la pantalla de detalle esté activa.

**SDD-DET-001**
El sistema deberá renderizar `PaginaDetalleWidget` como pantalla de detalle de propiedad, recibiendo `ValueEspaciosCasaGet propiedad` y `GetIdsFotosUserProp listaIdsFotos` como parámetros obligatorios.

**SDD-DET-002**
El sistema deberá mostrar la información de la propiedad en un `SingleChildScrollView` con `ConstrainedBox` de `maxWidth: desktopContentMaxWidth`, garantizando legibilidad en pantallas anchas.

**SDD-DET-003**
El sistema deberá adaptar los márgenes de padding según el ancho de pantalla: `padMargenL/R = 15.0` en pantallas estrechas y `40.0` en pantallas anchas; `padMargenT/B = 10.0` en estrechas y `50.0` en anchas.

**SDD-DET-004**
El sistema deberá mostrar todos los campos de datos de propiedad que no estén vacíos ni sean "0", utilizando `valoresVacios = ["", "0"]` como filtro.

**SDD-DET-005**
El sistema deberá mostrar el botón de Me Gusta solo si el usuario está autenticado; si no hay sesión, deberá abrir `dialogBoxFichaLogin` en lugar de agregar a favoritos.

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

**SDD-DET-010**
Cuando `PaginaDetalleWidget` se monte (`initState`), el sistema deberá inicializar `scaffoldDetalleKey` y registrar el ciclo de vida mediante `debugPrintLevels`.

**SDD-DET-011**
Cuando el usuario presione el botón de editar avatar en el perfil, el sistema deberá navegar a `AppRoutes.gestionavatar` con `Navigator.pushNamed`.

**SDD-DET-012**
Cuando el usuario presione el botón de Me Gusta y no tenga sesión iniciada, el sistema deberá abrir `dialogBoxFichaLogin(context, ref)` y no ejecutar `toggleMeGusta`.

**SDD-DET-013**
Cuando el usuario presione el botón de Me Gusta y tenga sesión iniciada, el sistema deberá ejecutar `toggleMeGusta` con `usuarioId`, `propiedadId` y `userListsNotifier`.

**SDD-DET-014**
Cuando el usuario presione el botón "Iniciar Sesión" en la vista de invitado, el sistema deberá abrir `dialogBoxFichaLogin(context, ref)` y, tras el login, actualizar el estado de sesión.

**SDD-DET-015**
Cuando el usuario presione el botón "Cerrar Sesión Actual", el sistema deberá abrir `_showLogoutDialog` con el título "Termina sesión" y el mensaje "¿Quiéres salir de la sesión?".

**SDD-DET-016**
Cuando el usuario presione "Si" en el diálogo de cierre de sesión, el sistema deberá ejecutar `deleteLocalSessionData()`, `resetInitialUserData(0)`, `resetclassUserAvatarProvider()` y resetear los 4 providers de menú a sus valores por defecto.

**SDD-DET-017**
Cuando el usuario presione "No" en el diálogo de cierre de sesión, el sistema deberá cerrar el diálogo con `Navigator.pop()` y mantener la sesión activa.

**SDD-DET-018**
Cuando el cierre de sesión se complete exitosamente, el sistema deberá navegar a `AppRoutes.principal` mediante `pushReplacementNamed` con `arguments: ""`, posicionando los menús en `indiceInicial=1`, `indicePrincipal=0`, `indiceNivelGobierno=0`, `indiceTipoTransaccion=0`.

**SDD-DET-019**
Cuando se renderice la foto principal, el sistema deberá ejecutar `recuperaFotoPorIdFoto(idFotoPrincipal)` para obtener la imagen en base64.

**SDD-DET-020**
Cuando se renderice la galería de fotos, el sistema deberá ejecutar `recuperaIdsFotosDePropiedades(idUsuario, idPropiedad)` y luego `recuperaFotosOrdenadasIdProperty` para obtener las fotos ordenadas.

**SDD-DET-021**
Cuando se genere el PDF, el sistema deberá ejecutar `PdfGeneratorService.generarYDescargarPDF` con la propiedad, ID de foto principal y lista de IDs de galería.

**SDD-DET-022**
Cuando el PDF se genere exitosamente, el sistema deberá ejecutar `Printing.layoutPdf` para abrir la vista previa en móvil o una nueva pestaña en web.

---

## 4. Requerimientos Controlados por Estados (State-Driven)

**SDD-DET-020**
Mientras `isUserLoggedIn == false`, el sistema deberá mostrar `_buildNoUserView()` con el icono `Symbols.person_off_rounded`, el texto "No has iniciado sesión" y el botón "Iniciar Sesión".

**SDD-DET-021**
Mientras `isUserLoggedIn == true` y `_gatDatosCompletosUsuario` está en estado `waiting` o `none`, el sistema deberá mostrar `stateWaiting` como indicador de carga centrado.

**SDD-DET-022**
Mientras `_gatDatosCompletosUsuario` está en estado `done` y `hasError == true`, el sistema deberá mostrar `stateErrorFormat` con el mensaje de error.

**SDD-DET-023**
Mientras `_gatDatosCompletosUsuario` está en estado `done` y `sessionProvider.userData.rows.isEmpty`, el sistema deberá mostrar `_buildNoUserView()`.

**SDD-DET-024**
Mientras `_gatDatosCompletosUsuario` está en estado `done` y `userData.rows` tiene datos, el sistema deberá mostrar `_buildUserProfileView()` con toda la información del usuario.

**SDD-DET-025**
Mientras `sessionData.esPromotor == true`, el sistema deberá mostrar la sección "Perfil Profesional" con los campos Inmobiliaria, RFC y No. Cliente.

**SDD-DET-026**
Mientras `sessionData.esPromotor == false`, el sistema deberá ocultar la sección "Perfil Profesional" y no mostrar los campos de datos profesionales.

**SDD-DET-027**
Mientras el avatar exista (`avatarRow.isNotEmpty && avatarRow[0].value.avatar.isNotEmpty`), el sistema deberá mostrar `MemoryImage` en el `CircleAvatar`.

**SDD-DET-028**
Mientras el avatar no exista, el sistema deberá mostrar `Icon(Symbols.person)` en color gris dentro del `CircleAvatar`.

**SDD-DET-029**
Mientras cualquier campo de perfil esté vacío o sea "0", el sistema deberá mostrar "No registrado" en lugar del valor vacío.

**SDD-DET-030**
Mientras el usuario esté autenticado, el sistema deberá mostrar el botón "Cerrar Sesión Actual" con fondo `appTheme.error` e icono `Symbols.logout` en color blanco.

**SDD-DET-031**
Mientras `constraints.maxWidth < smallScreenMin`, el sistema deberá usar márgenes reducidos (`padMargenL/R = 15.0`, `padMargenT/B = 10.0`) en el detalle de propiedad.

**SDD-DET-032**
Mientras `constraints.maxWidth >= smallScreenMin`, el sistema deberá usar márgenes amplios (`padMargenL/R = 40.0`, `padMargenT/B = 50.0`) en el detalle de propiedad.

**SDD-DET-033**
Mientras la propiedad tenga `idFotoPrincipal` vacío, el sistema deberá mostrar el texto "Sin foto" centrado en el lugar de la imagen principal.

**SDD-DET-034**
Mientras `snapshotFoto.hasData && snapshotFoto.data != ''`, el sistema deberá mostrar la imagen en un `Container` con borde de 3px en `appTheme.outlineVariant` y radio 15.

**SDD-DET-035**
Mientras `snapshotFoto.hasError`, el sistema deberá mostrar un `Container` con icono `Symbols.broken_image` en color `appTheme.onSurface`.

**SDD-DET-036**
Mientras `listamasdatos` tenga características adicionales, el sistema deberá mostrar chips con borde `appTheme.outline`, radio 8 y padding 8.

**SDD-DET-037**
Mientras `fotosParaMostrar` tenga elementos, el sistema deberá mostrar cada foto en un `SizedBox` de 150x100 con `BoxFit.cover` dentro de un `Wrap`.

**SDD-DET-038**
Mientras `tieneGusta == true`, el botón de Me Gusta deberá mostrar `Symbols.favorite` en color rojo `#E91E63`; mientras sea `false`, deberá mostrar `Symbols.favorite_border` en color `appTheme.onPrimary`.

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-DET-030**
Si `getUserDataByNameInSessionData()` falla, entonces el sistema deberá mostrar `stateErrorFormat` con el error y no intentar mostrar `_buildUserProfileView()`.

**SDD-DET-031**
Si `sessionProvider.userData.rows` está vacío después de una carga exitosa, entonces el sistema deberá mostrar `_buildNoUserView()` en lugar de `_buildUserProfileView()`.

**SDD-DET-032**
Si el usuario presiona "Iniciar Sesión" pero cancela el login, entonces el sistema deberá mantener `_buildNoUserView()` visible y no cambiar a `_buildUserProfileView()`.

**SDD-DET-033**
Si el avatar guardado en `classUserAvatarProvider` está corrupto o vacío, entonces el sistema deberá mostrar el icono `Symbols.person` como fallback sin crashear.

**SDD-DET-034**
Si el usuario presiona "Si" en el diálogo de cierre de sesión pero `deleteLocalSessionData()` falla, entonces el sistema deberá igualmente ejecutar el reseteo de providers y navegación para garantizar la salida del usuario.

**SDD-DET-035**
Si `sessionProvider` no tiene datos cuando se intenta acceder a `userData.rows[0]`, entonces el sistema deberá manejar el caso sin lanzar excepciones, posiblemente mostrando la vista de invitado.

**SDD-DET-036**
Si el usuario navega a "Perfil" mientras ya está en "Perfil", entonces el sistema no debe crear una nueva instancia del widget ni realizar una nueva petición HTTP si `isUserDataLoaded == true`.

**SDD-DET-037**
Si `recuperaFotoPorIdFoto` retorna un string vacío, entonces el sistema deberá mostrar el icono `Symbols.broken_image` en lugar de intentar decodificar una imagen vacía.

**SDD-DET-038**
Si `recuperaIdsFotosDePropiedades` falla, entonces el sistema deberá mostrar `stateErrorFormat` y no intentar cargar la galería de fotos.

**SDD-DET-039**
Si `recuperaFotosOrdenadasIdProperty` retorna un código diferente a 200, entonces el sistema deberá usar el orden de `listaIdsFotos.rows` como fallback.

**SDD-DET-040**
Si el PDF no puede cargar una imagen de la galería, entonces el sistema deberá omitir esa imagen y continuar con las siguientes sin interrumpir la generación.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-DET-040**
Donde el usuario tenga perfil "Promotor", el sistema deberá mostrar la sección "Perfil Profesional" con campos de negocio (Inmobiliaria, RFC, No. Cliente).

**SDD-DET-041**
Donde el usuario tenga avatar guardado, el sistema deberá mostrar el botón de edición circular con icono `Symbols.edit` sobre el avatar, permitiendo navegar a `AppRoutes.gestionavatar`.

**SDD-DET-042**
Donde el usuario no tenga avatar, el sistema deberá mostrar el icono `Symbols.person` en color gris dentro del `CircleAvatar` sin botón de edición superpuesto.

**SDD-DET-043**
Donde el usuario presione "Cerrar Sesión Actual", el sistema deberá resetear 4 providers de menú (`menuInicialProvider`, `menuPrincipalProvider`, `menuNivelDeGobiernoProvider`, `menuTipoDeTransaccionProvider`) a sus valores por defecto antes de navegar a `principal`.

**SDD-DET-044**
Donde la propiedad tenga características adicionales, el sistema deberá mostrar chips con íconos y textos para: paneles solares, jardín, alberca, calefacción, aire acondicionado, seguridad, fraccionamiento, casa club, salón de eventos, centro de negocios, gimnasio, cisterna, almacenamiento de agua, tratamiento de aguas y otras características.

**SDD-DET-045**
Donde se genere el PDF, el sistema deberá incluir la clave de propiedad en el pie de página tanto en la primera página como en la última.

**SDD-DET-046**
Donde el usuario comparta una propiedad desde el chat, el sistema deberá pasar `fromChatUserId` al detalle para mostrar el botón "Guardar en lista".

---

## 7. Requerimientos Complejos (Combinados)

**SDD-DET-050**
Mientras el usuario esté autenticado con `isUserDataLoaded == false`, cuando navegue a "Perfil", el sistema deberá invocar `getUserDataByNameInSessionData()`, mostrar `stateWaiting` durante la carga y, al completar, mostrar `_buildUserProfileView()` con todas las secciones de información.

**SDD-DET-051**
Mientras el usuario esté autenticado como promotor, cuando navegue a "Perfil", el sistema deberá mostrar las secciones de Información Personal, Dirección Registrada y Perfil Profesional; mientras sea usuario, solo mostrará las primeras dos secciones.

**SDD-DET-052**
Mientras el usuario presione "Cerrar Sesión Actual", cuando confirme en el diálogo, el sistema deberá ejecutar secuencialmente `deleteLocalSessionData()`, `resetInitialUserData(0)`, `resetclassUserAvatarProvider()`, reseteo de 4 providers de menú y `pushReplacementNamed` a `AppRoutes.principal` con argumentos vacíos.

**SDD-DET-053**
Mientras el avatar exista en `classUserAvatarProvider`, cuando el usuario presione el botón de editar, el sistema deberá navegar a `AppRoutes.gestionavatar` manteniendo el contexto del perfil para regresar sin perder los datos cargados.

**SDD-DET-054**
Mientras el usuario esté en el detalle de una propiedad, cuando presione el botón de Me Gusta sin sesión, el sistema deberá abrir `dialogBoxFichaLogin`; si inicia sesión exitosamente, deberá ejecutar `toggleMeGusta` automáticamente.

**SDD-DET-055**
Mientras se genere el PDF de una propiedad, cuando la imagen principal o las fotos de galería fallen al cargar, el sistema deberá mostrar placeholders o omitir las imágenes sin interrumpir la generación del documento.

---

## 8. Diagrama de Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                    PaginaDetalleWidget                          │
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
