# Inventario de Componentes - Sección `tu_cuenta` (D:\buscobien\lib\08_pantallas\tu_cuenta)

Este documento contiene el inventario completo y detallado de los archivos, modelos, vistas y proveedores dentro del directorio de la cuenta del usuario en Buscobien. La estructura se organiza en los siguientes subdirectorios funcionales:
1. **`conocidos`**: Gestión del motor social de contactos (descubrimiento, perfiles, invitaciones y chats privados).
2. **`grupos`**: Gestión de grupos sociales (creación, visualización de miembros, publicaciones, avisos y chat de grupo).
3. **`tus_espacios`**: Dashboard de promotor/usuario para administrar las propiedades capturadas, editar fichas técnicas y controlar publicaciones.
4. **`tus_espacios/compra_espacios`**: Compra y control de espacios (slots de publicación) para destacar propiedades.

---

## Tabla de Inventario Completo

| Subdirectorio | Nombre del archivo | Tipo de componentes | Nombre del componente | Parámetros que requiere | Variables que utiliza (externas/globales/Riverpod) | Variables internas / Estado | Estilos que le aplican |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `conocidos` | `conocidos_view.dart` | `ConsumerStatefulWidget` / `State` | `ConocidosView`, `_ConocidosViewState` | Ninguno | `sessionProvider` | `_currentIndex` | `Theme.of(context).colorScheme`, `appTheme` |
| `conocidos` | `invitacion_model.dart` | Clase de Modelo | `InvitacionModel` | Constructor con parámetros nombrados del JSON | Ninguno | `id`, `solicitanteId`, `solicitanteNombre`, `receptorId`, `receptorNombre`, `estado` | N/A |
| `conocidos` | `mensaje_model.dart` | Clase de Modelo | `MensajeModel` | Constructor con parámetros nombrados del JSON | Ninguno | `id`, `senderId`, `receiverId`, `content`, `timestamp` | N/A |
| `conocidos` | `page_chat_privado.dart` | `ConsumerStatefulWidget` / `State` | `PageChatPrivado`, `_PageChatPrivadoState` | `currentUserId`, `targetUserId`, `targetName` | `mensajesChatProvider` | `_textController`, `_scrollController`, `_chatKey` | `appTheme.surface`, `appTheme.primary`, `appTheme.secondary` |
| `conocidos` | `page_descubrir_usuarios.dart` | `ConsumerWidget` | `PageDescubrirUsuarios` | `currentUserId`, `currentUserName` | `usersListProvider`, `usersPromotoresListProvider`, `conocidosProvider` | Ninguno | `Theme.of(context).colorScheme` |
| `conocidos` | `page_invitaciones.dart` | `ConsumerWidget` | `PageInvitaciones` | `currentUserId` | `invitacionesRecibidasProvider`, `invitacionesEnviadasProvider`, `conocidosProvider` | Ninguno | `Theme.of(context).colorScheme` |
| `conocidos` | `page_mis_contactos.dart` | `ConsumerStatefulWidget` / `State` | `PageMisContactos`, `_PageMisContactosState` | `currentUserId` | `conocidosAceptadosProvider`, `conocidosProvider` | Ninguno | `Theme.of(context).colorScheme` |
| `conocidos` | `page_perfil_contacto.dart` | `ConsumerWidget` | `PagePerfilContacto` | `contactoId`, `contactoName` | `usersListProvider`, `conocidosProvider` | Ninguno | `Theme.of(context).colorScheme` |
| `conocidos` | `provider_mensajes.dart` | Helper de Controlador / Providers | `ChatController`, `mensajesChatProvider` | String de clave chat única | `ProviderRef`, CouchDB HTTP | Funciones estáticas de envío, Stream interno de CouchDB | N/A |
| `conocidos` | `social_providers.dart` | State Notifiers / Providers | `InvitacionesNotifier`, `conocidosProvider`, `usersListProvider`, `usersPromotoresListProvider` | Ninguno | `sessionProvider`, CouchDB HTTP | Lista de invitaciones, lista de usuarios, lista de promotores | N/A |
| `conocidos/models` | `conocido.dart` | Clase de datos (Freezed) | `Conocido` | Parámetros nombrados generados | Ninguno | `id`, `solicitanteId`, `solicitanteNombre`, `receptorId`, `receptorNombre`, `estado` | N/A |
| `conocidos/providers` | `conocidos_notifier.dart` | AsyncNotifier | `ConocidosNotifier` | Ninguno | `conocidosAceptadosProvider`, `invitacionesRecibidasProvider`, `invitacionesEnviadasProvider` | Métodos para cargar de CouchDB, responder y enviar invitaciones | N/A |
| `grupos` | `grupos_view.dart` | `ConsumerStatefulWidget` / `State` | `GruposView`, `_GruposViewState` | Ninguno | `sessionProvider` | `_currentIndex` | `Theme.of(context).colorScheme`, `appTheme` |
| `grupos` | `page_mis_grupos.dart` | `ConsumerStatefulWidget` / `State` | `PageMisGrupos`, `_PageMisGruposState`, `_GrupoCard` | Ninguno | `sessionProvider`, `gruposAceptadosProvider`, `gruposProvider` | Ninguno | `Theme.of(context).colorScheme`, `appTheme` |
| `grupos` | `page_invitaciones_grupo.dart` | `ConsumerStatefulWidget` / `State` | `PageInvitacionesGrupo`, `_PageInvitacionesGrupoState`, `_ListaInvitaciones`, `_InvitacionCard`, `_StatusBadge` | Ninguno | `sessionProvider`, `invitacionesGrupoRecibidasProvider`, `invitacionesGrupoEnviadasProvider` | `_tabController` | `Theme.of(context).colorScheme` |
| `grupos` | `page_detalle_grupo.dart` | `ConsumerStatefulWidget` / `State` | `PageDetalleGrupo`, `_PageDetalleGrupoState`, `_TabPublicaciones`, `_TabMiembros`, `_TabAvisos`, `_InfoRow` | `grupo` (GrupoModel) | `sessionProvider`, `gruposProvider` | `_tabController` | `Theme.of(context).colorScheme`, `appTheme` |
| `grupos` | `page_descubrir_grupos.dart` | `ConsumerWidget` | `PageDescubrirGrupos`, `_GrupoDescubrirCard` | Ninguno | `todosLosGruposProvider`, `gruposProvider`, `sessionProvider` | Ninguno | `Theme.of(context).colorScheme` |
| `grupos` | `page_chat_grupo.dart` | `ConsumerStatefulWidget` / `State` | `PageChatGrupo`, `_PageChatGrupoState`, `_BurbujaMensaje`, `_BarraInput`, `ChatGrupoEmbebido`, `_ChatGrupoEmbebidoState` | `grupoId`, `grupoNombre` | `mensajesGrupoProvider`, `sessionProvider` | `_textController`, `_scrollController` | `Theme.of(context).colorScheme`, `appTheme` |
| `grupos/models` | `grupo_model.dart` | Clases de Modelos | `GrupoModel`, `MiembroGrupoModel` | Constructor con mapa JSON | Ninguno | `id`, `nombre`, `descripcion`, `creadorId`, `miembros` | N/A |
| `grupos/models` | `invitacion_grupo_model.dart` | Clase de Modelo | `InvitacionGrupoModel` | Constructor con mapa JSON | Ninguno | `id`, `grupoId`, `grupoNombre`, `solicitanteId`, `receptorId`, `estado` | N/A |
| `grupos/models` | `mensaje_grupo_model.dart` | Clase de Modelo | `MensajeGrupoModel` | Constructor con mapa JSON | Ninguno | `id`, `grupoId`, `senderId`, `senderName`, `content`, `timestamp` | N/A |
| `grupos/models` | `grupo.dart` | Clases de Datos (Freezed) | `Grupo`, `MiembroGrupo` | Parámetros nombrados generados | Ninguno | `id`, `nombre`, `descripcion`, `creadorId`, `miembros` | N/A |
| `grupos/providers` | `grupos_notifier.dart` | AsyncNotifier | `GruposNotifier` | Ninguno | `sessionProvider`, CouchDB HTTP | Carga y gestión de grupos, unirse, crear, invitar y salir de grupos | N/A |
| `grupos/providers` | `grupos_mensajes_provider.dart` | Controlador y Providers | `ChatGrupoController`, `mensajesGrupoProvider` | String de ID del grupo | CouchDB HTTP, `ProviderRef` | Envío de mensajes de grupo, streaming en tiempo real de CouchDB | N/A |
| `grupos/providers` | `grupos_invitaciones_provider.dart` | StateNotifier | `GruposInvitacionesNotifier`, `gruposInvitacionesProvider` | Ninguno | `sessionProvider`, CouchDB HTTP | Envío y respuesta a invitaciones de grupos | N/A |
| `tus_espacios` | `pagina_tus_espacios.dart` | `ConsumerStatefulWidget` / `State` | `PaginaTusEspacios`, `PaginaTipoEspaciosState` | Ninguno | `sessionProvider`, `compraDeEspaciosGetProvider` | `_futureRefresh`, listado de propiedades | `appTheme`, `Comfortaa`, `Outfit` |
| `tus_espacios` | `form_update_espacio_comprado.dart` | `ConsumerStatefulWidget` / `State` | `PaginaEditaEspacio`, `PaginaEditaEspacioState` | `propiedad` (ValueEspaciosCasaGet) | `sessionProvider`, CouchDB HTTP | Controladores de campos de formulario (texto, ubicación, contacto) | `appTheme` |
| `tus_espacios` | `form_crea_ficha_captura_propiedad.dart` | `ConsumerStatefulWidget` / `State` / `StatelessWidget` | `CreaFichaCapturaPropiedad`, `_CreaFichaCapturaPropiedadState`, `ConceptoEspacioRow`, `UbicacionEspacioRow` | `indexListaPropiedad`, `propiedad`, `update` | `sessionProvider`, `recuperaFotoPorIdFoto`, `recuperaIdsFotosDePropiedades` | `_futureIdsFotos` (Future de fotos), diálogos de confirmación | `appTheme` |
| `tus_espacios` | `provider_espacios_casa_get.dart` | Clases de Modelos, Providers | `ListaEspaciosCasa`, `ClassCompraEspaciosNotifierProvider`, `compraDeEspaciosGetProvider` | Ninguno | `sessionProvider`, CouchDB HTTP | Lista de espacios por casa, carga remota y filtrado | N/A |
| `tus_espacios` | `http_publica_propiedad.dart` | Funciones Auxiliares (HTTP) | Funciones de red CouchDB | Parámetros del documento CouchDB | CouchDB HTTP, `sessionProvider` | Métodos para publicar, despublicar o borrar lógicamente propiedades | N/A |
| `tus_espacios/compra_espacios` | `data_compra_espacios.dart` | Clases de Modelos | `CompraEspacio`, `FechaDe` | Constructor con mapa JSON | Ninguno | `id`, `idUsuario`, `medioDePago`, `noDeEspaciosNormales`, etc. | N/A |
| `tus_espacios/compra_espacios` | `data_compra_espacios_get.dart` | Clases de Modelos | `CompraEspacioGet`, `RowCompraEspacio`, `ValueCompraEspacio` | Constructor con mapa JSON | Ninguno | Estructura mapeada de CouchDB de espacios comprados | N/A |
| `tus_espacios/compra_espacios` | `form_compra_espacios.dart` | `ConsumerStatefulWidget` / `State` / `Widget` | `PaginaCompraEspacios`, `PaginaCompraEspaciosState`, `buildCampoCompraEspacioCasa` | Ninguno | `sessionProvider`, `compraDeEspaciosProvider` | `formKeyCompraEspacio`, `idUsuario`, `alto`, `ancho` | `appTheme`, `Comfortaa`, `Outfit` |
| `tus_espacios/compra_espacios` | `provider_compra_espacios.dart` | StateNotifier / Notifier | `ClassCompraEspaciosNotifierProvider`, `compraDeEspaciosProvider` | Ninguno | `sessionProvider`, CouchDB HTTP | Instancia temporal de `CompraEspacio`, campos editables y guardado a CouchDB | N/A |

---

## Análisis de Diseño y Estilos de la Sección

1. **Unificación de Temas (`appTheme` vs `ColorScheme`):**
   - El subdirectorio `tus_espacios` y `compra_espacios` utiliza predominantemente el objeto global `appTheme` importado de `var_color_themes.dart`, lo cual garantiza un control estricto del color de acuerdo a la paleta centralizada de Buscobien.
   - Los subdirectorios `conocidos` y `grupos` heredan el estilo de forma más dinámica utilizando `Theme.of(context).colorScheme` (`cs`), aplicando colores modernos como `cs.surfaceContainerLow` y `cs.surfaceContainerHighest`, consistentes con la transición hacia **Material Design 3**.

2. **Tipografías Premium:**
   - Se observa el uso estratégico de fuentes modernas de Google Fonts: **`Comfortaa`** para títulos llamativos y amigables, y **`Outfit`** para textos secundarios, campos de formulario y botones de interacción.
   - El resto de los textos utiliza pesos tipográficos controlados (`FontWeight.bold` para encabezados e identificadores y `FontWeight.normal` para valores), con tamaños adaptativos configurados globalmente (como `fontSizeTituloPagina` y `fontSizeTextoCarta`).

3. **Arquitectura de Gestión de Estado (Riverpod 2.0):**
   - **`AsyncNotifier`**: Implementado con éxito en `conocidos_notifier.dart` y `grupos_notifier.dart`. Permite cargar datos de CouchDB de forma asíncrona manejando automáticamente los estados de carga (`loading`), error (`error`) y éxito (`data`), maximizando la legibilidad y mantenimiento del código.
   - **`Family Providers`**: Utilizados de forma elegante en `mensajesChatProvider` y `mensajesGrupoProvider` para mantener canales de comunicación aislados por chat/grupo sin mezclar estados.
