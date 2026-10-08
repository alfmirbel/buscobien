# language: es
Característica: Argumentos de ruta y manejo de rutas inválidas
  Como desarrollador
  Quiero conocer el comportamiento ante argumentos o rutas incorrectos
  Para prevenir fallos de navegación en tiempo de ejecución

  @REQ-ROUT-005
  Escenario: La ruta /sinconeccion recibe un mensaje como String
    Cuando se navega a "/sinconeccion" con el texto "Sin internet" como argumento
    Entonces se abre `PaginaSinConeccion` con ese mensaje

  @REQ-ROUT-005
  Escenario: La ruta /checaconeccion recibe un mapa
    Cuando se navega a "/checaconeccion" con un `Map<String, dynamic>` como argumento
    Entonces se abre `PaginaChecaInternet` con ese mapa

  @REQ-ROUT-004
  Escenario: La ruta /cambiopassword usa token y perfil del mapa de argumentos
    Cuando se navega a "/cambiopassword" con los argumentos {"token": "abc", "perfil": "promotor"}
    Entonces se abre `PageCambioPassword` con `token` "abc" y `perfil` "promotor"

  @REQ-ROUT-006
  Escenario: Una ruta sin case devuelve null
    Cuando `routeGenerate` recibe la ruta "/rutainexistente"
    Entonces devuelve `null`
    Y `MaterialApp` usa `onUnknownRoute` y muestra `PaginaDeError` con el nombre de la ruta

  @REQ-ROUT-006
  Escenario: Una ruta eliminada de AppRoutes se comporta como ruta desconocida
    Cuando `routeGenerate` recibe la ruta "/login"
    Entonces devuelve `null` porque ya no existe esa ruta

  @REQ-ROUT-016
  Escenario: Falta el argumento obligatorio de /editaespacio
    Cuando se navega a "/editaespacio" sin argumentos
    Entonces el cast a `ValueEspaciosCasaGet` lanza un error en tiempo de ejecución

  @REQ-ROUT-016
  Escenario: Argumentos de otro tipo en /cambiopassword
    Cuando se navega a "/cambiopassword" con un `String` como argumento
    Entonces el cast a `Map<String, String>` lanza un `TypeError`
