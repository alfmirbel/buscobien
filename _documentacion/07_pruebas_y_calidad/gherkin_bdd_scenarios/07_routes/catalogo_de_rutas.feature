# language: es
Característica: Catálogo de rutas y resolución con routeGenerate
  Como desarrollador
  Quiero una única fuente de verdad para las rutas con nombre
  Para navegar de forma determinista entre las pantallas de BuscoBien

  Antecedentes:
    Dado que `MaterialApp` usa `routeGenerate` como `onGenerateRoute` y `AppRoutes.main` como `initialRoute`

  @REQ-ROUT-001
  Escenario: Todas las constantes de AppRoutes tienen pantalla
    Dado que la clase `AppRoutes` define constantes `static const String`
    Cuando se cuentan las constantes y los `case` de `routeGenerate`
    Entonces existen 22 constantes de ruta
    Y las 22 tienen un `case` activo
    Y las 16 constantes que no tenían pantalla (por ejemplo "/home", "/login") se eliminaron

  @REQ-ROUT-002
  Escenario: La app arranca en la ruta inicial
    Cuando la aplicación inicia
    Entonces `MaterialApp` solicita la ruta "/"
    Y `routeGenerate` es el único generador de rutas

  @REQ-ROUT-013
  Escenario: La ruta raíz y /splash muestran el splash de 3 segundos
    Cuando se navega a "/" o a "/splash"
    Entonces se construye `SplashPage` con duración de 3 segundos
    Y al terminar muestra `PrincipalSliversMenuInicial`

  @REQ-ROUT-003
  Escenario: Una ruta conocida se envuelve en un MaterialPageRoute con los mismos settings
    Cuando se navega a "/perfil"
    Entonces `navigateToRoute` devuelve un `MaterialPageRoute`
    Y el `RouteSettings` conserva el nombre "/perfil"

  @REQ-ROUT-003
  Escenario: Una ruta con argumentos recibe el argumento casteado al tipo esperado
    Cuando se navega a "/editaespacio" con un `ValueEspaciosCasaGet` como argumento
    Entonces se abre `PaginaEditaEspacio` con ese objeto

  @REQ-ROUT-003
  Escenario: La ruta de mapa recibe una lista de propiedades
    Cuando se navega a "/mapapropiedades" con un `EspaciosCasaGet` como argumento
    Entonces se abre `PaginaMapaPropiedades` con `listaPropiedadesVar` igual al argumento

  @REQ-ROUT-003
  Escenario: Rutas sin argumentos
    Cuando se navega a "/principal", "/registro", "/perfil" o "/listaspropiedades"
    Entonces se abre la pantalla correspondiente sin requerir argumentos

  @REQ-ROUT-017
  Escenario: Cada navegación queda registrada en el log
    Cuando `routeGenerate` recibe cualquier ruta
    Entonces registra con `debugPrintLevels(1)` el nombre y los argumentos
    Y `navigateToRoute` registra con `debugPrintLevels(2)` el nombre de la ruta
