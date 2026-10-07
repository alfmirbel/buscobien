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
  Escenario: PaginaDeError no está registrada como ruta
    Cuando se navega a cualquier ruta desconocida
    Entonces `PaginaDeError` no se muestra porque `routeGenerate` no la referencia

  @REQ-ROUT-012
  Escenario: Sin permiso de ubicación el widget se crea pero no se muestra
    Dado que `permisodelocalizacion` es 0 en la barra principal
    Cuando el usuario toca la opción que requiere ubicación
    Entonces se crea `PaginaDeError("Activa los permisos de ubicación")` dentro de una expresión
    Y la pantalla no se presenta al usuario
