<a id="X7119363c2dd5d55eba743fa70322732222753ab"></a># Reporte de Archivos \.dart \(Flujo de Operación y Menús\)

A continuación se detalla el análisis de los archivos principales que componen el flujo de inicialización, enrutamiento y menús de navegación de BuscoBien, basado en el diagrama de flujo\_operacion\_buscobien\.md y la estructura de menús\.

<a id="bootstrap-y-enrutamiento"></a>## 1\. Bootstrap y Enrutamiento

<a id="libmain.dart"></a>### lib/main\.dart

- __Contenido general:__ Es el punto de entrada principal de la aplicación\. Configura inicializaciones críticas de Flutter, la estrategia de URLs para Web, bloquea la orientación y levanta el contenedor raíz de Riverpod \(ProviderScope\)\.
- __Clases:__ BuscoBienApp \(clase principal de la app\)\.
- __Widgets:__ BuscoBienApp \(StatelessWidget que retorna un MaterialApp\)\.
- __Providers/Modelos:__ No define providers, pero implementa el ProviderScope que envuelve toda la app\.

<a id="lib07_routesapp_routes.dart"></a>### lib/07\_routes/app\_routes\.dart

- __Contenido general:__ Centraliza las rutas de navegación de la app utilizando un sistema de constantes de string y una función generadora de rutas\.
- __Clases:__ AppRoutes \(agrupa constantes estáticas\)\.
- __Widgets:__ No define widgets propios, pero invoca pantallas como SplashPage o PrincipalSliversMenuInicial\.
- __Providers/Modelos:__ Ninguno\.
- __Métodos clave:__ routeGenerate\(RouteSettings settings\) que funciona como el router principal de MaterialApp\.

<a id="X6103611fdd4391c9ee9d78bab11c87a03c68d65"></a>## 2\. Pantalla de Arranque \(Splash\) y Estados Globales

<a id="lib01_splash_screensplash_page.dart"></a>### lib/01\_splash\_screen/splash\_page\.dart

- __Contenido general:__ Pantalla transitoria mostrada al iniciar la app\. Mantiene un temporizador \(3 segundos\) mientras en segundo plano dispara chequeos de plataforma y conectividad, para luego decidir la navegación a la pantalla principal o a error de red\.
- __Clases:__ SplashPage, \_SplashPageState\.
- __Widgets:__ SplashPage \(StatefulWidget\), Scaffold con logo y un CircularProgressIndicator\.
- __Providers/Modelos:__ Consume checaConeccionesProvider, invoca el actualizador de plataforma\.

<a id="X450c68f3b739c787677237f436720fd02fd0bc8"></a>### lib/41\_connectivity/connectivitycheck\_provider\.dart

- __Contenido general:__ Monitorea de forma continua la conexión a internet\.
- __Clases:__ ElementoDeConeccion, ChecaConeccionesNotifier\.
- __Widgets:__ Ninguno\.
- __Providers/Modelos:__ checaConeccionesProvider \(AsyncNotifierProvider\), modelo ElementoDeConeccion \(que indica “Conectado” o “Sin conexión”\)\.

<a id="lib42_sistema_operativodetecta_os.dart"></a>### lib/42\_sistema\_operativo/detecta\_os\.dart

- __Contenido general:__ Detecta la plataforma subyacente \(Android, iOS, Web, Windows\) y actualiza el estado correspondiente\.
- __Clases:__ Ninguna \(basado en funciones puras y StateProvider\)\.
- __Widgets:__ Ninguno\.
- __Providers/Modelos:__ checaPlataformaProvider \(StateProvider\), método setCheckPlataformaProvider\(ref\)\.

<a id="navegación-principal-y-menús"></a>## 3\. Navegación Principal y Menús

<a id="X775a1d4faa76fea3203d4b5acdf2aa86643290a"></a>### lib/02\_principal\_screen/principal\_sliver\_screen\_menus\_inicio\.dart

- __Contenido general:__ Es el “esqueleto” principal de la aplicación\. Maneja el estado global de la navegación en la pantalla principal\. Crea los TabControllers para 7 menús distintos, escucha el estado del GPS y dibuja el cajón \(Drawer\) y el AppBar superior \(Slivers\)\.
- __Clases:__ PrincipalSliversMenuInicial, \_PrincipalSliversMenuInicialState\.
- __Widgets:__ PrincipalSliversMenuInicial \(ConsumerStatefulWidget\)\. Construye un Scaffold con un CustomScrollView\.
- __Providers/Modelos:__ Consume gran cantidad de providers de menús \(ej\. menuInicialProvider, menuPrincipalProvider\) y lanza \_triggerLocationUpdate\(\) interactuando con ubicacionActualProvider\.

<a id="X5b934e283d199e550f12ff205ca9c72d6d0ed00"></a>### lib/20\_var\_globales/var\_elementos\_menus\.dart

- __Contenido general:__ Archivo de constantes y modelos de datos que define absolutamente todos los elementos de los menús \(ítems de navegación, iconos asociados, etiquetas, índices\)\. Configura qué iconos y textos van en “Inicio”, “Tu Cuenta”, “Mis Grupos”, etc\.
- __Clases:__ ElementosMenus, ElementoSeleccionado\.
- __Widgets:__ Ninguno\.
- __Providers/Modelos:__ Modelos puros \(ElementosMenus\)\. Exporta múltiples listas como elementosMenuPrincipal, elementosMenuGrupos, etc\.

<a id="X2d9cbd83192804f35dab879e24f9169a7490eea"></a>### lib/05\_provider\_menus/provider\_menu\_tu\_cuenta\_usuario\.dart

- __Contenido general:__ Gestiona la lógica y el estado de selección de los tabs correspondientes a la cuenta del usuario \(“Listas”, “Grupos”, “Conocidos”\)\.
- __Clases:__ ElementosDelMenuTuCuentaUsuario, ClaseMenuTuCuentaUsuario\.
- __Widgets:__ Ninguno\.
- __Providers/Modelos:__ menuTuCuentaUsuarioProvider \(StateNotifierProvider\)\. Controla el TabController del submenú y qué opción está activa actualmente\.

<a id="geolocalización"></a>## 4\. Geolocalización

<a id="X559010c6914c2c1cd20af4e186cd0bb166714f1"></a>### lib/14\_geolocalizacion/provider\_actual\_place\.dart

- __Contenido general:__ Determina los permisos del GPS y obtiene la latitud/longitud del usuario, así como su Código Postal vía Geocoding \(nativo o de Google Maps si es Web\)\.
- __Clases:__ ClassLocalidadesNotifierProvider\.
- __Widgets:__ Ninguno\.
- __Providers/Modelos:__ ubicacionActualProvider \(NotifierProvider\)\. Utiliza GoogleMapPlaceData\.

<a id="X0a642a25cbee5a8ad8802f3cb8d875059b8c27d"></a>### lib/08\_pantallas/ubicacion/provider\_localidades\_del\_cp\.dart

- __Contenido general:__ Una vez que el GPS determina el Código Postal, este provider hace una llamada HTTP a Sepomex para recuperar las colonias/asentamientos de dicho CP\.
- __Clases:__ LocalidadesDeUnCodigoPostalNotifier\.
- __Widgets:__ Ninguno\.
- __Providers/Modelos:__ localidadesPorCodigoPostalProvider \(StateNotifierProvider\)\.

<a id="sesión-y-autenticación"></a>## 5\. Sesión y Autenticación

<a id="X86974519b7f3209881754e25f79c6ff900b403a"></a>### lib/10\_user\_login/usuario\_login/provider\_session\.dart

- __Contenido general:__ El núcleo del estado de usuario en BuscoBien\. Mantiene en memoria si hay un usuario logueado, sus credenciales y tipo de perfil \(Usuario / Promotor\)\. Controla los flujos de login y logout\.
- __Clases:__ SessionNotifier\.
- __Widgets:__ Ninguno\.
- __Providers/Modelos:__ sessionProvider \(StateNotifierProvider o AsyncNotifierProvider basado en Riverpod Generator\), que expone el modelo AuthState\.

<a id="módulos-y-páginas-ejemplos-principales"></a>## 6\. Módulos y Páginas \(Ejemplos Principales\)

<a id="X991d74f5b2c950b70e8b5b9c5a0049f96aeec3f"></a>### lib/08\_pantallas/inicio/pagina\_inicio\_busca\_espacios\.dart

- __Contenido general:__ Es la Landing Page inicial que el usuario ve al arrancar exitosamente la app, que permite iniciar búsquedas de inmuebles y servicios\.
- __Clases:__ PageInicio\.
- __Widgets:__ PageInicio \(ConsumerWidget\)\.
- __Providers/Modelos:__ Lee y muestra categorías de var\_elementos\_menus\.dart\.

<a id="X29a65885d48f27d1e03e97b8c8e7acaf5103c58"></a>### lib/08\_pantallas/tu\_cuenta/grupos/page\_mis\_grupos\.dart

- __Contenido general:__ La página base del motor social para Grupos\. Conecta los UI elements creados en iteraciones pasadas con los endpoints HTTP\.
- __Clases:__ MisGruposView, \_MisGruposViewState\.
- __Widgets:__ MisGruposView \(ConsumerStatefulWidget\)\.
- __Providers/Modelos:__ Consume gruposUsuarioProvider y invitacionesProvider para poblar listas y badges\.

<a id="X889455f284f3a81cfdfda415f52ab258289fb1a"></a>## 7\. Profundización: Directorio lib/08\_pantallas

Este directorio \(compuesto por 68 archivos \.dart\) aloja las __interfaces gráficas de usuario \(vistas y pantallas\)__ que agrupan los distintos módulos funcionales de BuscoBien\. Adicionalmente a los widgets, dentro de estas subcarpetas suelen alojarse modelos de datos o providers fuertemente acoplados a estas pantallas\.

<a id="módulo-inicio-búsqueda-y-exploración"></a>### 7\.1 Módulo inicio \(Búsqueda y Exploración\)

Contiene la pantalla principal del Home y su lógica de presentación paginada de inmuebles\. \* __pagina\_inicio\_busca\_espacios\.dart__ \* __Contenido:__ Landing page interactiva\. Muestra un carril de navegación lateral \(NavigationRail\) y filtros superiores, además de una cuadrícula de propiedades\. \* __Clases/Widgets:__ PaginaBuscaEspacios \(ConsumerStatefulWidget\), \_PaginaBuscaEspaciosState\. \* __Providers:__ Consume variables reactivas de Riverpod como findPropiedadesEstadosde10en10Provider y viewCountFilterPropiedadesProvider para gestionar la paginación a BD\. \* __http\_find\_propiedades\_10en10\.dart y http\_view\_count\_filter\_propiedades\.dart__ \* __Contenido:__ Clientes HTTP \(apoyados en @riverpod / Riverpod Generator\) dedicados a hacer la consulta POST a CouchDB con los filtros activos y recuperar los JSON en bloques \(ej\. de 10 en 10\)\. \* __widget\_wrap\_modern\_card\.dart__ \* __Contenido:__ Contiene el widget individual \(tarjeta\) que representa una propiedad específica en el listado\.

<a id="módulo-tu_cuentaconocidos-red-1-a-1"></a>### 7\.2 Módulo tu\_cuenta/conocidos \(Red 1\-a\-1\)

Es el motor social enfocado en las conexiones individuales entre usuarios \(“Conocidos”\)\. \* __conocidos\_view\.dart, page\_mis\_contactos\.dart, page\_descubrir\_usuarios\.dart__ \* __Contenido:__ Páginas \(Widgets\) donde el usuario puede visualizar su lista de amigos/contactos aceptados, descubrir nuevos perfiles, o ver las invitaciones pendientes de aceptar\. \* __models/conocido\.dart, invitacion\_model\.dart__ \* __Contenido:__ Clases inmutables construidas con el paquete freezed \(@freezed\) que mapean los datos JSON de la base de datos a objetos de Dart fuertemente tipados\. \* __providers/conocidos\_notifier\.dart, social\_providers\.dart__ \* __Contenido:__ Providers \(StateNotifier\) que administran el arreglo de conocidos, despachan acciones como “enviar invitación” o “aceptar contacto” actualizando la UI de forma reactiva\.

<a id="X0b25ed3e933b74bbc4a9f2dafbae04498954c40"></a>### 7\.3 Módulo tu\_cuenta/grupos \(Motor Social de Grupos\)

Gestión de comunidades y espacios grupales \(estilo foros o chats inmobiliarios\)\. \* __page\_mis\_grupos\.dart, page\_detalle\_grupo\.dart, page\_chat\_grupo\.dart__ \* __Contenido:__ Todo el flujo gráfico para que un usuario liste los grupos a los que pertenece, visualice la información/administración de un grupo específico, e ingrese a un chat en tiempo real grupal\. \* __models/grupo\_model\.dart, invitacion\_grupo\_model\.dart, mensaje\_grupo\_model\.dart__ \* __Contenido:__ Definiciones con freezed correspondientes a la estructura JSON para colecciones de CouchDB \(campos como nombre, administrador, miembros, texto de mensajes, estampas de tiempo\)\. \* __providers/grupos\_notifier\.dart, grupos\_mensajes\_provider\.dart__ \* __Contenido:__ Providers y repositorios HTTP que inyectan los datos de grupos e historial de chat en las vistas, manejando los estados de carga y error\.

<a id="Xa0229a59cff09c5ed4f4d46fa5c267be95eca7a"></a>### 7\.4 Módulo tu\_cuenta/tus\_espacios \(Gestor del Promotor/Propietario\)

Donde el usuario administrador sube e inventaría sus inmuebles\. \* __pagina\_tus\_espacios\.dart__ \* __Contenido:__ El “Dashboard” del promotor\. Pantalla donde se listan todas las propiedades que ha dado de alta\. \* __form\_crea\_ficha\_captura\_propiedad\.dart, form\_update\_espacio\_comprado\.dart__ \* __Contenido:__ Formularios extensos que recopilan datos duros de la propiedad \(precio, recámaras, m2, descripción\)\. Utilizan controladores de texto y validación de formularios \(FormKey\)\. \* __compra\_espacios/form\_compra\_espacios\.dart__ \* __Contenido:__ Interfaz dedicada al proceso comercial \(pasarela\) donde el promotor puede adquirir “espacios/fichas” adicionales para publicar\.

<a id="X3269904daabd8306bb05ac5a6d60359f7a635f3"></a>### 7\.5 Módulo ubicacion \(Directorios y Coordenadas\)

Componentes gráficos y de datos enfocados exclusivamente en la posición geográfica del usuario o inmueble\. \* __screen\_maestro\_localidades\.dart, pagina\_busca\_localidades\_gmaps\.dart__ \* __Contenido:__ Pantallas auxiliares que se abren \(ej\. como modales o pantallas completas\) para que el usuario busque manualmente un Código Postal o utilice Google Maps para ajustar un “Pin” en el mapa\. \* __data\_sepomex\_localidades\.dart, data\_localidad\_find\.dart__ \* __Contenido:__ Modelos de datos estructurados para procesar las catálogos de asentamientos, municipios y estados de México provenientes de la API de Sepomex\.

<a id="módulo-propiedades-vista-de-detalle"></a>### 7\.6 Módulo propiedades \(Vista de Detalle\)

- __pagina\_detalle\_propiedad\.dart__
	- __Contenido:__ Cuando se hace clic en una tarjeta del inicio, esta pantalla dibuja el carrusel de fotografías, amenidades, precio y datos de contacto del promotor\.
- __pagina\_detalle\_propiedad\_pdf\.dart__
	- __Contenido:__ Lógica acoplada a una vista para generar dinámicamente un documento exportable en formato PDF \(una “Ficha Técnica”\) de la propiedad\.

