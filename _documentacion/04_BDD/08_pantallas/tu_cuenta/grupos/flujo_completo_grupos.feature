# language: es
Característica: Flujo completo del Módulo Grupos
  Como usuario de BuscoBien
  Quiero interactuar con todas las funcionalidades del módulo Grupos
  Para gestionar mi participación en comunidades de bienes raíces

  Antecedentes:
    Dado que el usuario "Juan Pérez" ha iniciado sesión en la aplicación
    Y su ID de usuario es "user-juan-123"

  Escenario: Flujo completo de creación de grupo y participación
    Dado que Juan se encuentra en la pestaña "Mis Grupos"
    Y no pertenece a ningún grupo
    Cuando Juan presiona "Crea grupo"
    Y completa el formulario con:
      | campo         | valor                    |
      | nombre        | "Inversionistas Norte"   |
      | descripcion   | "Grupo para inversiones" |
      | objetivo      | "Compartir oportunidades"|
      | privacidad    | "publica"               |
      | participacion | "abierta"               |
    Y presiona "Crear"
    Entonces el sistema deberá crear el grupo "Inversionistas Norte"
    Y Juan deberá ser el administrador del grupo
    Y el grupo deberá aparecer en la lista de "Mis Grupos"

  Escenario: Flujo de descubrimiento y unión a grupo
    Dado que existe un grupo público "Comunidad Sur" con participación abierta
    Y Juan no es miembro de "Comunidad Sur"
    Cuando Juan navega a la pestaña "Descubrir"
    Y visualiza el grupo "Comunidad Sur"
    Y presiona "Unirse"
    Entonces el sistema deberá agregar a Juan como miembro de "Comunidad Sur"
    Y el grupo "Comunidad Sur" deberá desaparecer de la lista de descubrimiento

  Escenario: Flujo de invitación y aceptación
    Dado que "María García" es administradora del grupo "Red de Agentes"
    Y Juan no es miembro de "Red de Agentes"
    Cuando María envía una invitación a Juan para "Red de Agentes"
    Y Juan navega a la pestaña "Invitaciones"
    Y visualiza la invitación pendiente de "Red de Agentes"
    Y presiona "Aceptar"
    Entonces el sistema deberá actualizar la invitación a "accepted"
    Y Juan deberá ser miembro de "Red de Agentes" con rol "miembro"
    Y el grupo deberá aparecer en "Mis Grupos" de Juan
    Y mostrar un SnackBar de confirmación

  Escenario: Flujo de rechazo de invitación
    Dado que Juan tiene una invitación pendiente al grupo "Grupo Privado"
    Cuando Juan presiona "Rechazar"
    Entonces el sistema deberá actualizar la invitación a "rejected"
    Y mostrar un SnackBar "Invitación rechazada"
    Y Juan no deberá ser miembro del grupo

  Escenario: Flujo de publicación y visualización de propiedad
    Dado que Juan es miembro del grupo "Inversionistas Norte"
    Y Juan tiene una propiedad "Casa en Colonia Roma"
    Cuando Juan comparte "Casa en Colonia Roma" en el grupo
    Y navega a la pestaña "Publicaciones"
    Entonces el sistema deberá mostrar la publicación de "Casa en Colonia Roma"
    Y mostrar el nombre del tipo de espacio
    Y mostrar "Compartido por Juan Pérez"

  Escenario: Flujo de chat en tiempo real
    Dado que Juan y María son miembros del grupo "Red de Agentes"
    Y Juan tiene abierta la pestaña "Chat" del grupo
    Cuando Juan escribe "¿Alguien tiene propiedades en Polanco?" y presiona enviar
    Entonces el sistema deberá mostrar el mensaje en el chat de Juan
    Y María deberá recibir el mensaje en tiempo real sin recargar

  Escenario: Flujo de publicación y eliminación de aviso
    Dado que Juan es administrador del grupo "Inversionistas Norte"
    Cuando Juan publica el aviso "Reunión mañana a las 10:00"
    Entonces el aviso deberá aparecer al inicio de la lista de avisos
    Cuando Juan presiona eliminar en su propio aviso
    Entonces el aviso deberá desaparecer de la lista

  Escenario: Flujo de solicitud a grupo por invitación
    Dado que existe el grupo público "Grupo Exclusivo" con participación "por invitación"
    Y Juan no es miembro
    Cuando Juan presiona "Solicitar" en "Grupo Exclusivo"
    Entonces el sistema deberá enviar una invitación al creador del grupo
    Y mostrar un SnackBar "Solicitud enviada al administrador"
    Si Juan intenta solicitar nuevamente
    Entonces el sistema deberá mostrar "Ya tienes una solicitud pendiente"
