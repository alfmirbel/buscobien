# language: es
Característica: Detección de Conectividad de Red
  Como usuario final
  Quiero que la aplicación detecte mi tipo de conexión a Internet
  Para adaptar el comportamiento según mi conexión (datos móviles, Wi-Fi, etc.)

  Escenario: Detección de conexión móvil
    Dado que el dispositivo tiene conexión móvil activa
    Y no tiene Wi-Fi ni Ethernet conectados
    Cuando el sistema verifica la conectividad
    Entonces el sistema detecta `ConnectivityResult.mobile`
    Y establece la etiqueta "Conectado"
    Y establece el icono `wifi`
    Y activa el índice 0 en `boolEstadoConeccion`
    Y actualiza la descripción a "Uso de datos moviles."
    Y actualiza la ruta global a "/principal"

  Escenario: Detección de conexión Wi-Fi
    Dado que el dispositivo tiene conexión Wi-Fi activa
    Cuando el sistema verifica la conectividad
    Entonces el sistema detecta `ConnectivityResult.wifi`
    Y establece la etiqueta "Conectado"
    Y establece el icono `wifi`
    Y activa el índice 1 en `boolEstadoConeccion`
    Y actualiza la descripción a "Uso de Wi-Fi."
    Y actualiza la ruta global a "/principal"

  Escenario: Detección de conexión Ethernet
    Dado que el dispositivo tiene conexión Ethernet activa
    Cuando el sistema verifica la conectividad
    Entonces el sistema detecta `ConnectivityResult.ethernet`
    Y establece la etiqueta "Conectado"
    Y activa el índice 2 en `boolEstadoConeccion`
    Y actualiza la descripción a "Uso de red."
    Y actualiza la ruta global a "/principal"

  Escenario: Detección de conexión VPN
    Dado que el dispositivo tiene una VPN activa
    Cuando el sistema verifica la conectividad
    Entonces el sistema detecta `ConnectivityResult.vpn`
    Y establece la etiqueta "Conectado"
    Y activa el índice 3 en `boolEstadoConeccion`
    Y actualiza la descripción a "Uso de VPN."
    Y actualiza la ruta global a "/principal"

  Escenario: Detección de conexión Bluetooth
    Dado que el dispositivo tiene conexión Bluetooth de red activa
    Cuando el sistema verifica la conectividad
    Entonces el sistema detecta `ConnectivityResult.bluetooth`
    Y establece la etiqueta "Conectado"
    Y activa el índice 4 en `boolEstadoConeccion`
    Y actualiza la descripción a "Uso de Bluetooth."
    Y actualiza la ruta global a "/principal"

  Escenario: Detección de conexión satelital
    Dado que el dispositivo tiene conexión satelital activa
    Cuando el sistema verifica la conectividad
    Entonces el sistema detecta `ConnectivityResult.satellite`
    Y establece la etiqueta "Conectado"
    Y activa el índice 5 en `boolEstadoConeccion`
    Y actualiza la descripción a "Uso de conexión satelital."
    Y actualiza la ruta global a "/principal"

  Escenario: Detección de conexión "other"
    Dado que el dispositivo tiene un tipo de conexión no especificado
    Cuando el sistema verifica la conectividad
    Entonces el sistema detecta `ConnectivityResult.other`
    Y establece la etiqueta "Conectado"
    Y activa el índice 5 en `boolEstadoConeccion`
    Y actualiza la descripción a "Otro tipo de conexión."
    Y actualiza la ruta global a "/principal"

  Escenario: Detección de sin conexión
    Dado que el dispositivo no tiene ninguna conexión a Internet
    Cuando el sistema verifica la conectividad
    Entonces el sistema detecta `ConnectivityResult.none`
    Y establece la etiqueta "Sin conexión"
    Y establece el icono `wifi_off`
    Y activa el índice 6 en `boolEstadoConeccion`
    Y actualiza la descripción a "Sin conexión."
    Y actualiza la ruta global a "/sinconeccion"
