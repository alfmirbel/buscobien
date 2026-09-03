# SDD — Módulo `lib/03_listas` — Especificación de Arquitectura
## Especificación General del Módulo de Listas y Favoritos
**Módulo:** `lib/03_listas/`
**Versión:** 1.0
**Metodología:** EARS — Easy Approach to Requirements Syntax
**Fecha:** 2026-08-07

---

## 1. Inventario de Archivos del Módulo

| Archivo | Tipo | Rol |
|---|---|---|
| `pagina_mis_listas.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Pantalla principal de listas con 3 tabs: Propias, Recibidas, Enviadas; incluye diálogos de crear, borrar, compartir y dejar de compartir listas |
| `pagina_detalle_listas.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Detalle de una lista propia; muestra propiedades en `ListView.separated` con `Dismissible` para eliminar, incluye fallback multi-endpoint |
| `pagina_detalle_lista_compartida.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Detalle de una lista compartida; carga propiedades desde `_dbListasPropCompartidas` y renderiza `WrapModernCardPropiedades` |
| `page_compartir_con_conocido.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Pantalla de compartir propiedad con conocidos; selección múltiple con `CheckboxListTile` hasta 5, envía mensaje de chat tipo "propiedad" |
| `page_compartir_con_grupo.dart` | Fuente — Widget con Estado (`ConsumerStatefulWidget`) | Pantalla de compartir propiedad con grupos; selección múltiple de grupos, crea publicación y envía mensaje al chat grupal |
| `provider_user_lists.dart` | Fuente — Riverpod `NotifierProvider` | Gestiona listas del usuario: `fetchUserLists`, `createList`, `deleteLista`; reordena "Favoritas" al índice 0 |
| `provider_listas_compartidas.dart` | Fuente — Riverpod `AsyncNotifierProvider` | Gestiona listas compartidas: `fetchListasCompartidas`, `compartirLista` (con anti-duplicado), `dejarDeCompartir`, `_copiarPropiedades`, `fetchPropiedadesListaCompartida` |
| `provider_listas_propiedades.dart` | Fuente — Riverpod `NotifierProvider` | Gestiona relaciones lista-propiedad: `getListaPropiedad`, `addPropiedadALista`, `borrarPropiedadDeLista`, `borrarListapropiedadPorId`, `getPropiedadesDetallesPorListaId` |
| `provider_me_gusta.dart` | Fuente — Riverpod `AsyncNotifierProvider` | Gestiona "Me gusta": `init`, `toggleMeGusta`, `_agregarMeGusta`, `_quitarMeGusta`, auto-crea lista "Favoritas", agrega propiedad a Favoritas |
| `provider_propiedades_compartidas_conocidos.dart` | Fuente — Riverpod Provider | Gestiona compartición de propiedades con conocidos específicamente |
| `models/lista_compartida_model.dart` | Fuente — Modelo de Datos | Define `ListaCompartidaModel` con campos `id`, `listaOrigenId`, `listaNombre`, `usuarioOrigenId/DestinoId/Nombre`, `timestamp` |
| `data_user_list_model.dart` / `data_user_list_model_get.dart` | Fuente — Modelos de Datos | Define `Lista`, `GetUserPropertyListModel`, `RowGetUserPropertyList` para listas del usuario |
| `data_lista_propiedad.dart` / `data_lista_propiedad_get.dart` | Fuente — Modelos de Datos | Define `Listapropiedad`, `ListaPropertyListModel`, `RowListaProperty` para relaciones lista-propiedad |
| `models/me_gusta_model.dart` | Fuente — Modelo de Datos | Define `MeGustaModel` para registros de "Me gusta" |
| `lista_select_lista_save_propiedad.dart` | Fuente — Widget/Utilidad | Componente para seleccionar una lista al guardar una propiedad |
| `data_listas.json` | Documentación/Datos | Datos estáticos o de referencia para listas |
| `consulta_gemini.txt` | Documentación | Notas o consultas relacionadas con Gemini AI |
| `models/` | Directorio | Contiene modelos de datos del módulo |

---

## 2. Requerimientos Ubicuos (Ubiquitous)

> Aplican al módulo completo en todo momento mientras el módulo de listas esté activo.

**SDD-LIS-001**
El sistema deberá gestionar el estado de listas del usuario exclusivamente mediante Riverpod (`userListsProvider`, `listasCompartidasProvider`, `listaPropiedadesProvider`, `meGustaProvider`), garantizando reactividad automática ante cambios en los datos.

**SDD-LIS-002**
El sistema deberá autenticar todas las peticiones HTTP a CouchDB mediante cabecera `Authorization: Basic <base64(username:password)>`, utilizando las credenciales globales `username` y `password` definidas en `direccionip.dart`.

**SDD-LIS-003**
El sistema deberá mantener separadas las bases de datos por dominio:
- `buscobien_usuarios_listas` — listas del usuario
- `buscobien_listas_propiedades` — relaciones lista-propiedad
- `buscobien_listas_compartidas_usuarios` — comparticiones de listas
- `buscobien_listas_prop_compartidas` — propiedades copiadas de listas compartidas
- `buscobien_megusta_propiedades` — registros de "Me gusta"

**SDD-LIS-004**
El sistema deberá garantizar que la lista "Favoritas" siempre aparezca en la primera posición (`índice 0`) del estado de `userListsProvider` cuando se cargue o actualice el listado de listas del usuario.

**SDD-LIS-005**
El sistema deberá manejar errores de red y HTTP de forma graceful, mostrando mensajes informativos en `SnackBar` o widgets de error sin crashear la aplicación, y retornando estados vacíos (`[]`, `totalRows: 0`) ante fallos.

---

## 3. Requerimientos Controlados por Eventos (Event-Driven)

**SDD-LIS-010**
Cuando `PageMisListas` se monte (`initState`), el sistema deberá crear un `TabController` de longitud 3 (Propias, Recibidas, Enviadas) y, si `sessionUserData.userId` no está vacío, ejecutar `fetchUserLists`, `fetchListasCompartidas` y `cargar` de conocidos en segundo plano.

**SDD-LIS-011**
Cuando el usuario presione el botón "Crea lista" (`FloatingActionButton.extended`), el sistema deberá abrir el diálogo `_mostrarDialogoCrearLista` con un `TextField` de máximo 60 caracteres y botones "Cancelar" y "Crear".

**SDD-LIS-012**
Cuando el usuario presione "Crear" en el diálogo de nueva lista y el texto no esté vacío, el sistema deberá invocar `userListsProvider.notifier.createList(userId, listName)` y, si es exitoso, mostrar un `SnackBar` con "Lista creada" en color primario.

**SDD-LIS-013**
Cuando el usuario presione "Crear" con el campo vacío, el sistema deberá mostrar un `SnackBar` con "Escribe el nombre de la lista." en color de error y mantener el diálogo abierto.

**SDD-LIS-014**
Cuando el usuario presione el botón de eliminar en una lista propia, el sistema deberá abrir `_dialogBorrarLista` con el nombre de la lista y la confirmación "¿Deseas eliminar la lista...? Esta acción no se puede deshacer."

**SDD-LIS-015**
Cuando el usuario confirme la eliminación en `_dialogBorrarLista`, el sistema deberá invocar `userListsProvider.notifier.deleteLista(docId, userId)` y, si es exitoso, mostrar un `SnackBar` con "Lista eliminada" en color primario.

**SDD-LIS-016**
Cuando el usuario presione el botón de compartir en una lista propia, el sistema deberá abrir `_dialogCompartir` con la lista de conocidos aceptados, permitiendo seleccionar hasta 5 destinatarios.

**SDD-LIS-017**
Cuando el usuario presione "Enviar" en `_dialogCompartir`, el sistema deberá invocar `_dialogConfirmarCompartir` mostrando el nombre de la lista y los destinatarios seleccionados, con botones "Cancelar" y "Compartir".

**SDD-LIS-018**
Cuando el usuario confirme en `_dialogConfirmarCompartir`, el sistema deberá invocar `_ejecutarCompartir` que itera sobre los seleccionados, llamando a `listasCompartidasProvider.notifier.compartirLista` por cada destinatario.

**SDD-LIS-019**
Cuando `compartirLista` se ejecute exitosamente, el sistema deberá: crear el documento en `buscobien_listas_compartidas_usuarios`, copiar las propiedades a `buscobien_listas_prop_compartidas` y enviar un mensaje de chat privado con `tipo: 'lista'` y `listaCompartidaId`.

**SDD-LIS-020**
Cuando el usuario presione "Dejar de compartir" en una lista recibida o enviada, el sistema deberá abrir `_dialogDejarDeCompartir` con el nombre de la lista y el usuario destino, y al confirmar invocar `listasCompartidasProvider.notifier.dejarDeCompartir`.

**SDD-LIS-021**
Cuando `dejarDeCompartir` se ejecute, el sistema deberá marcar el documento como `_deleted: true`, limpiar las propiedades copiadas en `buscobien_listas_prop_compartidas` y refrescar el estado con `fetchListasCompartidas`.

**SDD-LIS-022**
Cuando el usuario toque una tarjeta de lista en las tabs Propias, Recibidas o Enviadas, el sistema deberá navegar a `PageDetalleLista` (propias) o `PageDetalleListaCompartida` (recibidas/enviadas) usando `Navigator.push` con `MaterialPageRoute`.

**SDD-LIS-023**
Cuando `PageDetalleLista` se monte, el sistema deberá invocar `listaPropiedadesProvider.notifier.getListaPropiedad(widget.lista)` para cargar las relaciones propiedad-lista.

**SDD-LIS-024**
Cuando el usuario deslice una propiedad hacia la izquierda en `PageDetalleLista`, el sistema deberá mostrar un `confirmDismiss` con diálogo "Quitar propiedad" y, al confirmar, invocar `_borrarPropiedad(listapropiedadId)`.

**SDD-LIS-025**
Cuando el usuario presione "Compartir con conocido" en una propiedad, el sistema deberá navegar a `PageCompartirConConocido` con `propiedadId`, `propiedadNombre`, `tipodeespacio`, `currentUserId` y `currentUserName`.

**SDD-LIS-026**
Cuando el usuario presione "Compartir con grupo" en una propiedad, el sistema deberá navegar a `PageCompartirConGrupo` con los mismos parámetros de propiedad y usuario.

**SDD-LIS-027**
Cuando el usuario presione "Enviar" en `PageCompartirConConocido`, el sistema deberá iterar sobre los conocidos seleccionados, registrar la compartición en `propiedadesCompartidasConocidosProvider` y enviar un mensaje de chat privado con `tipo: 'propiedad'` y `propiedadId`.

**SDD-LIS-028**
Cuando el usuario presione "Enviar" en `PageCompartirConGrupo`, el sistema deberá iterar sobre los grupos seleccionados, crear una publicación en `publicacionesGrupoProvider` y enviar un mensaje al chat grupal con `tipo: 'propiedad'` y `propiedadId`.

**SDD-LIS-029**
Cuando el usuario presione el botón de "Me gusta" en una propiedad, el sistema deberá invocar `meGustaProvider.notifier.toggleMeGusta` con `usuarioId`, `propiedadId` y `userListsNotifier`.

**SDD-LIS-030**
Cuando `toggleMeGusta` detecte que es el primer "Me gusta" del usuario, el sistema deberá crear automáticamente la lista "Favoritas" y agregar la propiedad a ella.

**SDD-LIS-031**
Cuando `toggleMeGusta` detecte que el "Me gusta" ya existe, el sistema deberá eliminarlo y quitar la propiedad de la lista "Favoritas" si estaba ahí.

**SDD-LIS-032**
Cuando `PageDetalleListaCompartida` se monte, el sistema deberá invocar `fetchPropiedadesListaCompartida(listaCompartidaId)` para obtener los IDs de propiedades y luego renderizar cada una con `WrapModernCardPropiedades`.

**SDD-LIS-033**
Cuando el usuario regrese de `PageDetalleLista` a `PageMisListas`, el sistema deberá recargar las listas del usuario con `fetchUserLists(_idUsuario)` para reflejar cambios (eliminaciones, creaciones).

---

## 4. Requerimientos Controlados por Estados (State-Driven)

**SDD-LIS-020**
Mientras `_idUsuario` esté vacío, el sistema deberá mostrar `_vistaInvitado()` con el mensaje "No hay listas que mostrar" y el botón de login "Ingresa como usuario o promotor para crear listas".

**SDD-LIS-021**
Mientras `_idUsuario` no esté vacío, el sistema deberá mostrar el `TabBar` con las tabs "Propias", "Recibidas" y "Enviadas", y el `TabBarView` correspondiente.

**SDD-LIS-022**
Mientras `navState.indiceInicial == 3` y `userSession.esPromotor == true`, el sistema deberá mostrar `MenuSuperiorPaginaTuCuenta` y, si `indiceMiCuenta == 1`, mostrar `PageMisListas` con `hasScrollBody: false`.

**SDD-LIS-023**
Mientras `navState.indiceInicial == 3` y `userSession.esUsuario == true`, el sistema deberá mostrar `MenuSuperiorPaginaTuCuentaUsuario` y, si `indiceMiCuentaUsuario == 0`, mostrar `PageMisListas` con `hasScrollBody: false`.

**SDD-LIS-024**
Mientras el usuario esté en la tab "Propias" de `PageMisListas`, el sistema deberá mostrar el `FloatingActionButton.extended` con texto "Crea lista" e ícono `Symbols.add`.

**SDD-LIS-025**
Mientras `userListsProvider.rows` esté vacío y no esté cargando, el sistema deberá mostrar el icono `Symbols.format_list_bulleted` y el texto "No tienes listas creadas." centrado.

**SDD-LIS-026**
Mientras `listasCompartidasProvider` esté en estado `loading`, el sistema deberá mostrar un `CircularProgressIndicator` centrado en las tabs "Recibidas" y "Enviadas".

**SDD-LIS-027**
Mientras `listasCompartidasProvider` esté en estado `error`, el sistema deberá mostrar el texto "Error al cargar listas recibidas/enviadas" en color `appTheme.error`.

**SDD-LIS-028**
Mientras `listasCompartidasProvider.data` esté vacío en la tab "Recibidas", el sistema deberá mostrar el icono `Symbols.move_to_inbox` y el texto "No has recibido listas compartidas."

**SDD-LIS-029**
Mientras `listasCompartidasProvider.data` esté vacío en la tab "Enviadas", el sistema deberá mostrar el icono `Symbols.outbox` y el texto "No has compartido listas con nadie."

**SDD-LIS-030**
Mientras `conocidosAceptadosProvider(_idUsuario)` esté vacío, el sistema deberá deshabilitar el botón de compartir en las tarjetas de listas propias (`onPressed: null`).

**SDD-LIS-031**
Mientras el usuario esté en `PageCompartirConConocido` y `conocidosAceptadosProvider` esté vacío, el sistema deberá mostrar el texto "Aún no tienes conocidos aceptados." centrado.

**SDD-LIS-032**
Mientras el usuario esté en `PageCompartirConGrupo` y `gruposProvider` esté vacío, el sistema deberá mostrar el texto "No perteneces a ningún grupo todavía." centrado.

**SDD-LIS-033**
Mientras `_seleccionados.length >= 5` en `PageCompartirConConocido`, el sistema deberá deshabilitar los `CheckboxListTile` adicionales (`onChanged: null`) y mostrar el texto en color `appTheme.onSurfaceVariant`.

**SDD-LIS-034**
Mientras `_enviando == true` en las pantallas de compartir, el sistema deberá mostrar un `CircularProgressIndicator` en el botón "Enviar" y deshabilitar su `onPressed`.

**SDD-LIS-035**
Mientras `_cargando == true` en `PageMisListas`, el sistema deberá mostrar el widget `stateWaiting` como indicador de carga en la tab activa.

---

## 5. Requerimientos de Comportamiento No Deseado (Unwanted Behaviour)

**SDD-LIS-030**
Si el usuario intenta crear una lista con un nombre mayor a 60 caracteres, entonces el sistema deberá retornar `false` sin invocar la petición HTTP y no crear la lista.

**SDD-LIS-031**
Si el usuario intenta compartir una lista con un conocido que ya la recibió, entonces el sistema deberá detectar la duplicidad mediante `_existeCompartida` y retornar `-1` sin crear un nuevo registro.

**SDD-LIS-032**
Si el usuario intenta eliminar una lista y el documento no tiene `_rev` en CouchDB, entonces el sistema deberá retornar `false` y mostrar un SnackBar de error sin modificar el estado local.

**SDD-LIS-033**
Si el usuario desliza para eliminar una propiedad y `_borrarPropiedad` falla, entonces el sistema deberá mostrar un SnackBar con "Error al eliminar" en color de error y no remover la propiedad de la UI.

**SDD-LIS-034**
Si `fetchPropiedadesListaCompartida` retorna una lista vacía, entonces el sistema deberá mostrar el texto "Esta lista no tiene propiedades." con el icono `Symbols.folder_open`.

**SDD-LIS-035**
Si una propiedad en el detalle de lista tiene `tipodeespacio` vacío y no se encuentra en ningún endpoint, entonces el sistema deberá mostrar el texto "No se encontró la propiedad." en lugar de una tarjeta rota.

**SDD-LIS-036**
Si el usuario cierra sesión mientras está en `PageMisListas`, entonces el `ref.listen(sessionProvider)` deberá detectar el cambio de `userId`, resetear `_idUsuario` a vacío y mostrar la vista de invitado.

**SDD-LIS-037**
Si el usuario comparte una propiedad pero no selecciona ningún conocido o grupo, entonces el sistema no debe ejecutar ninguna petición HTTP y debe mantener al usuario en la pantalla de selección.

**SDD-LIS-038**
Si el mensaje de chat privado o grupal falla al enviarse, entonces el sistema deberá igualmente mostrar el SnackBar de éxito si la compartición en la base de datos fue exitosa, sin bloquear la navegación.

**SDD-LIS-039**
Si el usuario intenta acceder a `PageMisListas` sin estar autenticado y sin `userId`, entonces el sistema debe mostrar la vista de invitado y no intentar cargar providers que requieren autenticación.

**SDD-LIS-040**
Si `deleteLista` falla después de obtener el `_rev`, entonces el sistema deberá retornar `false`, mostrar "Error al eliminar la lista" y no modificar el estado de `userListsProvider`.

---

## 6. Requerimientos de Funciones Opcionales (Optional Feature)

**SDD-LIS-040**
Donde el módulo `03_listas` incluya la pantalla de compartir con grupos, el sistema deberá integrarse con `publicacionesGrupoProvider` para crear publicaciones en el feed grupal y con `mensajesGrupoProvider` para notificar por chat.

**SDD-LIS-041**
Donde el módulo incluya la pantalla de compartir con conocidos, el sistema deberá integrarse con `propiedadesCompartidasConocidosProvider` para registrar la compartición y con `mensajesChatProvider` para enviar el mensaje privado.

**SDD-LIS-042**
Donde el usuario tenga habilitada la función de "Me gusta", el sistema deberá crear automáticamente la lista "Favoritas" si no existe, y agregar la propiedad marcada como favorita a dicha lista.

**SDD-LIS-043**
Donde `PageDetalleLista` renderice propiedades con `tipodeespacio` vacío, el sistema deberá ejecutar el fallback multi-endpoint consultando `endpointsPublicados` hasta encontrar la propiedad.

**SDD-LIS-044**
Donde el usuario regrese de un detalle de lista, el sistema deberá refrescar `userListsProvider` automáticamente para reflejar cambios en la UI sin intervención manual.

---

## 7. Requerimientos Complejos (Combinados)

**SDD-LIS-050**
Mientras el usuario esté autenticado y navegue a la pestaña "Propias", cuando el usuario presione "Crea lista" y confirme la creación, el sistema deberá cerrar el diálogo, mostrar el SnackBar de éxito, recargar `userListsProvider` y posicionar la nueva lista en la parte superior (después de "Favoritas").

**SDD-LIS-051**
Mientras el usuario esté en `PageMisListas` y cambie de sesión (login/logout), cuando `sessionProvider` emita un nuevo `userId`, el sistema deberá actualizar `_idUsuario` y `_nombreUsuario`, recargar listas, listas compartidas y conocidos, y cambiar entre vista invitado y vista autenticada.

**SDD-LIS-052**
Mientras el usuario esté compartiendo una lista y seleccione conocidos, cuando presione "Enviar", el sistema deberá validar la selección, mostrar diálogo de confirmación con el nombre de la lista y los destinatarios, y al confirmar ejecutar `compartirLista` por cada uno, copiar propiedades y enviar mensajes de chat sin bloquear la UI.

**SDD-LIS-053**
Mientras el usuario esté en `PageDetalleLista` y deslice una propiedad, cuando confirme la eliminación, el sistema deberá borrar la relación en CouchDB, actualizar optimísticamente el estado local de `listaPropiedadesProvider`, mostrar SnackBar de éxito y, si falla, restaurar la propiedad en la UI.

**SDD-LIS-054**
Mientras el usuario presione "Me gusta" en una propiedad que no está en ninguna lista, cuando `toggleMeGusta` se ejecute, el sistema deberá crear "Favoritas", agregar la propiedad a Favoritas, registrar el "Me gusta" y actualizar el estado local optimistamente sin re-fetch.

**SDD-LIS-055**
Mientras el usuario esté en `PageCompartirConConocido` y seleccione conocidos, cuando llegue al límite de 5, el sistema deberá deshabilitar los checkboxes restantes, mantener la selección actual y, al presionar "Enviar", enviar mensajes de chat a cada conocido y registrar comparticiones en la base de datos.

---

## 8. Diagrama de Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                    PageMisListas (build)                        │
│                                                                 │
│  ┌─────────────┐    ┌──────────────┐    ┌──────────────────┐  │
│  │ initState   │    │ ref.listen   │    │  Conditional UI  │  │
│  │             │    │              │    │                  │  │
│  │ TabController│    │ sessionProv: │    │  _idUsuario=""   │  │
│  │ length: 3   │    │ refresh on  │    │  → _vistaInvitado│  │
│  │             │    │ login/logout │    │  _idUsuario!=""  │  │
│  │ fetchLists  │    │              │    │  → Tabs + FAB    │  │
│  │ fetchShared │    │              │    │                  │  │
│  │ fetchConoc  │    │              │    │                  │  │
│  └─────────────┘    └──────────────┘    └──────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     userListsProvider         │
              │  ┌─────────────────────────┐  │
              │  │ GetUserPropertyListModel│  │
              │  │ rows: [RowGetUser...]   │  │
              │  │ Favoritas → índice 0    │  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
      ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
      │listasCompartid│ │conocidosProv│ │listaPropProv│
      │asProvider    │ │aceptados    │ │ider        │
      │ AsyncNotifier│ │             │ │             │
      │ List<ListaCom │ │             │ │             │
      │ partidaModel>│ │             │ │             │
      └─────────────┘ └─────────────┘ └─────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     Tabs Propias/Recibidas/    │
              │     Enviadas                   │
              │  ┌─────────────────────────┐  │
              │  │ Propias: ListView +     │  │
              │  │ FAB "Crea lista"       │  │
              │  │ Cards: nombre + btns   │  │
              │  │ (Compartir/Borrar)     │  │
              │  ├─────────────────────────┤  │
      │  │ Recibidas: ListView      │  │
      │  │ Cards: listaNombre +     │  │
      │  │ "De [origen]"            │  │
      │  │ btn "Dejar de compartir" │  │
      │  ├─────────────────────────┤  │
      │  │ Enviadas: ListView       │  │
      │  │ Cards: listaNombre +     │  │
      │  │ "Para [destino]"         │  │
      │  │ btn "Dejar de compartir" │  │
      │  └─────────────────────────┘  │
      └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │     Dialogs / Detail Views     │
              │  ┌─────────────────────────┐  │
              │  │ _mostrarDialogoCrearLista│ │
              │  │ _dialogBorrarLista      │ │
              │  │ _dialogCompartir        │ │
              │  │ _dialogConfirmarCompartir│ │
              │  │ _dialogDejarDeCompartir │ │
              │  ├─────────────────────────┤ │
              │  │ PageDetalleLista        │ │
              │  │ - FutureBuilder         │ │
              │  │ - ListView.separated    │ │
              │  │ - Dismissible (swipe)   │ │
              │  │ - WrapModernCardPropied.│ │
              │  ├─────────────────────────┤ │
              │  │ PageDetalleListaCompart.│ │
              │  │ - fetchPropiedades...   │ │
              │  │ - WrapModernCardPropied.│ │
              │  ├─────────────────────────┤ │
              │  │ PageCompartirConConocido│ │
              │  │ - CheckboxListTile      │ │
              │  │ - max 5 seleccionados   │ │
              │  │ - chat privado          │ │
              │  ├─────────────────────────┤ │
              │  │ PageCompartirConGrupo   │ │
              │  │ - CheckboxListTile      │ │
              │  │ - publicación grupal    │ │
              │  │ - chat grupal           │ │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
                              │
                              ▼
              ┌───────────────────────────────┐
              │        meGustaProvider         │
              │  ┌─────────────────────────┐  │
              │  │ toggleMeGusta()        │  │
              │  │ - _agregarMeGusta()    │  │
              │  │ - _quitarMeGusta()     │  │
              │  │ - _crearListaFavoritas │  │
              │  │ - _agregarPropiedadAFav│  │
              │  └─────────────────────────┘  │
              └───────────────────────────────┘
```

---

## 9. Mapa de Correspondencia Elemento → Comportamiento

### Pantalla Principal de Listas

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `PageMisListas` | `pagina_mis_listas.dart` | Widget raíz; renderiza `Scaffold` con `FloatingActionButton` y cuerpo condicional por sesión |
| `TabController` | `pagina_mis_listas.dart` | Creado en `initState` con longitud 3; gestiona las tabs Propias/Recibidas/Enviadas |
| `ref.listen(sessionProvider)` | `pagina_mis_listas.dart` | Detecta cambios de sesión post-login; actualiza `_idUsuario`, `_nombreUsuario` y recarga datos |
| `_vistaInvitado()` | `pagina_mis_listas.dart` | Muestra mensaje "No hay listas que mostrar" y botón de login |
| `FloatingActionButton` | `pagina_mis_listas.dart` | Botón "Crea lista" con ícono `Symbols.add`; abre `_mostrarDialogoCrearLista` |
| `_mostrarDialogoCrearLista` | `pagina_mis_listas.dart` | Diálogo M3 con `TextField` (maxLength 60), botones Cancelar/Crear; valida nombre no vacío |
| `_dialogBorrarLista` | `pagina_mis_listas.dart` | Diálogo de confirmación con texto de la lista y botones Cancelar/Eliminar |
| `_dialogCompartir` | `pagina_mis_listas.dart` | Diálogo con `CheckboxListTile` de conocidos aceptados; máximo 5 selección; botón Enviar deshabilitado si no hay selección |
| `_dialogConfirmarCompartir` | `pagina_mis_listas.dart` | Diálogo de confirmación previa al compartir; muestra nombre de lista y destinatarios |
| `_ejecutarCompartir` | `pagina_mis_listas.dart` | Ejecuta `compartirLista` por cada destinatario; acumula exitosos/duplicados; muestra SnackBar diferenciado |
| `_dialogDejarDeCompartir` | `pagina_mis_listas.dart` | Diálogo para dejar de compartir; disponible en tabs Recibidas y Enviadas |

### Detalle de Lista

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `PageDetalleLista` | `pagina_detalle_listas.dart` | Muestra título "Lista: [nombre]"; carga propiedades con `FutureBuilder` |
| `Dismissible` | `pagina_detalle_listas.dart` | Swipe izquierdo para eliminar; `confirmDismiss` con diálogo "Quitar propiedad" |
| `_getPropiedadFallback` | `pagina_detalle_listas.dart` | Busca propiedad en todos los endpoints cuando `tipodeespacio` está vacío |
| Estados vacíos | `pagina_detalle_listas.dart` | Icono `folder_open` + "Esta lista está vacía." / "No se encontró la propiedad." |

### Detalle de Lista Compartida

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `PageDetalleListaCompartida` | `pagina_detalle_lista_compartida.dart` | Carga IDs de propiedades con `fetchPropiedadesListaCompartida`; renderiza `WrapModernCardPropiedades` |
| Estados vacíos | `pagina_detalle_lista_compartida.dart` | "Esta lista no tiene propiedades." / "No se encontró la propiedad." |

### Compartir con Conocido

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `PageCompartirConConocido` | `page_compartir_con_conocido.dart` | Lista `conocidosAceptadosProvider` con `CheckboxListTile`; máximo 5 selección |
| Botón Enviar | `page_compartir_con_conocido.dart` | Muestra `CircularProgressIndicator` mientras `_enviando == true`; deshabilitado si no hay selección |
| `_compartir` | `page_compartir_con_conocido.dart` | Registra en `propiedadesCompartidasConocidosProvider` + envía mensaje chat por cada seleccionado |

### Compartir con Grupo

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `PageCompartirConGrupo` | `page_compartir_con_grupo.dart` | Lista `gruposProvider` con `CheckboxListTile`; sin límite de selección |
| `_compartir` | `page_compartir_con_grupo.dart` | Crea publicación en `publicacionesGrupoProvider` + envía mensaje grupal por cada grupo seleccionado |

### Me Gusta y Favoritas

| Elemento | Archivo | Comportamiento |
|---|---|---|
| `meGustaProvider` | `provider_me_gusta.dart` | `AsyncNotifierProvider`; estado `AsyncValue<List<MeGustaModel>>` |
| `toggleMeGusta` | `provider_me_gusta.dart` | Agrega o quita like; primer like crea lista "Favoritas" y agrega propiedad |
| `_crearListaFavoritasSiNoExiste` | `provider_me_gusta.dart` | Crea lista "Favoritas" si no existe en `userListsProvider` |
| `_agregarPropiedadAFavoritas` | `provider_me_gusta.dart` | Agrega propiedad a Favoritas con anti-duplicado |
| Actualización optimista | `provider_me_gusta.dart` | Modifica `state` local sin re-fetch tras agregar/quitar like |

---

## 10. Decisiones de Diseño Documentadas

| ID | Decisión | Justificación |
|---|---|---|
| DD-01 | `TabController` creado en `initState` con `TickerProviderStateMixin` | Garantiza que los controladores estén listos antes del primer build que necesita pintar el `TabBar` |
| DD-02 | Carga de datos en `initState` via `Future.microtask` | Evita bloquear el primer frame; permite que la UI se renderice mientras se cargan listas |
| DD-03 | `ref.listen(sessionProvider)` en `build()` | Detecta cambios de sesión post-login para actualizar `_idUsuario` y recargar listas automáticamente |
| DD-04 | Diálogos con `barrierDismissible: false` | Fuerza al usuario a tomar una decisión explícita (Crear/Cancelar, Borrar/Confirmar) evitando cierres accidentales |
| DD-05 | Anti-duplicado en `compartirLista` via `_existeCompartida` | Previene registros huérfanos y consultas innecesarias a la base de datos |
| DD-06 | Límite de 5 conocidos por compartición de lista | Limita la carga del servidor y la complejidad del diálogo; coincide con el diseño original |
| DD-07 | SnackBar diferenciado por resultado | Proporciona feedback claro: éxito (primario), duplicado (secundario), error (error) |
| DD-08 | `dejarDeCompartir` elimina propiedades copiadas | Limpia registros huérfanos en `buscobien_listas_prop_compartidas` manteniendo la integridad referencial |
| DD-09 | `PageDetalleLista` usa `FutureBuilder` + `ref.watch` | Combina carga inicial (`_initialLoadFuture`) con reactividad posterior (cambios en `listaPropiedadesProvider`) |
| DD-10 | Fallback multi-endpoint en detalle de lista | Propiedades antiguas pueden tener `tipodeespacio` vacío; consulta todos los endpoints hasta encontrar la propiedad |
| DD-11 | "Favoritas" siempre en índice 0 | Mejora la UX posicionando la lista más usada en la parte superior sin intervención del usuario |
| DD-12 | `toggleMeGusta` con actualización optimista | Modifica el estado local inmediatamente sin re-fetch, mejorando la percepción de velocidad |
| DD-13 | Compartición con chat en el mismo flujo | Integra la compartición de propiedades/listas con el motor social (chat privado/grupal) en una sola operación atómica |
| DD-14 | `PageCompartirConGrupo` sin límite de selección | Los grupos no tienen la restricción de 5 que tienen los conocidos, diferenciando los casos de uso |
| DD-15 | `exitApp()` en Drawer mediante `ServicesBinding.instance.exitApplication` | Cierra la aplicación completamente en lugar de solo retroceder, cumpliendo la expectativa del usuario en la opción "Salir" |

---

*Generado por ingeniería inversa — BuscoBien SDD v1.0 — 2026-08-07*
