# language: es
Característica: Publicaciones de Propiedades en Grupo
  Como miembro de un grupo
  Quiero ver y gestionar publicaciones de propiedades compartidas
  Para mantenerme informado sobre los bienes compartidos

  Antecedentes:
    Dado que el usuario se encuentra en la pestaña "Publicaciones" del detalle de grupo

  Escenario: Carga inicial de publicaciones
    Dado que el usuario abre la pestaña "Publicaciones"
    Entonces el sistema deberá mostrar un indicador de carga circular centrado
    Y el sistema deberá consultar las publicaciones del grupo ordenadas por timestamp descendente

  Escenario: Estado vacío de publicaciones
    Dado que el grupo no tiene publicaciones compartidas
    Cuando la carga finalice
    Entonces el sistema deberá mostrar un ícono de artículo
    Y el mensaje "Aún no hay propiedades compartidas en este grupo."

  Escenario: Visualización de publicación
    Dado que existen publicaciones en el grupo
    Cuando el usuario visualiza la lista
    Entonces el sistema deberá mostrar el nombre de la propiedad
    Y el tipo de espacio
    Y el nombre del autor que compartió la propiedad

  Escenario: Ver detalle de propiedad publicada
    Dado que el usuario visualiza una publicación
    Cuando el usuario presiona el ícono de abrir propiedad
    Entonces el sistema deberá navegar a la pantalla de detalle de la propiedad

  Escenario: Cargar más publicaciones
    Dado que existen más de 10 publicaciones en el grupo
    Cuando el usuario presiona "Cargar más"
    Entonces el sistema deberá cargar las siguientes 10 publicaciones
    Y agregarlas al final de la lista

  Escenario: Sin botón cargar más cuando no hay más publicaciones
    Dado que se han cargado todas las publicaciones disponibles
    Cuando el usuario visualiza la lista
    Entonces el sistema deberá ocultar el botón "Cargar más"

  Escenario: Eliminar publicación propia
    Dado que el usuario es el autor de una publicación
    Cuando el usuario presiona el ícono de eliminar
    Entonces el sistema deberá eliminar la publicación del grupo
    Y actualizar la lista de publicaciones

  Escenario: Sin botón eliminar para publicaciones de otros
    Dado que el usuario no es el autor de una publicación
    Cuando el usuario visualiza la tarjeta de publicación
    Entonces el sistema deberá ocultar el ícono de eliminar
