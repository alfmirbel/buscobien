# language: es

Característica: Conectividad a Internet y Manejo de Errores de Red
  Como usuario de BuscoBien
  Quiero que la aplicación me informe claramente cuando no hay conexión a Internet
  Para saber que el problema es de red y no de la aplicación

  # ---------------------------------------------------------------------------
  # DETECCIÓN DE PÉRDIDA DE CONEXIÓN
  # ---------------------------------------------------------------------------
  Escenario: Pérdida de conexión detectada mientras se usa la app
    Dado que el usuario está usando la aplicación con conexión activa
    Y el monitor de conectividad "checaConeccionesProvider" está activo
    Cuando el dispositivo pierde la conexión a Internet
    Y el proveedor emite un nuevo estado con "etiqueta != 'Conectado'"
    Entonces el sistema debe navegar automáticamente a la ruta "/sinconeccion"
    Y el mensaje de la pantalla debe decir "Se perdió la conexión a Internet."
    Y el sistema debe establecer "_isErrorPageOpen = true" para evitar múltiples pantallas de error

  Escenario: La pantalla de sin conexión se muestra solo una vez
    Dado que la conexión se pierde intermitentemente
    Y la pantalla de error ya está abierta ("_isErrorPageOpen = true")
    Cuando el proveedor emite un nuevo estado de "sin conexión"
    Entonces el sistema NO debe abrir una segunda pantalla de error
    Y la pantalla de error existente debe permanecer visible

  Escenario: La pantalla de error se descarta cuando regresa la conexión
    Dado que la pantalla de error de sin conexión está visible
    Cuando el dispositivo recupera la conexión a Internet
    Y el usuario cierra la pantalla de error
    Entonces el sistema debe establecer "_isErrorPageOpen = false"
    Y el usuario debe regresar a la pantalla anterior de donde estaba

  Escenario: Error de conectividad al inicio de la aplicación
    Dado que el dispositivo no tiene conexión a Internet al arrancar la app
    Cuando la aplicación llega a la pantalla principal
    Entonces el sistema debe navegar a la ruta "/sinconeccion"
    Y el mensaje debe indicar "No se detectó conexión a Internet."

  # ---------------------------------------------------------------------------
  # CONNECTIVITY CHECK PROVIDER
  # ---------------------------------------------------------------------------
  Escenario: El provider emite un error (estado de error del AsyncValue)
    Dado que el "checaConeccionesProvider" emite un estado de error
    Cuando el listener procesa el error
    Entonces el sistema debe llamar a "_navigateToErrorPage()"
    Y el usuario debe ver la pantalla de sin conexión

  Escenario: La pantalla de sin conexión muestra la causa del error
    Dado que la navegación a "/sinconeccion" recibe como argumento "Se perdió la conexión a Internet."
    Cuando la pantalla "PaginaSinConeccion" se muestra
    Entonces debe renderizarse el mensaje de error pasado como argumento
    Y el usuario debe poder intentar reconectarse o esperar

  # ---------------------------------------------------------------------------
  # ACCESO A DATOS CON RED
  # ---------------------------------------------------------------------------
  Escenario: Petición HTTP falla durante el inicio de sesión por error de red
    Dado que el usuario intentó iniciar sesión con credenciales válidas
    Y la conexión se perdió durante la petición HTTP
    Cuando el catch del try/catch captura la excepción de red
    Entonces el sistema debe mostrar un SnackBar con el texto "Error inesperado: [mensaje de excepción]"
    Y el estado de carga "_isLoading" debe restablecer a "false"
    Y el botón "Entrar" debe volver a ser visible

  Escenario: Petición HTTP falla durante la recuperación de contraseña
    Dado que el usuario solicitó la recuperación de contraseña
    Y la conexión a Internet falla durante el proceso
    Cuando el sistema no puede completar alguna de las operaciones HTTP
    Entonces debe mostrar un diálogo de error apropiado
    Y el estado de carga "_isLoading" debe restablecer a "false"
