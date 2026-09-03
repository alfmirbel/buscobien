# language: es
Característica: Estados de FutureBuilder
  Como usuario final
  Quiero ver indicadores visuales mientras se cargan datos
  Para entender el estado de la operación en curso

  Escenario: Estado None - Sin resultados
    Dado que un FutureBuilder está en estado `ConnectionState.none`
    Cuando el sistema renderiza el estado
    Entonces el sistema muestra un contenedor con ancho y alto especificados
    Y el contenedor tiene color `appTheme.primaryContainer`
    Y muestra el texto "Sin resultados" centrado
    Y el texto tiene color `appTheme.onPrimaryContainer` y tamaño 10

  Escenario: Estado Waiting - Cargando
    Dado que un FutureBuilder está en estado `ConnectionState.waiting`
    Cuando el sistema renderiza el estado
    Entonces el sistema muestra un contenedor de ancho `w-3` y alto `l-3`
    Y el contenedor tiene color `appTheme.surface`
    Y muestra un `CircularProgressIndicator` con color `appTheme.onPrimaryContainer`

  Escenario: Estado Active - Esperando datos
    Dado que un FutureBuilder está en estado `ConnectionState.active`
    Cuando el sistema renderiza el estado
    Entonces el sistema muestra un contenedor con ancho y alto especificados
    Y el contenedor tiene color `appTheme.surface`
    Y muestra el texto "Esperando datos" centrado
    Y el texto tiene color `appTheme.onPrimaryContainer` y tamaño 10

  Escenario: Estado Error - Error genérico
    Dado que un FutureBuilder completa con error
    Cuando el sistema renderiza el estado con `stateError`
    Entonces el sistema muestra un contenedor con ancho y alto especificados
    Y el contenedor tiene color `appTheme.surface`
    Y muestra el texto "Error: [mensaje]" centrado
    Y el texto tiene color `appTheme.onPrimaryContainer` y tamaño 10

  Escenario: Estado Error - Error formateado
    Dado que un FutureBuilder completa con error
    Cuando el sistema renderiza el estado con `stateErrorFormat`
    Entonces el sistema muestra un contenedor con ancho y alto especificados
    Y el contenedor tiene color `appTheme.surface`
    Y muestra el texto "Error: [mensaje]" centrado
    Y el texto tiene color `appTheme.onPrimaryContainer` y tamaño 10

  Escenario: Estado None sin dimensiones (FullScreen)
    Dado que un FutureBuilder está en estado `ConnectionState.none`
    Cuando el sistema renderiza `stateNoneFS`
    Entonces el sistema muestra el texto "Sin resultados" centrado
    Y el texto tiene color `appTheme.onPrimaryContainer` y tamaño 14
    Y no tiene contenedor con dimensiones especificadas

  Escenario: Estado Waiting sin dimensiones (FullScreen)
    Dado que un FutureBuilder está en estado `ConnectionState.waiting`
    Cuando el sistema renderiza `stateWaitingFS`
    Entonces el sistema muestra un `CircularProgressIndicator` centrado
    Y el indicador tiene color `appTheme.onPrimaryContainer`

  Escenario: Estado Active sin dimensiones (FullScreen)
    Dado que un FutureBuilder está en estado `ConnectionState.active`
    Cuando el sistema renderiza `stateActiveFS`
    Entonces el sistema muestra el texto "Esperando datos" centrado
    Y el texto tiene color `appTheme.onPrimaryContainer` y tamaño 10

  Escenario: Estado Error sin dimensiones (FullScreen)
    Dado que un FutureBuilder completa con error
    Cuando el sistema renderiza `stateErrorFS`
    Entonces el sistema muestra el texto "Error: [mensaje]" centrado
    Y el texto tiene color `appTheme.onPrimaryContainer` y tamaño 10
