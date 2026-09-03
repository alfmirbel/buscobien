# language: es
Característica: Pantalla de Estado de Conexiones
  Como usuario final
  Quiero ver el estado detallado de todas mis conexiones de red
  Para diagnosticar problemas de conectividad

  Escenario: Visualización de pantalla de estado de conexiones
    Dado que el usuario abre la pantalla de estado de conexiones
    Cuando el sistema carga el estado inicial
    Entonces el sistema muestra un indicador de progreso circular centrado
    Y el AppBar tiene título "conexión"
    Y el AppBar tiene color de fondo `appTheme.error`

  Escenario: Lista de tipos de conexión con estados
    Dado que el usuario está en la pantalla de estado de conexiones
    Y el sistema ha detectado el estado de cada tipo de conexión
    Cuando el sistema renderiza la lista
    Entonces muestra "mobile" con estado "Activada" o "Desctivada"
    Y muestra "wifi" con estado "Activada" o "Desctivada"
    Y muestra "ethernet" con estado "Activada" o "Desctivada"
    Y muestra "vpn" con estado "Activada" o "Desctivada"
    Y muestra "bluetooth" con estado "Activada" o "Desctivada"
    Y muestra "otras" con estado "Activada" o "Desctivada"
    Y muestra "ninguna" con estado "Activada" o "Desctivada"
    Y no muestra "No se pudo verificar" en la lista

  Escenario: Botón de regresar en pantalla de conexiones
    Dado que el usuario está en la pantalla de estado de conexiones
    Cuando el sistema renderiza la pantalla
    Entonces muestra un botón "Regresar" en la parte inferior
    Y el botón tiene color de fondo `appTheme.error`
    Y el texto del botón tiene color `appTheme.onError`
    Y al presionar el botón, el sistema cierra la pantalla con `Navigator.pop()`

  Escenario: Actualización en tiempo real del estado de conexiones
    Dado que el usuario está en la pantalla de estado de conexiones
    Y la conectividad cambia de Wi-Fi a móvil
    Cuando el sistema detecta el cambio a través del stream
    Entonces el provider actualiza el estado automáticamente
    Y la pantalla refleja el nuevo estado sin necesidad de recargar

  Escenario: Descripción del estado de conexión
    Dado que el usuario está en la pantalla de estado de conexiones
    Y el sistema ha detectado Wi-Fi activo
    Cuando el sistema renderiza la información adicional
    Entonces muestra la descripción "Uso de Wi-Fi." en color `appTheme.error`
