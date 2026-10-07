# language: es
Característica: Comportamiento reactivo ante cambios de conectividad
  Como usuario final
  Quiero que la aplicación responda automáticamente si mi conexión cambia durante la carga
  Para no quedarme atascado en el splash screen o ser enviado a error injustificadamente

  Escenario: El usuario gana conexión después de que el temporizador finaliza
    Dado que el usuario está en el splash screen sin conexión
    Y el temporizador de duración mínima ya ha finalizado
    Cuando el sistema detecta que la conexión a Internet se restablece
    Entonces el sistema debe navegar automáticamente a la pantalla principal (`principal`)
    Y no debe mostrar la pantalla de error

  Escenario: El usuario pierde conexión después de que el temporizador finaliza
    Dado que el usuario está en el splash screen con conexión
    Y el temporizador de duración mínima ya ha finalizado
    Cuando el sistema detecta que la conexión a Internet se pierde
    Entonces el sistema debe navegar automáticamente a la pantalla sin conexión (`sinconeccion`)
    Y no debe navegar a la pantalla principal

  Escenario: Cambios de conectividad mientras el temporizador está activo
    Dado que el usuario está en el splash screen
    Y el temporizador de duración mínima aún está corriendo
    Cuando el estado de conexión cambia de conectado a desconectado
    Entonces el sistema no debe navegar inmediatamente
    Y el sistema debe esperar a que finalice el temporizador antes de decidir la ruta

  Escenario: El usuario no debe poder navegar dos veces
    Dado que el usuario está en el splash screen
    Cuando el sistema ya inició una navegación automática
    Entonces cualquier evaluación adicional de navegación debe ser ignorada
    Y no deben abrirse pantallas duplicadas
