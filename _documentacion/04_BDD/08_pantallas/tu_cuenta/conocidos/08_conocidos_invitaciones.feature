# language: es
Característica: Gestión de Invitaciones de Contactos
  Como usuario autenticado
  Quiero ver y responder a invitaciones de contacto recibidas y enviadas
  Para aceptar o rechazar solicitudes de conexión

  Escenario: La pantalla muestra tabs Recibidas y Enviadas
    Dado que el usuario navega a "PageInvitaciones"
    Cuando se renderiza la pantalla
    Entonces el sistema debe mostrar un "DefaultTabController" con 2 tabs
    Y los tabs deben ser "Recibidas" y "Enviadas"
    Y el AppBar debe mostrar el título "Invitaciones"

  Escenario: Las invitaciones recibidas muestran botones de aceptar y rechazar
    Dado que el usuario está en la pestaña "Recibidas"
    Y tiene una invitación pendiente
    Cuando se renderiza la tarjeta de invitación
    Entonces el sistema debe mostrar un botón "check_circle" para aceptar
    Y debe mostrar un botón "cancel" para rechazar
    Y el botón de aceptar debe tener color "appTheme.primary"
    Y el botón de rechazar debe tener color "appTheme.error"

  Escenario: El usuario acepta una invitación recibida
    Dado que el usuario está en la pestaña "Recibidas"
    Cuando el usuario presiona el botón "check_circle" de una invitación pendiente
    Entonces el sistema debe llamar a "conocidosProvider.notifier.responderInvitacion(inv.id, InvitacionEstado.aceptado)"
    Y la invitación debe cambiar su estado a "aceptado"
    Y debe mostrar el icono "handshake" en color "appTheme.primary"

  Escenario: El usuario rechaza una invitación recibida
    Dado que el usuario está en la pestaña "Recibidas"
    Cuando el usuario presiona el botón "cancel" de una invitación pendiente
    Entonces el sistema debe llamar a "conocidosProvider.notifier.responderInvitacion(inv.id, InvitacionEstado.rechazado)"
    Y la invitación debe cambiar su estado a "rechazado"
    Y debe mostrar el icono "block" en color "appTheme.onSurfaceVariant"

  Escenario: Las invitaciones aceptadas muestran icono de handshake
    Dado que el usuario tiene una invitación aceptada
    Cuando se renderiza la tarjeta de invitación
    Entonces el sistema debe mostrar el icono "handshake" en color "appTheme.primary"

  Escenario: Las invitaciones rechazadas muestran icono de block
    Dado que el usuario tiene una invitación rechazada
    Cuando se renderiza la tarjeta de invitación
    Entonces el sistema debe mostrar el icono "block" en color "appTheme.onSurfaceVariant"

  Escenario: Las invitaciones pendientes muestran icono de tiempo
    Dado que el usuario tiene una invitación pendiente sin responder
    Cuando se renderiza la tarjeta de invitación (en enviadas)
    Entonces el sistema debe mostrar el icono "access_time" en color "appTheme.onSurfaceVariant"

  Escenario: Las invitaciones enviadas no muestran botones de acción
    Dado que el usuario está en la pestaña "Enviadas"
    Cuando se renderiza una invitación enviada
    Entonces el sistema no debe mostrar botones de aceptar ni rechazar
    Y debe mostrar solo el icono de estado según el estado de la invitación

  Escenario: El estado de la invitación se muestra en mayúsculas
    Dado que el usuario está en la pestaña de invitaciones
    Cuando se renderiza el subtítulo de una tarjeta
    Entonces el sistema debe mostrar "Estado: {estado.name.toUpperCase()}"
    Y el estado debe ser: PENDIENTE, ACEPTADO, RECHAZADO o BLOQUEADO

  Escenario: La pantalla muestra estado vacío si no hay invitaciones
    Dado que el usuario no tiene invitaciones recibidas ni enviadas
    Cuando se renderiza la pestaña correspondiente
    Entonces el sistema debe mostrar el texto "No hay solicitudes aquí."
