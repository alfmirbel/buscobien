# Funcionalidad para la opción Mis Grupos

Genera la funcionalidad de la opción Mis Grupos, con codigo completo, para mostrar al usuario la lista de usuarios registrados, que pueda seleccionar un usuario, que pueda enviarle una invitación para intercambiar mensajes.

Crea también una pantalla para ver las invitaciones, que tenga dos pestañas, una para las invitaciones enviadas y otra para las invitaciones recibidas, que ,uestren si estan pendientes, rechazadas o aceptadas.

Crea también una ventana para que se muestren las publicaciones de los usuarios que han aceptados invitación; y otra con los mensajes que se intercambian con el usuatios.

La aplicación debe funcionar el Android, IOs, Web y Windows.

Para implementar esta funcionalidad completa de "Red Social" (Usuarios, Invitaciones, Feed y Chat) con Flutter, Riverpod y CouchDB, he diseñado una arquitectura basada en documentos NoSQL.

Crearemos **tres secciones principales**:

## 1. Modelos y Lógica (Providers): Gestionan las peticiones a CouchDB mediante Mango Queries (\_find) para manejar invitaciones, publicaciones y mensajes.

## 2. Pantallas de Red (Usuarios e Invitaciones): Donde exploras usuarios y gestionas las solicitudes de conexión.

## 3. Pantallas Sociales (Feed y Chat): Donde consumes contenido y te comunicas uno a uno.

A continuación, tienes el código completo.

**Parte 1: Modelos y Providers (social_providers.dart)**

Este archivo contiene la estructura de datos y los controladores (Notifier) para comunicarse con CouchDB.

**Parte 2: Pantallas de Red (Usuarios e Invitaciones)**

Aquí implementamos la lista de usuarios para invitar y el gestor de solicitudes (Pestañas).

**Parte 3: Pantallas Sociales (Chat y Red)**

Implementación del chat 1 a 1 en tiempo real (mediante refresh manual/automático) y la visualización de contactos.

Para mostrar ambas listas (asyncUsers y asyncUsersPromotores) en la misma página de manera fluida y profesional, la mejor práctica en Flutter es utilizar un **CustomScrollView** con **SliverList**. Esto permite que ambas listas se desplacen juntas en la misma pantalla sin anidar ListViews (lo cual causaría errores de layout o mal rendimiento).

Para manejar los estados asíncronos (Loading, Error, Data) de ambos _providers_ al mismo tiempo, podemos anidar sus métodos .when().

Aquí tienes el código completo y optimizado de la pantalla PageUsuariosRegistrados con estas mejoras aplicadas.

**Resumen de Cambios:**

## 1. Manejo de Doble Provider: Se anida asyncUsers.when dentro de asyncUsersPromotores.when para asegurar que la pantalla solo se dibuje cuando ambas listas hayan terminado de cargar.

## 2. CustomScrollView y Slivers: Se reemplazó el ListView.builder simple por un CustomScrollView. Se agregaron encabezados (SliverToBoxAdapter) para separar visualmente la sección de "Usuarios Regulares" y "Promotores", seguidos de sus respectivos SliverList.

## 3. Reutilización de UI: Se creó un método privado \_buildSliverUserList para no repetir el código que dibuja cada fila de usuario (avatar, nombre, botón de invitar).

Aquí tienes un **Mapa de Recorrido del Usuario (User Journey Map)** diseñado específicamente para la funcionalidad social que estamos construyendo.

Este mapa divide la experiencia en fases cronológicas, detallando qué hace el usuario, qué interfaz utiliza, qué piensa en ese momento y qué oportunidades tienes a nivel de código o diseño para mejorar su experiencia.

**Mapa de Recorrido: Conexión e Interacción Social**

| **Fase**                      | **Acción del Usuario**                                                                                                                                                        | **Puntos de Contacto (UI)**                                                  | **Emociones / Pensamientos**                                                             | **Oportunidades de Mejora (App)**                                                                                                  |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| **1. Exploración y Búsqueda** | El usuario navega por la lista de usuarios sugeridos o usa un buscador para encontrar a un conocido. Entra a ver su perfil público para confirmar que es la persona correcta. | Pantalla Descubrir Usuarios, Barra de búsqueda, Perfil Público de Usuario.   | _"¿Estará mi amigo aquí? Ah, sí, esta es su foto de perfil, es él."_                     | Implementar filtros de búsqueda (por nombre o tipo de usuario) y mostrar un botón rápido de "Invitar" directamente desde la lista. |
| **2. Envío de Invitación**    | Hace clic en "Invitar". Luego, va a revisar el estado de esta solicitud para confirmar que se envió correctamente.                                                            | Botón Invitar, Pantalla Mis Invitaciones (Pestaña "Enviadas").               | _"Listo, invitación enviada. Espero que me acepte pronto."_                              | Cambiar dinámicamente el botón de "Invitar" a "Pendiente" en la lista general para evitar envíos duplicados.                       |
| **3. Recepción y Respuesta**  | El usuario recibe una notificación de que alguien quiere conectar. Revisa quién es y decide si presionar "Aceptar" o "Rechazar".                                              | Notificaciones push/In-app, Pantalla Mis Invitaciones (Pestaña "Recibidas"). | _"Alguien me mandó solicitud. Voy a revisar su perfil rápido antes de darle a aceptar."_ | Mostrar un indicador visual (un punto rojo o un contador) en el ícono de invitaciones cuando hay solicitudes nuevas sin leer.      |
| **4. Consumo de Red**         | Revisa su lista de amigos confirmados. Selecciona a uno para ver qué ha estado publicando o compartiendo en la red.                                                           | Pantalla Mis Contactos, Perfil del Amigo, Pantalla de Publicaciones/Feed.    | _"Quiero ver qué propiedades o contenido ha subido mi amigo recientemente."_             | Ordenar la lista de contactos alfabéticamente o por los que tienen publicaciones más recientes ("Novedades").                      |
| **5. Interacción Directa**    | Desde la lista de contactos o desde el perfil del amigo, presiona el botón de mensaje. Entra al chat y comienza a intercambiar textos.                                        | Botón Chat, Pantalla Chat 1 a 1, Input de texto, Teclado.                    | _"Voy a preguntarle sobre la publicación que acaba de hacer."_                           | Agregar auto-scroll automático al último mensaje enviado y mostrar la fecha/hora de los mensajes para dar contexto temporal.       |

**Resumen del Flujo Lógico para el Desarrollo**

Para que este recorrido funcione a la perfección en Flutter, el ciclo de vida de los datos será así:

## 1. Búsqueda: Consultas a buscobien_usuarios (filtrando al usuario actual).

## 2. Solicitud: Se crea un documento en buscobien_social con estado "pending".

## 3. Pestañas: Se leen los documentos "pending" filtrando por senderId (Enviadas) o receiverId (Recibidas).

## 4. Respuesta: Se actualiza el documento social a "accepted" o "rejected".

## 5. Contactos y Publicaciones: Al listar la red, se filtran solo los documentos "accepted". Al tocar un perfil, se consultan las publicaciones vinculadas a ese userId.

## 6. Chat: Se guardan documentos tipo "chat_message" con los IDs de ambos usuarios y se ordenan por timestamp.

Define las pantallas para su implementacion, dividiendo el almacenamiento de mensajes del de initaciones y solicitudes.

Separar el almacenamiento de las invitaciones (relaciones/conexiones) del almacenamiento de los mensajes (chat) es una **práctica fundamental de arquitectura de bases de datos**. Esto mejora drásticamente el rendimiento, facilita la escalabilidad y permite consultas más rápidas (especialmente cuando el volumen de mensajes crezca).

A continuación, defino la arquitectura de datos y el desglose exacto de las **5 pantallas necesarias** para implementar este flujo en Flutter (Android, iOS, Web y Windows).

**Arquitectura de Datos Separada (CouchDB)**

En lugar de tener una sola base de datos buscobien_social, usaremos dos distintas (o al menos, tipos de documentos estrictamente separados con índices diferentes):

## 1. Base de Datos: buscobien_invitaciones

- Modelo: InvitacionModel
- Campos: \_id, senderId, receiverId, status (pending, accepted, rejected), timestamp.
- Propósito: Solo guarda el estado de la relación entre dos usuarios.

## 2. Base de Datos: buscobien_mensajes

- Modelo: MensajeModel
- Campos: \_id, senderId, receiverId, content, timestamp, read (booleano).
- Propósito: Almacena exclusivamente el historial de chat. Al estar separado, las consultas para saber "quiénes son mis amigos" no tienen que filtrar entre miles de mensajes de texto.

**Definición de las Pantallas (UI / UX)**

Aquí tienes la definición funcional de las pantallas que debemos codificar, cómo interactúan entre sí y qué datos consumen:

**1. Pantalla de Descubrimiento (PageDescubrirUsuarios)**

- Propósito: Buscar grupos y enviarles invitaciones.
- UI:
- Una barra de búsqueda en la parte superior (TextField).
- Un CustomScrollView (como hicimos antes) que lista a los usuarios registrados (Promotores y Regulares).
- Cada fila (ListTile) muestra el Avatar, Nombre y un botón de "Invitar".
- Lógica Backend: Al presionar "Invitar", hace un POST a buscobien_invitaciones con status: "pending". El botón debe cambiar visualmente a "Pendiente" para evitar envíos duplicados.

**2. Pantalla de Gestión de Invitaciones (PageInvitaciones)**

- Propósito: Ver, aceptar, rechazar o monitorear el estado de las solicitudes.
- UI: Un DefaultTabController con dos pestañas (TabBarView):
- Pestaña 1 (Recibidas): Lista las invitaciones donde el usuario actual es el receiverId. Muestra botones de Aceptar (verde) y Rechazar (rojo).
- Pestaña 2 (Enviadas): Lista las invitaciones donde el usuario actual es el senderId. Muestra el estado actual (Pendiente, Aceptada, Rechazada).
- Lógica Backend: Consulta a buscobien_invitaciones. Al presionar Aceptar/Rechazar, hace un PUT actualizando el status del documento.

**3. Pantalla de Red / Mis Contactos (PageMisContactos)**

- Propósito: Ver la lista de usuarios con los que ya se ha conectado exitosamente.
- UI:
- Una lista limpia (ListView.builder) con avatares y nombres.
- Cada elemento tiene dos botones de acción rápida: "Ver Perfil" y "Chatear".
- Lógica Backend: Consulta a buscobien_invitaciones buscando documentos donde status == "accepted" y el usuario actual sea el senderId o el receiverId.

**4. Pantalla de Perfil y Publicaciones (PagePerfilContacto)**

- Propósito: Ver la información pública de un contacto y el contenido (propiedades) que ha publicado.
- UI:
- Cabecera: Foto de perfil grande, nombre, tipo de usuario (Promotor, etc.), e información de contacto (correo/teléfono, si es público).
- Cuerpo: Una cuadrícula (GridView) o lista (ListView) de las propiedades o publicaciones que ese usuario ha subido.
- Lógica Backend:
- Requiere el idUsuario del contacto.
- Hace una consulta a buscobien_propiedades (o donde guardes las publicaciones) buscando documentos cuyo userId coincida con el contacto.

**5. Pantalla de Chat Privado (PageChatPrivado)**

- Propósito: Intercambiar mensajes en tiempo real (o casi real) con un contacto.
- UI:
- AppBar con el nombre y foto del contacto.
- Lista de mensajes (ListView.builder invertido para que los nuevos salgan abajo). Burbujas de chat verdes (propias) y grises (del contacto).
- Barra inferior con TextField y botón de enviar (IconButton).
- Lógica Backend:
- Consulta exclusiva a la base de datos buscobien_mensajes.
- Busca todos los mensajes donde (sender == yo AND receiver == él) OR (sender == él AND receiver == yo).
- Se ordena cronológicamente por el timestamp.

**Siguiente Paso para el Desarrollo**

Ya tenemos la arquitectura mental y la separación de datos estructurada.

Para empezar a generar el código de Flutter (siguiendo tus estándares, usando Riverpod y CouchDB), te sugiero que lo hagamos en este orden para evitar archivos gigantes y asegurar que todo compile bien:

## 1. Fase 1: Generar los Modelos y Providers Separados (Invitaciones y Mensajes).

## 2. Fase 2: Generar las pantallas de Descubrir Usuarios e Invitaciones (Pantallas 1 y 2).

## 3. Fase 3: Generar las pantallas de Contactos, Chat y Perfil (Pantallas 3, 4 y 5).

¿Estás de acuerdo con esta división en tres fases para empezar a pasarte el código de la **Fase 1 (Modelos y Providers)**?

Genera el código completo de las pantallas, con los estilos usados anteriormente, coloca los modelos de datos en archivos separados para mensajes, invitaciones o solicitudes, también separa los provider en archivos separados, y las pantallas en otros, uno para cada pantalla.

Esta es una implementación completa y profesional. He dividido el código en **9 archivos separados** (2 modelos, 2 providers y 5 pantallas) para mantener una arquitectura limpia, escalable y fácil de mantener, tal como solicitaste.

**PARTE 1: Modelos de Datos**

**1. Archivo: invitacion_model.dart**

Modelo para manejar las solicitudes de amistad/conexión.

2. Archivo: mensaje_model.dart

Modelo para los mensajes del chat privado.

PARTE 2: Providers (Lógica de CouchDB)

3. Archivo: provider_invitaciones.dart

Maneja el envío, recepción y actualización de las invitaciones. (Usa la DB buscobien_invitaciones).

**4. Archivo: provider_mensajes.dart**

Maneja el chat privado. (Usa la DB buscobien_mensajes).

**PARTE 3: Pantallas de Interfaz de Usuario**

**5. Archivo: page_descubrir_usuarios.dart**

Lista para enviar invitaciones (usa el CustomScrollView que ajustamos antes).

**6. Archivo: page_invitaciones.dart**

Muestra las pestañas de invitaciones enviadas y recibidas.

**7. Archivo: page_mis_contactos.dart**

Lista de amigos confirmados.

**8. Archivo: page_perfil_contacto.dart**

Muestra el perfil y las propiedades publicadas por el contacto.

**9. Archivo: page_chat_privado.dart**

Ventana de chat 1 a 1.

**Verifica que el código considere los siguientes Ajustes y Mejoras:**

## 1. Seguridad contra Nulos (Null Safety):

En el filtrado de las listas (fUsers y fPromotores), se agregó el operador de acceso seguro (?) y validación de nulos al acceder a u['usuario']['idUsuario']. Esto evita que la aplicación sufra un "crash" si la base de datos devuelve un documento mal formado.

## 2. Manejo de Estado Vacío (Empty State):

Si ambas listas resultan vacías (por ejemplo, si el usuario actual es el único registrado en la base de datos), se mostraba una pantalla en blanco. Ahora se incluye un mensaje amigable indicando que no hay más usuarios.

## 3. Física de Scroll:

Se agregó BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()) al CustomScrollView. Esto garantiza que el scroll se sienta natural y elástico en iOS, Web y Windows, incluso si la lista no ocupa toda la pantalla.

## 4. Validación Visual en Avatar:

Se aseguró que la letra del CircleAvatar siempre sea mayúscula (toUpperCase()) para mantener un diseño limpio y uniforme.

## 5. Espaciado Inferior (Safe Area):

Se agregó un SliverToBoxAdapter vacío al final del CustomScrollView para asegurar que el último elemento no quede pegado al borde inferior de la pantalla o tapado por los gestos de navegación del sistema operativo.
