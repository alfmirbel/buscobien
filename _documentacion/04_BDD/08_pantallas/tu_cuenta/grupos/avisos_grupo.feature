# language: es
Característica: Avisos del Grupo
  Como miembro de un grupo
  Quiero ver y publicar avisos importantes
  Para comunicar información relevante a todos los miembros

  Antecedentes:
    Dado que el usuario se encuentra en la pestaña "Avisos" del detalle de grupo

  Escenario: Carga inicial de avisos
    Dado que el usuario abre la pestaña "Avisos"
    Entonces el sistema deberá mostrar un indicador de carga circular centrado
    Y el sistema deberá consultar los avisos del grupo ordenados por timestamp descendente

  Escenario: Estado vacío de avisos
    Dado que el grupo no tiene avisos publicados
    Cuando la carga finalice
    Entonces el sistema deberá mostrar un ícono de notificaciones
    Y el mensaje "Aún no hay avisos en este grupo."

  Escenario: Visualización de aviso
    Dado que existen avisos en el grupo
    Cuando el usuario visualiza la lista
    Entonces el sistema deberá mostrar el nombre del autor
    Y el contenido del aviso

  Escenario: Publicar nuevo aviso
    Dado que el usuario se encuentra en la pestaña "Avisos"
    Cuando el usuario presiona el botón "Publicar aviso"
    Entonces el sistema deberá mostrar un diálogo con un campo de texto multilínea de máximo 250 caracteres

  Escenario: Validación de aviso vacío
    Dado que el diálogo de publicar aviso está abierto
    Y el campo de texto está vacío
    Cuando el usuario presiona "Publicar"
    Entonces el sistema deberá impedir la publicación del aviso

  Escenario: Validación de aviso demasiado largo
    Dado que el diálogo de publicar aviso está abierto
    Y el campo de texto tiene 251 caracteres
    Cuando el usuario presiona "Publicar"
    Entonces el sistema deberá impedir la publicación del aviso

  Escenario: Publicación exitosa de aviso
    Dado que el diálogo de publicar aviso está abierto
    Y el usuario ha ingresado un texto válido de 100 caracteres
    Cuando el usuario presiona "Publicar"
    Entonces el sistema deberá crear el aviso en la base de datos
    Y agregarlo al inicio de la lista de avisos
    Y cerrar el diálogo
    Y mostrar un SnackBar con "Aviso publicado"

  Escenario: Error al publicar aviso
    Dado que el diálogo de publicar aviso está abierto
    Y el usuario ha ingresado un texto válido
    Cuando ocurre un error en el servidor
    Entonces el sistema deberá mostrar un SnackBar con "Error al publicar"

  Escenario: Cancelar publicación de aviso
    Dado que el diálogo de publicar aviso está abierto
    Cuando el usuario presiona "Cancelar"
    Entonces el sistema deberá cerrar el diálogo sin publicar el aviso

  Escenario: Eliminar aviso propio
    Dado que el usuario es el autor de un aviso
    Cuando el usuario presiona el ícono de eliminar en el aviso
    Entonces el sistema deberá eliminar el aviso del grupo
    Y actualizar la lista de avisos

  Escenario: Sin botón eliminar para avisos de otros
    Dado que el usuario no es el autor de un aviso
    Cuando el usuario visualiza el aviso
    Entonces el sistema deberá ocultar el ícono de eliminar
