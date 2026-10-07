# language: es
Característica: Detalle y Gestión de Propiedades en una Lista
  Como usuario autenticado
  Quiero ver las propiedades guardadas en una lista y gestionarlas
  Para mantener organizadas mis propiedades de interés

  Escenario: El detalle de una lista muestra sus propiedades
    Dado que el usuario abre una lista que contiene propiedades
    Cuando se renderiza "PageDetalleLista"
    Entonces el sistema debe mostrar el título "Lista: [nombre de la lista]"
    Y debe mostrar cada propiedad como una tarjeta con su imagen, nombre y precio

  Escenario: El usuario puede quitar una propiedad de la lista deslizando
    Dado que el usuario está en el detalle de una lista
    Cuando desliza una propiedad hacia la izquierda
    Y confirma en el diálogo "Quitar propiedad"
    Entonces el sistema debe eliminar la relación propiedad-lista de la base de datos
    Y debe mostrar un SnackBar con el texto "Propiedad eliminada de la lista"
    Y la propiedad debe desaparecer del detalle

  Escenario: El usuario cancela la eliminación de una propiedad
    Dado que el usuario desliza una propiedad hacia la izquierda
    Cuando aparece el diálogo "Quitar propiedad"
    Y presiona "Cancelar"
    Entonces el sistema debe mantener la propiedad en el detalle de la lista
    Y no debe mostrar ningún mensaje de error

  Escenario: El detalle de una lista vacía muestra un estado informativo
    Dado que el usuario abre una lista sin propiedades
    Cuando se renderiza "PageDetalleLista"
    Entonces el sistema debe mostrar el icono "folder_open"
    Y debe mostrar el texto "Esta lista está vacía."

  Escenario: El sistema busca la propiedad en todos los endpoints cuando falta el tipo de espacio
    Dado que una propiedad en la lista tiene "tipodeespacio" vacío
    Cuando se renderiza el detalle de la lista
    Entonces el sistema debe buscar la propiedad en todos los endpoints disponibles
    Y debe mostrar la propiedad encontrada en la tarjeta correspondiente

  Escenario: El detalle muestra un mensaje cuando no se encuentra una propiedad
    Dado que una propiedad fue eliminada de la base de datos
    Cuando el sistema intenta cargar sus datos en el detalle de la lista
    Entonces el sistema debe mostrar el texto "No se encontró la propiedad."
    Y no debe mostrar una tarjeta de propiedad vacía o rota

  Escenario: El indicador de carga aparece mientras se obtienen las propiedades
    Dado que el usuario acaba de abrir el detalle de una lista
    Cuando las propiedades aún se están cargando desde el servidor
    Entonces el sistema debe mostrar un "CircularProgressIndicator" centrado
    Y no debe mostrar contenido parcial o tarjetas vacías
