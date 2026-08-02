# <a id="flujo-de-operación-buscobien"></a>Flujo de Operación — BuscoBien

## <a id="X173f23268ae231011b830f22e0cd7ea879a6ac1"></a>Desde el inicio hasta que el usuario puede interactuar

## <a id="diagrama-general"></a>Diagrama General

flowchart TD  
    A\["▶ main\(\)"\] \-\-> B\["WidgetsFlutterBinding\.ensureInitialized\(\)"\]  
    B \-\-> C\["setPathUrlStrategy\(\)\\nFija URLs limpias en Web"\]  
    C \-\-> D\["SystemChrome → Portrait Only"\]  
    D \-\-> E\["lcwc = 0\\nReinicia contador de debug"\]  
    E \-\-> F\["runApp ProviderScope\\n→ BuscoBienApp\(\)"\]  
  
    F \-\-> G\["BuscoBienApp\.build\(\)\\nMaterialApp \+ ThemeData MD3"\]  
    G \-\-> H\["initialRoute: AppRoutes\.main → routeGenerate\(\)"\]  
    H \-\-> I\["case AppRoutes\.main\\n→ SplashPage\(duration:3, goToPage: PrincipalSliversMenuInicial\)"\]  
  
    I \-\-> J\["SplashPage\.initState\(\)"\]  
    J \-\-> K\["\_startSplashTimer\(\)\\nFuture\.delayed 3 segundos"\]  
    J \-\-> L\["addPostFrameCallback\\n→ setCheckPlataformaProvider\(ref\)"\]  
    L \-\-> M\["checaPlataformaProvider actualizado\\nDetecta: Web/Android/iOS/Windows/etc\."\]  
    J \-\-> N\["ref\.read\(checaConeccionesProvider\)\\nChequeo inicial de red"\]  
  
    K \-\-> O\["\_minDurationPassed = true"\]  
    O \-\-> P\["\_attemptNavigation\(\)"\]  
    N \-\-> P  
  
    P \-\-> Q\{¿Hay conexión?\}  
    Q \-\- Sí \-\-> R\["Navigator\.pushReplacementNamed\\nAppRoutes\.principal"\]  
    Q \-\- No \-\-> S\["Navigator\.pushNamed\\nAppRoutes\.sinconeccion"\]  
  
    R \-\-> T\["PrincipalSliversMenuInicial\.initState\(\)"\]  
    T \-\-> U\["\_inicializarSoloControladores\(\)\\n7 TabControllers inicializados sincronamente"\]  
    T \-\-> V\["addPostFrameCallback\\n→ \_inicializarLogicaDeNegocio\(\)"\]  
    T \-\-> W\["\_triggerLocationUpdate\(\) async\\nen background"\]  
  
    V \-\-> X\["7 providers de menú\\nasignaNuevaOpcionSeleccionada \+ restablece"\]  
  
    W \-\-> Y\["ubicacionActualProvider\.notifier\\n\.determinePermisosUbicacion\(\)"\]  
    Y \-\-> Z\{¿Permisos OK?\}  
    Z \-\- Sí \-\-> AA\["locationNotifier\.determinaUbicacion\(\)\\nGPS \+ Geocoding API"\]  
    AA \-\-> AB\["localidadesPorCodigoPostalProvider\\n\.fetchLocaliadesCodigoPostal\(\)"\]  
    Z \-\- No \-\-> AC\["Log error, flujo continúa\\nsin ubicación"\]  
  
    T \-\-> AD\["PrincipalSliversMenuInicial\.build\(\)\\nScaffold con AppBar \+ Drawer \+ CustomScrollView"\]  
    AD \-\-> AE\["ref\.listen: homeNavigationProvider\\nScroll al inicio en cambio de sección"\]  
    AD \-\-> AF\["ref\.listen: checaConeccionesProvider\\nRedirige a sinconeccion si se pierde la red"\]  
    AD \-\-> AG\["menuSuperiorMenuInicial\(ref\)\\nPrimer SliverAppBar con TabBar"\]  
    AD \-\-> AH\["navState\.indiceInicial == 0\\n→ PageInicio\(\) visible al usuario"\]  
  
    AH \-\-> AI\["✅ USUARIO PUEDE INTERACTUAR"\]

## <a id="pasos-detallados"></a>Pasos Detallados

### <a id="paso-1-bootstrap-de-la-aplicación"></a>PASO 1 — Bootstrap de la aplicación

__Funcionalidad:__ Configuración inicial del framework Flutter antes de renderizar nada\.

Acción

Detalle

WidgetsFlutterBinding\.ensureInitialized\(\)

Conecta el motor Flutter con la plataforma host

setPathUrlStrategy\(\)

Elimina el \# de las URLs en Web

SystemChrome\.setPreferredOrientations\(\.\.\.\)

Bloquea la orientación a Portrait

lcwc = 0

Reinicia el contador de nivel de debug

runApp\(ProviderScope\(\.\.\.\)\)

Crea el contenedor raíz de Riverpod e inicia el árbol de widgets

__Archivos:__ \- [main\.dart](file:///d:/buscobien/lib/main.dart) — punto de entrada único

### <a id="X115b45e4e2bd3e77f61d0dd9182fbc62a29a36f"></a>PASO 2 — Configuración del tema y el enrutador

__Funcionalidad:__ BuscoBienApp construye el MaterialApp con Material Design 3\.

Acción

Detalle

ThemeData\(useMaterial3: true\)

Aplica MD3 globalmente

NavigationBarThemeData

Configura colores de iconos/etiquetas de la barra de navegación

initialRoute: AppRoutes\.main

Indica la ruta inicial \("/"\)

onGenerateRoute → routeGenerate\(\)

Función central de enrutamiento

__Archivos:__ \- [main\.dart](file:///d:/buscobien/lib/main.dart) \- [20\_var\_globales/var\_color\_themes\.dart](file:///d:/buscobien/lib/20_var_globales/var_color_themes.dart) — appTheme y tokens de color \- [20\_var\_globales/var\_login\.dart](file:///d:/buscobien/lib/20_var_globales/var_login.dart) — appName \- [07\_routes/app\_routes\.dart](file:///d:/buscobien/lib/07_routes/app_routes.dart) — constantes de rutas y routeGenerate\(\)

### <a id="paso-3-resolución-de-la-ruta-splashpage"></a>PASO 3 — Resolución de la ruta / → SplashPage

__Funcionalidad:__ routeGenerate\(\) detecta la ruta AppRoutes\.main y devuelve el widget SplashPage\.

Acción

Detalle

case AppRoutes\.main

Resuelve ruta "/"

SplashPage\(3, duration: 3, goToPage: PrincipalSliversMenuInicial\(\)\)

Instancia el splash con 3 segundos de duración

__Archivos:__ \- [07\_routes/app\_routes\.dart](file:///d:/buscobien/lib/07_routes/app_routes.dart) — routeGenerate\(\)

### <a id="paso-4-splash-screen-inicialización"></a>PASO 4 — Splash Screen: inicialización

__Funcionalidad:__ SplashPage\.initState\(\) lanza en paralelo el temporizador y las detecciones de plataforma/conectividad\.

Acción

Método/Provider

Archivo

Temporizador visual 3 seg

\_startSplashTimer\(\) → Future\.delayed

splash\_page\.dart

Detección de plataforma

setCheckPlataformaProvider\(ref\) en addPostFrameCallback

42\_sistema\_operativo/detecta\_os\.dart

Chequeo de conectividad inicial

ref\.read\(checaConeccionesProvider\)

41\_connectivity/connectivitycheck\_provider\.dart

\[\!NOTE\] El addPostFrameCallback garantiza que el árbol de widgets ya está pintado antes de ejecutar código que accede a ref\.

__Archivos:__ \- [01\_splash\_screen/splash\_page\.dart](file:///d:/buscobien/lib/01_splash_screen/splash_page.dart) \- [42\_sistema\_operativo/detecta\_os\.dart](file:///d:/buscobien/lib/42_sistema_operativo/detecta_os.dart) \- [41\_connectivity/connectivitycheck\_provider\.dart](file:///d:/buscobien/lib/41_connectivity/connectivitycheck_provider.dart)

### <a id="X391280d3ae4ac99eb5e7d9d96f4c9571ddf562f"></a>PASO 5 — Provider de Conectividad: ChecaConeccionesNotifier

__Funcionalidad:__ AsyncNotifierProvider que monitorea la red en tiempo real durante toda la sesión\.

Acción

Detalle

connectivity\.checkConnectivity\(\)

Chequeo inicial del estado de red

connectivity\.onConnectivityChanged\.listen\(\.\.\.\)

Suscripción continua a cambios de red

\_logicaAsignaConectividad\(result\)

Mapea ConnectivityResult a ElementoDeConeccion

ref\.onDispose\(\(\) => subscription\.cancel\(\)\)

Limpieza del stream al destruir el provider

__Resultado:__ ElementoDeConeccion con etiqueta = "Conectado" o "Sin conexión"\.

__Archivos:__ \- [41\_connectivity/connectivitycheck\_provider\.dart](file:///d:/buscobien/lib/41_connectivity/connectivitycheck_provider.dart)

### <a id="Xde14fddda7bdee5aaa77af276d0f59dcaee7fee"></a>PASO 6 — Provider de Plataforma: checaPlataformaProvider

__Funcionalidad:__ Detecta el sistema operativo/plataforma para adaptar comportamientos \(geolocalización, etc\.\)\.

Plataforma detectada

Resultado en provider

kIsWeb == true

etiqueta = "Web u otro", index 6

TargetPlatform\.android

etiqueta = "android", index 0

TargetPlatform\.windows

etiqueta = "windows", index 5

iOS, Linux, macOS, Fuchsia

Respectivos índices

__Archivos:__ \- [42\_sistema\_operativo/detecta\_os\.dart](file:///d:/buscobien/lib/42_sistema_operativo/detecta_os.dart) — setCheckPlataformaProvider\(\) \+ checaPlataformaProvider

### <a id="Xb871360ac0c4938cf74367b2b49206e4f976625"></a>PASO 7 — Decisión de navegación en SplashPage

__Funcionalidad:__ \_attemptNavigation\(\) evalúa si se cumplen las condiciones para avanzar\.

\_minDurationPassed = true  AND  checaConeccionesProvider == "Conectado"  
       ↓ SÍ                            ↓ NO  
pushReplacementNamed\(         pushNamed\(AppRoutes\.sinconeccion\)  
  AppRoutes\.principal\)

__Archivos:__ \- [01\_splash\_screen/splash\_page\.dart](file:///d:/buscobien/lib/01_splash_screen/splash_page.dart) — \_attemptNavigation\(\) \- [41\_connectivity/pagina\_sin\_coneccion\.dart](file:///d:/buscobien/lib/41_connectivity/pagina_sin_coneccion.dart) — pantalla de error de red

### <a id="X33b75f2d46db4779d382d9f4527a2706693390e"></a>PASO 8 — PrincipalSliversMenuInicial: initState

__Funcionalidad:__ Inicialización de los 7 controladores de menú y la lógica de negocio\.

#### <a id="X3ff26118412f6616f4ef23b39190d37804ceeac"></a>Fase 8a — Síncrona: \_inicializarSoloControladores\(\)

Inicializa TabController para cada menú antes del primer build\(\):

Provider

Menú

menuInicialProvider

Tab Inicio \(Inicio / Propiedades / Landing pages\)

menuPrincipalProvider

Tab Principal \(Buscar, Localidades, Tu Cuenta, Perfil\)

menuNivelDeGobiernoProvider

Filtro por nivel de gobierno

menuTipoEspaciosProvider

Filtro por tipo de espacio

menuTipoDeTransaccionProvider

Filtro por tipo de transacción

menuTuCuentaProvider

Submenú cuenta Promotor

menuTuCuentaUsuarioProvider

Submenú cuenta Usuario

#### <a id="X17dacd3ff4e7ede88085a01942bae151fb23aea"></a>Fase 8b — Asíncrona: \_inicializarLogicaDeNegocio\(\) \(post\-frame\)

Para cada uno de los 7 menús ejecuta: 1\. asignaNuevaOpcionSeleccionada\(ref, seleccionActual\) — sincroniza el TabController con el estado del provider 2\. restableceOpcionActualSeleccionada\(ref\) — aplica la selección en la UI

__Archivos:__ \- [02\_principal\_screen/principal\_sliver\_screen\_menus\_inicio\.dart](file:///d:/buscobien/lib/02_principal_screen/principal_sliver_screen_menus_inicio.dart) \- [05\_provider\_menus/provider\_menu\_inicial\.dart](file:///d:/buscobien/lib/05_provider_menus/provider_menu_inicial.dart) \- [05\_provider\_menus/provider\_menu\_principal\.dart](file:///d:/buscobien/lib/05_provider_menus/provider_menu_principal.dart) \- [05\_provider\_menus/provider\_menu\_nivel\_gobierno\.dart](file:///d:/buscobien/lib/05_provider_menus/provider_menu_nivel_gobierno.dart) \- [05\_provider\_menus/provider\_menu\_tipo\_espacio\.dart](file:///d:/buscobien/lib/05_provider_menus/provider_menu_tipo_espacio.dart) \- [05\_provider\_menus/provider\_menu\_tipo\_de\_transaccion\.dart](file:///d:/buscobien/lib/05_provider_menus/provider_menu_tipo_de_transaccion.dart) \- [05\_provider\_menus/provider\_menu\_tu\_cuenta\.dart](file:///d:/buscobien/lib/05_provider_menus/provider_menu_tu_cuenta.dart) \- [05\_provider\_menus/provider\_menu\_tu\_cuenta\_usuario\.dart](file:///d:/buscobien/lib/05_provider_menus/provider_menu_tu_cuenta_usuario.dart)

### <a id="Xba0a77332b2c60dd368dd0ac7b86c05597fa7e1"></a>PASO 9 — Geolocalización en Background: \_triggerLocationUpdate\(\)

__Funcionalidad:__ Se lanza en segundo plano \(sin await\) para no bloquear la UI\.

\_triggerLocationUpdate\(\)  
   │  
   ├─ determinePermisosUbicacion\(\)  
   │     ├─ Geolocator\.isLocationServiceEnabled\(\)  
   │     ├─ Geolocator\.checkPermission\(\)  
   │     └─ Geolocator\.getCurrentPosition\(\) → lat/lon en state  
   │  
   └─ \(si permiso OK\) determinaUbicacion\(\)  
         ├─ Web/Windows: HTTP GET Geocoding API → googlemapPlaceFromJson\(\)  
         ├─ Android/iOS: placemarkFromCoordinates\(\) \(geocoding nativo\)  
         └─ setCodigoPostal\(cp\) → localidadesPorCodigoPostalProvider  
                     └─ fetchLocaliadesCodigoPostal\(\) → HTTP a Sepomex API

__Archivos:__ \- [02\_principal\_screen/principal\_sliver\_screen\_menus\_inicio\.dart](file:///d:/buscobien/lib/02_principal_screen/principal_sliver_screen_menus_inicio.dart) — \_triggerLocationUpdate\(\) \- [14\_geolocalizacion/provider\_actual\_place\.dart](file:///d:/buscobien/lib/14_geolocalizacion/provider_actual_place.dart) — ubicacionActualProvider, ClassLocalidadesNotifierProvider \- [14\_geolocalizacion/app\_keys\.dart](file:///d:/buscobien/lib/14_geolocalizacion/app_keys.dart) — GOOGLE\_MAPS\_KEY \- [08\_pantallas/ubicacion/provider\_localidades\_del\_cp\.dart](file:///d:/buscobien/lib/08_pantallas/ubicacion/provider_localidades_del_cp.dart) — localidadesPorCodigoPostalProvider

### <a id="Xd692b7cb9f8c72888dcf0ce3d6a558782a03872"></a>PASO 10 — Construcción de la Pantalla Principal \(build\)

__Funcionalidad:__ PrincipalSliversMenuInicial\.build\(\) ensambla el Scaffold completo\.

Componente

Widget/Archivo

AppBar superior con acciones

appBarPrincipal\(\) → [02\_principal\_screen/principal\_02\_page\_appbar\.dart](file:///d:/buscobien/lib/02_principal_screen/principal_02_page_appbar.dart)

Drawer lateral

MenuDrawer\(\) → [02\_principal\_screen/principal\_03\_page\_drawer\.dart](file:///d:/buscobien/lib/02_principal_screen/principal_03_page_drawer.dart)

Listener de navegación

ref\.listen\(homeNavigationProvider, \.\.\.\) — hace scroll al inicio

Listener de conectividad

ref\.listen\(checaConeccionesProvider, \.\.\.\) — redirige si se pierde la red

TabBar inicial

menuSuperiorMenuInicial\(ref\) → [05\_provider\_menus/appbar\_sliver\_menu\_inicial\.dart](file:///d:/buscobien/lib/05_provider_menus/appbar_sliver_menu_inicial.dart)

Contenido inicial

navState\.indiceInicial == 0 → PageInicio\(\) → [08\_pantallas/inicio/pagina\_inicio\_busca\_espacios\.dart](file:///d:/buscobien/lib/08_pantallas/inicio/pagina_inicio_busca_espacios.dart)

__Archivos principales:__ \- [02\_principal\_screen/principal\_sliver\_screen\_menus\_inicio\.dart](file:///d:/buscobien/lib/02_principal_screen/principal_sliver_screen_menus_inicio.dart) \- [01\_home/home\_navigation\_provider\.dart](file:///d:/buscobien/lib/01_home/home_navigation_provider.dart) — homeNavigationProvider \+ HomeState \- [01\_home/home\_state\.dart](file:///d:/buscobien/lib/01_home/home_state.dart) — modelo de estado de navegación

### <a id="Xa508eaf880df8677c757aa3978690ff8ed6971c"></a>PASO 11 — Estado inicial de sesión \(sin login\)

__Funcionalidad:__ Al arrancar, sessionProvider está en estado AuthState\.initial\(\) \(sin usuario\)\.

Estado

Valor

nombrePerfil

"" \(vacío\)

esPromotor / esUsuario

false

sessionUserData\.userId

""

El usuario ve PageInicio\(\) sin restricción\. Si navega a __Tu Cuenta__ sin sesión, se muestra \_vistaSinUsuario\(\) con un botón que abre dialogBoxFichaLogin\(\)\.

__Archivos:__ \- [10\_user\_login/usuario\_login/provider\_session\.dart](file:///d:/buscobien/lib/10_user_login/usuario_login/provider_session.dart) — SessionNotifier, sessionProvider \- [10\_user\_login/usuario\_login/dialogbox\_login\.dart](file:///d:/buscobien/lib/10_user_login/usuario_login/dialogbox_login.dart)

## <a id="resumen-cronológico"></a>Resumen Cronológico

t=0ms   main\(\) → ProviderScope → BuscoBienApp → routeGenerate → SplashPage  
t=1ms   SplashPage\.initState:  
          └─ \_startSplashTimer\(\) \[temporizador 3s\]  
          └─ postFrameCallback:  
                └─ setCheckPlataformaProvider\(\) \[detecta OS\]  
                └─ ref\.read\(checaConeccionesProvider\) \[chequea red\]  
t=~50ms checaConeccionesProvider\.build\(\):  
          └─ connectivity\.checkConnectivity\(\) \[resultado inicial\]  
          └─ onConnectivityChanged\.listen\(\) \[suscripción continua\]  
t=3000ms \_minDurationPassed = true → \_attemptNavigation\(\)  
          └─ \[si hay red\] pushReplacementNamed\(AppRoutes\.principal\)  
t=3001ms PrincipalSliversMenuInicial\.initState\(\):  
          └─ \_inicializarSoloControladores\(\) \[7 TabControllers\]  
          └─ postFrameCallback → \_inicializarLogicaDeNegocio\(\) \[7 menús\]  
          └─ \_triggerLocationUpdate\(\) \[GPS en background\]  
t=3002ms PrincipalSliversMenuInicial\.build\(\):  
          └─ Scaffold → AppBar \+ Drawer \+ CustomScrollView  
          └─ PageInicio\(\) renderizado  
✅ t≈3100ms  USUARIO PUEDE INTERACTUAR CON LA APP

## <a id="mapa-de-archivos-por-paso"></a>Mapa de Archivos por Paso

Paso

Módulo

Archivo principal

1

Bootstrap

lib/main\.dart

2

App & Tema

main\.dart, 20\_var\_globales/var\_color\_themes\.dart

3

Enrutamiento

07\_routes/app\_routes\.dart

4

Splash Screen

01\_splash\_screen/splash\_page\.dart

5

Conectividad

41\_connectivity/connectivitycheck\_provider\.dart

6

Plataforma

42\_sistema\_operativo/detecta\_os\.dart

7

Navegación

01\_splash\_screen/splash\_page\.dart, 41\_connectivity/pagina\_sin\_coneccion\.dart

8

Menús \(init\)

02\_principal\_screen/principal\_sliver\_screen\_menus\_inicio\.dart, 05\_provider\_menus/\*

9

Geolocalización

14\_geolocalizacion/provider\_actual\_place\.dart, 14\_geolocalizacion/app\_keys\.dart

10

Pantalla Principal

02\_principal\_screen/\*, 01\_home/\*, 05\_provider\_menus/\*

11

Sesión

10\_user\_login/usuario\_login/provider\_session\.dart

