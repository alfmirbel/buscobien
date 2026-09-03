# SDD — Módulo Grupos (BuscoBien)
## Especificación de Requerimientos (EARS)
**Directorio fuente:** `lib/08_pantallas/tu_cuenta/grupos`  
**Arquitectura:** Flutter + Riverpod 3.x + Freezed + Dio (vía API Node.js → CouchDB)  
**Bases de datos:** `buscobien_grupos`, `buscobien_grupos_invitaciones`, `buscobien_grupos_publicaciones`, `buscobien_grupos_avisos`, `buscobien_grupos_mensajes`

---

## 1. Requerimientos Ubicuos

### 1.1 Navegación Principal
- **REQ-NAV-001:** El sistema deberá presentar una vista raíz con barra de navegación inferior que permita acceder a las secciones Mis Grupos, Invitaciones y Descubrir.
- **REQ-NAV-002:** El sistema deberá mantener el estado de la pestaña activa al cambiar entre las secciones del módulo Grupos.
- **REQ-NAV-003:** El sistema deberá mostrar un badge numérico en la pestaña Invitaciones cuando existan invitaciones pendientes recibidas.

### 1.2 Gestión de Estado
- **REQ-EST-001:** El sistema deberá cargar las invitaciones del usuario al montar la vista raíz del módulo.
- **REQ-EST-002:** El sistema deberá refrescar la lista de invitaciones cuando el usuario realice una acción de respuesta (aceptar/rechazar).
- **REQ-EST-003:** El sistema deberá refrescar la lista de grupos del usuario después de aceptar una invitación o unirse a un grupo.

### 1.3 Acceso a Datos
- **REQ-DAT-001:** El sistema deberá consultar la base de datos CouchDB mediante el endpoint `/_find` con selectores Mango para todas las operaciones de lectura.
- **REQ-DAT-002:** El sistema deberá autenticar todas las peticiones HTTP mediante encabezado `Authorization: Basic`.
- **REQ-DAT-003:** El sistema deberá incluir el campo `type` en el selector de todas las consultas para discriminar el tipo de documento.

---

## 2. Requerimientos Controlados por Eventos

### 2.1 Pantalla: Mis Grupos
- **REQ-MG-001:** Cuando el usuario abra la pantalla Mis Grupos, el sistema deberá cargar la lista de grupos donde el usuario es miembro mediante el selector `type: "grupo"` y `$elemMatch` en `miembros.usuarioId`.
- **REQ-MG-002:** Cuando el usuario presione el botón de crear grupo, el sistema deberá mostrar un diálogo con campos de nombre (obligatorio), descripción, objetivo, privacidad (pública/privada) y participación (abierta/por invitación).
- **REQ-MG-003:** Cuando el usuario presione Crear en el diálogo, el sistema deberá crear un documento en `buscobien_grupos` con el creador como primer miembro con rol `admin`.
- **REQ-MG-004:** Cuando el usuario presione el botón de retroceso o Cancelar en el diálogo, el sistema deberá cerrar el diálogo sin crear el grupo.
- **REQ-MG-005:** Cuando el usuario presione una tarjeta de grupo, el sistema deberá navegar a la pantalla de detalle del grupo.
- **REQ-MG-006:** Cuando el usuario realice pull-to-refresh en la lista, el sistema deberá recargar los grupos del usuario.

### 2.2 Pantalla: Invitaciones
- **REQ-INV-001:** Cuando el usuario abra la pantalla Invitaciones, el sistema deberá cargar todas las invitaciones donde el usuario es remitente o destinatario.
- **REQ-INV-002:** Cuando el usuario presione el botón de actualizar, el sistema deberá recargar las invitaciones desde el servidor.
- **REQ-INV-003:** Cuando el usuario presione Aceptar en una invitación recibida pendiente, el sistema deberá actualizar el estado a `accepted`, agregar al usuario como miembro del grupo y recargar Mis Grupos.
- **REQ-INV-004:** Cuando el usuario presione Rechazar en una invitación recibida pendiente, el sistema deberá actualizar el estado a `rejected`.
- **REQ-INV-005:** Cuando el usuario presione Aceptar o Rechazar, el sistema deberá mostrar un SnackBar con el resultado de la operación.
- **REQ-INV-006:** Cuando el usuario presione el botón Invitar miembro en el detalle del grupo, el sistema deberá mostrar un diálogo con lista de usuarios y promotores disponibles para invitar.
- **REQ-INV-007:** Cuando el usuario seleccione usuarios y presione Enviar, el sistema deberá crear una invitación por cada usuario seleccionado en `buscobien_grupos_invitaciones`.
- **REQ-INV-008:** Cuando el sistema detecte una invitación pendiente existente para el mismo remitente, destinatario y grupo, el sistema deberá impedir el envío duplicado.

### 2.3 Pantalla: Descubrir
- **REQ-DESC-001:** Cuando el usuario abra la pantalla Descubrir, el sistema deberá cargar todos los grupos públicos (`privacidad: "publica"`).
- **REQ-DESC-002:** Cuando el usuario presione el botón de actualizar, el sistema deberá invalidar el proveedor de grupos públicos y recargar.
- **REQ-DESC-003:** Cuando el usuario presione Unirse en un grupo con participación abierta, el sistema deberá agregar al usuario como miembro del grupo.
- **REQ-DESC-004:** Cuando el usuario presione Solicitar en un grupo con participación por invitación, el sistema deberá enviar una invitación al creador del grupo.
- **REQ-DESC-005:** Cuando el usuario presione Ver en cualquier grupo, el sistema deberá navegar a la pantalla de detalle del grupo.
- **REQ-DESC-006:** Cuando el usuario se una exitosamente a un grupo, el sistema debera recargar la lista pública para ocultar el grupo ya unido.

### 2.4 Pantalla: Detalle de Grupo
- **REQ-DET-001:** Cuando el usuario abra la pantalla de detalle, el sistema deberá mostrar el nombre del grupo y el conteo de miembros en el AppBar.
- **REQ-DET-002:** Cuando el usuario presione el ícono de invitación (solo administradores), el sistema deberá abrir el diálogo de invitación de miembros.
- **REQ-DET-003:** Cuando el usuario presione Info del grupo en el menú de opciones, el sistema deberá mostrar un diálogo con objetivo, descripción, privacidad, participación y creador.
- **REQ-DET-004:** Cuando el usuario presione Editar grupo en el menú (solo administradores), el sistema deberá permitir modificar los datos editables del grupo.

### 2.5 Tab: Publicaciones
- **REQ-PUB-001:** Cuando el usuario abra la pestaña Publicaciones, el sistema deberá cargar las publicaciones del grupo ordenadas por timestamp descendente.
- **REQ-PUB-002:** Cuando el usuario presione Cargar más y existan más publicaciones, el sistema deberá cargar la siguiente página de 10 publicaciones.
- **REQ-PUB-003:** Cuando el usuario presione el ícono de propiedad, el sistema deberá navegar a la pantalla de detalle de la propiedad compartida.
- **REQ-PUB-004:** Cuando el usuario presione el ícono de eliminar (solo autor), el sistema deberá eliminar la publicación del grupo.

### 2.6 Tab: Miembros
- **REQ-MEM-001:** Cuando el usuario abra la pestaña Miembros, el sistema deberá listar todos los miembros con su nombre, rol (admin/miembro) e indicador de "Tú" para el usuario actual.
- **REQ-MEM-002:** El sistema deberá mostrar un ícono de estrella para los administradores.
- **REQ-MEM-003:** El sistema deberá mostrar el avatar con la inicial del nombre del miembro.

### 2.7 Tab: Chat
- **REQ-CHAT-001:** Cuando el usuario abra la pestaña Chat, el sistema deberá cargar los últimos 300 mensajes del grupo ordenados por timestamp descendente.
- **REQ-CHAT-002:** Cuando el usuario escriba un mensaje y presione enviar, el sistema deberá crear el documento en `buscobien_grupos_mensajes` y actualizar la UI de forma optimista.
- **REQ-CHAT-003:** Cuando el usuario presione Enviar, el sistema deberá limpiar el campo de texto y ocultar el teclado.
- **REQ-CHAT-004:** El sistema deberá mantener una conexión `_changes` continua para recibir mensajes nuevos en tiempo real.
- **REQ-CHAT-005:** Cuando llegue un nuevo mensaje por `_changes`, el sistema deberá inyectarlo al frente de la lista sin recargar.
- **REQ-CHAT-006:** Cuando el usuario abra el chat, el sistema deberá marcar como leídos los mensajes no leídos enviados por otros usuarios.

### 2.8 Tab: Avisos
- **REQ-AV-001:** Cuando el usuario abra la pestaña Avisos, el sistema deberá cargar los avisos del grupo ordenados por timestamp descendente.
- **REQ-AV-002:** Cuando el usuario presione Publicar aviso, el sistema deberá mostrar un diálogo con campo de texto multilínea de máximo 250 caracteres.
- **REQ-AV-003:** Cuando el usuario presione Publicar en el diálogo, el sistema deberá crear el aviso en `buscobien_grupos_avisos` y agregarlo al inicio de la lista.
- **REQ-AV-004:** Cuando el usuario presione el ícono de eliminar (solo autor), el sistema deberá eliminar el aviso del grupo.
- **REQ-AV-005:** Cuando el sistema detecte un aviso vacío o mayor a 250 caracteres, el sistema deberá impedir la publicación.

---

## 3. Requerimientos Controlados por Estados

### 3.1 Estado: Cargando
- **REQ-CAR-001:** Mientras la lista de grupos se encuentre en estado de carga, el sistema deberá mostrar un indicador de progreso circular centrado.
- **REQ-CAR-002:** Mientras las invitaciones se encuentren en estado de carga, el sistema deberá mostrar un indicador de progreso circular centrado.
- **REQ-CAR-003:** Mientras los grupos públicos se encuentren en estado de carga, el sistema deberá mostrar un indicador de progreso circular centrado.
- **REQ-CAR-004:** Mientras las publicaciones se encuentren en estado de carga, el sistema deberá mostrar un indicador de progreso circular centrado.
- **REQ-CAR-005:** Mientras los avisos se encuentren en estado de carga, el sistema deberá mostrar un indicador de progreso circular centrado.
- **REQ-CAR-006:** Mientras los mensajes se encuentren en estado de carga, el sistema deberá mostrar un indicador de progreso circular centrado.

### 3.2 Estado: Error
- **REQ-ERR-001:** Mientras la lista de grupos se encuentre en estado de error, el sistema deberá mostrar un ícono de error, un mensaje descriptivo y un botón Reintentar.
- **REQ-ERR-002:** Mientras los grupos públicos se encuentren en estado de error, el sistema deberá mostrar un ícono de error, un mensaje descriptivo y un botón Reintentar.
- **REQ-ERR-003:** Mientras las invitaciones se encuentren en estado de error, el sistema deberá mostrar un mensaje de error.

### 3.3 Estado: Vacío
- **REQ-VAC-001:** Mientras la lista de grupos del usuario esté vacía, el sistema deberá mostrar un mensaje indicando que no pertenece a ningún grupo y sugerir crear o buscar grupos.
- **REQ-VAC-002:** Mientras la lista de invitaciones recibidas esté vacía, el sistema deberá mostrar un ícono de bandeja de entrada y un mensaje indicando que no hay invitaciones.
- **REQ-VAC-003:** Mientras la lista de invitaciones enviadas esté vacía, el sistema deberá mostrar un ícono de bandeja de salida y un mensaje indicando que no ha enviado invitaciones.
- **REQ-VAC-004:** Mientras no haya grupos públicos disponibles (o todos los grupos públicos tienen al usuario como miembro), el sistema deberá mostrar un ícono de búsqueda sin resultados y un mensaje correspondiente.
- **REQ-VAC-005:** Mientras no haya publicaciones en el grupo, el sistema deberá mostrar un mensaje indicando que aún no hay propiedades compartidas.
- **REQ-VAC-006:** Mientras no haya miembros registrados, el sistema deberá mostrar un mensaje indicando que no hay miembros.
- **REQ-VAC-007:** Mientras no haya avisos en el grupo, el sistema deberá mostrar un mensaje indicando que aún no hay avisos.
- **REQ-VAC-008:** Mientras no haya mensajes en el chat, el sistema deberá mostrar un mensaje indicando que envíe el primer mensaje.

### 3.4 Estado: Administrador
- **REQ-ADM-001:** Mientras el usuario sea administrador del grupo, el sistema deberá mostrar el chip "Admin" en la tarjeta del grupo en Mis Grupos.
- **REQ-ADM-002:** Mientras el usuario sea administrador del grupo, el sistema deberá mostrar el ícono de invitación de miembros en el AppBar del detalle.
- **REQ-ADM-003:** Mientras el usuario sea administrador del grupo, el sistema deberá mostrar la opción Editar grupo en el menú de opciones.

---

## 4. Requerimientos de Comportamiento No Deseado

### 4.1 Errores de Red y Servidor
- **REQ-FAL-001:** Si la base de datos de grupos no existe al crear un grupo, el sistema deberá crear la base de datos automáticamente y reintentar la creación.
- **REQ-FAL-002:** Si la respuesta del servidor no es 200/201 al cargar grupos, el sistema deberá mostrar estado vacío sin error crítico.
- **REQ-FAL-003:** Si ocurre una excepción de red al enviar un mensaje, el sistema deberá registrar el error sin eliminar el mensaje de la UI (optimistic update).
- **REQ-FAL-004:** Si el stream `_changes` se cierra inesperadamente, el sistema deberá liberar recursos (cancelar suscripción y cerrar cliente HTTP).
- **REQ-FAL-005:** Si ocurre una excepción al procesar una línea del stream `_changes`, el sistema deberá ignorar la línea y continuar procesando las siguientes.

### 4.2 Validaciones
- **REQ-VAL-001:** Si el usuario intenta crear un grupo sin nombre, el sistema deberá impedir el envío del formulario.
- **REQ-VAL-002:** Si el usuario intenta publicar un aviso vacío o mayor a 250 caracteres, el sistema deberá impedir la publicación.
- **REQ-VAL-003:** Si el usuario intenta enviar un mensaje vacío, el sistema deberá impedir el envío.

### 4.3 Duplicados
- **REQ-DUP-001:** Si ya existe una invitación pendiente para el mismo remitente, destinatario y grupo, el sistema deberá impedir el envío de una nueva invitación.
- **REQ-DUP-002:** Si el usuario ya compartió una propiedad en el grupo, el sistema deberá impedir compartirla nuevamente desde el proveedor de publicaciones.
- **REQ-DUP-003:** Si el usuario ya es miembro del grupo, el sistema deberá impedir volver a agregarlo.

### 4.4 Datos Ausentes
- **REQ-AUS-001:** Si el documento de grupo no contiene `_id` o `_rev`, el sistema deberá usar valores vacíos como fallback.
- **REQ-AUS-002:** Si el documento de invitación no contiene campos de texto, el sistema deberá usar cadenas vacías como fallback.
- **REQ-AUS-003:** Si la lista de miembros está ausente en el documento de grupo, el sistema deberá tratarla como lista vacía.

---

## 5. Requerimientos de Funciones Opcionales

### 5.1 Chat en Tiempo Real
- **REQ-OPT-001:** Donde el módulo de chat grupal esté incluido, el sistema deberá establecer una conexión continua `_changes` con CouchDB para recibir mensajes en tiempo real.
- **REQ-OPT-002:** Donde el módulo de chat grupal esté incluido, el sistema deberá mostrar la burbuja de mensaje con el nombre del remitente, el contenido y la marca de tiempo formateada.
- **REQ-OPT-003:** Donde el tipo de mensaje sea `propiedad`, el sistema deberá renderizar una burbuja especial para propiedades (actualmente placeholder).
- **REQ-OPT-004:** Donde el tipo de mensaje sea `lista`, el sistema deberá renderizar una burbuja especial para listas compartidas (actualmente placeholder).

### 5.2 Publicaciones de Propiedades
- **REQ-OPT-005:** Donde el módulo de publicaciones esté incluido, el sistema deberá permitir compartir propiedades del usuario en el grupo con paginación de 10 elementos por página.
- **REQ-OPT-006:** Donde el usuario comparta una propiedad, el sistema deberá mostrar el nombre de la propiedad, el tipo de espacio y el autor en la tarjeta de publicación.

---

## 6. Requerimientos Complejos

### 6.1 Navegación y Badge de Invitaciones
- **REQ-COM-001:** Mientras el usuario permanezca en la vista raíz del módulo Grupos, cuando el proveedor de invitaciones se actualice, el sistema deberá recalcular el número de invitaciones pendientes recibidas y actualizar el badge en la pestaña Invitaciones.

### 6.2 Flujo de Aceptación de Invitación
- **REQ-COM-002:** Mientras el usuario visualice una invitación recibida pendiente, cuando presione Aceptar, el sistema deberá actualizar el estado de la invitación a `accepted`, agregar al usuario como miembro del grupo con rol `miembro`, recargar la lista de Mis Grupos y mostrar un SnackBar de confirmación.

### 6.3 Flujo de Unión a Grupo Público
- **REQ-COM-003:** Mientras el usuario visualice un grupo público con participación abierta en Descubrir, cuando presione Unirse, el sistema deberá agregar al usuario como miembro, mostrar un SnackBar de éxito, invalidar el proveedor de grupos públicos para ocultar el grupo unido y refrescar Mis Grupos.

### 6.4 Flujo de Solicitud de Invitación a Grupo Privado
- **REQ-COM-004:** Mientras el usuario visualice un grupo público con participación por invitación en Descubrir, cuando presione Solicitar, el sistema deberá enviar una invitación al creador del grupo; si ya existe una solicitud pendiente, el sistema deberá mostrar un mensaje informativo sin crear duplicado.

### 6.5 Flujo de Publicación de Aviso
- **REQ-COM-005:** Mientras el usuario se encuentre en la pestaña Avisos del detalle de grupo, cuando presione Publicar aviso, ingrese texto válido y presione Publicar, el sistema deberá crear el aviso en la base de datos, agregarlo al inicio de la lista local y mostrar un SnackBar de confirmación.

### 6.6 Flujo de Envío de Mensaje en Chat
- **REQ-COM-006:** Mientras el usuario se encuentre en la pestaña Chat del detalle de grupo, cuando escriba un mensaje y presione enviar, el sistema deberá mostrar el mensaje en la UI de forma optimista, enviarlo a CouchDB y mantener la conexión `_changes` activa para sincronizar mensajes de otros usuarios en tiempo real.

### 6.7 Flujo de Invitación Masiva
- **REQ-COM-007:** Mientras el administrador se encuentre en el diálogo de invitación de miembros, cuando seleccione múltiples usuarios y presione Enviar, el sistema deberá procesar cada invitación secuencialmente, contar los envíos exitosos y mostrar un resumen en un SnackBar.

---

## 7. Modelos de Datos

### 7.1 Grupo (`buscobien_grupos`)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `_id` | String | UUID generado |
| `_rev` | String | Revisión CouchDB |
| `type` | String | Siempre `"grupo"` |
| `creadorId` | String | ID del usuario creador |
| `creadorNombre` | String | Nombre del creador |
| `nombre` | String | Nombre del grupo |
| `descripcion` | String | Descripción del grupo |
| `objetivo` | String | Objetivo del grupo |
| `privacidad` | String | `"publica"` o `"privada"` |
| `visibilidad` | String | `"todos"` o `"miembros"` |
| `participacion` | String | `"abierta"` o `"invitacion"` |
| `miembros` | Array | Lista de objetos `MiembroGrupoModel` |
| `timestamp` | String | ISO8601 |

### 7.2 Miembro de Grupo
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `usuarioId` | String | ID del usuario |
| `usuarioNombre` | String | Nombre del usuario |
| `rol` | String | `"admin"` o `"miembro"` |
| `fechaIngreso` | String | ISO8601 |

### 7.3 Invitación a Grupo (`buscobien_grupos_invitaciones`)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `_id` | String | UUID generado |
| `_rev` | String | Revisión CouchDB |
| `type` | String | Siempre `"invitacion_grupo"` |
| `senderId` | String | ID del remitente |
| `senderName` | String | Nombre del remitente |
| `receiverId` | String | ID del destinatario |
| `receiverName` | String | Nombre del destinatario |
| `grupoId` | String | ID del grupo |
| `grupoNombre` | String | Nombre del grupo |
| `status` | String | `"pending"`, `"accepted"` o `"rejected"` |
| `timestamp` | String | ISO8601 |
| `timestampRespuesta` | String | ISO8601 |

### 7.4 Publicación de Grupo (`buscobien_grupos_publicaciones`)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `_id` | String | UUID generado |
| `_rev` | String | Revisión CouchDB |
| `type` | String | Siempre `"publicacion_grupo"` |
| `grupoId` | String | ID del grupo |
| `propiedadId` | String | ID de la propiedad |
| `propiedadNombre` | String | Nombre de la propiedad |
| `tipodeespacio` | String | Tipo de espacio |
| `autorId` | String | ID del autor |
| `autorNombre` | String | Nombre del autor |
| `timestamp` | String | ISO8601 |

### 7.5 Aviso de Grupo (`buscobien_grupos_avisos`)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `_id` | String | UUID generado |
| `_rev` | String | Revisión CouchDB |
| `type` | String | Siempre `"aviso_grupo"` |
| `grupoId` | String | ID del grupo |
| `autorId` | String | ID del autor |
| `autorNombre` | String | Nombre del autor |
| `contenido` | String | Texto del aviso (máx 250) |
| `timestamp` | String | ISO8601 |

### 7.6 Mensaje de Grupo (`buscobien_grupos_mensajes`)
| Campo | Tipo | Descripción |
|-------|------|-------------|
| `_id` | String | UUID generado |
| `_rev` | String | Revisión CouchDB |
| `type` | String | Siempre `"mensaje_grupo"` |
| `grupoId` | String | ID del grupo |
| `senderId` | String | ID del remitente |
| `senderName` | String | Nombre del remitente |
| `content` | String | Contenido del mensaje |
| `timestamp` | String | ISO8601 |
| `leido` | Bool | Estado de lectura |
| `tipo` | String | `"texto"`, `"propiedad"` o `"lista"` |
| `propiedadId` | String | ID de propiedad (si tipo=propiedad) |
| `listaCompartidaId` | String | ID de lista (si tipo=lista) |

---

## 8. Índices CouchDB Requeridos

### 8.1 Grupos
```json
{"index": {"fields": ["type", "miembros.usuarioId"]}, "name": "idx-tipo-miembros"}
{"index": {"fields": ["type", "privacidad"]}, "name": "idx-tipo-privacidad"}
```

### 8.2 Invitaciones
```json
{"index": {"fields": ["type", "receiverId"]}, "name": "idx-inv-receiver"}
{"index": {"fields": ["type", "senderId"]}, "name": "idx-inv-sender"}
```

### 8.3 Publicaciones
```json
{"index": {"fields": ["type", "grupoId", "timestamp"]}, "name": "idx-pub-grupo"}
```

### 8.4 Avisos
```json
{"index": {"fields": ["type", "grupoId", "timestamp"]}, "name": "idx-aviso-grupo"}
```

### 8.5 Mensajes
```json
{"index": {"fields": ["type", "grupoId", "timestamp"]}, "name": "idx-msg-grupo"}
```

---

## 9. Proveedores Riverpod

| Proveedor | Tipo | Descripción |
|-----------|------|-------------|
| `gruposProvider` | AsyncNotifierProvider | Lista de grupos del usuario |
| `gruposPublicosProvider` | FutureProvider | Lista de grupos públicos |
| `gruposInvitacionesProvider` | StateNotifierProvider | Lista de invitaciones (sender o receiver) |
| `invitacionesGrupoRecibidasProvider` | Provider.family | Invitaciones pendientes recibidas |
| `invitacionesGrupoEnviadasProvider` | Provider.family | Todas las invitaciones enviadas |
| `usuariosParaInvitarProvider` | FutureProvider | Usuarios registrados para invitar |
| `promotoresParaInvitarProvider` | FutureProvider | Promotores para invitar |
| `publicacionesGrupoProvider` | AsyncNotifierProvider.family | Publicaciones de un grupo |
| `avisosGrupoProvider` | AsyncNotifierProvider.family | Avisos de un grupo |
| `mensajesGrupoProvider` | AsyncNotifierProvider.family | Mensajes de un grupo |

---

## 10. Reglas de Negocio

- **RN-001:** El creador de un grupo siempre es el primer miembro con rol `admin`.
- **RN-002:** Un usuario no puede ser invitado a un grupo del cual ya es miembro.
- **RN-003:** Un usuario no puede enviar múltiples invitaciones pendientes al mismo receptor para el mismo grupo.
- **RN-004:** Un usuario no puede compartir la misma propiedad más de una vez en el mismo grupo.
- **RN-005:** Los avisos tienen un límite máximo de 250 caracteres.
- **RN-006:** Solo el autor de una publicación o aviso puede eliminarlo.
- **RN-007:** Solo los administradores pueden invitar nuevos miembros y editar el grupo.
- **RN-008:** Los grupos públicos se ocultan automáticamente de Descubrir después de que el usuario se une.
- **RN-009:** Los mensajes se ordenan por timestamp descendente (más reciente primero).
- **RN-010:** Al aceptar una invitación, el usuario se agrega como miembro con rol `miembro` (no admin).
