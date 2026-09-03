# Inventario de Componentes — 07_routes

**Directorio:** `lib/07_routes/`  
**Archivos:** `app_routes.dart`, `deep_link_handler.dart`, `pagina_route_error.dart`, `routes_parameters.dart`  
**Fecha:** 2026-08-12

---

## Tabla 1: Componentes (por archivo)

| Subdirectorio | Nombre del archivo | Tipo de componente | Nombre del componente | Parámetros que requiere | Variables que utiliza | Variables internas | Estilos que le aplican |
|---------------|-------------------|-------------------|----------------------|------------------------|----------------------|-------------------|------------------------|
| 07_routes | `app_routes.dart` | Clase constantes | `AppRoutes` | — | 30+ `static const String` rutas | — | — |
| 07_routes | `app_routes.dart` | Función wrapper | `navigateToRoute` | `Widget screen, required RouteSettings settings` | `debugPrintLevels` | — | `MaterialPageRoute` |
| 07_routes | `app_routes.dart` | Función principal | `routeGenerate` | `RouteSettings settings` | 25+ imports de pantallas/providers, `debugPrintLevels` | — | `MaterialPageRoute` con 30+ cases |
| 07_routes | `deep_link_handler.dart` | Funciones top-level | `initDeepLinkHandler`, `_handleWebInitialUri`, `_handleMobileDeepLinks`, `_navigateIfRecovery` | `GlobalKey<NavigatorState>`, `Uri` | `AppRoutes`, `navigatorKey`, `app_links` package | — | `navigatorKey.currentState?.pushNamed`, `AppLinks().getInitialLink()`, `uriLinkStream.listen()` |
| 07_routes | `pagina_route_error.dart` | StatelessWidget | `PaginaDeError` | `String letrero` | `appTheme`, `debugPrintLevels` | — | `AppBar`, `Column`, `Text`, `ElevatedButton`, `Navigator.pop()` |
| 07_routes | `routes_parameters.dart` | Clases DTO / Variables globales | `ResultadoGuardaFoto`, `ResultSaveFoto`, `ArgumentsLocalidad`, `ArgumentsListaLocalidad` + 15+ variables top-level mutables | Varios constructores | Modelos de datos (ValueEspaciosCasaGet, EspaciosCasa, LocalidadCp, etc.) | 15+ Maps/Objects mutables top-level | Casteos `as` en routeGenerate |

---

## Tabla 2: Elementos (por archivo)

| Subdirectorio | Nombre del archivo | Variables definidas en el archivo | Clases | Variables de la clase | Funciones o widgets definidos en la clase | Variables que utiliza | Llamadas a otras clases o widgets |
|---------------|-------------------|----------------------------------|--------|----------------------|------------------------------------------|----------------------|----------------------------------|
| 07_routes | `app_routes.dart` | 30+ `static const String` (main, splash, principal, login, registro, sinconeccion, perfil, editaespacio, mapapropiedades, listaspropiedades, solicitarrecuperacion, cambiopassword, etc.) | `AppRoutes` | Ninguna (solo constantes) | `navigateToRoute()`, `routeGenerate()` | `debugPrintLevels`, 25+ imports pantallas | `MaterialPageRoute`, `SplashPage`, `PrincipalSliversMenuInicial`, `PaginaSinConeccion`, `LocalidadesListScreen`, `PaginaBuscaLocalidadGMaps`, `PaginaEditaEspacio`, `PaginaPerfilWidget`, `PaginaColores`, `GestionAvatares`, `PaginaCompraEspacios`, `PaginaCarouselFotosWidget`, `PaginaFotosPropiedad`, `PropiedadesListaFotosPromotor`, `AgregaMultiplesFotos`, `PaginaMapaPropiedades`, `PageMisListas`, `PageSolicitarRecuperacion`, `PageCambioPassword`, `PaginaDeError` |
| 07_routes | `deep_link_handler.dart` | — | Ninguna (funciones top-level) | — | `initDeepLinkHandler(navigatorKey)`, `_handleWebInitialUri(navigatorKey)`, `_handleMobileDeepLinks(navigatorKey)`, `_navigateIfRecovery(uri, navigatorKey)` | `AppLinks`, `Uri.base`, `navigatorKey`, `AppRoutes.cambioPassword` | `AppLinks().getInitialLink()`, `AppLinks().uriLinkStream.listen()`, `navigatorKey.currentState?.pushNamed()` |
| 07_routes | `pagina_route_error.dart` | — | `PaginaDeError` | `letrero` (final String) | `build()` | `appTheme`, `debugPrintLevels` | `Scaffold`, `AppBar`, `Column`, `Text`, `ElevatedButton`, `Navigator.pop()` |
| 07_routes | `routes_parameters.dart` | 15+ variables top-level mutables: `parameterLocalidad`, `parametrosListaFotos`, `parameterEditaEspacio`, `parameterEditaFotos`, `inicializaValueGetCasa`, `parameterFotoPrincipal`, `parameterActualizaEspacio`, `parameterPaginaChecaConeccion`, `parameterCapturaFotosCasa`, `parameterPaginaMenuTipoTransaccion`, `parameterGestionFoto` + DTOs | `ResultadoGuardaFoto`, `ResultSaveFoto`, `ArgumentsLocalidad`, `ArgumentsListaLocalidad` | Campos según DTO (statusCode, idFoto, cp, listaLocalidades, etc.) | Constructores, setters | Modelos: `ValueEspaciosCasaGet`, `EspaciosCasa`, `LocalidadCp`, `FindLocalidadXcp`, `Datosadicionalescasa`, `Datosdelcontactocasa`, `Ubicacioncasa`, `Fechadecasa` | Casteos `as` en `routeGenerate` |