<a id="motor-social"></a># Motor Social

Para la funcionalidad del Motor Social, el diseño debe ser el siguiente:

Al seleccionar la opción “Mi cuenta” del Menú Principal, mostrado al seleccionar la opción “Propiedades” del Menú Inicial, se presenta una página, que puede variar dependiendo de varias condiciones\. La pantalla por mostrar, y las condiciones de que mostrar, están contenidas en el archivo D:\\02\_principal\_screen\_sliver\_screen\_menus\_inicio\.dart\.

- Si al seleccionar la opción no hay usuario activo en la aplicación, se muestra una pantalla en la que se invita al Usuario anónimo que está navegando a ingresar en la aplicación \(o en su caso registrarse como usuario\), por medio de un botón que abrirá la pantalla de logIn de la aplicación\.
- Si es la primera vez que se selecciona la opción, se muestra un AVISO IMPORTANTE, de que la aplicación está en un ambiente de prueba y con fines de demostración \(archivo D:\\10\_user\_login\_login\_03\_form\_register\_user\.dart\)\.
- La pantalla de logIn de la aplicación es invocada por medio de un DialogBox \(archivo D:\\10\_user\_login\_login\_login\.dart\)\.
- En caso de que el usuario seleccione Registrase, se invoca a la página contenida en el archivo D:\\10\_user\_login\_login\_03\_form\_register\_user\.dart\.
- Si ya hay un usuario que ha ingresado a la aplicación, con un nombre de usuario y una clave de acceso validas, dependiendo del perfil muestra información, tal como se establece en el Mapa de Arquitectura y Referencia Técnica, en el apartado Opción “Mi Cuenta”, para los perfiles de Usuario y Promotor\.
- En este documento de Arquitectura se establece que todos los perfiles contarán con las tres opciones del motor social: Mis Listas, Mis Grupos y Mis conocidos\.

<a id="Xaad765ef4356e26fa9de82eebcc54a548fbe1a1"></a>## Funcionalidad para las opciones Mis grupos y Mis conocidos

Se requiere crear la funcionalidad Mis conocidos, con código completo, para mostrar al usuario la lista de usuarios registrados \(seccionada por perfiles\), en la cual pueda seleccionar un usuario, ver su perfil, se debe contar con la funcionalidad para ver las publicaciones del usuario, poder enviarle una invitación para intercambiar mensajes; ver las invitaciones que ha enviado, ver el estado de cada invitación que muestren si están pendientes, recadas o aceptadas con la fecha de envío y de respuesta, en su caso ver la respuesta del usuario a la que fue dirigida; ver la invitaciones que ha recibido, poder ver el perfil del usuario que lo está invitando, contestar la invitación\. Crear también la funcionalidad para que se muestren las publicaciones de los usuarios que han aceptados invitación; y otra con los mensajes, que se intercambian con el usuario, en un chat\.

Otra funcionalidad es similar a la anterior, solo que para grupos\. El usuario puede crear un grupo, invitar a otros usuarios a pertenecer al grupo, ver el contenido de las publicaciones del grupo, y el mismo manejo de invitaciones enviadas y recibidas que se le da a los Conocidos\.

Debe contar con la funcionalidad de un espacio para ver los grupos que se han creado, el objetivo del grupo, quien lo creo y mostrar alguna de sus publicaciones\.

La aplicación debe funcionar el Android, IOs, Web y Windows\.

<a id="flujo-lógico-para-el-desarrollo"></a>### Flujo Lógico para el Desarrollo

Para que este recorrido funcione a la perfección en Flutter, el ciclo de vida de los datos será así:

<a id="X7c529babc3b1bd55078aeed35e0190d07e96a70"></a>#### 1\. Búsqueda: Consultas a buscobien\_usuarios \(filtrando al usuario actual\)\.

<a id="X22dbfaaf1e8a7f51bc78fe8bda4ced6ae8fcbb8"></a>#### 2\. Solicitud: Se crea un documento en buscobien\_social con estado “pending”\.

<a id="Xca568007cb7f274a6afda2a8914f6227a1427bd"></a>#### 3\. Pestañas: Se leen los documentos “pending” filtrando por senderId \(Enviadas\) o receiverId \(Recibidas\)\.

<a id="X5d70586f58e7d8ca707ad88cbc37f3c2cbc6652"></a>#### 4\. Respuesta: Se actualiza el documento social a “accepted” o “rejected”\.

<a id="X4594ae6cdc168d2bb91ba23caf402825a3658cd"></a>#### 5\. Contactos y Publicaciones: Al listar la red, se filtran solo los documentos “accepted”\. Al tocar un perfil, se consultan las publicaciones vinculadas a ese userId\.

<a id="Xae5ee36f6ebb0461d71671b764f16b93c1878ba"></a>#### 6\. Chat: Se guardan documentos tipo “chat\_message” con los IDs de ambos usuarios y se ordenan por timestamp\.

<a id="Xf7c77fbab8be897f13c54de6af33d023435b63c"></a>### Mapa de Recorrido del Usuario \(User Journey Map\)

Mapa de recorrido que muestra cómo un usuario busca conocidos en una red social, manda invitaciones, recibe solicitudes de amistad, contesta invitaciones, ve el estado de sus solicitudes, ve su lista de conocidos, hace chat con ellos, mira perfiles y publicaciones de usuarios\.

Aquí se muestra un __Mapa de Recorrido del Usuario \(User Journey Map\)__ diseñado específicamente para la funcionalidad social que estamos construyendo\.

Este mapa divide la experiencia en fases cronológicas, detallando qué hace el usuario, qué interfaz utiliza, qué piensa en ese momento y qué oportunidades tienes a nivel de código o diseño para mejorar su experiencia\.

<a id="Xe84030dbe2394413edab02f0c5e252949241dd7"></a>#### Mapa de Recorrido: Conexión e Interacción Social

__Fase__

__Acción del Usuario__

__Puntos de Contacto \(UI\)__

__Emociones / Pensamientos__

__Oportunidades de Mejora \(App\)__

__1\. Exploración y Búsqueda__

El usuario navega por la lista de usuarios sugeridos o usa un buscador para encontrar a un conocido\. Entra a ver su perfil público para confirmar que es la persona correcta\.

Pantalla Descubrir Usuarios, Barra de búsqueda, Perfil Público de Usuario\.

*“¿Estará mi amigo aquí? Ah, sí, esta es su foto de perfil, es él\.”*

Implementar filtros de búsqueda \(por nombre o tipo de usuario\) y mostrar un botón rápido de “Invitar” directamente desde la lista\.

__2\. Envío de Invitación__

Hace clic en “Invitar”\. Luego, va a revisar el estado de esta solicitud para confirmar que se envió correctamente\.

Botón Invitar, Pantalla Mis Invitaciones \(Pestaña “Enviadas”\)\.

*“Listo, invitación enviada\. Espero que me acepte pronto\.”*

Cambiar dinámicamente el botón de “Invitar” a “Pendiente” en la lista general para evitar envíos duplicados\.

__3\. Recepción y Respuesta__

El usuario recibe una notificación de que alguien quiere conectar\. Revisa quién es y decide si presionar “Aceptar” o “Rechazar”\.

Notificaciones push/In\-app, Pantalla Mis Invitaciones \(Pestaña “Recibidas”\)\.

*“Alguien me mandó solicitud\. Voy a revisar su perfil rápido antes de darle a aceptar\.”*

Mostrar un indicador visual \(un punto rojo o un contador\) en el ícono de invitaciones cuando hay solicitudes nuevas sin leer\.

__4\. Consumo de Red__

Revisa su lista de amigos confirmados\. Selecciona a uno para ver qué ha estado publicando o compartiendo en la red\.

Pantalla Mis Contactos, Perfil del Amigo, Pantalla de Publicaciones/Feed\.

*“Quiero ver qué propiedades o contenido ha subido mi amigo recientemente\.”*

Ordenar la lista de contactos alfabéticamente o por los que tienen publicaciones más recientes \(“Novedades”\)\.

__5\. Interacción Directa__

Desde la lista de contactos o desde el perfil del amigo, presiona el botón de mensaje\. Entra al chat y comienza a intercambiar textos\.

Botón Chat, Pantalla Chat 1 a 1, Input de texto, Teclado\.

*“Voy a preguntarle sobre la publicación que acaba de hacer\.”*

Agregar auto\-scroll automático al último mensaje enviado y mostrar la fecha/hora de los mensajes para dar contexto temporal\.

<a id="diseño-de-la-arquitectura-de-red-social"></a>### Diseño de la arquitectura de Red Social

Para implementar esta funcionalidad completa de “Red Social” \(Usuarios, Grupos, Invitaciones, Feed y Chat\) con Flutter, Riverpod y CouchDB, he diseñado una arquitectura basada en documentos NoSQL\.

Crearemos __tres secciones principales__:

<a id="Xde7a321b8318115123b9ed4d616ead3247e5ad6"></a>#### 1\. Modelos y Lógica \(Providers\): Gestionan las peticiones a CouchDB mediante Mango Queries \(\_find\) para manejar invitaciones, publicaciones y mensajes\.

<a id="Xf1791d451979285c83e53f79826fb96aa4f741a"></a>#### 2\. Pantallas de Red \(Usuarios e Invitaciones\): Donde exploras usuarios y gestionas las solicitudes de conexión\.

<a id="X46d4f8eab30bc848b0af3a9001751793039b540"></a>#### 3\. Pantallas Sociales \(Feed y Chat\): Donde consumes contenido y te comunicas uno a uno\.

Se definen las pantallas para su implementación, dividiendo el almacenamiento de mensajes, del de invitaciones y solicitudes\.

Separar el almacenamiento de las invitaciones \(relaciones/conexiones\) del almacenamiento de los mensajes \(chat\) es una __práctica fundamental de arquitectura de bases de datos__\. Esto mejora drásticamente el rendimiento, facilita la escalabilidad y permite consultas más rápidas \(especialmente cuando el volumen de mensajes crezca\)\.

A continuación, defino la arquitectura de datos y el desglose exacto de las __pantallas necesarias__ para implementar este flujo en Flutter \(Android, iOS, Web y Windows\)\.

<a id="arquitectura-de-datos-separada-couchdb"></a>#### Arquitectura de Datos Separada \(CouchDB\)

En lugar de tener una sola base de datos buscobien\_social, usaremos dos distintas \(o al menos, tipos de documentos estrictamente separados con índices diferentes\):

<a id="base-de-datos-buscobien_invitaciones"></a>##### 1\. Base de Datos: buscobien\_invitaciones

- Modelo: InvitacionModel
- Campos: \_id, senderId, receiverId, status \(pending, accepted, rejected\), timestamp\.
- Propósito: Solo guarda el estado de la relación entre dos usuarios\.

<a id="base-de-datos-buscobien_mensajes"></a>##### 2\. Base de Datos: buscobien\_mensajes

- Modelo: MensajeModel
- Campos: \_id, senderId, receiverId, content, timestamp, read \(booleano\)\.
- Propósito: Almacena exclusivamente el historial de chat\. Al estar separado, las consultas para saber “quiénes son mis amigos” no tienen que filtrar entre miles de mensajes de texto\.

<a id="definición-de-las-pantallas-ui-ux"></a>#### Definición de las Pantallas \(UI / UX\)

Aquí tienes la definición funcional de las pantallas que debemos codificar, cómo interactúan entre sí y qué datos consumen:

<a id="X7a8d30d0e833ef4c3232c4417ce720fa066c340"></a>##### 1\. Pantalla de Descubrimiento \(PageDescubrirUsuarios\)

- Propósito: Buscar conocidos y enviarles invitaciones\.
- UI:
- Una barra de búsqueda en la parte superior \(TextField\)\.
- Un CustomScrollView \(como hicimos antes\) que lista a los usuarios registrados \(Promotores y Regulares\)\.
- Cada fila \(ListTile\) muestra el Avatar, Nombre y un botón de “Invitar”\.
- Lógica Backend: Al presionar “Invitar”, hace un POST a buscobien\_invitaciones con status: “pending”\. El botón debe cambiar visualmente a “Pendiente” para evitar envíos duplicados\.

<a id="X82598f6c63d98350cb512ab50249091567542c3"></a>##### 2\. Pantalla de Gestión de Invitaciones \(PageInvitaciones\)

- Propósito: Ver, aceptar, rechazar o monitorear el estado de las solicitudes\.
- UI: Un DefaultTabController con dos pestañas \(TabBarView\):
- Pestaña 1 \(Recibidas\): Lista las invitaciones donde el usuario actual es el receiverId\. Muestra botones de Aceptar \(verde\) y Rechazar \(rojo\)\.
- Pestaña 2 \(Enviadas\): Lista las invitaciones donde el usuario actual es el senderId\. Muestra el estado actual \(Pendiente, Aceptada, Rechazada\)\.
- Lógica Backend: Consulta a buscobien\_invitaciones\. Al presionar Aceptar/Rechazar, hace un PUT actualizando el status del documento\.

<a id="X3e827b3d3c91e68df7428b569944d0f1eeac295"></a>##### 3\. Pantalla de Red / Mis Contactos \(PageMisContactos\)

- Propósito: Ver la lista de usuarios con los que ya se ha conectado exitosamente\.
- UI:
- Una lista limpia \(ListView\.builder\) con avatares y nombres\.
- Cada elemento tiene dos botones de acción rápida: “Ver Perfil” y “Chatear”\.
- Lógica Backend: Consulta a buscobien\_invitaciones buscando documentos donde status == “accepted” y el usuario actual sea el senderId o el receiverId\.

<a id="X670594211ecd2500091ac84f21d08b8e649fa19"></a>##### 4\. Pantalla de Perfil y Publicaciones \(PagePerfilContacto\)

- Propósito: Ver la información pública de un contacto y el contenido \(propiedades\) que ha publicado\.
- UI:
- Cabecera: Foto de perfil grande, nombre, tipo de usuario \(Promotor, etc\.\), e información de contacto \(correo/teléfono, si es público\)\.
- Cuerpo: Una cuadrícula \(GridView\) o lista \(ListView\) de las propiedades o publicaciones que ese usuario ha subido\.
- Lógica Backend:
- Requiere el idUsuario del contacto\.
- Hace una consulta a buscobien\_propiedades \(o donde guardes las publicaciones\) buscando documentos cuyo userId coincida con el contacto\.

<a id="pantalla-de-chat-privado-pagechatprivado"></a>##### 5\. Pantalla de Chat Privado \(PageChatPrivado\)

- Propósito: Intercambiar mensajes en tiempo real \(o casi real\) con un contacto\.
- UI:
- AppBar con el nombre y foto del contacto\.
- Lista de mensajes \(ListView\.builder invertido para que los nuevos salgan abajo\)\. Burbujas de chat verdes \(propias\) y grises \(del contacto\)\.
- Barra inferior con TextField y botón de enviar \(IconButton\)\.
- Lógica Backend:
- Consulta exclusiva a la base de datos buscobien\_mensajes\.
- Busca todos los mensajes donde \(sender == yo AND receiver == él\) OR \(sender == él AND receiver == yo\)\.
- Se ordena cronológicamente por el timestamp\.

__Siguiente Paso para el Desarrollo__

Ya tenemos la arquitectura y la separación de datos estructurada\.

Para empezar a generar el código de Flutter \(siguiendo los estándares, usando Riverpod y CouchDB\), se llevó a cabo en este orden para evitar archivos gigantes y asegurar que todo compile bien:

<a id="X11347ad515fbd36b6f4c31ef290ee4f9e918b52"></a>###### 1\. Fase 1: Generar los Modelos y Providers Separados \(Invitaciones y Mensajes\)\.

<a id="X4ea69393ea5d9af1c0b44f79db1589b72e92edb"></a>###### 2\. Fase 2: Generar las pantallas de Descubrir Usuarios e Invitaciones \(Pantallas 1 y 2\)\.

<a id="X6b31abb9405bc87926f8917b28d28f9a4c8deff"></a>###### 3\. Fase 3: Generar las pantallas de Contactos, Chat y Perfil \(Pantallas 3, 4 y 5\)\.

<a id="código-generado"></a>## Código generado

Código completo de las pantallas, con los estilos usados anteriormente, los modelos de datos colocados en archivos separados para mensajes, invitaciones o solicitudes, también separa los provider en archivos separados, y las pantallas en otros, uno para cada pantalla\.

Esta es una implementación completa y profesional\. He dividido el código en __9 archivos separados__ \(2 modelos, 2 providers y 5 pantallas\) para mantener una arquitectura limpia, escalable y fácil de mantener\.

<a id="parte-1-modelos-de-datos"></a>### PARTE 1: Modelos de Datos

Este archivo contiene la estructura de datos y los controladores \(Notifier\) para comunicarse con CouchDB\.

<a id="archivo-invitacion_model.dart"></a>#### 1\. Archivo: invitacion\_model\.dart

Modelo para manejar las solicitudes de amistad/conexión\.

D:\\08\_pantallas\_cuenta\_model\.dart

<a id="archivo-mensaje_model.dart"></a>#### 2\. Archivo: mensaje\_model\.dart

Modelo para los mensajes del chat privado\.

Ubicación del Archivo: D:\\08\_pantallas\_cuenta\_model\.dart

<a id="parte-2-providers-lógica-de-couchdb"></a>### PARTE 2: Providers \(Lógica de CouchDB\)

<a id="archivo-provider_invitaciones.dart"></a>#### 3\. Archivo: provider\_invitaciones\.dart

Maneja el envío, recepción y actualización de las invitaciones\. \(Usa la DB buscobien\_invitaciones\)\.

Ubicación del Archivo: D:\\08\_pantallas\_cuenta\_providers\.dart

<a id="archivo-provider_mensajes.dart"></a>#### 4\. Archivo: provider\_mensajes\.dart

Maneja el chat privado\. \(Usa la DB buscobien\_mensajes\)\.

Ubicación del Archivo: D:\\08\_pantallas\_cuenta\_mensajes\.dart

<a id="parte-3-pantallas-de-interfaz-de-usuario"></a>### PARTE 3: Pantallas de Interfaz de Usuario

<a id="archivo-page_descubrir_usuarios.dart"></a>#### 5\. Archivo: page\_descubrir\_usuarios\.dart

Lista para enviar invitaciones \(usa el CustomScrollView que ajustamos antes\)\.

Ubicación del Archivo: D:\\08\_pantallas\_cuenta\_descubrir\_usuarios\.dart

<a id="archivo-page_invitaciones.dart"></a>#### 6\. Archivo: page\_invitaciones\.dart

Muestra las pestañas de invitaciones enviadas y recibidas\.

Ubicación del Archivo: D:\\08\_pantallas\_cuenta\_invitaciones\.dart

<a id="archivo-page_mis_contactos.dart"></a>#### 7\. Archivo: page\_mis\_contactos\.dart

Lista de conocidos confirmados\.

Ubicación del Archivo: D:\\08\_pantallas\_cuenta\_mis\_contactos\.dart

<a id="archivo-page_perfil_contacto.dart"></a>#### 8\. Archivo: page\_perfil\_contacto\.dart

Muestra el perfil y las propiedades publicadas por el contacto\.

Ubicación del Archivo: D:\\08\_pantallas\_cuenta\_perfil\_contacto\.dart

<a id="archivo-page_chat_privado.dart"></a>#### 9\. Archivo: page\_chat\_privado\.dart

Ventana de chat 1 a 1\.

Ubicación del Archivo: D:\\08\_pantallas\_cuenta\_chat\_privado\.dart

