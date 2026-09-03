# Notificaciones entre Usuarios
## ***Notificaciones entre usuarios: Tipos y Mejores Prácticas***
Las **notificaciones entre usuarios** son la columna vertebral de la interactividad en cualquier plataforma digital (redes sociales, apps de gestión de tareas o herramientas de colaboración). Su objetivo es informar sobre acciones relevantes sin saturar al usuario.

Aquí te presento un desglose de cómo se clasifican, qué canales usan y las mejores prácticas para implementarlas:

-----
### **1. Tipos de Notificaciones**
Dependiendo de la acción que las detone, suelen dividirse en:

- **Interacciones Directas:** Menciones (@usuario), mensajes directos (DM) o respuestas a un comentario.
- **Acciones de Estado:** "A Juan le gustó tu foto" o "María empezó a seguirte".
- **Colaborativas:** "Sofía te asignó una tarea" o "Diego editó el documento compartido".
- **Proximidad/Contexto:** "Tu amigo está a menos de 500 metros" o "Es el cumpleaños de un contacto".
-----
### **2. Canales de Entrega**
La elección del canal depende de la **urgencia** de la información:

|**Canal**|**Uso Ideal**|**Nivel de Intrusión**|
| :-: | :-: | :-: |
|**Push (Móvil/Web)**|Alertas en tiempo real (mensajes, emergencias).|Alto|
|**In-App (Campanita)**|Actividades secundarias (likes, nuevos seguidores).|Bajo|
|**Correo Electrónico**|Resúmenes semanales o seguridad (cambio de clave).|Medio|
|**SMS/WhatsApp**|Verificaciones de identidad o alertas críticas.|Muy Alto|

-----
### **3. Elementos Clave de una Notificación**
Para que una notificación sea efectiva (y no molesta), debe contener:

1. **El Quién:** Avatar o nombre del usuario que originó la acción.
1. **El Qué:** Un verbo claro (*comentó, compartió, reaccionó*).
1. **El Dónde:** Contexto breve (ej. "...en tu publicación sobre IA").
1. **Llamada a la acción (CTA):** Al hacer clic, debe llevar exactamente al punto de la interacción.
-----
### **4. Buenas Prácticas (UX)**
Evitar que el usuario desactive las notificaciones es un arte. Considera esto:

- **Agrupamiento (Stacking):** En lugar de enviar 10 alertas por 10 "likes", envía una que diga: *"A Juan y 9 personas más les gustó tu foto"*.
- **Centro de Preferencias:** Permite al usuario elegir qué quiere recibir y por qué canal.
- **Modo "No Molestar":** Respetar horarios nocturnos para notificaciones no críticas.
- **Latencia:** La notificación debe ser casi instantánea para mantener la fluidez de la conversación.
-----
# CouchDB Changes Feed
El **CouchDB Changes Feed** es, posiblemente, la característica más potente de CouchDB para construir sistemas en tiempo real. Es lo que permite que CouchDB pase de ser una base de datos "pasiva" a un motor de eventos activo.

Aquí profundizamos en su funcionamiento y luego vemos cómo configurar los **Channels** en el Sync Gateway para segmentar las notificaciones.

-----
## ***1. ¿Qué es el Changes Feed?***
Imagínatelo como un **registro de transacciones infinito**. Cada vez que un documento se crea, edita o elimina, CouchDB añade una entrada al final de este feed.
### **Modos de consulta:**
- **Polling (Normal):** Pides los cambios y la conexión se cierra.
- **Long Polling:** La conexión se queda abierta hasta que ocurra un cambio o se agote el tiempo de espera.
- **Continuous (Streaming):** La conexión se mantiene abierta indefinidamente. Cada vez que hay un cambio, CouchDB envía una línea JSON por el socket. Es ideal para procesos de backend que deben reaccionar al instante.
### **Ejemplo de respuesta del feed:**
JSON

{

`  `"seq": "1-g1AAAA...", 

`  `"id": "notificacion\_abc\_123",

`  `"changes": [{"rev": "1-61a... "}],

`  `"doc": { 

`    `"type": "notificacion",

`    `"from": "UsuarioA",

`    `"to": "UsuarioB",

`    `"mensaje": "Te ha enviado un mensaje"

`  `}

}
### **¿Por qué es vital para tu arquitectura?**
Porque en lugar de que tu servidor de Flutter esté preguntando cada 5 segundos "¿hay algo nuevo?", el servidor de CouchDB "empuja" el dato en cuanto el seq (número de secuencia) aumenta.

-----
## ***2. Configuración de Channels (Sync Gateway)***
En una arquitectura de notificaciones, **el aislamiento es clave**. No quieres que el Usuario A reciba por error los cambios o documentos del Usuario B. Aquí es donde entra el **Sync Gateway** con sus **Channels**.

El Sync Gateway actúa como un firewall inteligente frente a CouchDB. Utiliza una función de JavaScript (llamada sync function) para decidir a qué canal pertenece cada documento y quién tiene permiso para leerlo.
### **Ejemplo de Función de Sincronización:**
JavaScript

function (doc, oldDoc) {

`  `// Solo procesamos documentos de tipo 'notificacion'

`  `if (doc.type == "notificacion") {



`    `// Validamos que el documento tenga un destinatario

`    `if (!doc.target\_user) {

`      `throw({forbidden: "El campo target\_user es obligatorio"});

`    `}

`    `// ASIGNACIÓN AL CANAL:

`    `// El documento se envía al canal privado del usuario destino.

`    `// Solo los usuarios suscritos al canal 'user\_Juan123' recibirán esto.

`    `channel("user\_" + doc.target\_user);



`    `// Opcional: Dar acceso de lectura explícito al usuario destino

`    `access(doc.target\_user, "user\_" + doc.target\_user);

`  `}

}
## ***3. Implementación del Flujo de Notificaciones***
Para que esto funcione en tu app de Flutter, el proceso es:

1. **Suscripción:** Cuando el usuario inicia sesión en la app de Flutter, el Sync Gateway lo autentica y lo conecta automáticamente a su canal (user\_id).
1. **Replicación Selectiva:** Couchbase Lite (en Flutter) le dice al Sync Gateway: *"Dame todos los cambios del canal al que tengo acceso"*.
1. **Escucha en Flutter:**
- Utilizas un ListenerToken en la base de datos local.
- Cuando el Changes Feed del servidor envía un documento al Sync Gateway, este lo pasa al canal del usuario.
- Couchbase Lite en el móvil lo descarga.
- El listener en Flutter se dispara y tú muestras la notificación.
### **Resumen de la Segmentación:**
- **Documento en CouchDB:** Tiene una propiedad target\_user: "pedro".
- **Sync Gateway:** Lee esa propiedad y lo mete en la "caja" (canal) de Pedro.
- **Flutter (App de Pedro):** Solo "ve" el contenido de su caja. Nunca descarga los documentos de "María" o "Juan".
# Implementación con flutter y couchdb únicamente.
En esta estrategia, haremos peticiones HTTP directas y consumiremos el **Changes Feed** a través de un *stream* continuo. Además, implementaremos una cola manual en memoria (que idealmente después puedes guardar en disco con sqflite).

Aquí tienes la implementación directa:
## ***Dependencias requeridas (pubspec.yaml):***
YAML

dependencies:

`  `flutter:

`    `sdk: flutter

`  `http: ^1.1.0       # Para consumir la API REST de CouchDB

`  `connectivity\_plus: ^5.0.0
## ***Implementación del Servicio (couchdb\_direct\_service.dart):***
Dart

import 'dart:async';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:connectivity\_plus/connectivity\_plus.dart';

class DirectCouchDbService {

`  `final String currentUserId;

`  `final String couchDbUrl = "http://TU\_SERVIDOR:5984/notificaciones";



`  `// Asumimos que ya tienes el header de autenticación (ej. Basic Auth o Cookie)

`  `final Map<String, String> authHeaders;

`  `StreamSubscription<List<ConnectivityResult>>? \_connectivitySubscription;

`  `http.Client? \_changesClient;



`  `// Cola para almacenar mensajes cuando no hay internet

`  `final List<Map<String, dynamic>> \_offlineQueue = [];

`  `bool \_isOnline = true;



`  `// Para llevar el control de qué notificaciones ya leímos

`  `String \_lastSeq = "now"; 

`  `DirectCouchDbService({

`    `required this.currentUserId,

`    `required this.authHeaders,

`  `});

`  `/// 1. Inicializa el monitor de red

`  `void initialize() {

`    `authHeaders['Content-Type'] = 'application/json';

`    `\_connectivitySubscription = Connectivity().onConnectivityChanged.listen(

`      `(List<ConnectivityResult> results) {

`        `\_isOnline = !results.contains(ConnectivityResult.none);



`        `if (!\_isOnline) {

`          `print("Sin internet: Suspendiendo feed y encolando mensajes...");

`          `\_stopChangesFeed();

`        `} else {

`          `print("Internet detectado: Reconectando feed y vaciando cola...");

`          `\_flushOfflineQueue();

`          `\_startChangesFeed();

`        `}

`      `},

`    `);

`  `}

`  `/// 2. Envía un mensaje corto (o lo encola si no hay internet)

`  `Future<void> sendMessage(String targetUserId, String textMessage) async {

`    `final doc = {

`      `"type": "notificacion",

`      `"sender\_id": currentUserId,

`      `"target\_user": targetUserId,

`      `"message": textMessage,

`      `"timestamp": DateTime.now().toIso8601String(),

`    `};

`    `if (\_isOnline) {

`      `await \_postDocument(doc);

`    `} else {

`      `\_offlineQueue.add(doc);

`      `print("Mensaje encolado offline.");

`    `}

`  `}

`  `/// Petición HTTP POST directa a CouchDB

`  `Future<void> \_postDocument(Map<String, dynamic> doc) async {

`    `try {

`      `final response = await http.post(

`        `Uri.parse(couchDbUrl),

`        `headers: authHeaders,

`        `body: jsonEncode(doc),

`      `);

`      `if (response.statusCode == 201) {

`        `print("Mensaje enviado con éxito a CouchDB.");

`      `}

`    `} catch (e) {

`      `print("Error enviando documento, reencolando: $e");

`      `\_offlineQueue.add(doc); // Si falla, lo devolvemos a la cola

`    `}

`  `}

`  `/// 3. Vacía la cola cuando vuelve el internet

`  `Future<void> \_flushOfflineQueue() async {

`    `while (\_offlineQueue.isNotEmpty && \_isOnline) {

`      `final doc = \_offlineQueue.removeAt(0);

`      `await \_postDocument(doc);

`    `}

`  `}

`  `/// 4. Escucha el CouchDB Changes Feed directamente

`  `Future<void> \_startChangesFeed() async {

`    `\_stopChangesFeed(); // Asegura que no haya conexiones duplicadas

`    `\_changesClient = http.Client();

`    `// Usamos \_selector para que CouchDB solo nos envíe los mensajes de este usuario

`    `final requestBody = jsonEncode({

`      `"selector": {"target\_user": currentUserId},

`      `"limit": 100

`    `});

`    `// Construimos la URL del continuous feed

`    `final feedUrl = Uri.parse(

`      `'$couchDbUrl/\_changes?feed=continuous&heartbeat=10000&since=$\_lastSeq&include\_docs=true&filter=\_selector'

`    `);

`    `try {

`      `final request = http.Request('POST', feedUrl)

..headers.addAll(authHeaders)

..body = requestBody;

`      `final response = await \_changesClient!.send(request);

`      `// Leemos el stream línea por línea (CouchDB envía un JSON por línea en continuous)

`      `response.stream

.transform(utf8.decoder)

.transform(const LineSplitter())

.listen((String line) {



`        `if (line.trim().isEmpty) return; // Ignora los heartbeats

`        `final data = jsonDecode(line);



`        `// Actualizamos el last\_seq para no repetir notificaciones si se cae la red

`        `if (data['seq'] != null) {

`          `\_lastSeq = data['seq'].toString();

`        `}

`        `// Si trae el documento, es una notificación nueva

`        `if (data['doc'] != null) {

`          `final sender = data['doc']['sender\_id'];

`          `final message = data['doc']['message'];

`          `print("🔔 Nuevo mensaje de $sender: $message");

`        `}



`      `}, onError: (error) {

`        `print("Error en el Changes Feed: $error");

`        `\_stopChangesFeed();

`      `}, cancelOnError: true);



`    `} catch (e) {

`      `print("No se pudo conectar al Changes Feed: $e");

`    `}

`  `}

`  `/// Detiene el cliente HTTP del stream

`  `void \_stopChangesFeed() {

`    `\_changesClient?.close();

`    `\_changesClient = null;

`  `}

`  `void dispose() {

`    `\_stopChangesFeed();

`    `\_connectivitySubscription?.cancel();

`  `}

}
## ***Diferencias Clave de esta Arquitectura:***
1. **El Stream HTTP (LineSplitter):** CouchDB mantiene la petición HTTP viva enviando fragmentos de datos. En Flutter, usamos response.stream y lo decodificamos línea por línea. Cada línea es un evento en tiempo real.
1. **El parámetro since:** Al usar since=$\_lastSeq, si el usuario se queda sin internet y vuelve 5 minutos después, le diremos a CouchDB: *"dame todo lo que pasó desde la última secuencia que registré"*. Así no pierde notificaciones ni recibe repetidas.
1. **El filtro \_selector:** Mandamos un POST al endpoint de changes con un JSON que le dice al servidor: *"solo mándame las notificaciones donde target\_user sea mi ID"*.

**Nota para producción:** La lista \_offlineQueue actualmente vive en la memoria RAM. Si el usuario escribe un mensaje sin internet y cierra la app por completo, se perderá.
## ***Cola de mensajes en caché local***
Añadamos unas líneas de código para guardar esa pequeña cola de mensajes en caché local (usando SharedPreferences) para que sobreviva al reinicio de la app.

Para una cola de mensajes de texto cortos, shared\_preferences es una solución ligera, rápida y perfecta para evitar perder datos si el usuario cierra la aplicación abruptamente sin conexión.

Aquí tienes la evolución del servicio. El código se ha modificado para que cada vez que un mensaje se encole o se envíe con éxito, el estado se guarde en la memoria persistente del teléfono.
### **1. Actualización de Dependencias (pubspec.yaml)**
Añadimos el paquete a tus dependencias actuales:

YAML

dependencies:

`  `flutter:

`    `sdk: flutter

`  `http: ^1.1.0

`  `connectivity\_plus: ^5.0.0

`  `shared\_preferences: ^2.2.0 # <-- Nueva dependencia
### **2. El Servicio Actualizado con Persistencia**
Dart

import 'dart:async';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:connectivity\_plus/connectivity\_plus.dart';

import 'package:shared\_preferences/shared\_preferences.dart';

class DirectCouchDbService {

`  `final String currentUserId;

`  `final String couchDbUrl = "http://TU\_SERVIDOR:5984/notificaciones";

`  `final Map<String, String> authHeaders;

`  `static const String \_queuePrefsKey = 'offline\_message\_queue';



`  `StreamSubscription<List<ConnectivityResult>>? \_connectivitySubscription;

`  `http.Client? \_changesClient;



`  `final List<Map<String, dynamic>> \_offlineQueue = [];

`  `bool \_isOnline = true;

`  `String \_lastSeq = "now"; 

`  `DirectCouchDbService({

`    `required this.currentUserId,

`    `required this.authHeaders,

`  `});

`  `/// 1. Inicializa cargando la cola guardada y escuchando la red

`  `Future<void> initialize() async {

`    `authHeaders['Content-Type'] = 'application/json';



`    `// Cargar mensajes pendientes que sobrevivieron al cierre de la app

`    `await \_loadQueueFromPrefs();

`    `\_connectivitySubscription = Connectivity().onConnectivityChanged.listen(

`      `(List<ConnectivityResult> results) {

`        `\_isOnline = !results.contains(ConnectivityResult.none);



`        `if (!\_isOnline) {

`          `print("Sin internet: Suspendiendo feed...");

`          `\_stopChangesFeed();

`        `} else {

`          `print("Internet detectado: Reconectando feed y vaciando cola...");

`          `\_flushOfflineQueue();

`          `\_startChangesFeed();

`        `}

`      `},

`    `);

`  `}

`  `/// 2. Lógica de Persistencia (SharedPreferences)

`  `Future<void> \_loadQueueFromPrefs() async {

`    `final prefs = await SharedPreferences.getInstance();

`    `final String? savedQueue = prefs.getString(\_queuePrefsKey);



`    `if (savedQueue != null) {

`      `final List<dynamic> decodedList = jsonDecode(savedQueue);

`      `\_offlineQueue.clear();

`      `\_offlineQueue.addAll(decodedList.cast<Map<String, dynamic>>());

`      `print("Cola offline cargada: ${\_offlineQueue.length} mensajes pendientes.");

`    `}

`  `}

`  `Future<void> \_saveQueueToPrefs() async {

`    `final prefs = await SharedPreferences.getInstance();

`    `await prefs.setString(\_queuePrefsKey, jsonEncode(\_offlineQueue));

`  `}

`  `/// 3. Envía un mensaje (Directo o a la cola persistente)

`  `Future<void> sendMessage(String targetUserId, String textMessage) async {

`    `final doc = {

`      `"type": "notificacion",

`      `"sender\_id": currentUserId,

`      `"target\_user": targetUserId,

`      `"message": textMessage,

`      `"timestamp": DateTime.now().toIso8601String(),

`    `};

`    `if (\_isOnline) {

`      `bool success = await \_postDocument(doc);

`      `if (!success) {

`        `// Si falló por un micro-corte, lo encolamos

`        `\_enqueueMessage(doc);

`      `}

`    `} else {

`      `\_enqueueMessage(doc);

`    `}

`  `}

`  `Future<void> \_enqueueMessage(Map<String, dynamic> doc) async {

`    `\_offlineQueue.add(doc);

`    `await \_saveQueueToPrefs(); // Guardamos en disco al instante

`    `print("Mensaje guardado en disco. Se enviará con conexión.");

`  `}

`  `/// Petición HTTP POST directa a CouchDB (ahora retorna un bool)

`  `Future<bool> \_postDocument(Map<String, dynamic> doc) async {

`    `try {

`      `final response = await http.post(

`        `Uri.parse(couchDbUrl),

`        `headers: authHeaders,

`        `body: jsonEncode(doc),

`      `);

`      `if (response.statusCode == 201) {

`        `print("Mensaje enviado con éxito a CouchDB.");

`        `return true;

`      `}

`      `return false;

`    `} catch (e) {

`      `print("Error HTTP enviando documento: $e");

`      `return false;

`    `}

`  `}

`  `/// 4. Vacía la cola de forma segura actualizando las preferencias

`  `Future<void> \_flushOfflineQueue() async {

`    `if (\_offlineQueue.isEmpty || !\_isOnline) return;

`    `// Iteramos sobre una copia de la cola para evitar errores al modificarla

`    `final queueCopy = List<Map<String, dynamic>>.from(\_offlineQueue);

`    `for (final doc in queueCopy) {

`      `if (!\_isOnline) break; // Aborta si la conexión se cae en medio del proceso

`      `bool success = await \_postDocument(doc);



`      `if (success) {

`        `\_offlineQueue.remove(doc); // Lo quitamos de la lista en memoria

`        `await \_saveQueueToPrefs(); // Actualizamos el almacenamiento en disco

`      `}

`    `}

`  `}

`  `// ... (El código de \_startChangesFeed y \_stopChangesFeed se mantiene exactamente igual al ejemplo anterior) ...

`  `Future<void> dispose() async {

`    `\_stopChangesFeed();

`    `await \_connectivitySubscription?.cancel();

`  `}

}
### **Cambios Clave Realizados:**
- **\_loadQueueFromPrefs():** Se llama durante el initialize(). Busca si hay un string JSON guardado en las preferencias, lo decodifica y repuebla tu lista de espera.
- **\_saveQueueToPrefs():** Convierte tu lista a JSON y sobrescribe la preferencia. Se llama cada vez que añades un mensaje sin internet, y cada vez que vacías un mensaje con éxito.
- **Control de Errores de Red:** Modifiqué \_postDocument para que devuelva true o false. Así, si la app cree que tiene internet pero la solicitud HTTP falla (por ejemplo, estás conectado a un WiFi que requiere inicio de sesión), el mensaje no se pierde y se va a la cola segura.
-----
Con esto, tienes un sistema robusto, sin dependencias complejas de bases de datos locales, y tolerante a fallos de conectividad.

¿Te gustaría que veamos cómo conectar la llegada de un nuevo mensaje en \_startChangesFeed con la Interfaz de Usuario de Flutter utilizando un StreamController o un paquete como flutter\_local\_notifications?
# Conectar la llegada de un nuevo mensaje
Vamos a conectar el "motor" que construimos en el servicio con la **Interfaz de Usuario (UI)**.

A continuación, se explica cómo conectar la llegada de un nuevo mensaje en \_startChangesFeed con la Interfaz de Usuario de Flutter utilizando un StreamController o un paquete como flutter\_local\_notifications.

Para hacerlo de la manera más profesional y completa, utilizaremos dos herramientas al mismo tiempo:

1. **StreamController (Nativo de Dart):** Para que la pantalla principal de la app se actualice en tiempo real cuando llega un mensaje (si el usuario tiene la app abierta).
1. **flutter\_local\_notifications:** Para mostrar la clásica "burbuja/alerta" del sistema operativo en la parte superior del teléfono.
## ***1. Actualiza tus dependencias (pubspec.yaml)***
Agrega el paquete para las notificaciones locales:

YAML

dependencies:

`  `flutter:

`    `sdk: flutter

`  `http: ^1.1.0

`  `connectivity\_plus: ^5.0.0

`  `shared\_preferences: ^2.2.0

`  `flutter\_local\_notifications: ^17.0.0 # <-- Agrega esta línea
## ***2. Actualización del Servicio (DirectCouchDbService.dart)***
Vamos a agregar el inicializador de notificaciones locales y un Stream (tubería de datos) al que la UI se podrá suscribir.

*(Solo muestro el código nuevo o modificado para no repetir todo)*

Dart

import 'dart:async';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:connectivity\_plus/connectivity\_plus.dart';

import 'package:shared\_preferences/shared\_preferences.dart';

import 'package:flutter\_local\_notifications/flutter\_local\_notifications.dart'; // NUEVO

class DirectCouchDbService {

`  `// ... (Tus variables anteriores: url, headers, queue, etc.) ...

`  `// NUEVO: Tubería para enviar datos a la Interfaz de Usuario

`  `final \_messageStreamController = StreamController<Map<String, dynamic>>.broadcast();

`  `Stream<Map<String, dynamic>> get messageStream => \_messageStreamController.stream;

`  `// NUEVO: Instancia del plugin de notificaciones locales

`  `final FlutterLocalNotificationsPlugin \_localNotifications = FlutterLocalNotificationsPlugin();

`  `// ... (Constructor) ...

`  `Future<void> initialize() async {

`    `// ... (Tu código anterior de authHeaders y carga de Preferencias) ...

`    `await \_initLocalNotifications(); // Inicializamos las alertas del sistema

`    `// ... (Tu código anterior del listener de Connectivity) ...

`  `}

`  `/// NUEVO: Configuración de flutter\_local\_notifications

`  `Future<void> \_initLocalNotifications() async {

`    `const AndroidInitializationSettings initializationSettingsAndroid =

`        `AndroidInitializationSettings('@mipmap/ic\_launcher'); // Icono de tu app

`    `// Para iOS (Darwin)

`    `const DarwinInitializationSettings initializationSettingsIOS =

`        `DarwinInitializationSettings();

`    `const InitializationSettings initializationSettings = InitializationSettings(

`      `android: initializationSettingsAndroid,

`      `iOS: initializationSettingsIOS,

`    `);

`    `await \_localNotifications.initialize(initializationSettings);

`  `}

`  `/// NUEVO: Dispara la alerta del sistema

`  `Future<void> \_showSystemNotification(String sender, String message) async {

`    `const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(

`      `'canal\_mensajes', // ID del canal

`      `'Mensajes Nuevos', // Nombre del canal

`      `importance: Importance.max,

`      `priority: Priority.high,

`    `);



`    `const NotificationDetails platformChannelDetails = NotificationDetails(

`      `android: androidDetails,

`    `);

`    `await \_localNotifications.show(

`      `DateTime.now().millisecond, // ID único de la notificación

`      `'Nuevo mensaje de $sender', // Título

`      `message,                    // Cuerpo

`      `platformChannelDetails,

`    `);

`  `}

`  `/// ACTUALIZADO: Dentro de tu \_startChangesFeed

`  `// ... (código de \_startChangesFeed HTTP) ...

`      `response.stream

.transform(utf8.decoder)

.transform(const LineSplitter())

.listen((String line) {



`        `if (line.trim().isEmpty) return;

`        `final data = jsonDecode(line);

`        `if (data['seq'] != null) \_lastSeq = data['seq'].toString();

`        `if (data['doc'] != null) {

`          `final doc = data['doc'];

`          `final sender = doc['sender\_id'];

`          `final message = doc['message'];



`          `// 1. Enviamos el mensaje a la UI (StreamBuilder)

`          `\_messageStreamController.add(doc);



`          `// 2. Mostramos la notificación en Android/iOS

`          `\_showSystemNotification(sender, message);

`        `}

`      `});

`  `// ... (resto de \_startChangesFeed) ...

`  `Future<void> dispose() async {

`    `\_messageStreamController.close(); // Cerramos el stream para evitar fugas de memoria

`    `// ... (tu dispose anterior) ...

`  `}

}
## ***3. La Interfaz de Usuario (UI) en Flutter***
Ahora en tu pantalla de Flutter (pantalla\_mensajes.dart), usaremos un StreamBuilder. Este widget se redibuja automáticamente cada vez que el DirectCouchDbService detecta un mensaje nuevo en el CouchDB Changes Feed.

Dart

import 'package:flutter/material.dart';

// Importa tu servicio aquí

class PantallaMensajes extends StatefulWidget {

`  `final DirectCouchDbService couchDbService;

`  `const PantallaMensajes({Key? key, required this.couchDbService}) : super(key: key);

`  `@override

`  `\_PantallaMensajesState createState() => \_PantallaMensajesState();

}

class \_PantallaMensajesState extends State<PantallaMensajes> {

`  `// Aquí guardaremos el historial local de la pantalla

`  `final List<Map<String, dynamic>> \_mensajesEnPantalla = [];

`  `final TextEditingController \_textController = TextEditingController();

`  `@override

`  `Widget build(BuildContext context) {

`    `return Scaffold(

`      `appBar: AppBar(title: const Text('Notificaciones en Vivo')),

`      `body: Column(

`        `children: [

`          `Expanded(

`            `// El StreamBuilder "escucha" los mensajes nuevos

`            `child: StreamBuilder<Map<String, dynamic>>(

`              `stream: widget.couchDbService.messageStream,

`              `builder: (context, snapshot) {

`                `// Si llega un mensaje nuevo por el stream, lo agregamos a la lista

`                `if (snapshot.hasData) {

`                  `// Evitamos duplicados si el build se ejecuta varias veces

`                  `final nuevoDoc = snapshot.data!;

`                  `if (!\_mensajesEnPantalla.any((m) => m['\_id'] == nuevoDoc['\_id'])) {

`                     `// Insertamos al principio de la lista

`                    `\_mensajesEnPantalla.insert(0, nuevoDoc);

`                  `}

`                `}

`                `if (\_mensajesEnPantalla.isEmpty) {

`                  `return const Center(child: Text('No hay mensajes aún.'));

`                `}

`                `// Pintamos la lista de mensajes

`                `return ListView.builder(

`                  `reverse: true, // Para que los nuevos salgan abajo o arriba como en WhatsApp

`                  `itemCount: \_mensajesEnPantalla.length,

`                  `itemBuilder: (context, index) {

`                    `final msg = \_mensajesEnPantalla[index];

`                    `return ListTile(

`                      `leading: const CircleAvatar(child: Icon(Icons.person)),

`                      `title: Text(msg['sender\_id'] ?? 'Desconocido'),

`                      `subtitle: Text(msg['message'] ?? ''),

`                      `trailing: Text(

`                        `msg['timestamp'] != null 

`                          `? msg['timestamp'].substring(11, 16) // Solo la hora HH:MM

`                          `: ''

`                      `),

`                    `);

`                  `},

`                `);

`              `},

`            `),

`          `),



`          `// Campo para enviar un mensaje simulado a ti mismo (o a otro)

`          `Padding(

`            `padding: const EdgeInsets.all(8.0),

`            `child: Row(

`              `children: [

`                `Expanded(

`                  `child: TextField(

`                    `controller: \_textController,

`                    `decoration: const InputDecoration(hintText: "Enviar mensaje..."),

`                  `),

`                `),

`                `IconButton(

`                  `icon: const Icon(Icons.send),

`                  `onPressed: () {

`                    `if (\_textController.text.isNotEmpty) {

`                      `// Usamos tu función con la lógica offline persistente!

`                      `widget.couchDbService.sendMessage(

`                        `'ID\_DEL\_DESTINATARIO', 

`                        `\_textController.text

`                      `);

`                      `\_textController.clear();

`                    `}

`                  `},

`                `)

`              `],

`            `),

`          `)

`        `],

`      `),

`    `);

`  `}

}
## ***¿Qué logramos con esto?***
1. **Reacción Inmediata (In-App):** Si el usuario está viendo la pantalla, el StreamBuilder detecta el dato que le pasaste mediante \_messageStreamController.add(doc) y actualiza el chat al instante.
1. **Reacción Global (Push nativo):** Al mismo tiempo, \_showSystemNotification usa el plugin nativo. Si el usuario está minimizando tu app (pero el feed sigue vivo en segundo plano), verá la notificación clásica de Android/iOS vibrar en su barra superior.
1. **Persistencia Total:** Y gracias a tu lógica previa, si intentan enviar algo sin red, se guarda en SharedPreferences y se dispara solo al recuperar el WiFi/Datos.

# Motor Principal Usando flutter y CouchDB, para buscobien.
Basándome en nuestra arquitectura anterior (Flutter + conexión directa a la API REST de CouchDB), la funcionalidad central de "buscobien" requerirá un motor de búsqueda potente. Para esto, en CouchDB no usamos el \_changes feed, sino el endpoint **\_find** (conocido como Mango Queries), que te permite filtrar, ordenar y buscar dentro de tus documentos JSON.

Aquí tienes la arquitectura para la funcionalidad central de búsqueda y filtrado:

-----
## ***1. Estructura del Documento en CouchDB***
Para que la búsqueda sea rápida, tus documentos (ya sean productos, servicios o personas) deben tener una estructura clara. Por ejemplo:

JSON

{

`  `"\_id": "servicio\_123",

`  `"type": "publicacion",

`  `"titulo": "Plomero a domicilio",

`  `"descripcion": "Reparación de tuberías 24/7",

`  `"categoria": "mantenimiento",

`  `"precio": 500,

`  `"activo": true

}

-----
## ***2. Servicio de Búsqueda en Flutter (buscobien\_service.dart)***
Este servicio se encargará de hacer peticiones HTTP al endpoint \_find de CouchDB, permitiendo a tus usuarios buscar por texto o filtrar por categoría.

Dart

import 'dart:convert';

import 'package:http/http.dart' as http;

class BuscobienService {

`  `final String couchDbUrl = "http://TU\_SERVIDOR:5984/buscobien\_db";

`  `final Map<String, String> authHeaders;

`  `BuscobienService({required this.authHeaders}) {

`    `authHeaders['Content-Type'] = 'application/json';

`  `}

`  `/// Motor principal de búsqueda

`  `Future<List<Map<String, dynamic>>> buscarPublicaciones({

`    `String? textoBusqueda,

`    `String? categoria,

`  `}) async {

`    `// 1. Construimos el "selector" (la consulta Mango)

`    `Map<String, dynamic> selector = {

`      `"type": "publicacion",

`      `"activo": true

`    `};

`    `// 2. Agregamos filtro por categoría si el usuario seleccionó una

`    `if (categoria != null && categoria.isNotEmpty) {

`      `selector["categoria"] = categoria;

`    `}

`    `// 3. Agregamos búsqueda por texto (usando Expresiones Regulares para ignorar mayúsculas)

`    `if (textoBusqueda != null && textoBusqueda.isNotEmpty) {

`      `selector["titulo"] = {

`        `"\$regex": "(?i)$textoBusqueda" // (?i) lo hace case-insensitive

`      `};

`    `}

`    `final requestBody = jsonEncode({

`      `"selector": selector,

`      `"limit": 50, // Paginación inicial

`      `// "sort": [{"precio": "asc"}] // Opcional: Si tienes índices creados en CouchDB

`    `});

`    `try {

`      `// 4. Hacemos la petición al endpoint \_find

`      `final response = await http.post(

`        `Uri.parse('$couchDbUrl/\_find'),

`        `headers: authHeaders,

`        `body: requestBody,

`      `);

`      `if (response.statusCode == 200) {

`        `final data = jsonDecode(response.body);

`        `final List<dynamic> docs = data['docs'];



`        `// Retornamos la lista de documentos encontrados

`        `return docs.cast<Map<String, dynamic>>();

`      `} else {

`        `print("Error en la búsqueda: ${response.statusCode} - ${response.body}");

`        `return [];

`      `}

`    `} catch (e) {

`      `print("Excepción al conectar con CouchDB: $e");

`      `return [];

`    `}

`  `}

}

-----
## ***3. La Interfaz de Búsqueda (UI)***
Ahora conectamos ese servicio a una pantalla típica de búsqueda con una barra superior y una lista de resultados.

Dart

import 'package:flutter/material.dart';

// Importa tu servicio aquí

class PantallaBuscobien extends StatefulWidget {

`  `final BuscobienService servicio;

`  `const PantallaBuscobien({Key? key, required this.servicio}) : super(key: key);

`  `@override

`  `\_PantallaBuscobienState createState() => \_PantallaBuscobienState();

}

class \_PantallaBuscobienState extends State<PantallaBuscobien> {

`  `List<Map<String, dynamic>> \_resultados = [];

`  `bool \_cargando = false;

`  `final TextEditingController \_searchController = TextEditingController();

`  `// Función que llama al servicio y actualiza la UI

`  `Future<void> \_ejecutarBusqueda(String query) async {

`    `setState(() => \_cargando = true);



`    `final resultados = await widget.servicio.buscarPublicaciones(

`      `textoBusqueda: query,

`      `// categoria: 'mantenimiento' // Aquí podrías conectar un DropdownMenu

`    `);

`    `setState(() {

`      `\_resultados = resultados;

`      `\_cargando = false;

`    `});

`  `}

`  `@override

`  `void initState() {

`    `super.initState();

`    `\_ejecutarBusqueda(""); // Cargar todos los activos al inicio

`  `}

`  `@override

`  `Widget build(BuildContext context) {

`    `return Scaffold(

`      `appBar: AppBar(

`        `title: const Text('Buscobien'),

`        `bottom: PreferredSize(

`          `preferredSize: const Size.fromHeight(60.0),

`          `child: Padding(

`            `padding: const EdgeInsets.all(8.0),

`            `child: TextField(

`              `controller: \_searchController,

`              `decoration: InputDecoration(

`                `hintText: '¿Qué estás buscando?',

`                `fillColor: Colors.white,

`                `filled: true,

`                `suffixIcon: IconButton(

`                  `icon: const Icon(Icons.search),

`                  `onPressed: () => \_ejecutarBusqueda(\_searchController.text),

`                `),

`                `border: OutlineInputBorder(

`                  `borderRadius: BorderRadius.circular(30.0),

`                  `borderSide: BorderSide.none,

`                `),

`              `),

`              `onSubmitted: \_ejecutarBusqueda, // Buscar al darle "Enter" en el teclado

`            `),

`          `),

`        `),

`      `),

`      `body: \_cargando

`          `? const Center(child: CircularProgressIndicator())

`          `: \_resultados.isEmpty

`              `? const Center(child: Text('No se encontraron resultados.'))

`              `: ListView.builder(

`                  `itemCount: \_resultados.length,

`                  `itemBuilder: (context, index) {

`                    `final item = \_resultados[index];

`                    `return Card(

`                      `margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

`                      `child: ListTile(

`                        `leading: const Icon(Icons.image, size: 50), // Aquí iría tu imagen

`                        `title: Text(item['titulo'] ?? 'Sin título'),

`                        `subtitle: Text(item['descripcion'] ?? ''),

`                        `trailing: Text(

`                          `'\$${item['precio'] ?? '0'}',

`                          `style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),

`                        `),

`                        `onTap: () {

`                          `// Navegar al detalle de la publicación

`                          `print("Abriendo detalle de: ${item['\_id']}");

`                        `},

`                      `),

`                    `);

`                  `},

`                `),

`    `);

`  `}

}

-----
## ***4. Uniendo las piezas (El gran panorama)***
Si juntamos el motor de notificaciones que hicimos antes con este motor de búsqueda, el flujo de "Buscobien" sería el siguiente:

1. El **Usuario A** usa la PantallaBuscobien y busca a un "Conocido" (**Usuario B)**.
1. Flutter consulta al endpoint \_find de CouchDB.
1. El **Usuario A** ve el perfil del **Usuario B** (el conocido) y le da al botón "Invitar".
1. Esto dispara la función sendMessage del DirectCouchDbService que creamos en los pasos anteriores.
1. El **Usuario B** recibe la **Notificación Push** (gracias al Changes Feed) diciendo: *"El Usuario A te mando una invitación"*.

Para una plataforma de promoción inmobiliaria como **Buscobien**, la arquitectura debe manejar búsquedas complejas (rango de precios, ubicación, tipo de propiedad) y permitir una comunicación fluida entre el interesado y el vendedor o agente.

En CouchDB, esto se traduce en el uso extensivo de **Mango Queries** para los filtros y el **Changes Feed** para las alertas de nuevas propiedades que coincidan con los intereses del usuario.



