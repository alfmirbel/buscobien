# language: es
Característica: Pantalla de Error por Falta de Conexión
  Como usuario final
  Quiero ver una pantalla clara cuando no hay Internet
  Para entender que debo activar mi conexión para usar la aplicación

  Escenario: Visualización de pantalla sin conexión
    Dado que el usuario no tiene conexión a Internet
    Cuando el sistema navega a la pantalla de error
    Entonces el sistema muestra un AppBar con título "buscobien: error en la aplicación"
    Y el AppBar tiene color de fondo `appTheme.error`
    Y el título tiene color `appTheme.onError`
    Y no muestra botón de retroceso en el AppBar

  Escenario: Mensajes informativos en pantalla sin conexión
    Dado que el usuario está en la pantalla de error por conexión
    Cuando el sistema renderiza el contenido
    Entonces muestra "Estado de la conexión a Internet" en color `appTheme.error`
    Y muestra el letrero personalizado recibido como parámetro en color `appTheme.error`
    Y muestra "Para usar la aplicación" en color `appTheme.error`
    Y muestra "se requiere acceso a Internet." en color `appTheme.error`
    Y muestra "Verifica tu conexión" en color `appTheme.error`
    Y muestra "Al activar tu conexión" en color `appTheme.primary`
    Y muestra "se inicia la aplicación" en color `appTheme.primary`
    Y muestra "en automático." en color `appTheme.primary`

  Escenario: Cierre automático al recuperar conexión
    Dado que el usuario está en la pantalla de error por conexión
    Y el estado de conectividad cambia a "Conectado"
    Cuando el sistema detecta el cambio en el provider
    Entonces el sistema cierra automáticamente la pantalla con `Navigator.pop()`
    Y el usuario regresa a la pantalla anterior

  Escenario: Cierre manual no disponible
    Dado que el usuario está en la pantalla de error por conexión
    Y no hay botón de retroceso visible
    Cuando el usuario intenta cerrar la pantalla manualmente
    Entonces el sistema no permite el cierre manual
    Y solo se cierra cuando se recupera la conexión
