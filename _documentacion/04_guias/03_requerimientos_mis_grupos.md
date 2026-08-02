# Funcionalidad para las opciones Mis grupos

Se requiere crear la funcionalidad Mis grupos, con código completo.

## Análisis de "Mis Grupos" — BuscoBien

## 1. Diagrama de Estado Actual (Prototipo)

┌─────────────────────────────────────────────────────────────────┐

│ ENTRADA (Mi Cuenta) │

└────────────────────────┬────────────────────────────────────────┘

│

┌─────────────▼──────────────┐

│ PaginaInicialGrupos │ ← usa listaDeGrupos (MOCK)

│ pagina\_inicial\_grupos.dart│ lib/03\_listas/lista\_de\_grupos.dart

│ │ genera 3 grupos falsos

│ [Verifica sesión activa] │

└──────┬──────────────────────┘

│ onTap / fullscreen / more\_vert

│

┌──────▼──────────────────────┐

│ PaginaOpcionesGrupo │ ← recibe objeto Grupos (legacy)

│ pagina\_grupo\_opciones.dart │

│ │

│ TabBar (length: 2 ← BUG) │ ← sólo 2 tabs funcionan,

│ [Publicaciones] │ pero se definen 5 contenidos

│ [Avisos] │

│ [Eventos] ← MOCK │ genera 9 cards ficticias

│ [Actividades] ← MOCK │ con imágenes de picsum.photos

│ [Anuncios] ← MOCK │

│ │

│ FAB → dialogBoxCreaGrupo() │

└──────────────────────────────┘

│

┌──────▼──────────────────────┐

│ PaginaCreaGrupoDialog │

│ pagina\_grupo\_crea\_dialog │

│ → PaginaCreaGrupo │ ← formulario en lib/09\_forms/

│ form\_crea\_grupos.dart │ (fuera del módulo)

└──────────────────────────────┘

── PARALELO (no integrado) ──────────────────────────────────────

┌──────────────────────────────┐

│ GruposView │ ← usa gruposProvider (Freezed)

│ grupos\_view.dart │ MOCK con AsyncNotifier

│ [Lista con NavigationBar] │

│ FAB → crear grupo (modal) │ ← no persiste en CouchDB

└──────────────────────────────┘

↑ No está conectado a la navegación principal

## 2. Inventario de Archivos

| **Archivo** | **Tipo** | **Función** | **Estado** |
| --- | --- | --- | --- |
| [data\_grupos.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/data_grupos.dart) | **Datos (legacy)** | Modelo manual JSON: Grupos + Fecha. Campos: idGrupo, idUsuario, nombre, objetivo, privacidad, visibilidad, participacion | Funcional pero obsoleto |
| [data\_grupo\_publicacion\_servicio.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/data_grupo_publicacion_servicio.dart) | **Datos (legacy)** | Modelo manual JSON para publicaciones de servicios dentro de un grupo | Sin uso real, datos vacíos |
| [models/grupo.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/models/grupo.dart) | **Datos (Freezed)** | Modelo moderno: Grupo + MiembroGrupo + RolGrupo. Campos: id, nombre, descripcion, creadorId, miembros, fechaCreacion | Bien diseñado, sin conectar |
| [models/grupo.freezed.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/models/grupo.freezed.dart) | **Generado** | Código auto-generado por Freezed (copyWith, ==, toString) | Auto-generado |
| [models/grupo.g.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/models/grupo.g.dart) | **Generado** | Código auto-generado por json\_serializable (fromJson/toJson) | Auto-generado |
| [providers/grupos\_notifier.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/providers/grupos_notifier.dart) | **Provider** | GruposNotifier (AsyncNotifier). Métodos: cargarGrupos, crearGrupo, agregarMiembro, listenToGroupChanges | Todo MOCK, sin CouchDB |
| [grupos\_view.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/grupos_view.dart) | **Pantalla** | Vista NavigationBar con lista de grupos + FAB crear. Usa gruposProvider | MOCK, no integrada al nav |
| [pagina\_inicial\_grupos.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/pagina_inicial_grupos.dart) | **Pantalla** | Pantalla principal real del flujo actual. Muestra tarjetas con imagen (picsum) de listaDeGrupos | MOCK hardcodeado |
| [pagina\_grupo\_opciones.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/pagina_grupo_opciones.dart) | **Pantalla (mixta)** | Detalle de un grupo con TabBar de 5 secciones + FAB crear. Define 5 secciones de contenido pero TabController(length: 2) | Bug de tabs, todo MOCK |
| [pagina\_grupo\_crea\_dialog.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/pagina_grupo_crea_dialog.dart) | **Widget** | AlertDialog que envuelve PaginaCreaGrupo con botón Salir | Funcional como UI, sin lógica |

## 3. Resumen de la Funcionalidad Actual

**Mis Grupos está en un estado de prototipo visual con las siguientes características:**

**Lo que existe:**

- Una pantalla principal que muestra 3 tarjetas de grupos ficticias (hardcodeadas en lista\_de\_grupos.dart) con imágenes aleatorias de picsum
- Una pantalla de detalle con 5 secciones de contenido (Publicaciones, Avisos, Eventos, Actividades, Anuncios) — todas con 9 cards ficticias generadas con List.generate
- Un diálogo para crear grupos que abre un formulario externo (form\_crea\_grupos.dart)
- Un modelo de datos moderno (models/grupo.dart) con Freezed bien estructurado
- Un notifier (grupos\_notifier.dart) con la estructura correcta de Riverpod pero con datos MOCK

**Problemas críticos identificados:**

### 1. Doble modelo incompatible: data\_grupos.dart (legacy) y models/grupo.dart (Freezed) coexisten sin relación
### 2. Bug de TabController: pagina\_grupo\_opciones.dart crea un TabController(length: 2) pero define 5 secciones de contenido — sólo las 2 primeras son accesibles
### 3. Doble vista sin integrar: pagina\_inicial\_grupos.dart (en producción) y grupos\_view.dart (nueva, no integrada) son paralelas y no están conectadas
### 4. Sin conexión a CouchDB: ningún archivo del módulo hace llamadas HTTP reales
### 5. Sin funcionalidad social: no existe invitación a grupos, membresía, chat grupal, búsqueda de grupos, ni gestión de miembros

## 4. Plan de Desarrollo — Mis Grupos Operativo

Estrategia: reutilizar los patrones probados de conocidos/ (modelos, providers HTTP, NavigationBar) y el modelo Freezed existente de grupos, desechando el código legacy.

### Fase 1 — Modelo de Datos y Bases CouchDB

#### Bases de datos a crear en CouchDB:

| **Base de datos** | **Propósito** |
| --- | --- |
| buscobien\_grupos | Documentos de grupos (metadata, miembros embebidos) |
| buscobien\_grupos\_invitaciones | Invitaciones enviadas/recibidas a grupos |
| buscobien\_grupos\_mensajes | Mensajes del chat grupal |

#### Archivos a crear/modificar:

**models/grupo.dart** — Ampliar el modelo Freezed existente (conservar y extender):

// Agregar campos faltantes al modelo Grupo existente:

// objetivo, privacidad (publica/privada), visibilidad, participacion

// type: "grupo" (para CouchDB)

**models/invitacion\_grupo\_model.dart** — Nuevo (espejo de invitacion\_model.dart):

\_id, senderId, senderName, receiverId, receiverName,

grupoId, grupoNombre, status (pending/accepted/rejected),

timestamp, type: "invitacion\_grupo"

**models/mensaje\_grupo\_model.dart** — Nuevo (espejo de mensaje\_model.dart):

\_id, senderId, senderName, grupoId, content,

timestamp, read, type: "mensaje\_grupo"

### Fase 2 — Providers HTTP (conexión CouchDB real)

**providers/grupos\_http\_provider.dart** — Reemplaza grupos\_notifier.dart (conservar estructura AsyncNotifier):

| **Método** | **Acción CouchDB** |
| --- | --- |
| cargarMisGrupos(userId) | POST /buscobien\_grupos/\_find → miembros contains userId |
| cargarGruposPublicos() | POST /buscobien\_grupos/\_find → privacidad == "publica" |
| crearGrupo(Grupo) | POST /buscobien\_grupos |
| actualizarGrupo(Grupo) | PUT /buscobien\_grupos/{id} |

**providers/grupos\_invitaciones\_provider.dart** — Nuevo (espejo de social\_providers.dart):

| **Método** | **Acción** |
| --- | --- |
| fetchInvitaciones(userId) | Invitaciones enviadas y recibidas |
| enviarInvitacion(grupoId, receiverId) | POST a buscobien\_grupos\_invitaciones |
| responderInvitacion(inv, status) | PUT actualizando status |
| agregarMiembro(grupoId, userId) | PUT al doc del grupo |

**providers/grupos\_mensajes\_provider.dart** — Nuevo (espejo de provider\_mensajes.dart):

| **Método** | **Acción** |
| --- | --- |
| fetchMensajes(grupoId) | Mensajes del grupo ordenados por timestamp |
| enviarMensaje(grupoId, content) | POST a buscobien\_grupos\_mensajes |

### Fase 3 — Pantallas (5 pantallas operativas)

Todas deben seguir los patrones visuales del proyecto: appTheme, sin hardcoding, Material Design 3, CustomScrollView.

**Pantalla 1: page\_mis\_grupos.dart** — Lista de grupos donde el usuario es miembro

- CustomScrollView con SliverList de tarjetas de grupos
- Cada tarjeta: nombre, objetivo, badge de miembros, botón "Entrar"
- FAB → crear grupo (reemplaza el dialog actual, pero con provider real)
- Reemplaza pagina\_inicial\_grupos.dart eliminando el uso de listaDeGrupos

**Pantalla 2: page\_descubrir\_grupos.dart** — Explorar grupos existentes

- Barra de búsqueda + lista de grupos públicos
- Botón "Unirse" (participación abierta) o "Solicitar" (por invitación)
- Paralelo a page\_descubrir\_usuarios.dart de conocidos

**Pantalla 3: page\_invitaciones\_grupo.dart** — Gestión de invitaciones

- DefaultTabController con 2 pestañas: Recibidas / Enviadas
- Recibidas: Aceptar / Rechazar con nombre del grupo y quien invita
- Enviadas: estado (Pendiente / Aceptada / Rechazada)
- Paralelo a page\_invitaciones.dart de conocidos

**Pantalla 4: page\_detalle\_grupo.dart** — Reemplaza pagina\_grupo\_opciones.dart

- AppBar con nombre y datos del grupo
- Corregir el bug: TabController(length: 5) con las 5 secciones conectadas a datos reales
- Tabs: Publicaciones · Miembros · Chat · Avisos · Eventos
- FAB contextual según tab activo (publicar / invitar / escribir)

**Pantalla 5: page\_chat\_grupo.dart** — Chat grupal dentro del detalle

- ListView.builder con mensajes del grupo
- Burbujas con nombre del remitente + timestamp
- TextField + botón enviar → enviarMensaje(grupoId, content)
- Paralelo a page\_chat\_privado.dart de conocidos

### Fase 4 — Vista Raíz y Navegación

**grupos\_view.dart** — Refactorizar (ya tiene la estructura correcta de NavigationBar):

NavigationBar (3 destinos):

[grupos] Mis Grupos → PageMisGrupos

[mail] Invitaciones → PageInvitacionesGrupo

[search] Descubrir → PageDescubrirGrupos

Conectar en principal\_sliver\_screen\_menus\_inicio.dart de la misma forma que ConocidosView pasa currentUserId y currentUserName.

#### Resumen de archivos del plan

| **Acción** | **Archivo** | **Basado en** |
| --- | --- | --- |
| **Extender** | models/grupo.dart | modelo existente Freezed |
| **Crear** | models/invitacion\_grupo\_model.dart | invitacion\_model.dart |
| **Crear** | models/mensaje\_grupo\_model.dart | mensaje\_model.dart |
| **Reemplazar** | providers/grupos\_notifier.dart | social\_providers.dart |
| **Crear** | providers/grupos\_invitaciones\_provider.dart | social\_providers.dart |
| **Crear** | providers/grupos\_mensajes\_provider.dart | provider\_mensajes.dart |
| **Refactorizar** | grupos\_view.dart | conocidos\_view.dart |
| **Crear** | page\_mis\_grupos.dart | pagina\_inicial\_grupos.dart + page\_mis\_contactos.dart |
| **Crear** | page\_descubrir\_grupos.dart | page\_descubrir\_usuarios.dart |
| **Crear** | page\_invitaciones\_grupo.dart | page\_invitaciones.dart |
| **Reemplazar** | page\_detalle\_grupo.dart | pagina\_grupo\_opciones.dart (corr. bug tabs) |
| **Crear** | page\_chat\_grupo.dart | page\_chat\_privado.dart |
| **Archivar** | data\_grupos.dart, data\_grupo\_publicacion\_servicio.dart, pagina\_inicial\_grupos.dart | — |

## Implementa las Fase 1 (modelo unificado) y la Fase 2 (providers HTTP)

**Fase 1 y 2 — Implementación completada**

**Fase 1 — Modelos de datos (3 archivos nuevos)**

| **Archivo** | **Rol** |
| --- | --- |
| [models/grupo\_model.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/models/grupo_model.dart) | Modelo canónico CouchDB. Unifica data\_grupos.dart (legacy) y models/grupo.dart (Freezed). Campos completos: \_id, \_rev, creadorId, nombre, descripcion, objetivo, privacidad, visibilidad, participacion, miembros[], timestamp. Incluye helpers esMiembro(), esAdmin(), totalMiembros. |
| [models/invitacion\_grupo\_model.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/models/invitacion_grupo_model.dart) | Espejo de invitacion\_model.dart de conocidos. Agrega grupoId, grupoNombre y timestampRespuesta. type: "invitacion\_grupo" en CouchDB. |
| [models/mensaje\_grupo\_model.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/models/mensaje_grupo_model.dart) | Espejo de mensaje\_model.dart de conocidos. Usa grupoId en lugar de receiverId. Agrega campo leido. type: "mensaje\_grupo" en CouchDB. |

**Fase 2 — Providers HTTP (3 archivos: 1 reemplazado, 2 nuevos)**

| **Archivo** | **Rol** |
| --- | --- |
| [providers/grupos\_notifier.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/providers/grupos_notifier.dart) | **Reemplaza el MOCK** con AsyncNotifier real. Métodos: cargarMisGrupos(userId), cargarGruposPublicos(), crearGrupo(...), agregarMiembro(...), actualizarGrupo(...). Usa buscobien\_grupos. |
| [providers/grupos\_invitaciones\_provider.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/providers/grupos_invitaciones_provider.dart) | StateNotifierProvider para invitaciones a grupos. Métodos: fetchInvitaciones, enviarInvitacion (con verificación de duplicados), responderInvitacion. Providers derivados: invitacionesGrupoRecibidasProvider, invitacionesGrupoEnviadasProvider. Usa buscobien\_grupos\_invitaciones. |
| [providers/grupos\_mensajes\_provider.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/providers/grupos_mensajes_provider.dart) | FutureProvider.family<List<MensajeGrupoModel>, String> por grupoId. Clase ChatGrupoController con enviarMensaje(...) y marcarMensajesLeidos(...). Usa buscobien\_grupos\_mensajes. |

**Bases de datos CouchDB requeridas**

Debes crear estos 3 índices en Fauxton antes de que las queries funcionen:

// buscobien\_grupos

{"index": {"fields": ["type", "miembros"]}, "name": "idx-grupo-miembros"}

{"index": {"fields": ["type", "privacidad"]}, "name": "idx-grupo-privacidad"}

// buscobien\_grupos\_invitaciones

{"index": {"fields": ["type", "senderId"]}, "name": "idx-inv-sender"}

{"index": {"fields": ["type", "receiverId"]}, "name": "idx-inv-receiver"}

// buscobien\_grupos\_mensajes

{"index": {"fields": ["type", "grupoId", "timestamp"]}, "name": "idx-msg-grupo"}

## Implementa la Fase 3 — Pantallas (5 pantallas operativas) y la Fase 4 — Vista Raíz y Navegación

**Fases 3 y 4 — Implementación completada**

**Archivos creados (5 pantallas)**

| **Archivo** | **Descripción** |
| --- | --- |
| [page\_mis\_grupos.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/page_mis_grupos.dart) | Lista real de grupos del usuario desde CouchDB. Carga en initState, RefreshIndicator para recargar, cards con nombre/descripción/rol/privacidad. FAB con diálogo de creación con SegmentedButton para privacidad y tipo de participación. |
| [page\_descubrir\_grupos.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/page_descubrir_grupos.dart) | Grupos públicos filtrados (excluye los que ya es miembro). Botón **Unirse** (participación abierta) → llama agregarMiembro directo. Botón **Solicitar** (por invitación) → envía invitación al creador. Botón **Ver** → abre el detalle sin ser miembro. |
| [page\_invitaciones\_grupo.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/page_invitaciones_grupo.dart) | Tabs **Recibidas / Enviadas**. Badge con contador de pendientes en la tab. Al **Aceptar**: responde invitación + agrega miembro + refresca mis grupos. \_StatusBadge con icono y color según estado. |
| [page\_detalle\_grupo.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/page_detalle_grupo.dart) | TabController(length: 4) — corrige el bug del prototipo. Tabs: **Publicaciones** (placeholder) · **Miembros** (lista real con rol y badge "Tú") · **Chat** (embebido) · **Avisos** (placeholder). AppBar con subtítulo de conteo de miembros. Acción invitar solo para admins. Menú con info del grupo. |
| [page\_chat\_grupo.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/page_chat_grupo.dart) | Chat grupal usando mensajesGrupoProvider. Burbujas con nombre del remitente en mensajes ajenos y hora formateada. ChatGrupoEmbebido — widget sin Scaffold para usar dentro del tab de detalle. Auto-scroll al último mensaje. Input multilinea. |

**Archivos actualizados (3)**

| **Archivo** | **Cambio** |
| --- | --- |
| [grupos\_view.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/grupos_view.dart) | Reescrito como **NavigationBar root** con 3 destinos: Mis Grupos · Invitaciones · Descubrir. Acepta currentUserId y currentUserName. Badge con contador de invitaciones pendientes en tiempo real. |
| [providers/grupos\_notifier.dart](https://claude.ai/epitaxy/lib/08_pantallas/tu_cuenta/grupos/providers/grupos_notifier.dart) | Agrega gruposPublicosProvider (FutureProvider) para la pantalla Descubrir. |
| [principal\_sliver\_screen\_menus\_inicio.dart](https://claude.ai/epitaxy/lib/02_principal_screen/principal_sliver_screen_menus_inicio.dart) | Actualiza las 2 llamadas a GruposView() (Promotor e Usuario) para pasar currentUserId y currentUserName desde el provider de sesión, igual que ConocidosView. |

**Flujo completo de usuario**

Mi Cuenta → GruposView (NavigationBar)

├─ [Mis Grupos] → PageMisGrupos → tap → PageDetalleGrupo

│ ├─ Tab Publicaciones

│ ├─ Tab Miembros (real)

│ ├─ Tab Chat (ChatGrupoEmbebido)

│ └─ Tab Avisos

├─ [Invitaciones] → PageInvitacionesGrupo

│ ├─ Tab Recibidas → Aceptar/Rechazar

│ └─ Tab Enviadas → Estado

└─ [Descubrir] → PageDescubrirGrupos

├─ Unirse (abierto)

├─ Solicitar (por invitación)

└─ Ver detalle