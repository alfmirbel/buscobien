# language: es
Característica: Gestión de Invitaciones a Grupos
  Como usuario de BuscoBien
  Quiero recibir y enviar invitaciones a grupos
  Para unirme a grupos o invitar a otros usuarios

  Antecedentes:
    Dado que el usuario ha iniciado sesión en la aplicación
    Y se encuentra en la pestaña "Invitaciones"

  Escenario: Carga inicial de invitaciones
    Dado que el usuario abre la pantalla "Invitaciones"
    Entonces el sistema deberá mostrar un indicador de carga circular centrado
    Y el sistema deberá consultar todas las invitaciones donde el usuario es remitente o destinatario

  Escenario: Visualización de pestañas Recibidas y Enviadas
    Dado que el usuario se encuentra en la pantalla "Invitaciones"
    Entonces el sistema deberá mostrar dos pestañas: "Recibidas" y "Enviadas"
    Y la pestaña "Recibidas" deberá estar activa por defecto

  Escenario: Estado vacío de invitaciones recibidas
    Dado que el usuario no tiene invitaciones recibidas
    Cuando la carga finalice
    Entonces el sistema deberá mostrar un ícono de bandeja de entrada
    Y el mensaje "No tienes invitaciones recibidas."

  Escenario: Estado vacío de invitaciones enviadas
    Dado que el usuario no ha enviado invitaciones
    Cuando el usuario cambia a la pestaña "Enviadas"
    Entonces el sistema deberá mostrar un ícono de bandeja de salida
    Y el mensaje "No has enviado invitaciones."

  Escenario: Visualización de invitación recibida
    Dado que el usuario tiene una invitación recibida pendiente
    Cuando el usuario visualiza la pestaña "Recibidas"
    Entonces el sistema deberá mostrar el nombre del grupo
    Y el nombre del usuario que envió la invitación
    Y un badge de estado "Pendiente"
    Y los botones "Aceptar" y "Rechazar"

  Escenario: Visualización de invitación enviada
    Dado que el usuario envió una invitación
    Cuando el usuario visualiza la pestaña "Enviadas"
    Entonces el sistema deberá mostrar el nombre del grupo
    Y el nombre del destinatario
    Y el estado de la invitación (Pendiente, Aceptada o Rechazada)

  Escenario: Aceptar invitación recibida
    Dado que el usuario tiene una invitación recibida pendiente
    Cuando el usuario presiona el botón "Aceptar"
    Entonces el sistema deberá actualizar el estado de la invitación a "accepted"
    Y agregar al usuario como miembro del grupo con rol "miembro"
    Y recargar la lista de "Mis Grupos"
    Y mostrar un SnackBar con "Te uniste a [nombre del grupo]"

  Escenario: Rechazar invitación recibida
    Dado que el usuario tiene una invitación recibida pendiente
    Cuando el usuario presiona el botón "Rechazar"
    Entonces el sistema deberá actualizar el estado de la invitación a "rejected"
    Y mostrar un SnackBar con "Invitación rechazada"

  Escenario: Actualización manual de invitaciones
    Dado que el usuario se encuentra en la pantalla "Invitaciones"
    Cuando el usuario presiona el botón de actualizar
    Entonces el sistema deberá recargar las invitaciones desde el servidor

  Escenario: Envío de invitación desde detalle de grupo (admin)
    Dado que el usuario es administrador de un grupo
    Y se encuentra en la pantalla de detalle del grupo
    Cuando el usuario presiona el ícono de invitar miembro
    Entonces el sistema deberá mostrar un diálogo con lista de usuarios y promotores disponibles

  Escenario: Invitación masiva de usuarios
    Dado que el diálogo de invitar miembros está abierto
    Y el administrador ha seleccionado 3 usuarios
    Cuando el administrador presiona "Enviar"
    Entonces el sistema deberá enviar una invitación por cada usuario seleccionado
    Y mostrar un SnackBar con el resumen: "Invitaciones enviadas (3)"

  Escenario: Prevención de invitación duplicada
    Dado que existe una invitación pendiente del mismo remitente al mismo destinatario para el mismo grupo
    Cuando el administrador intenta enviar otra invitación
    Entonces el sistema deberá impedir el envío duplicado
    Y mostrar un mensaje indicando que ya existe una solicitud pendiente

  Escenario: Filtrado de usuarios no disponibles para invitar
    Dado que el diálogo de invitar miembros está abierto
    Entonces el sistema deberá excluir al usuario actual de la lista
    Y excluir a los usuarios que ya son miembros del grupo
