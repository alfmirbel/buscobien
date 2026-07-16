# Reporte de Archivos `.dart` (Flujo de Operación y Menús)

A continuación se detalla el análisis de los archivos principales que componen el flujo de inicialización, enrutamiento y menús de navegación de BuscoBien, basado en el diagrama de `flujo_operacion_buscobien.md` y la estructura de menús.

---

## 1. Bootstrap y Enrutamiento

### `lib/main.dart`
* **Contenido general:** Es el punto de entrada principal de la aplicación. Configura inicializaciones críticas de Flutter, la estrategia de URLs para Web, bloquea la orientación y levanta el contenedor raíz de Riverpod (`ProviderScope`).
* **Clases:** `BuscoBienApp` (clase principal de la app).
* **Widgets:** `BuscoBienApp` (StatelessWidget que retorna un `MaterialApp`).
* **Providers/Modelos:** No define providers, pero implementa el `ProviderScope` que envuelve toda la app.

### `lib/07_routes/app_routes.dart`
* **Contenido general:** Centraliza las rutas de navegación de la app utilizando un sistema de constantes de string y una función generadora de rutas.
* **Clases:** `AppRoutes` (agrupa constantes estáticas).
* **Widgets:** No define widgets propios, pero invoca pantallas como `SplashPage` o `PrincipalSliversMenuInicial`.
* **Providers/Modelos:** Ninguno.
* **Métodos clave:** `routeGenerate(RouteSettings settings)` que funciona como el router principal de `MaterialApp`.

---

## 2. Pantalla de Arranque (Splash) y Estados Globales

### `lib/01_splash_screen/splash_page.dart`
* **Contenido general:** Pantalla transitoria mostrada al iniciar la app. Mantiene un temporizador (3 segundos) mientras en segundo plano dispara chequeos de plataforma y conectividad, para luego decidir la navegación a la pantalla principal o a error de red.
* **Clases:** `SplashPage`, `_SplashPageState`.
* **Widgets:** `SplashPage` (StatefulWidget), `Scaffold` con logo y un `CircularProgressIndicator`.
* **Providers/Modelos:** Consume `checaConeccionesProvider`, invoca el actualizador de plataforma.

### `lib/41_connectivity/connectivitycheck_provider.dart`
* **Contenido general:** Monitorea de forma continua la conexión a internet.
* **Clases:** `ElementoDeConeccion`, `ChecaConeccionesNotifier`.
* **Widgets:** Ninguno.
* **Providers/Modelos:** `checaConeccionesProvider` (AsyncNotifierProvider), modelo `ElementoDeConeccion` (que indica "Conectado" o "Sin conexión").

### `lib/42_sistema_operativo/detecta_os.dart`
* **Contenido general:** Detecta la plataforma subyacente (Android, iOS, Web, Windows) y actualiza el estado correspondiente.
* **Clases:** Ninguna (basado en funciones puras y StateProvider).
* **Widgets:** Ninguno.
* **Providers/Modelos:** `checaPlataformaProvider` (StateProvider), método `setCheckPlataformaProvider(ref)`.

---

## 3. Navegación Principal y Menús

### `lib/02_principal_screen/principal_sliver_screen_menus_inicio.dart`
* **Contenido general:** Es el "esqueleto" principal de la aplicación. Maneja el estado global de la navegación en la pantalla principal. Crea los `TabControllers` para 7 menús distintos, escucha el estado del GPS y dibuja el cajón (Drawer) y el AppBar superior (Slivers).
* **Clases:** `PrincipalSliversMenuInicial`, `_PrincipalSliversMenuInicialState`.
* **Widgets:** `PrincipalSliversMenuInicial` (ConsumerStatefulWidget). Construye un `Scaffold` con un `CustomScrollView`.
* **Providers/Modelos:** Consume gran cantidad de providers de menús (ej. `menuInicialProvider`, `menuPrincipalProvider`) y lanza `_triggerLocationUpdate()` interactuando con `ubicacionActualProvider`.

### `lib/20_var_globales/var_elementos_menus.dart`
* **Contenido general:** Archivo de constantes y modelos de datos que define absolutamente todos los elementos de los menús (ítems de navegación, iconos asociados, etiquetas, índices). Configura qué iconos y textos van en "Inicio", "Tu Cuenta", "Mis Grupos", etc.
* **Clases:** `ElementosMenus`, `ElementoSeleccionado`.
* **Widgets:** Ninguno.
* **Providers/Modelos:** Modelos puros (`ElementosMenus`). Exporta múltiples listas como `elementosMenuPrincipal`, `elementosMenuGrupos`, etc.

### `lib/05_provider_menus/provider_menu_tu_cuenta_usuario.dart`
* **Contenido general:** Gestiona la lógica y el estado de selección de los tabs correspondientes a la cuenta del usuario ("Listas", "Grupos", "Conocidos").
* **Clases:** `ElementosDelMenuTuCuentaUsuario`, `ClaseMenuTuCuentaUsuario`.
* **Widgets:** Ninguno.
* **Providers/Modelos:** `menuTuCuentaUsuarioProvider` (StateNotifierProvider). Controla el `TabController` del submenú y qué opción está activa actualmente.

---

## 4. Geolocalización

### `lib/14_geolocalizacion/provider_actual_place.dart`
* **Contenido general:** Determina los permisos del GPS y obtiene la latitud/longitud del usuario, así como su Código Postal vía Geocoding (nativo o de Google Maps si es Web).
* **Clases:** `ClassLocalidadesNotifierProvider`.
* **Widgets:** Ninguno.
* **Providers/Modelos:** `ubicacionActualProvider` (NotifierProvider). Utiliza `GoogleMapPlaceData`.

### `lib/08_pantallas/ubicacion/provider_localidades_del_cp.dart`
* **Contenido general:** Una vez que el GPS determina el Código Postal, este provider hace una llamada HTTP a Sepomex para recuperar las colonias/asentamientos de dicho CP.
* **Clases:** `LocalidadesDeUnCodigoPostalNotifier`.
* **Widgets:** Ninguno.
* **Providers/Modelos:** `localidadesPorCodigoPostalProvider` (StateNotifierProvider).

---

## 5. Sesión y Autenticación

### `lib/10_user_login/usuario_login/provider_session.dart`
* **Contenido general:** El núcleo del estado de usuario en BuscoBien. Mantiene en memoria si hay un usuario logueado, sus credenciales y tipo de perfil (Usuario / Promotor). Controla los flujos de login y logout.
* **Clases:** `SessionNotifier`.
* **Widgets:** Ninguno.
* **Providers/Modelos:** `sessionProvider` (StateNotifierProvider o AsyncNotifierProvider basado en Riverpod Generator), que expone el modelo `AuthState`.

---

## 6. Módulos y Páginas (Ejemplos Principales)

### `lib/08_pantallas/inicio/pagina_inicio_busca_espacios.dart`
* **Contenido general:** Es la Landing Page inicial que el usuario ve al arrancar exitosamente la app, que permite iniciar búsquedas de inmuebles y servicios.
* **Clases:** `PageInicio`.
* **Widgets:** `PageInicio` (ConsumerWidget).
* **Providers/Modelos:** Lee y muestra categorías de `var_elementos_menus.dart`.

### `lib/08_pantallas/tu_cuenta/grupos/page_mis_grupos.dart`
* **Contenido general:** La página base del motor social para Grupos. Conecta los UI elements creados en iteraciones pasadas con los endpoints HTTP.
* **Clases:** `MisGruposView`, `_MisGruposViewState`.
* **Widgets:** `MisGruposView` (ConsumerStatefulWidget).
* **Providers/Modelos:** Consume `gruposUsuarioProvider` y `invitacionesProvider` para poblar listas y badges.

---

## 7. Profundización: Directorio `lib/08_pantallas`

Este directorio (compuesto por 68 archivos `.dart`) aloja las **interfaces gráficas de usuario (vistas y pantallas)** que agrupan los distintos módulos funcionales de BuscoBien. Adicionalmente a los widgets, dentro de estas subcarpetas suelen alojarse modelos de datos o providers fuertemente acoplados a estas pantallas.

### 7.1 Módulo `inicio` (Búsqueda y Exploración)
Contiene la pantalla principal del Home y su lógica de presentación paginada de inmuebles.
* **`pagina_inicio_busca_espacios.dart`**
  * **Contenido:** Landing page interactiva. Muestra un carril de navegación lateral (`NavigationRail`) y filtros superiores, además de una cuadrícula de propiedades.
  * **Clases/Widgets:** `PaginaBuscaEspacios` (ConsumerStatefulWidget), `_PaginaBuscaEspaciosState`.
  * **Providers:** Consume variables reactivas de Riverpod como `findPropiedadesEstadosde10en10Provider` y `viewCountFilterPropiedadesProvider` para gestionar la paginación a BD.
* **`http_find_propiedades_10en10.dart` y `http_view_count_filter_propiedades.dart`**
  * **Contenido:** Clientes HTTP (apoyados en `@riverpod` / Riverpod Generator) dedicados a hacer la consulta `POST` a CouchDB con los filtros activos y recuperar los JSON en bloques (ej. de 10 en 10).
* **`widget_wrap_modern_card.dart`**
  * **Contenido:** Contiene el widget individual (tarjeta) que representa una propiedad específica en el listado.

### 7.2 Módulo `tu_cuenta/conocidos` (Red 1-a-1)
Es el motor social enfocado en las conexiones individuales entre usuarios ("Conocidos").
* **`conocidos_view.dart`, `page_mis_contactos.dart`, `page_descubrir_usuarios.dart`**
  * **Contenido:** Páginas (Widgets) donde el usuario puede visualizar su lista de amigos/contactos aceptados, descubrir nuevos perfiles, o ver las invitaciones pendientes de aceptar.
* **`models/conocido.dart`, `invitacion_model.dart`**
  * **Contenido:** Clases inmutables construidas con el paquete `freezed` (`@freezed`) que mapean los datos JSON de la base de datos a objetos de Dart fuertemente tipados.
* **`providers/conocidos_notifier.dart`, `social_providers.dart`**
  * **Contenido:** Providers (`StateNotifier`) que administran el arreglo de conocidos, despachan acciones como "enviar invitación" o "aceptar contacto" actualizando la UI de forma reactiva.

### 7.3 Módulo `tu_cuenta/grupos` (Motor Social de Grupos)
Gestión de comunidades y espacios grupales (estilo foros o chats inmobiliarios).
* **`page_mis_grupos.dart`, `page_detalle_grupo.dart`, `page_chat_grupo.dart`**
  * **Contenido:** Todo el flujo gráfico para que un usuario liste los grupos a los que pertenece, visualice la información/administración de un grupo específico, e ingrese a un chat en tiempo real grupal.
* **`models/grupo_model.dart`, `invitacion_grupo_model.dart`, `mensaje_grupo_model.dart`**
  * **Contenido:** Definiciones con `freezed` correspondientes a la estructura JSON para colecciones de CouchDB (campos como nombre, administrador, miembros, texto de mensajes, estampas de tiempo).
* **`providers/grupos_notifier.dart`, `grupos_mensajes_provider.dart`**
  * **Contenido:** Providers y repositorios HTTP que inyectan los datos de grupos e historial de chat en las vistas, manejando los estados de carga y error.

### 7.4 Módulo `tu_cuenta/tus_espacios` (Gestor del Promotor/Propietario)
Donde el usuario administrador sube e inventaría sus inmuebles.
* **`pagina_tus_espacios.dart`**
  * **Contenido:** El "Dashboard" del promotor. Pantalla donde se listan todas las propiedades que ha dado de alta.
* **`form_crea_ficha_captura_propiedad.dart`, `form_update_espacio_comprado.dart`**
  * **Contenido:** Formularios extensos que recopilan datos duros de la propiedad (precio, recámaras, m2, descripción). Utilizan controladores de texto y validación de formularios (`FormKey`).
* **`compra_espacios/form_compra_espacios.dart`**
  * **Contenido:** Interfaz dedicada al proceso comercial (pasarela) donde el promotor puede adquirir "espacios/fichas" adicionales para publicar.

### 7.5 Módulo `ubicacion` (Directorios y Coordenadas)
Componentes gráficos y de datos enfocados exclusivamente en la posición geográfica del usuario o inmueble.
* **`screen_maestro_localidades.dart`, `pagina_busca_localidades_gmaps.dart`**
  * **Contenido:** Pantallas auxiliares que se abren (ej. como modales o pantallas completas) para que el usuario busque manualmente un Código Postal o utilice Google Maps para ajustar un "Pin" en el mapa.
* **`data_sepomex_localidades.dart`, `data_localidad_find.dart`**
  * **Contenido:** Modelos de datos estructurados para procesar las catálogos de asentamientos, municipios y estados de México provenientes de la API de Sepomex.

### 7.6 Módulo `propiedades` (Vista de Detalle)
* **`pagina_detalle_propiedad.dart`**
  * **Contenido:** Cuando se hace clic en una tarjeta del inicio, esta pantalla dibuja el carrusel de fotografías, amenidades, precio y datos de contacto del promotor.
* **`pagina_detalle_propiedad_pdf.dart`**
  * **Contenido:** Lógica acoplada a una vista para generar dinámicamente un documento exportable en formato PDF (una "Ficha Técnica") de la propiedad.
