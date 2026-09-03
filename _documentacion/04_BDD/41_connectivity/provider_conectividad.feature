# language: es
Característica: Provider de Conectividad (Riverpod)
  Como sistema
  Quiero mantener un estado reactivo de la conectividad
  Para que la UI se actualice automáticamente cuando cambie la conexión

  Escenario: Inicialización automática del provider
    Dado que la aplicación inicia y un widget observa `checaConeccionesProvider`
    Cuando el provider se construye por primera vez
    Entonces el sistema crea una instancia de `Connectivity`
    Y se suscribe al stream `onConnectivityChanged`
    Y ejecuta `checkConnectivity` para obtener el estado inicial
    Y retorna el primer estado de conectividad

  Escenario: Actualización reactiva al cambiar la conectividad
    Dado que el provider está activo y escuchando cambios
    Y el usuario activa el Wi-Fi
    Cuando el stream `onConnectivityChanged` emite el nuevo estado
    Entonces el provider recibe la lista de resultados
    Y ejecuta `_logicaAsignaConectividad` con el primer resultado
    Y actualiza el estado con el nuevo `ElementoDeConeccion`
    Y notifica a todos los widgets que observan el provider

  Escenario: Limpieza de suscripción al destruir el provider
    Dado que el provider está activo
    Cuando el widget que lo usa se destruye
    Entonces el sistema ejecuta `subscription.cancel()`
    Y libera los recursos del stream

  Escenario: Estado inicial sin conexión
    Dado que el dispositivo no tiene conexión al iniciar
    Cuando el provider ejecuta `checkConnectivity`
    Entonces retorna `ConnectivityResult.none`
    Y establece etiqueta "Sin conexión"
    Y establece icono `wifi_off`
    Y activa el índice 6 en `boolEstadoConeccion`
    Y actualiza la descripción a "Sin conexión."
    Y actualiza la ruta global a "/sinconeccion"

  Escenario: Estado inicial con conexión Wi-Fi
    Dado que el dispositivo tiene Wi-Fi activo al iniciar
    Cuando el provider ejecuta `checkConnectivity`
    Entonces retorna `ConnectivityResult.wifi`
    Y establece etiqueta "Conectado"
    Y establece icono `wifi`
    Y activa el índice 1 en `boolEstadoConeccion`
    Y actualiza la descripción a "Uso de Wi-Fi."
    Y actualiza la ruta global a "/principal"

  Escenario: Manejo de lista vacía de resultados
    Dado que el stream emite una lista vacía de resultados
    Cuando el provider procesa la lista
    Entonces usa `ConnectivityResult.none` como fallback
    Y establece el estado como "Sin conexión"
