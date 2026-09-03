# language: es
Característica: Gestión de Mis Grupos
  Como usuario de BuscoBien
  Quiero ver mis grupos y crear nuevos grupos
  Para participar en comunidades de bienes raíces

  Antecedentes:
    Dado que el usuario ha iniciado sesión en la aplicación
    Y se encuentra en la pestaña "Mis Grupos"

  Escenario: Carga inicial de grupos
    Dado que el usuario abre la pantalla "Mis Grupos"
    Entonces el sistema deberá mostrar un indicador de carga circular centrado
    Y el sistema deberá consultar los grupos donde el usuario es miembro
    Y mostrar la lista de grupos cuando la carga finalice

  Escenario: Visualización de estado vacío
    Dado que el usuario no pertenece a ningún grupo
    Cuando la carga de grupos finalice
    Entonces el sistema deberá mostrar un ícono de grupos
    Y el mensaje "Aún no perteneces a ningún grupo."
    Y el texto "Crea uno o busca grupos en Descubrir."

  Escenario: Visualización de error en carga
    Dado que ocurre un error al cargar los grupos
    Cuando la carga falle
    Entonces el sistema deberá mostrar un ícono de error
    Y el mensaje "Error al cargar grupos"
    Y un botón "Reintentar" para volver a cargar

  Escenario: Reintentar carga de grupos
    Dado que se mostró un error al cargar grupos
    Cuando el usuario presiona el botón "Reintentar"
    Entonces el sistema deberá volver a consultar los grupos del usuario

  Escenario: Actualización pull-to-refresh
    Dado que el usuario visualiza la lista de grupos
    Cuando el usuario realiza pull-to-refresh
    Entonces el sistema deberá recargar la lista de grupos

  Escenario: Apertura de diálogo de crear grupo
    Dado que el usuario se encuentra en "Mis Grupos"
    Cuando el usuario presiona el botón flotante "Crea grupo"
    Entonces el sistema deberá mostrar un diálogo con campos de nombre, descripción, objetivo, privacidad y participación

  Escenario: Validación de nombre obligatorio
    Dado que el diálogo de crear grupo está abierto
    Y el campo "Nombre" está vacío
    Cuando el usuario presiona el botón "Crear"
    Entonces el sistema deberá impedir la creación del grupo
    Y el diálogo deberá permanecer abierto

  Escenario: Creación exitosa de grupo
    Dado que el diálogo de crear grupo está abierto
    Y el usuario ha ingresado un nombre válido
    Y ha configurado privacidad "Pública" y participación "Abierta"
    Cuando el usuario presiona el botón "Crear"
    Entonces el sistema deberá crear un nuevo grupo en la base de datos
    Y el creador deberá ser el primer miembro con rol "admin"
    Y cerrar el diálogo
    Y mostrar un mensaje de éxito
    Y el nuevo grupo deberá aparecer en la lista

  Escenario: Error al crear grupo
    Dado que el diálogo de crear grupo está abierto
    Y el usuario ha ingresado un nombre válido
    Cuando ocurre un error en el servidor al crear el grupo
    Entonces el sistema deberá mostrar un SnackBar con "Error al crear el grupo"

  Escenario: Cancelar creación de grupo
    Dado que el diálogo de crear grupo está abierto
    Cuando el usuario presiona el botón "Cancelar"
    Entonces el sistema deberá cerrar el diálogo sin crear el grupo

  Escenario: Selección de privacidad pública
    Dado que el diálogo de crear grupo está abierto
    Cuando el usuario selecciona "Público" en el campo Privacidad
    Entonces el sistema deberá establecer la privacidad del grupo como "publica"

  Escenario: Selección de privacidad privada
    Dado que el diálogo de crear grupo está abierto
    Cuando el usuario selecciona "Privado" en el campo Privacidad
    Entonces el sistema deberá establecer la privacidad del grupo como "privada"

  Escenario: Selección de participación abierta
    Dado que el diálogo de crear grupo está abierto
    Cuando el usuario selecciona "Abierto" en el campo Participación
    Entonces el sistema deberá establecer la participación del grupo como "abierta"

  Escenario: Selección de participación por invitación
    Dado que el diálogo de crear grupo está abierto
    Cuando el usuario selecciona "Por invitación" en el campo Participación
    Entonces el sistema deberá establecer la participación del grupo como "invitacion"

  Escenario: Navegación a detalle de grupo
    Dado que el usuario visualiza la lista de sus grupos
    Cuando el usuario presiona la tarjeta de un grupo
    Entonces el sistema deberá navegar a la pantalla de detalle del grupo

  Escenario: Visualización de chip de administrador
    Dado que el usuario es administrador de un grupo
    Cuando el usuario visualiza la tarjeta del grupo en "Mis Grupos"
    Entonces el sistema deberá mostrar un chip "Admin" en la tarjeta

  Escenario: Visualización de información de grupo
    Dado que el usuario visualiza la lista de grupos
    Cuando el usuario observa una tarjeta de grupo
    Entonces el sistema deberá mostrar el nombre del grupo
    Y la descripción (si existe)
    Y el número de miembros
    Y el ícono de privacidad (público/privado)
