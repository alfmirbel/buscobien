# Inventario de Componentes del Directorio: `D:\buscobien\lib\07_routes`

Este documento contiene un análisis detallado e inventario de todos los componentes declarados en cada uno de los archivos `.dart` dentro de la carpeta `D:\buscobien\lib\07_routes`.

## Tabla de Inventario de Componentes

| Subdirectorio | Nombre del archivo | Tipo de componentes | Nombre del componente | Parámetros que requiere (en su caso) | Variables que utiliza (externas/globales/providers) | Variables internas / locales | Estilos que le aplican (en su caso) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `07_routes` | `app_routes.dart` | Clase de Constantes | `AppRoutes` | No aplica | Constantes de tipo `String` que representan las rutas (ej. `main`, `home`, `splash`, `login`, `principal`, `registro`, etc.) | Ninguna | No aplica |
| `07_routes` | `app_routes.dart` | Función global (retorna `MaterialPageRoute`) | `navigateToRoute` | `Widget screen`, `{required RouteSettings settings}` | `debugPrintLevels` | Ninguna | No aplica (lógica de ruteo) |
| `07_routes` | `app_routes.dart` | Función global (retorna `Route?`) | `routeGenerate` | `RouteSettings settings` | Diversas vistas y widgets de la aplicación (`SplashPage`, `PrincipalSliversMenuInicial`, `PaginaDetectaPlataforma`, `PaginaSinConeccion`, `PaginaChecaInternet`, `RegisterScreenUsers`, `LocalidadesListScreen`, `PaginaBuscaLocalidadGMaps`, `PaginaEditaEspacio`, `PaginaPerfilWidget`, `PaginaColores`, `GestionAvatares`, `PaginaCompraEspacios`, `PaginaCarouselFotosWidget`, `PaginaFotosPropiedad`, `PropiedadesListaFotosPromotor`, `AgregaMultiplesFotos`, `PaginaMapaPropiedades`, `PageMisListas`) | `settings.name`, `settings.arguments` | No aplica (lógica de ruteo) |
| `07_routes` | `pagina_route_error.dart` | Clase (`StatelessWidget`) | `PaginaDeError` | `final String letrero`, `{super.key}` | `appTheme` (de `../20_var_globales/var_color_themes.dart`) | `letrero` | `appTheme.error` (fondo de AppBar, fondo de ElevatedButton, texto del problema), `appTheme.onError` (texto de AppBar y texto de botón "Salir"), `fontFamily: "Comfortaa"`, `BorderRadius.circular(8.0)`, tamaños de fuente `12`, `14` y `16` |
| `07_routes` | `routes_parameters.dart` | Clase de datos | `ResultadoGuardaFoto` | `{required this.statusCode, required this.idFoto}` | Ninguna | `statusCode` (tipo `int`), `idFoto` (tipo `String`) | No aplica |
| `07_routes` | `routes_parameters.dart` | Clase de datos | `ResultSaveFoto` | `{required this.resultadoEnFotos, required this.resultadoEnEspacios}` | `ResultadoGuardaFoto` | `resultadoEnFotos`, `resultadoEnEspacios` (tipo `int`) | No aplica |
| `07_routes` | `routes_parameters.dart` | Variable Mapa global | `parameterLocalidad` | No aplica | Ninguna | Clave `"cp"`, valor `3100` | No aplica |
| `07_routes` | `routes_parameters.dart` | Variable Mapa global | `parametrosListaFotos` | No aplica | Ninguna | Claves `"skip"`, `"limit"`, `"idUsuario"`, `"idPropiedad"`, `"indiceListaPropiedad"` | No aplica |
| `07_routes` | `routes_parameters.dart` | Variable de datos global | `parameterEditaEspacio` | No aplica | `ValueEspaciosCasaGet` (inicializado con valores vacíos/predeterminados) | Campos de datos del objeto `ValueEspaciosCasaGet` | No aplica |
| `07_routes` | `routes_parameters.dart` | Variable de datos global | `parameterEditaFotos` | No aplica | `ValueEspaciosCasaGet` (inicializado con valores vacíos/predeterminados) | Campos de datos del objeto `ValueEspaciosCasaGet` | No aplica |
| `07_routes` | `routes_parameters.dart` | Clase de datos | `ArgumentsLocalidad` | `{required this.cp}` | Ninguna | `cp` (tipo `int`), método `setCP` | No aplica |
| `07_routes` | `routes_parameters.dart` | Clase de datos | `ArgumentsListaLocalidad` | `{required this.listaLocalidades, required this.cp}` | `FindLocalidadXcp` (de `../08_pantallas/ubicacion/data_localidad_find.dart`) | `listaLocalidades`, `cp` (tipo `int`), método `setListaLocalidades` | No aplica |
| `07_routes` | `routes_parameters.dart` | Variable de datos global | `inicializaValueGetCasa` | No aplica | `ValueEspaciosCasaGet` (inicializado con valores predeterminados de contacto y ubicación vacíos) | Campos de datos del objeto `ValueEspaciosCasaGet` | No aplica |
| `07_routes` | `routes_parameters.dart` | Variable global | `parameterFotoPrincipal` | No aplica | Ninguna | Tipo `int` igual a `0` | No aplica |
| `07_routes` | `routes_parameters.dart` | Variable Mapa global | `parameterActualizaEspacio` | No aplica | `ValueEspaciosCasaGet` | Clave `"getespacio"` asociada a una instancia vacía de `ValueEspaciosCasaGet` | No aplica |
| `07_routes` | `routes_parameters.dart` | Variable Mapa global | `parameterPaginaChecaConeccion` | No aplica | `WidgetRef` | Clave `"ref"` asociada a `WidgetRef` (tipo de tipo) | No aplica |
| `07_routes` | `routes_parameters.dart` | Variable Mapa global | `parameterCapturaFotosCasa` | No aplica | `ValueEspaciosCasaGet` | Claves `"idUsuario"`, `"idPropiedad"`, `"propiedad"`, `"indexlistafotos"` | No aplica |
| `07_routes` | `routes_parameters.dart` | Variable Mapa global | `parameterPaginaMenuTipoTransaccion` | No aplica | Ninguna | Claves `"nivelGobierno"`, `"tipodepublicacion"` asociadas a enteros | No aplica |
| `07_routes` | `routes_parameters.dart` | Variable Mapa global | `parameterGestionFoto` | No aplica | `ValueEspaciosCasaGet`, `bool` | Claves `"idUsuario"`, `"idPropiedad"`, `"idFoto"`, `"propiedad"`, `"fotoprincipal"`, `"indice"` | No aplica |

## Notas y Conclusiones del Análisis

1. **Gestión Unificada del Enrutamiento**:
   El enrutamiento está centralizado en `app_routes.dart` mediante constantes estáticas dentro de la clase `AppRoutes` (ej. `AppRoutes.splash`, `AppRoutes.registro`, etc.). La función `routeGenerate` actúa como un despachador dinámico tipo *onGenerateRoute* en el `MaterialApp` raíz de Flutter, permitiendo extraer argumentos complejos (`settings.arguments`) y moldearlos a los tipos correctos (ej. `ValueEspaciosCasaGet` o `Map<String, dynamic>`) antes de instanciar y navegar hacia las pantallas destino.

2. **Tipado Estricto de Parámetros de Ruta**:
   El archivo `routes_parameters.dart` define clases de argumentos (ej. `ArgumentsLocalidad`, `ArgumentsListaLocalidad`, `ResultadoGuardaFoto`, etc.) y objetos globales pre-construidos para asegurar que las transiciones entre pantallas pasen la información estructurada correcta. Esto minimiza errores de conversión en tiempo de ejecución al interactuar con el mapa, editar propiedades, agregar fotos, etc.

3. **Manejo de Errores Visuales**:
   `pagina_route_error.dart` contiene un widget sencillo pero robusto (`PaginaDeError`) diseñado para mostrar fallos graves o inconsistencias de navegación al usuario, con colores rojos estilizados (`appTheme.error`) y un botón para retroceder (`Navigator.pop`).
