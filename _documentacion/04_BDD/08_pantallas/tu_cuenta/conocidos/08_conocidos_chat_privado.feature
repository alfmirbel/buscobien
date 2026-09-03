# language: es
Característica: Chat Privado entre Contactos
  Como usuario autenticado
  Quiero enviar y recibir mensajes privados con mis contactos
  Para comunicarme directamente con otros usuarios de la plataforma

  Escenario: El chat muestra el nombre del contacto en el AppBar
    Dado que el usuario navega a "PageChatPrivado" con "targetName = María"
    Cuando se renderiza la pantalla
    Entonces el sistema debe mostrar el AppBar con título "María"
    Y el AppBar debe tener "toolbarHeight: socialAppBarHeight"
    Y debe mostrar un botón de refresh para recargar mensajes

  Escenario: El chat carga los mensajes al montar
    Dado que el usuario está en "PageChatPrivado"
    Cuando se renderiza el contenido
    Entonces el sistema debe generar "_chatKey" con "chatProviderKey(currentUserId, targetUserId)"
    Y debe observar "mensajesChatProvider(_chatKey)" para cargar los mensajes

  Escenario: El chat muestra indicador de carga mientras obtiene mensajes
    Dado que el usuario acaba de abrir el chat
    Cuando "mensajesChatProvider" está en estado "loading"
    Entonces el sistema debe mostrar un "CircularProgressIndicator" centrado

  Escenario: El chat muestra error si falla la carga de mensajes
    Dado que el usuario está en "PageChatPrivado"
    Cuando "mensajesChatProvider" emite "error"
    Entonces el sistema debe mostrar el texto "Error: $err" centrado

  Escenario: El chat muestra estado vacío cuando no hay mensajes
    Dado que el usuario y el contacto no tienen mensajes previos
    Cuando se renderiza el chat
    Entonces el sistema debe mostrar el texto "Envía el primer mensaje."

  Escenario: Los mensajes se alinean según el remitente
    Dado que el usuario está en "PageChatPrivado"
    Cuando se renderiza un mensaje del usuario actual
    Entonces el mensaje debe estar alineado a la derecha
    Y el color de fondo debe ser "appTheme.secondary"
    Y el texto debe ser "appTheme.onSecondary"

  Escenario: Los mensajes del otro contacto se alinean a la izquierda
    Dado que el usuario está en "PageChatPrivado"
    Cuando se renderiza un mensaje del contacto
    Entonces el mensaje debe estar alineado a la izquierda
    Y el color de fondo debe ser "appTheme.onInverseSurface"
    Y el texto debe ser "appTheme.onSecondaryContainer"

  Escenario: El usuario puede enviar un mensaje de texto
    Dado que el usuario está en "PageChatPrivado"
    Y escribe "Hola, ¿cómo estás?" en el campo de texto
    Cuando presiona el botón de enviar
    Entonces el sistema debe llamar a "mensajesChatProvider(_chatKey).notifier.enviar('Hola, ¿cómo estás?')"
    Y debe limpiar el campo de texto
    Y debe ocultar el teclado

  Escenario: El usuario puede enviar un mensaje presionando Enter
    Dado que el usuario está en "PageChatPrivado"
    Y escribe un mensaje en el TextField
    Cuando presiona la tecla Enter
    Entonces el sistema debe ejecutar "_send()" y enviar el mensaje

  Escenario: El chat no envía mensajes vacíos
    Dado que el usuario está en "PageChatPrivado"
    Y el campo de texto está vacío
    Cuando presiona el botón de enviar
    Entonces el sistema no debe ejecutar ninguna acción
    Y no debe crear un mensaje vacío

  Escenario: Los mensajes tienen timestamp formateado
    Dado que el usuario está en "PageChatPrivado"
    Cuando se renderiza un mensaje
    Entonces el sistema debe mostrar "formatChatTimestamp(msg.timestamp)" en tamaño 10
    Y el color del timestamp debe ser "appTheme.onSecondary" (usuario) o "appTheme.onPrimaryContainer" (contacto)

  Escenario: El chat muestra burbujas especiales para propiedades
    Dado que el usuario recibe un mensaje con "tipo = 'propiedad'"
    Cuando se renderiza el mensaje
    Entonces el sistema debe mostrar "_BurbujaPropiedad" con icono "Symbols.home"
    Y debe mostrar el texto "Toca para ver la ficha"
    Y al tocarlo debe navegar a "PaginaDetalleWidget"

  Escenario: El chat muestra burbujas especiales para listas
    Dado que el usuario recibe un mensaje con "tipo = 'lista'"
    Cuando se renderiza el mensaje
    Entonces el sistema debe mostrar "_BurbujaLista" con icono "Symbols.format_list_bulleted"
    Y debe mostrar el texto "Toca para ver las propiedades"
    Y al tocarlo debe navegar a "PageDetalleListaCompartida"

  Escenario: El campo de texto tiene estilo consistente
    Dado que el usuario está en "PageChatPrivado"
    Cuando se renderiza el campo de mensaje
    Entonces el TextField debe tener "maxLines: 10" y "textCapitalization: TextCapitalization.sentences"
    Y debe tener "hintText: 'Escribe un mensaje...'"
    Y debe tener "fillColor: appTheme.surface" con bordes redondeados de radio 9

  Escenario: El botón de enviar tiene estilo circular
    Dado que el usuario está en "PageChatPrivado"
    Cuando se renderiza el botón de enviar
    Entonces el sistema debe mostrar un "CircleAvatar" con "backgroundColor: appTheme.onPrimary"
    Y debe contener un "IconButton" con icono "Symbols.send" en color "appTheme.primary"
