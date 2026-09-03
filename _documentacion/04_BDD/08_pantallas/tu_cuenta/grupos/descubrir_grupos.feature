# language: es
Característica: Descubrimiento de Grupos Públicos
  Como usuario de BuscoBien
  Quiero descubrir grupos públicos disponibles
  Para unirme o solicitar acceso a comunidades de bienes raíces

  Antecedentes:
    Dado que el usuario ha iniciado sesión en la aplicación
    Y se encuentra en la pestaña "Descubrir"

  Escenario: Carga inicial de grupos públicos
    Dado que el usuario abre la pantalla "Descubrir"
    Entonces el sistema deberá mostrar un indicador de carga circular centrado
    Y el sistema deberá consultar todos los grupos con privacidad "publica"

  Escenario: Visualización de error en carga
    Dado que ocurre un error al cargar los grupos públicos
    Cuando la carga falle
    Entonces el sistema deberá mostrar un ícono de error
    Y el mensaje "Error al cargar grupos"
    Y un botón "Reintentar" para volver a cargar

  Escenario: Filtrado de grupos donde ya soy miembro
    Dado que el usuario ya es miembro de algunos grupos públicos
    Cuando se cargan los grupos públicos
    Entonces el sistema deberá ocultar los grupos donde el usuario ya es miembro
    Y mostrar solo los grupos disponibles

  Escenario: Estado vacío de grupos disponibles
    Dado que no hay grupos públicos disponibles
    O el usuario ya es miembro de todos los grupos públicos
    Cuando la carga finalice
    Entonces el sistema deberá mostrar un ícono de búsqueda sin resultados
    Y el mensaje "No hay grupos públicos disponibles."

  Escenario: Visualización de contador de grupos
    Dado que existen grupos públicos disponibles
    Cuando la carga finalice
    Entonces el sistema deberá mostrar el texto "[N] grupo(s) disponible(s)"

  Escenario: Actualización manual de grupos
    Dado que el usuario se encuentra en la pantalla "Descubrir"
    Cuando el usuario presiona el botón de actualizar
    Entonces el sistema deberá invalidar el proveedor de grupos públicos y recargar

  Escenario: Unirse a grupo abierto
    Dado que el usuario visualiza un grupo público con participación "abierta"
    Cuando el usuario presiona el botón "Unirse"
    Entonces el sistema deberá agregar al usuario como miembro del grupo
    Y mostrar un SnackBar con "Te uniste a [nombre del grupo]"
    Y recargar la lista de grupos públicos para ocultar el grupo unido

  Escenario: Error al unirse a grupo abierto
    Dado que el usuario presiona "Unirse" en un grupo abierto
    Cuando ocurre un error en el servidor
    Entonces el sistema deberá mostrar un SnackBar con "Error al unirse"

  Escenario: Solicitar acceso a grupo por invitación
    Dado que el usuario visualiza un grupo público con participación "por invitación"
    Cuando el usuario presiona el botón "Solicitar"
    Entonces el sistema deberá enviar una invitación al creador del grupo
    Y mostrar un SnackBar con "Solicitud enviada al administrador"

  Escenario: Prevención de solicitud duplicada
    Dado que el usuario ya tiene una solicitud pendiente para un grupo
    Cuando el usuario presiona "Solicitar" nuevamente
    Entonces el sistema deberá mostrar un SnackBar con "Ya tienes una solicitud pendiente"

  Escenario: Ver detalle de grupo
    Dado que el usuario visualiza un grupo en la pantalla "Descubrir"
    Cuando el usuario presiona el botón "Ver"
    Entonces el sistema deberá navegar a la pantalla de detalle del grupo

  Escenario: Visualización de información del grupo
    Dado que el usuario visualiza un grupo en "Descubrir"
    Entonces el sistema deberá mostrar el nombre del grupo
    Y el objetivo (si existe)
    Y la descripción (si existe)
    Y el número de miembros
    Y el botón de acción correspondiente al tipo de participación
