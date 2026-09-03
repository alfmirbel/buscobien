# SDD — Módulo `lib/08_pantallas/tu_cuenta/conocidos` — Especificación de Arquitectura
## Especificación General del Módulo de Conocidos (Red Social)
**Módulo:** `lib/08_pantallas/tu_cuenta/conocidos/`
**Versión:** 1.0
**Metodología:** EARS — Easy Approach to Requirements Syntax
**Fecha:** 2026-08-08

---

## 1. Inventario de Archivos del Módulo

| Archivo | Tipo | Rol |
|---|---|---|
| `conocidos_view.dart` | Fuente — Widget con Estado (`StatefulWidget`) | Vista raíz del módulo; orquesta la navegación entre Contactos, Invitaciones y Descubrir mediante `NavigationBar` |
| `page_mis_contactos.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Muestra la lista de contactos aceptados con acciones de perfil y chat |
| `page_invitaciones.dart` | Fuente — Widget (`ConsumerWidget`) | Muestra invitaciones recibidas y enviadas con tabs; permite aceptar/rechazar |
| `page_descubrir_usuarios.dart` | Fuente — Widget (`ConsumerWidget`) | Muestra listado de usuarios y promotores disponibles para invitar |
| `page_perfil_contacto.dart` | Fuente — Widget (`ConsumerWidget`) | Muestra el perfil público de un contacto y sus propiedades publicadas |
| `page_chat_privado.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Chat privado en tiempo real con mensajes de texto, propiedad y lista |
| `providers/conocidos_notifier.dart` | Fuente — Riverpod `AsyncNotifierProvider` | Gestiona invitaciones de contacto: carga, envío, respuesta y estado |
| `provider_mensajes.dart` | Fuente — Riverpod `AsyncNotifierProvider.family` | Gestiona mensajes de chat con `_changes` feed continuo de CouchDB |
| `social_providers.dart` | Fuente — Riverpod `FutureProvider` | Providers legacy para listar usuarios, promotores y chat |
| `models/conocido.dart` | Fuente — Modelo Freezed | Define `Conocido` con `InvitacionEstado` (pendiente, aceptado, rechazado, bloqueado) |
| `models/conocido.freezed.dart` | Generado | Código generado por Freezed |
| `models/conocido.g.dart` | Generado | Código generado por `json_serializable` |
| `invitacion_model.dart` | Fuente — Modelo | Modelo legacy de invitación con campos `_id`, `_rev`, sender/receiver, status |
| `mensaje_model.dart` | Fuente — Modelo | Modelo de mensaje de chat con tipo, propiedadId, listaCompartidaId |
| `data_invitacion.json` | Datos | Datos estáticos de invitaciones |
| `data_mensajes.json` | Datos | Datos estáticos de mensajes |

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Aplican al módulo completo en todo momento mientras el módulo de conocidos esté activo.

**SDD-CON-001**
El sistema deberá renderizar `ConocidosView` como contenedor raíz del módulo, orquestando la navegación entre `PageMisContactos`, `PageInvitaciones` y `PageDescubrirUsuarios` mediante `NavigationBar`.

**SDD-CON-002**
El sistema deberá autenticar todas las peticiones HTTP a CouchDB mediante cabecera `Authorization: Basic <base64(username:password)>`, utilizando las credenciales globales `username` y `password` definidas en `direccionip.dart`.

**SDD-CON-003**
El sistema deberá gestionar el estado de invitaciones y contactos exclusivamente mediante Riverpod (`conocidosProvider`, `conocidosAceptadosProvider`, `invitacionesRecibidasProvider`, `invitacionesEnviadasProvider`), garantizando reactividad automática ante cambios.

**SDD-CON-004**
El sistema deberá mantener separadas las bases de datos por dominio: `buscobien_invitaciones` para invitaciones/contactos y `buscobien_mensajes` para mensajes de chat.

**SDD-CON-005**
El sistema deberá mostrar todos los textos y elementos visuales utilizando `appTheme` (ColorScheme M3), evitando hardcodear colores excepto para casos específicos de marca.

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

**SDD-CON-010**
Cuando `ConocidosView` se monte, el sistema deberá crear 3 páginas hijas (`PageMisContactos`, `PageInvitaciones`, `PageDescubrirUsuarios`) propagando `currentUserId` y `currentUserName`.

**SDD-CON-011**
Cuando el usuario presione un destino en la `NavigationBar`, el sistema deberá actualizar `_currentIndex` mediante `setState` y mostrar la página correspondiente.

**SDD-CON-012**
Cuando `PageMisContactos` se monte (`initState`), el sistema deberá ejecutar `conocidosProvider.notifier.cargar(currentUserId)` en un post-frame callback.

**SDD-CON-013**
Cuando el usuario presione el botón `person_search` en un contacto, el sistema deberá navegar a `PagePerfilContacto` con `contactoId` y `contactoName` mediante `Navigator.push` y `MaterialPageRoute`.

**SDD-CON-014**
Cuando el usuario presione el botón `chat` en un contacto, el sistema deberá navegar a `PageChatPrivado` con `currentUserId`, `targetUserId` y `targetName` mediante `Navigator.push` y `MaterialPageRoute`.

**SDD-CON-015**
Cuando el usuario presione el botón de refrescar en `PageChatPrivado`, el sistema deberá invalidar `mensajesChatProvider(_chatKey)` para recargar los mensajes.

**SDD-CON-016**
Cuando el usuario presione el botón "Invitar" en `PageDescubrirUsuarios`, el sistema deberá llamar a `conocidosProvider.notifier.enviarInvitacion(currentUserId, currentUserName, targetId, targetName)`.

**SDD-CON-017**
Cuando `enviarInvitacion` complete exitosamente, el sistema deberá mostrar un `SnackBar` con "Enviada a {targetName}" en color `appTheme.primary`.

**SDD-CON-018**
Cuando `enviarInvitacion` falle, el sistema deberá mostrar un `SnackBar` con "Error al enviar" en color `appTheme.error`.

**SDD-CON-019**
Cuando el usuario presione `check_circle` en una invitación recibida pendiente, el sistema deberá llamar a `responderInvitacion(inv.id, InvitacionEstado.aceptado)`.

**SDD-CON-020**
Cuando el usuario presione `cancel` en una invitación recibida pendiente, el sistema deberá llamar a `responderInvitacion(inv.id, InvitacionEstado.rechazado)`.

**SDD-CON-021**
Cuando `responderInvitacion` complete exitosamente, el sistema deberá actualizar el estado local de la invitación en `conocidosProvider` sin recargar toda la lista.

**SDD-CON-022**
Cuando el usuario presione el botón de enviar en `PageChatPrivado`, el sistema deberá llamar a `mensajesChatProvider(_chatKey).notifier.enviar(text)`.

**SDD-CON-023**
Cuando el usuario presione una burbuja de propiedad en el chat, el sistema deberá navegar a `PaginaDetalleWidget` con la propiedad correspondiente.

**SDD-CON-024**
Cuando el usuario presione una burbuja de lista en el chat, el sistema deberá navegar a `PageDetalleListaCompartida` con el modelo de lista compartida.

**SDD-CON-025**
Cuando `PagePerfilContacto` se monte, el sistema deberá ejecutar `propiedadesContactoProvider(contactoId)` para cargar las propiedades del contacto.

---

## 4. Requerimientos Controlados por Estados (State-Driven)

**SDD-CON-020**
Mientras `_currentIndex == 0`, el sistema deberá mostrar `PageMisContactos` como contenido principal.

**SDD-CON-021**
Mientras `_currentIndex == 1`, el sistema deberá mostrar `PageInvitaciones` como contenido principal.

**SDD-CON-022**
Mientras `_currentIndex == 2`, el sistema deberá mostrar `PageDescubrirUsuarios` como contenido principal.

**SDD-CON-023**
Mientras `conocidosAceptadosProvider` esté en estado `loading`, el sistema deberá mostrar un `CircularProgressIndicator` centrado en `PageMisContactos`.

**SDD-CON-024**
Mientras `conocidosAceptadosProvider` esté en estado `error`, el sistema deberá mostrar `Symbols.cloud_off` en color `appTheme.error`, el texto "Error al cargar contactos" y un botón "Reintentar".

**SDD-CON-025**
Mientras `conocidosAceptadosProvider` retorne `contactos.isEmpty`, el sistema deberá mostrar el texto "Aún no tienes contactos confirmados." centrado.

**SDD-CON-026**
Mientras `invitacionesRecibidasProvider` o `invitacionesEnviadasProvider` estén en estado `loading`, el sistema deberá mostrar un `CircularProgressIndicator` centrado.

**SDD-CON-027**
Mientras una invitación recibida tenga `estado == InvitacionEstado.pendiente`, el sistema deberá mostrar los botones `check_circle` (aceptar) y `cancel` (rechazar).

**SDD-CON-028**
Mientras una invitación recibida tenga `estado == InvitacionEstado.aceptado`, el sistema deberá mostrar el icono `handshake` en color `appTheme.primary`.

**SDD-CON-029**
Mientras una invitación recibida tenga `estado == InvitacionEstado.rechazado`, el sistema deberá mostrar el icono `block` en color `appTheme.onSurfaceVariant`.

**SDD-CON-030**
Mientras una invitación enviada tenga cualquier estado, el sistema deberá mostrar solo el icono de estado correspondiente sin botones de acción.

**SDD-CON-031**
Mientras `usersPromotoresListProvider` o `usersListProvider` estén en estado `loading`, el sistema deberá mostrar un `CircularProgressIndicator` centrado en `PageDescubrirUsuarios`.

**SDD-CON-032**
Mientras `usersPromotoresListProvider` o `usersListProvider` estén en estado `error`, el sistema deberá mostrar el texto "Error: $err" centrado.

**SDD-CON-033**
Mientras `propiedadesContactoProvider` esté en estado `loading`, el sistema deberá mostrar un `CircularProgressIndicator` centrado en `PagePerfilContacto`.

**SDD-CON-034**
Mientras `propiedadesContactoProvider` retorne `propiedades.isEmpty`, el sistema deberá mostrar el texto "Este usuario no tiene propiedades publicadas." centrado.

**SDD-CON-035**
Mientras `mensajesChatProvider` esté en estado `loading`, el sistema deberá mostrar un `CircularProgressIndicator` centrado en `PageChatPrivado`.

**SDD-CON-036**
Mientras `mensajesChatProvider` retorne `mensajes.isEmpty`, el sistema deberá mostrar el texto "Envía el primer mensaje." centrado.

**SDD-CON-037**
Mientras un mensaje tenga `tipo == 'propiedad'`, el sistema deberá mostrar `_BurbujaPropiedad` con icono `Symbols.home`.

**SDD-CON-038**
Mientras un mensaje tenga `tipo == 'lista'`, el sistema deberá mostrar `_BurbujaLista` con icono `Symbols.format_list_bulleted`.

**SDD-CON-039**
Mientras un mensaje tenga `tipo != 'texto'`, el sistema deberá mostrar el texto "Toca para ver detalles" en color `appTheme.primary` con `fontStyle: italic`.

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-CON-030**
Si `conocidosProvider.cargar()` falla, entonces el sistema deberá mostrar el estado de error en `PageMisContactos` y permitir reintentar con el botón "Reintentar".

**SDD-CON-031**
Si `enviarInvitacion` retorna `false`, entonces el sistema deberá mostrar el SnackBar de error y no recargar la lista de usuarios.

**SDD-CON-032**
Si `responderInvitacion` falla al obtener el `_rev` o al hacer `PUT`, entonces el sistema deberá mantener el estado original de la invitación y no actualizar la UI.

**SDD-CON-033**
Si el usuario presiona el botón de enviar en el chat con texto vacío, entonces el sistema no debe ejecutar `enviar()` ni crear un mensaje vacío.

**SDD-CON-034**
Si `_changesSub` recibe una línea vacía (heartbeat de CouchDB), entonces el sistema deberá ignorarla y no procesarla como mensaje.

**SDD-CON-035**
Si el usuario se elimina a sí mismo de los listados en `PageDescubrirUsuarios`, entonces el sistema debe filtrar `id_usuario == currentUserId` y `idUsuario == currentUserId` antes de mostrar las listas.

**SDD-CON-036**
Si `propiedadesContactoProvider` retorna un documento sin el campo `espacioscasa`, entonces el sistema deberá mostrar el texto "Propiedad" como fallback en el título de la tarjeta.

**SDD-CON-037**
Si `propiedadesContactoProvider` retorna `precioventa` null o vacío, entonces el sistema deberá mostrar "$0" como precio fallback.

**SDD-CON-038**
Si el usuario navega a `PageChatPrivado` y el `_changes` feed no está disponible, entonces el sistema deberá mostrar la lista de mensajes cargada inicialmente sin actualizaciones en tiempo real.

**SDD-CON-039**
Si el usuario intenta enviar un mensaje mientras no hay conexión, entonces el sistema deberá mostrar el mensaje optimistamente en la UI y reintentar el envío cuando se restablezca la conexión.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-CON-040**
Donde el usuario tenga contactos aceptados, el sistema deberá mostrar las acciones de perfil (`person_search`) y chat (`chat`) en cada tarjeta de contacto.

**SDD-CON-041**
Donde el usuario tenga invitaciones pendientes recibidas, el sistema deberá mostrar los botones de aceptar y rechazar en la tarjeta de invitación.

**SDD-CON-042**
Donde el usuario navegue a `PageDescubrirUsuarios`, el sistema deberá mostrar secciones separadas de Promotores y Usuarios cuando ambos listados tengan resultados.

**SDD-CON-043**
Donde el usuario comparta una propiedad o lista en el chat, el sistema deberá mostrar burbujas especiales con iconos y texto "Toca para ver detalles/la ficha/las propiedades".

**SDD-CON-044**
Donde el usuario esté en `PageChatPrivado`, el sistema deberá iniciar un `_changes` feed continuo de CouchDB para recibir mensajes en tiempo real.

**SDD-CON-045**
Donde el usuario presione una burbuja de propiedad en el chat, el sistema deberá navegar a `PaginaDetalleWidget` con la propiedad correspondiente.

**SDD-CON-046**
Donde el usuario presione una burbuja de lista en el chat, el sistema deberá navegar a `PageDetalleListaCompartida` con el modelo de lista compartida.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-CON-050**
Mientras el usuario esté en `ConocidosView` con `_currentIndex = 0`, cuando se monte `PageMisContactos`, el sistema deberá ejecutar `conocidosProvider.cargar(currentUserId)`, filtrar por `conocidosAceptadosProvider` y mostrar la lista de contactos con acciones de perfil y chat.

**SDD-CON-051**
Mientras el usuario esté en `ConocidosView` con `_currentIndex = 1`, cuando se monte `PageInvitaciones`, el sistema deberá cargar `invitacionesRecibidasProvider` y `invitacionesEnviadasProvider`, mostrar tabs y permitir aceptar/rechazar invitaciones pendientes con actualización optimista del estado.

**SDD-CON-052**
Mientras el usuario esté en `ConocidosView` con `_currentIndex = 2`, cuando se monte `PageDescubrirUsuarios`, el sistema deberá cargar `usersPromotoresListProvider` y `usersListProvider`, filtrar el usuario actual y mostrar secciones de Promotores y Usuarios con botones de invitación.

**SDD-CON-053**
Mientras el usuario esté en `PageChatPrivado`, cuando envíe un mensaje de texto, el sistema deberá realizar un optimistic update en la UI, enviar el mensaje a CouchDB y, cuando el `_changes` feed lo devuelva, descartar el duplicado por ID.

**SDD-CON-054**
Mientras el usuario esté en `PageChatPrivado`, cuando reciba un mensaje con `tipo = 'propiedad'` o `tipo = 'lista'`, el sistema deberá mostrar la burbuja especial correspondiente y permitir navegar al detalle de la propiedad o lista compartida.

**SDD-CON-055**
Mientras el usuario presione aceptar/rechazar una invitación, cuando `responderInvitacion` complete, el sistema deberá actualizar el estado local de `conocidosProvider` mapeando la invitación por ID y cambiando su `estado` sin recargar toda la lista desde CouchDB.

---

## 8. Diagrama de Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                      ConocidosView                              │
│                                                                 │
│  ┌─────────────┐    ┌──────────────┐    ┌──────────────────┐  │
│  │ Navigation  │    │  PageMis     │    │  PageInvitaciones │  │
│  │ Bar         │    │  Contactos   │    │                  │  │
│  │             │    │              │    │  - Recibidas     │  │
│  │ - Contactos │    │ - Lista de   │    │  - Enviadas      │  │
│  │   (0)       │    │   contactos  │    │  - Aceptar/      │  │
│  │ - Invitac.  │    │ - Avatar +   │    │    Rechazar      │  │
│  │   (1)       │    │   nombre     │    │                  │  │
│  │ - Descubrir │    │ - Perfil/Chat│    │                  │  │
│  │   (2)       │    │              │    │                  │  │
│  └─────────────┘    └──────────────┘    └──────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     conocidosProvider          │
              │  ┌─────────────────────────┐  │
              │  │ ConocidosNotifier       │  │
              │  │ - cargar(userId)        │  │
              │  │ - enviarInvitacion()    │  │
              │  │ - responderInvitacion() │  │
              │  │ - agregarContactoAceptad│  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
      ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
      │conocidosAcept│ │invitaciones  │ │invitaciones │
      │adosProvider  │ │RecibidasProv │ │EnviadasProv │
      └─────────────┘ └─────────────┘ └─────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     PageDescubrirUsuarios      │
              │  ┌─────────────────────────┐  │
              │  │ usersPromotoresListProv │  │
              │  │ usersListProvider       │  │
              │  │ Filtro: excluir self    │  │
              │  │ Sección Promotores      │  │
              │  │ Sección Usuarios        │  │
              │  │ Botón "Invitar"         │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     PageChatPrivado            │
              │  ┌─────────────────────────┐  │
              │  │ mensajesChatProvider    │  │
              │  │ (AsyncNotifier.family)  │  │
              │  │                         │  │
              │  │ Flujo:                  │  │
              │  │ 1. _cargarMensajes()    │  │
              │  │ 2. _iniciarStream()     │  │
              │  │    (_changes feed)      │  │
              │  │ 3. enviar()             │  │
              │  │    (optimistic update)  │  │
              │  │ 4. dedup por ID         │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     PagePerfilContacto         │
              │  ┌─────────────────────────┐  │
              │  │ propiedadesContactoProv │  │
              │  │ (FutureProvider.family) │  │
              │  │ Grid 2x de propiedades  │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
```

---

## 9. Mapa de Correspondencia Elemento → Comportamiento

### Vista Raíz

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `ConocidosView` | `conocidos_view.dart` | `StatefulWidget` con `NavigationBar` de 3 destinos |
| `_currentIndex` | `conocidos_view.dart` | Índice de pestaña activa (0=Contactos, 1=Invitaciones, 2=Descubrir) |
| `NavigationBar` | `conocidos_view.dart` | `indicatorColor: appTheme.primary`, `height: navBarHeight` |
| Destinos | `conocidos_view.dart` | Contactos (`people`), Invitaciones (`mail`), Descubrir (`search`) |

### Página Mis Contactos

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `PageMisContactos` | `page_mis_contactos.dart` | `ConsumerStatefulWidget` que carga contactos en `initState` |
| `conocidosAceptadosProvider` | `page_mis_contactos.dart` | `Provider.family` que filtra contactos aceptados del usuario |
| Estados | `page_mis_contactos.dart` | Loading (`CircularProgressIndicator`), Error (`cloud_off` + botón reintentar), Empty ("Aún no tienes contactos confirmados.") |
| Lista | `page_mis_contactos.dart` | `ListView.builder` con `Card` + `ListTile` |
| Avatar | `page_mis_contactos.dart` | `CircleAvatar` con inicial del nombre, `backgroundColor: appTheme.secondary` |
| Botón perfil | `page_mis_contactos.dart` | `person_search` → `PagePerfilContacto` |
| Botón chat | `page_mis_contactos.dart` | `chat` → `PageChatPrivado` |
| Pull-to-refresh | `page_mis_contactos.dart` | `RefreshIndicator` que recarga `conocidosProvider` |

### Página Invitaciones

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `PageInvitaciones` | `page_invitaciones.dart` | `ConsumerWidget` con `DefaultTabController` de 2 tabs |
| `invitacionesRecibidasProvider` | `page_invitaciones.dart` | Provider que filtra invitaciones donde `receiverId == currentUserId` |
| `invitacionesEnviadasProvider` | `page_invitaciones.dart` | Provider que filtra invitaciones donde `senderId == currentUserId` |
| Tabs | `page_invitaciones.dart` | Recibidas / Enviadas con `TabBar` |
| Botones acción | `page_invitaciones.dart` | Solo en recibidas pendientes: `check_circle` (aceptar) y `cancel` (rechazar) |
| Iconos estado | `page_invitaciones.dart` | Aceptado: `handshake`, Rechazado: `block`, Pendiente: `access_time` |
| `_updateStatus` | `page_invitaciones.dart` | Llama a `conocidosProvider.notifier.responderInvitacion` |

### Página Descubrir Usuarios

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `PageDescubrirUsuarios` | `page_descubrir_usuarios.dart` | `ConsumerWidget` que carga usuarios y promotores |
| `usersListProvider` | `page_descubrir_usuarios.dart` | `FutureProvider` que obtiene usuarios desde `buscobien_usuarios` |
| `usersPromotoresListProvider` | `page_descubrir_usuarios.dart` | `FutureProvider` que obtiene promotores desde `buscobien_usuarios_promotores` |
| Filtro self | `page_descubrir_usuarios.dart` | Excluye `id_usuario == currentUserId` y `idUsuario == currentUserId` |
| Secciones | `page_descubrir_usuarios.dart` | `SliverToBoxAdapter` con headers "Promotores" y "Usuarios" + `SliverList` |
| Botón Invitar | `page_descubrir_usuarios.dart` | `OutlinedButton.icon` con `enviarInvitacion` y SnackBar de resultado |

### Página Perfil Contacto

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `PagePerfilContacto` | `page_perfil_contacto.dart` | `ConsumerWidget` con header y grid de propiedades |
| `propiedadesContactoProvider` | `page_perfil_contacto.dart` | `FutureProvider.family<String, List<dynamic>>` que consulta `buscobien_propiedades/_find` por `userId` |
| Header | `page_perfil_contacto.dart` | `CircleAvatar` radio 40, nombre en bold 22px, fondo `appTheme.primary.withValues(alpha: 0.05)` |
| Grid | `page_perfil_contacto.dart` | `GridView.builder` con `crossAxisCount: 2`, spacing 10 |
| Tarjeta propiedad | `page_perfil_contacto.dart` | Placeholder gris con `Symbols.home`, título `letreropromocional`, precio en verde |

### Página Chat Privado

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `PageChatPrivado` | `page_chat_privado.dart` | `ConsumerStatefulWidget` con chat en tiempo real |
| `_chatKey` | `page_chat_privado.dart` | Generado con `chatProviderKey(currentUserId, targetUserId)` |
| `mensajesChatProvider` | `page_chat_privado.dart` | `AsyncNotifierProvider.family` con `_changes` feed continuo |
| `_send()` | `page_chat_privado.dart` | Envía mensaje con optimistic update y clear/unfocus |
| Burbujas | `page_chat_privado.dart` | Alineación por remitente, colores diferenciados, timestamp |
| `_BurbujaPropiedad` | `page_chat_privado.dart` | Navega a `PaginaDetalleWidget` al tocar |
| `_BurbujaLista` | `page_chat_privado.dart` | Navega a `PageDetalleListaCompartida` al tocar |
| Campo de texto | `page_chat_privado.dart` | `TextField` con `maxLines: 10`, `onSubmitted`, hint "Escribe un mensaje..." |

### Providers

| Provider | Archivo | Tipo | Comportamiento |
|---|---|---|---|
| `conocidosProvider` | `providers/conocidos_notifier.dart` | `AsyncNotifierProvider` | Gestiona todas las invitaciones/contactos del usuario |
| `conocidosAceptadosProvider` | `providers/conocidos_notifier.dart` | `Provider.family` | Filtra contactos con `estado == aceptado` |
| `invitacionesRecibidasProvider` | `providers/conocidos_notifier.dart` | `Provider.family` | Filtra por `receptorId == currentUserId` |
| `invitacionesEnviadasProvider` | `providers/conocidos_notifier.dart` | `Provider.family` | Filtra por `senderId == currentUserId` |
| `mensajesChatProvider` | `provider_mensajes.dart` | `AsyncNotifierProvider.family` | Chat con `_changes` feed continuo |
| `usersListProvider` | `social_providers.dart` | `FutureProvider` | Lista de usuarios desde CouchDB |
| `usersPromotoresListProvider` | `social_providers.dart` | `FutureProvider` | Lista de promotores desde CouchDB |
| `propiedadesContactoProvider` | `page_perfil_contacto.dart` | `FutureProvider.family` | Propiedades de un usuario por `userId` |

### Modelos

| Modelo | Archivo | Campos |
|---|---|---|
| `Conocido` | `models/conocido.dart` | `id`, `solicitanteId`, `solicitanteNombre`, `receptorId`, `receptorNombre`, `estado` (`InvitacionEstado`), `fechaActualizacion` |
| `InvitacionEstado` | `models/conocido.dart` | Enum: `pendiente`, `aceptado`, `rechazado`, `bloqueado` |
| `MensajeModel` | `mensaje_model.dart` | `id`, `rev`, `senderId`, `receiverId`, `content`, `timestamp`, `tipo`, `propiedadId`, `listaCompartidaId` |
| `InvitacionModel` | `invitacion_model.dart` | `id`, `rev`, `senderId`, `senderName`, `receiverId`, `receiverName`, `status`, `timestamp` |

---

## 10. Decisiones de Diseño Documentadas

| ID | Decisión | Justificación |
|---|---|---|
| DD-01 | `StatefulWidget` para `ConocidosView` | Requiere `setState` para cambiar `_currentIndex` en la `NavigationBar` |
| DD-02 | `ConsumerStatefulWidget` para `PageMisContactos` | Necesita acceso a providers y `setState` para el post-frame callback |
| DD-03 | `ConsumerWidget` para `PageInvitaciones` y `PageDescubrirUsuarios` | Solo necesitan lectura de providers; no requieren `setState` |
| DD-04 | `DefaultTabController` en `PageInvitaciones` | Proporciona tabs nativos con `TabBar` y `TabBarView` sin necesidad de provider adicional |
| DD-05 | `AsyncNotifierProvider` para `conocidosProvider` | Maneja estados asíncronos (loading, error, data) y métodos personalizados |
| DD-06 | `Provider.family` para `conocidosAceptadosProvider` | Deriva contactos aceptados filtrando por `currentUserId` |
| DD-07 | `AsyncNotifierProvider.family` para `mensajesChatProvider` | Crea una instancia independiente por par de usuarios (`chatKey`) |
| DD-08 | `_changes` feed continuo en chat | Proporciona actualizaciones en tiempo real sin polling |
| DD-09 | Optimistic update en envío de mensajes | El mensaje aparece inmediatamente en la UI antes de confirmar con el servidor |
| DD-10 | Dedup por ID en `_changes` feed | Previene duplicados cuando el mensaje optimista ya está en la lista |
| DD-11 | `chatProviderKey` con separador `@@` | Genera claves únicas y predecibles para el provider familiar |
| DD-12 | `RefreshIndicator` en `PageMisContactos` | Permite pull-to-refresh para actualizar la lista de contactos |
| DD-13 | Anti-duplicado en `agregarContactoAceptado` | Verifica si ya existe una relación aceptada antes de crear una nueva |
| DD-14 | `barrierDismissible: false` implícito en diálogos | Los diálogos de confirmación requieren acción explícita del usuario |
| DD-15 | `NavigationBar` en lugar de `BottomNavigationBar` | Cumple con Material Design 3 según reglas del proyecto |
| DD-16 | `propiedadesContactoProvider` como `FutureProvider.family` | Aísla la consulta por usuario y permite cacheo por `userId` |
| DD-17 | Filtrado de `currentUserId` en `PageDescubrirUsuarios` | Previene que el usuario se vea a sí mismo en la lista de descubrimiento |
| DD-18 | Modelo `Conocido` con Freezed | Garantiza inmutabilidad, `copyWith` y serialización JSON automática |
| DD-19 | `InvitacionEstado` como enum | Proporciona type-safety y legibilidad sobre strings crudos |
| DD-20 | `MensajeModel` con campos `propiedadId` y `listaCompartidaId` | Permite burbujas especiales navegables sin consultas adicionales |

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-08*
