# language: es
Característica: Formato de Marca de Tiempo en Chat
  Como usuario final
  Quiero ver las horas de los mensajes de chat de forma intuitiva
  Para entender rápidamente cuándo se envió cada mensaje

  Escenario: Visualización de hora para mensaje enviado hoy
    Dado que el usuario recibe un mensaje de chat
    Y el mensaje fue enviado el día de hoy a las 14:35
    Cuando el sistema formatea la marca de tiempo para mostrar
    Entonces el sistema muestra "14:35" en la interfaz del chat

  Escenario: Visualización de hora para mensaje enviado ayer
    Dado que el usuario recibe un mensaje de chat
    Y el mensaje fue enviado el día anterior a las 09:15
    Cuando el sistema formatea la marca de tiempo para mostrar
    Entonces el sistema muestra "ayer 09:15" en la interfaz del chat

  Escenario: Visualización de fecha y hora para mensajes antiguos
    Dado que el usuario recibe un mensaje de chat
    Y el mensaje fue enviado el 15 de agosto a las 18:42
    Cuando el sistema formatea la marca de tiempo para mostrar
    Entonces el sistema muestra "15/08 18:42" en la interfaz del chat

  Escenario: Formato de hora con cero inicial
    Dado que el usuario recibe un mensaje de chat
    Y el mensaje fue enviado a las 05:07
    Cuando el sistema formatea la marca de tiempo para mostrar
    Entonces el sistema muestra "05:07" con cero inicial en horas y minutos

  Escenario: Manejo de marca de tiempo con formato inválido
    Dado que el sistema recibe una marca de tiempo con formato inválido
    Y no puede parsear la fecha ISO8601
    Cuando el sistema intenta formatear la marca de tiempo
    Entonces el sistema retorna una cadena vacía
    Y no muestra nada en la interfaz del chat

  Escenario: Formato consistente en listas de mensajes
    Dado que el usuario abre una conversación de chat con múltiples mensajes
    Y los mensajes tienen diferentes fechas (hoy, ayer, y anteriores)
    Cuando el sistema renderiza la lista de mensajes
    Entonces el mensaje de hoy muestra solo "HH:MM"
    Y el mensaje de ayer muestra "ayer HH:MM"
    Y los mensajes anteriores muestran "DD/MM HH:MM"
