# language: es
Característica: Página de error genérica
  Como usuario
  Quiero ver un mensaje claro cuando ocurre un problema
  Para saber qué pasó y poder salir de la pantalla

  @REQ-ROUT-012
  Escenario: PaginaDeError muestra el mensaje recibido
    Dado que se construye `PaginaDeError` con el letrero "Activa los permisos de ubicación"
    Cuando se dibuja la pantalla
    Entonces el AppBar usa el color `appTheme.error` y el título "Error en la aplicación"
    Y se muestran "Ocurrio el siguiente problema", el letrero y "Vuelva a intentarlo"

  @REQ-ROUT-012
  Escenario: El botón Salir cierra la pantalla
    Dado que `PaginaDeError` está visible dentro de un Navigator
    Cuando el usuario toca "Salir"
    Entonces se ejecuta `Navigator.of(context).pop()`

  @REQ-ROUT-012
  Escenario: Una ruta desconocida muestra PaginaDeError
    Cuando se navega a una ruta que `routeGenerate` no reconoce
    Entonces `onUnknownRoute` muestra `PaginaDeError` con "Pantalla no encontrada: <ruta>"

  @REQ-ROUT-012
  Escenario: Sin permiso de ubicación se muestra el aviso
    Dado que `permisodelocalizacion` es 0 en la barra principal
    Cuando el usuario toca la opción que requiere ubicación
    Entonces se abre `PaginaDeError("Activa los permisos de ubicación")` con `Navigator.push`
