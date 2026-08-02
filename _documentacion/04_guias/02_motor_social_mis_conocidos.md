## Funcionalidad para las opciones Mis conocidos

Se requiere crear la funcionalidad Mis conocidos, con código completo, para mostrar al usuario la lista de usuarios registrados (seccionada por perfiles), en la cual pueda seleccionar un usuario, ver su perfil, se debe contar con la funcionalidad para ver las publicaciones del usuario, poder enviarle una invitación para intercambiar mensajes; ver las invitaciones que ha enviado, ver el estado de cada invitación que muestren si están pendientes, recadas o aceptadas con la fecha de envío y de respuesta, en su caso ver la respuesta del usuario a la que fue dirigida; ver la invitaciones que ha recibido, poder ver el perfil del usuario que lo está invitando, contestar la invitación. Crear también la funcionalidad para que se muestren las publicaciones de los usuarios que han aceptados invitación; y otra con los mensajes, que se intercambian con el usuario, en un chat.

Otra funcionalidad es similar a la anterior, solo que para grupos. El usuario puede crear un grupo, invitar a otros usuarios a pertenecer al grupo, ver el contenido de las publicaciones del grupo, y el mismo manejo de invitaciones enviadas y recibidas que se le da a los Conocidos.

Debe contar con la funcionalidad de un espacio para ver los grupos que se han creado, el objetivo del grupo, quien lo creo y mostrar alguna de sus publicaciones.

La aplicación debe funcionar el Android, IOs, Web y Windows.

### Flujo Lógico para el Desarrollo

Para que este recorrido funcione a la perfección en Flutter, el ciclo de vida de los datos será así:

#### 1. Búsqueda: Consultas a buscobien\_usuarios (filtrando al usuario actual).
#### 2. Solicitud: Se crea un documento en buscobien\_social con estado "pending".
#### 3. Pestañas: Se leen los documentos "pending" filtrando por senderId (Enviadas) o receiverId (Recibidas).
#### 4. Respuesta: Se actualiza el documento social a "accepted" o "rejected".
#### 5. Contactos y Publicaciones: Al listar la red, se filtran solo los documentos "accepted". Al tocar un perfil, se consultan las publicaciones vinculadas a ese userId.
#### 6. Chat: Se guardan documentos tipo "chat\_message" con los IDs de ambos usuarios y se ordenan por timestamp.

### Mapa de Recorrido del Usuario (User Journey Map)

Mapa de recorrido que muestra cómo un usuario busca conocidos en una red social, manda invitaciones, recibe solicitudes de amistad, contesta invitaciones, ve el estado de sus solicitudes, ve su lista de conocidos, hace chat con ellos, mira perfiles y publicaciones de usuarios.

Aquí se muestra un **Mapa de Recorrido del Usuario (User Journey Map)** diseñado específicamente para la funcionalidad social que estamos construyendo.

Este mapa divide la experiencia en fases cronológicas, detallando qué hace el usuario, qué interfaz utiliza, qué piensa en ese momento y qué oportunidades tienes a nivel de código o diseño para mejorar su experiencia.

#### Mapa de Recorrido: Conexión e Interacción Social

|  |  |  |  |  |
| --- | --- | --- | --- | --- |
| **Fase** | **Acción del Usuario** | **Puntos de Contacto (UI)** | **Emociones / Pensamientos** | **Oportunidades de Mejora (App)** |
| **1. Exploración y Búsqueda** | El usuario navega por la lista de usuarios sugeridos o usa un buscador para encontrar a un conocido. Entra a ver su perfil público para confirmar que es la persona correcta. | Pantalla Descubrir Usuarios, Barra de búsqueda, Perfil Público de Usuario. | *"¿Estará mi amigo aquí? Ah, sí, esta es su foto de perfil, es él."* | Implementar filtros de búsqueda (por nombre o tipo de usuario) y mostrar un botón rápido de "Invitar" directamente desde la lista. |
| **2. Envío de Invitación** | Hace clic en "Invitar". Luego, va a revisar el estado de esta solicitud para confirmar que se envió correctamente. | Botón Invitar, Pantalla Mis Invitaciones (Pestaña "Enviadas"). | *"Listo, invitación enviada. Espero que me acepte pronto."* | Cambiar dinámicamente el botón de "Invitar" a "Pendiente" en la lista general para evitar envíos duplicados. |
| **3. Recepción y Respuesta** | El usuario recibe una notificación de que alguien quiere conectar. Revisa quién es y decide si presionar "Aceptar" o "Rechazar". | Notificaciones push/In-app, Pantalla Mis Invitaciones (Pestaña "Recibidas"). | *"Alguien me mandó solicitud. Voy a revisar su perfil rápido antes de darle a aceptar."* | Mostrar un indicador visual (un punto rojo o un contador) en el ícono de invitaciones cuando hay solicitudes nuevas sin leer. |
| **4. Consumo de Red** | Revisa su lista de amigos confirmados. Selecciona a uno para ver qué ha estado publicando o compartiendo en la red. | Pantalla Mis Contactos, Perfil del Amigo, Pantalla de Publicaciones/Feed. | *"Quiero ver qué propiedades o contenido ha subido mi amigo recientemente."* | Ordenar la lista de contactos alfabéticamente o por los que tienen publicaciones más recientes ("Novedades"). |
| **5. Interacción Directa** | Desde la lista de contactos o desde el perfil del amigo, presiona el botón de mensaje. Entra al chat y comienza a intercambiar textos. | Botón Chat, Pantalla Chat 1 a 1, Input de texto, Teclado. | *"Voy a preguntarle sobre la publicación que acaba de hacer."* | Agregar auto-scroll automático al último mensaje enviado y mostrar la fecha/hora de los mensajes para dar contexto temporal. |

### Diseño de la arquitectura de Red Social

Para implementar esta funcionalidad completa de "Red Social" (Usuarios, Grupos, Invitaciones, Feed y Chat) con Flutter, Riverpod y CouchDB, he diseñado una arquitectura basada en documentos NoSQL.

Crearemos **tres secciones principales**:

#### 1. Modelos y Lógica (Providers): Gestionan las peticiones a CouchDB mediante Mango Queries (\_find) para manejar invitaciones, publicaciones y mensajes.
#### 2. Pantallas de Red (Usuarios e Invitaciones): Donde exploras usuarios y gestionas las solicitudes de conexión.
#### 3. Pantallas Sociales (Feed y Chat): Donde consumes contenido y te comunicas uno a uno.

Se definen las pantallas para su implementación, dividiendo el almacenamiento de mensajes, del de invitaciones y solicitudes.

Separar el almacenamiento de las invitaciones (relaciones/conexiones) del almacenamiento de los mensajes (chat) es una **práctica fundamental de arquitectura de bases de datos**. Esto mejora drásticamente el rendimiento, facilita la escalabilidad y permite consultas más rápidas (especialmente cuando el volumen de mensajes crezca).

A continuación, defino la arquitectura de datos y el desglose exacto de las **pantallas necesarias** para implementar este flujo en Flutter (Android, iOS, Web y Windows).

#### Arquitectura de Datos Separada (CouchDB)

En lugar de tener una sola base de datos buscobien\_social, usaremos dos distintas (o al menos, tipos de documentos estrictamente separados con índices diferentes):

##### 1. Base de Datos: buscobien\_invitaciones

- Modelo: InvitacionModel
- Campos: \_id, senderId, receiverId, status (pending, accepted, rejected), timestamp.
- Propósito: Solo guarda el estado de la relación entre dos usuarios.

##### 2. Base de Datos: buscobien\_mensajes

- Modelo: MensajeModel
- Campos: \_id, senderId, receiverId, content, timestamp, read (booleano).
- Propósito: Almacena exclusivamente el historial de chat. Al estar separado, las consultas para saber "quiénes son mis amigos" no tienen que filtrar entre miles de mensajes de texto.

#### Definición de las Pantallas (UI / UX)

Aquí tienes la definición funcional de las pantallas que debemos codificar, cómo interactúan entre sí y qué datos consumen:

##### 1. Pantalla de Descubrimiento (PageDescubrirUsuarios)

- Propósito: Buscar conocidos y enviarles invitaciones.
- UI:
- Una barra de búsqueda en la parte superior (TextField).
- Un CustomScrollView (como hicimos antes) que lista a los usuarios registrados (Promotores y Regulares).
- Cada fila (ListTile) muestra el Avatar, Nombre y un botón de "Invitar".
- Lógica Backend: Al presionar "Invitar", hace un POST a buscobien\_invitaciones con status: "pending". El botón debe cambiar visualmente a "Pendiente" para evitar envíos duplicados.

##### 2. Pantalla de Gestión de Invitaciones (PageInvitaciones)

- Propósito: Ver, aceptar, rechazar o monitorear el estado de las solicitudes.
- UI: Un DefaultTabController con dos pestañas (TabBarView):
- Pestaña 1 (Recibidas): Lista las invitaciones donde el usuario actual es el receiverId. Muestra botones de Aceptar (verde) y Rechazar (rojo).
- Pestaña 2 (Enviadas): Lista las invitaciones donde el usuario actual es el senderId. Muestra el estado actual (Pendiente, Aceptada, Rechazada).
- Lógica Backend: Consulta a buscobien\_invitaciones. Al presionar Aceptar/Rechazar, hace un PUT actualizando el status del documento.

##### 3. Pantalla de Red / Mis Contactos (PageMisContactos)

- Propósito: Ver la lista de usuarios con los que ya se ha conectado exitosamente.
- UI:
- Una lista limpia (ListView.builder) con avatares y nombres.
- Cada elemento tiene dos botones de acción rápida: "Ver Perfil" y "Chatear".
- Lógica Backend: Consulta a buscobien\_invitaciones buscando documentos donde status == "accepted" y el usuario actual sea el senderId o el receiverId.

##### 4. Pantalla de Perfil y Publicaciones (PagePerfilContacto)

- Propósito: Ver la información pública de un contacto y el contenido (propiedades) que ha publicado.
- UI:
- Cabecera: Foto de perfil grande, nombre, tipo de usuario (Promotor, etc.), e información de contacto (correo/teléfono, si es público).
- Cuerpo: Una cuadrícula (GridView) o lista (ListView) de las propiedades o publicaciones que ese usuario ha subido.
- Lógica Backend:
- Requiere el idUsuario del contacto.
- Hace una consulta a buscobien\_propiedades (o donde guardes las publicaciones) buscando documentos cuyo userId coincida con el contacto.

##### 5. Pantalla de Chat Privado (PageChatPrivado)

- Propósito: Intercambiar mensajes en tiempo real (o casi real) con un contacto.
- UI:
- AppBar con el nombre y foto del contacto.
- Lista de mensajes (ListView.builder invertido para que los nuevos salgan abajo). Burbujas de chat verdes (propias) y grises (del contacto).
- Barra inferior con TextField y botón de enviar (IconButton).
- Lógica Backend:
- Consulta exclusiva a la base de datos buscobien\_mensajes.
- Busca todos los mensajes donde (sender == yo AND receiver == él) OR (sender == él AND receiver == yo).
- Se ordena cronológicamente por el timestamp.

#### Siguiente Paso para el Desarrollo

Ya tenemos la arquitectura y la separación de datos estructurada.

Para empezar a generar el código de Flutter (siguiendo los estándares, usando Riverpod y CouchDB), se llevó a cabo en este orden para evitar archivos gigantes y asegurar que todo compile bien:

##### 1. Fase 1: Generar los Modelos y Providers Separados (Invitaciones y Mensajes).
##### 2. Fase 2: Generar las pantallas de Descubrir Usuarios e Invitaciones (Pantallas 1 y 2).
##### 3. Fase 3: Generar las pantallas de Contactos, Chat y Perfil (Pantallas 3, 4 y 5).

## Código generado

Código completo de las pantallas, con los estilos usados anteriormente, los modelos de datos colocados en archivos separados para mensajes, invitaciones o solicitudes, también separa los provider en archivos separados, y las pantallas en otros, uno para cada pantalla.

Esta es una implementación completa y profesional. He dividido el código en **9 archivos separados** (2 modelos, 2 providers y 5 pantallas) para mantener una arquitectura limpia, escalable y fácil de mantener.

### PARTE 1: Modelos de Datos

Este archivo contiene la estructura de datos y los controladores (Notifier) para comunicarse con CouchDB.

#### 1. Archivo: invitacion\_model.dart

Modelo para manejar las solicitudes de amistad/conexión.

\08\_pantallas\tu\_cuenta\conocidos\invitacion\_model.dart

#### 2. Archivo: mensaje\_model.dart

Modelo para los mensajes del chat privado.

Ubicación del Archivo: \08\_pantallas\tu\_cuenta\conocidos\mensaje\_model.dart

### PARTE 2: Providers (Lógica de CouchDB)

#### 3. Archivo: provider\_invitaciones.dart

Maneja el envío, recepción y actualización de las invitaciones. (Usa la DB buscobien\_invitaciones).

Ubicación del Archivo: \08\_pantallas\tu\_cuenta\conocidos\social\_providers.dart

#### 4. Archivo: provider\_mensajes.dart

Maneja el chat privado. (Usa la DB buscobien\_mensajes).

Ubicación del Archivo: \08\_pantallas\tu\_cuenta\conocidos\provider\_mensajes.dart

### PARTE 3: Pantallas de Interfaz de Usuario

#### 5. Archivo: page\_descubrir\_usuarios.dart

Lista para enviar invitaciones (usa el CustomScrollView que ajustamos antes).

Ubicación del Archivo: \08\_pantallas\tu\_cuenta\conocidos\page\_descubrir\_usuarios.dart

#### 6. Archivo: page\_invitaciones.dart

Muestra las pestañas de invitaciones enviadas y recibidas.

Ubicación del Archivo: \08\_pantallas\tu\_cuenta\conocidos\page\_invitaciones.dart

#### 7. Archivo: page\_mis\_contactos.dart

Lista de conocidos confirmados.

Ubicación del Archivo: \08\_pantallas\tu\_cuenta\conocidos\page\_mis\_contactos.dart

#### 8. Archivo: page\_perfil\_contacto.dart

Muestra el perfil y las propiedades publicadas por el contacto.

Ubicación del Archivo: \08\_pantallas\tu\_cuenta\conocidos\page\_perfil\_contacto.dart

#### 9. Archivo: page\_chat\_privado.dart

Ventana de chat 1 a 1.

Ubicación del Archivo: \08\_pantallas\tu\_cuenta\conocidos\page\_chat\_privado.dart
