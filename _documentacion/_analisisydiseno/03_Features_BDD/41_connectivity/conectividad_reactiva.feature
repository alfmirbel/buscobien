# language: es
Característica: Detección y Gestión Reactiva de Conectividad

  Como usuario de Buscobien
  Quiero que la app detecte mi estado de red en tiempo real
  Para saber cuándo puedo usar funciones que requieren internet

  Antecedentes:
    Dado que checaConeccionesProvider (AsyncNotifierProvider) está activo
    Y escucha connectivity_plus.onConnectivityChanged stream

  Escenario: Detección de conectividad WiFi
    Dado que el dispositivo se conecta a WiFi
    Cuando connectivity_plus emite ConnectivityResult.wifi
    Entonces _logicaAsignaConectividad mapea a etiqueta "Conectado"
    Y icono Symbols.wifi
    Y boolEstadoConeccion[0] = true (wifi)
    Y rutaConectividad = "/principal"

  Escenario: Detección de pérdida de red
    Dado que el dispositivo pierde toda conectividad
    Cuando connectivity_plus emite ConnectivityResult.none
    Entonces _logicaAsignaConectividad setea etiqueta "Sin conexión"
    Y rutaConectividad = "/sinconeccion"
    Y estadoDeLaConeccion = false

  Escenario: Splash bloqueado sin conectividad
    Dado que SplashPage está visible con timer 3s
    Cuando checaConeccionesProvider != "Conectado"
    Entonces _attemptNavigation() NO navega a principal
    Y espera a conectividad + timer

  Escenario: Pantalla sin conexión auto-retry
    Dado que usuario está en PaginaSinConeccion
    Cuando checaConeccionesProvider emite "Conectado"
    Entonces ref.listen detecta cambio
    Y ejecuta Navigator.pop() automático

  Escenario: 9 tipos de conexión mapeados
    Dado que connectivity_plus reporta diferentes tipos
    Cuando _logicaAsignaConectividad ejecuta switch
    Entonces mapea: wifi, mobile, ethernet, vpn, bluetooth, other, unknown → "Conectado"
    Y none → "Sin conexión"
    Con iconos Material Symbols correspondientes