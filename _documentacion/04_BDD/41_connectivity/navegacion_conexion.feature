# language: es
Característica: Navegación por Estado de Conexión
  Como sistema
  Quiero redirigir al usuario según su estado de conexión
  Para mostrar la pantalla principal cuando hay Internet, o la pantalla de error cuando no hay

  Escenario: Redirección automática a pantalla principal con conexión
    Dado que el usuario intenta abrir la aplicación
    Y el sistema detecta conexión Wi-Fi activa
    Cuando el provider actualiza el estado a "Conectado"
    Entonces el sistema establece la ruta global a "/principal"
    Y el usuario puede navegar por la aplicación normalmente

  Escenario: Redirección automática a pantalla sin conexión
    Dado que el usuario intenta abrir la aplicación
    Y el sistema detecta que no hay conexión
    Cuando el provider actualiza el estado a "Sin conexión"
    Entonces el sistema establece la ruta global a "/sinconeccion"
    Y muestra la pantalla `PaginaSinConeccion` con el letrero apropiado

  Escenario: Navegación desde pantalla sin conexión al recuperar Internet
    Dado que el usuario está en la pantalla sin conexión
    Y el usuario activa el Wi-Fi en el dispositivo
    Cuando el stream de conectividad detecta el cambio
    Y el provider actualiza el estado a "Conectado"
    Entonces la pantalla sin conexión detecta el cambio
    Y se cierra automáticamente con `Navigator.pop()`
    Y el usuario regresa a la pantalla anterior

  Escenario: Cambio de ruta global al perder conexión
    Dado que el usuario está navegando en la aplicación
    Y tiene conexión Wi-Fi activa
    Cuando el usuario apaga el Wi-Fi
    Y el sistema detecta `ConnectivityResult.none`
    Entonces el sistema actualiza la ruta global a "/sinconeccion"
    Y la próxima navegación mostrará la pantalla de error
