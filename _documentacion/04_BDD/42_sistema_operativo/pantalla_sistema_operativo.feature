# language: es
Característica: Pantalla de Detección de Sistema Operativo
  Como usuario final
  Quiero ver en qué plataforma se está ejecutando la aplicación
  Para entender qué funcionalidades están disponibles según mi dispositivo

  Escenario: Visualización de pantalla de sistema operativo
    Dado que el usuario abre la pantalla de sistema operativo
    Cuando el sistema renderiza la pantalla
    Entonces el sistema muestra un AppBar con título "Sistema Operativo"
    Y el AppBar tiene color de fondo `appTheme.error`
    Y el título tiene color `appTheme.onError`
    Y el AppBar tiene elevación de 4
    Y no muestra botón de retroceso en el AppBar

  Escenario: Lista de plataformas con estado de detección
    Dado que el usuario está en la pantalla de sistema operativo
    Y el sistema ha detectado la plataforma Android
    Cuando el sistema renderiza la lista de plataformas
    Entonces muestra "android" con estado "Detectado"
    Y muestra "fuchsia" con estado "No"
    Y muestra "iOS" con estado "No"
    Y muestra "linux" con estado "No"
    Y muestra "macOS" con estado "No"
    Y muestra "windows" con estado "No"
    Y muestra "Web u otro" con estado "No"

  Escenario: Navegación de regreso desde pantalla de sistema operativo
    Dado que el usuario está en la pantalla de sistema operativo
    Cuando el usuario presiona el botón "Regresar"
    Entonces el sistema navega a la ruta `AppRoutes.principal`
    Y pasa argumentos vacíos
