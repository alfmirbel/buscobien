# language: es
Característica: Chat Grupal
  Como miembro de un grupo
  Quiero enviar y recibir mensajes en tiempo real
  Para comunicarme con los demás miembros del grupo

  Antecedentes:
    Dado que el usuario se encuentra en la pestaña "Chat" del detalle de grupo

  Escenario: Carga inicial de mensajes
    Dado que el usuario abre la pestaña "Chat"
    Entonces el sistema deberá mostrar un indicador de carga circular centrado
    Y el sistema deberá consultar los últimos 300 mensajes del grupo ordenados por timestamp descendente

  Escenario: Estado vacío de chat
    Dado que el grupo no tiene mensajes
    Cuando la carga finalice
    Entonces el sistema deberá mostrar el mensaje "Envía el primer mensaje al grupo."

  Escenario: Envío de mensaje de texto
    Dado que el usuario se encuentra en la pestaña "Chat"
    Y el campo de texto está vacío
    Cuando el usuario escribe "Hola a todos" y presiona enviar
    Entonces el sistema deberá crear el mensaje en la base de datos
    Y mostrar el mensaje en la lista de chat de forma optimista
    Y limpiar el campo de texto
    Y ocultar el teclado

  Escenario: Prevención de mensaje vacío
    Dado que el usuario se encuentra en el chat
    Y el campo de texto está vacío
    Cuando el usuario presiona enviar
    Entonces el sistema deberá impedir el envío del mensaje

  Escenario: Recepción de mensaje en tiempo real
    Dado que el usuario tiene abierto el chat de un grupo
    Cuando otro usuario envía un mensaje al grupo
    Entonces el sistema deberá recibir el mensaje mediante el feed continuo _changes
    Y agregar el mensaje al frente de la lista sin necesidad de recargar

  Escenario: Visualización de burbuja de mensaje propio
    Dado que el usuario envió un mensaje en el chat
    Cuando el usuario visualiza el mensaje en la lista
    Entonces el sistema deberá mostrar la burbuja alineada a la derecha
    Y mostrar el contenido del mensaje
    Y mostrar la marca de tiempo formateada

  Escenario: Visualización de burbuja de mensaje de otro
    Dado que otro usuario envió un mensaje en el chat
    Cuando el usuario visualiza el mensaje en la lista
    Entonces el sistema deberá mostrar la burbuja alineada a la izquierda
    Y mostrar el nombre del remitente
    Y mostrar el contenido del mensaje
    Y mostrar la marca de tiempo formateada

  Escenario: Burbuja de tipo propiedad
    Dado que se recibe un mensaje con tipo "propiedad"
    Cuando el usuario visualiza el mensaje
    Entonces el sistema deberá mostrar una burbuja especial para propiedades (placeholder)

  Escenario: Burbuja de tipo lista
    Dado que se recibe un mensaje con tipo "lista"
    Cuando el usuario visualiza el mensaje
    Entonces el sistema deberá mostrar una burbuja especial para listas compartidas (placeholder)

  Escenario: Envío con tecla Enter
    Dado que el usuario se encuentra en el chat
    Y el usuario ha escrito un mensaje en el campo de texto
    Cuando el usuario presiona la tecla Enter
    Entonces el sistema deberá enviar el mensaje
