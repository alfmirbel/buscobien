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
    Y la aplicación no muestra una pantalla de error dedicada

  @REQ-ROUT-006
  Escenario: Una constante de AppRoutes sin case se comporta como ruta desconocida
    Cuando `routeGenerate` recibe la ruta "/filtrapropiedades"
    Entonces devuelve `null` porque la constante no tiene `case`

  @REQ-ROUT-016
  Escenario: Falta el argumento obligatorio de /editaespacio
    Cuando se navega a "/editaespacio" sin argumentos
    Entonces el cast a `ValueEspaciosCasaGet` lanza un error en tiempo de ejecución

  @REQ-ROUT-016
  Escenario: Argumentos de otro tipo en /cambiopassword
    Cuando se navega a "/cambiopassword" con un `String` como argumento
    Entonces el cast a `Map<String, String>` lanza un `TypeError`
