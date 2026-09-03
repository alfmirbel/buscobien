# language: es
Característica: Publicación y Despublicación de Propiedades
  Como promotor
  Quiero publicar y dejar de publicar mis propiedades
  Para controlar su visibilidad en el portal

  Antecedentes:
    Dado que el usuario es promotor
    Y tiene una propiedad registrada
    Y se encuentra en la pantalla "Tus Espacios"

  Escenario: Publicar propiedad por primera vez
    Dado que la propiedad tiene activa = 0
    Y no tiene ID de publicación previo
    Cuando el usuario presiona "Publicar"
    Y confirma la publicación
    Entonces el sistema deberá crear un nuevo documento en la base de datos de publicaciones
    Y establecer activa = 1 en la propiedad
    Y guardar el ID de publicación en fotoprincipal
    Y actualizar la propiedad en CouchDB
    Y mostrar un mensaje de éxito
    Y mostrar el indicador "PUBLICADA" en la tarjeta

  Escenario: Republicar propiedad previamente publicada
    Dado que la propiedad tiene activa = 1
    Y tiene un ID de publicación previo
    Cuando el usuario presiona "Publicar"
    Y confirma la publicación
    Entonces el sistema deberá actualizar el documento existente en la base de datos de publicaciones
    Y mantener activa = 1
    Y actualizar la fecha de publicación
    Y mostrar un mensaje de éxito

  Escenario: Error al publicar propiedad - fallo en inserción
    Dado que el usuario confirma la publicación
    Cuando ocurre un error al crear el documento en CouchDB
    Entonces el sistema deberá mostrar un mensaje "Error: no se pudo publicar"
    Y restaurar el estado de la propiedad (activa = 0, fotoprincipal = "")

  Escenario: Error al publicar propiedad - fallo en actualización del espacio
    Dado que la publicación se creó exitosamente
    Cuando ocurre un error al actualizar la propiedad en CouchDB
    Entonces el sistema deberá eliminar la publicación creada
    Y restaurar el estado de la propiedad (activa = 0, fotoprincipal = "")
    Y mostrar un mensaje "Error: no se pudo actualizar el espacio"

  Escenario: Dejar de publicar propiedad
    Dado que la propiedad tiene activa = 1
    Cuando el usuario presiona "Dejar de publicar"
    Y confirma la acción
    Entonces el sistema deberá eliminar el documento de publicación de CouchDB
    Y establecer activa = 0 en la propiedad
    Y limpiar el ID de publicación de fotoprincipal
    Y actualizar la propiedad en CouchDB
    Y mostrar el indicador "SIN PUBLICAR" en la tarjeta

  Escenario: Error al dejar de publicar propiedad
    Dado que el usuario confirma dejar de publicar
    Cuando ocurre un error al eliminar la publicación
    Entonces el sistema deberá mostrar un mensaje de error
    Y mantener la propiedad como publicada

  Escenario: Indicador de carga durante publicación
    Dado que el usuario confirmó la publicación
    Cuando el sistema está procesando la solicitud
    Entonces el sistema deberá mostrar un indicador de carga circular en el diálogo
    Y deshabilitar los botones del diálogo

  Escenario: Actualización de estado después de publicar
    Dado que la propiedad se publicó exitosamente
    Cuando el sistema actualiza el estado
    Entonces el sistema deberá actualizar el índice en Riverpod
    Y refrescar la lista de propiedades en la pantalla
    Y el usuario deberá ver la tarjeta actualizada con el estado "PUBLICADA"
