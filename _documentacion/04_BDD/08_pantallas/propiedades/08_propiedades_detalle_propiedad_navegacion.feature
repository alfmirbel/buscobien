# language: es
Característica: Búsqueda y Navegación a Detalle de Propiedad
  Como usuario de BuscoBien
  Quiero acceder al detalle de una propiedad desde diferentes secciones de la app
  Para ver la información completa del inmueble

  Escenario: El usuario navega al detalle desde la lista de propiedades
    Dado que el usuario está en "PaginaBuscaEspacios"
    Cuando presiona una tarjeta de propiedad
    Entonces el sistema debe navegar a "PaginaDetalleWidget"
    Y debe pasar "ValueEspaciosCasaGet" y "GetIdsFotosUserProp" como parámetros

  Escenario: El usuario navega al detalle desde el mapa de propiedades
    Dado que el usuario está en "PaginaMapaPropiedades"
    Cuando presiona un marcador de propiedad
    Entonces el sistema debe navegar a "PaginaDetalleWidget"
    Y debe pasar la propiedad seleccionada y sus IDs de fotos

  Escenario: El usuario navega al detalle desde un chat
    Dado que el usuario está en una conversación de chat
    Cuando presiona una propiedad compartida en el chat
    Entonces el sistema debe navegar a "PaginaDetalleWidget"
    Y debe establecer "fromChatUserId" con el ID del usuario que compartió
    Y debe mostrar el botón "Guardar en lista"

  Escenario: El detalle muestra el botón Guardar en lista solo cuando viene del chat
    Dado que el usuario abrió el detalle desde un chat
    Cuando se renderiza "PaginaDetalleWidget"
    Entonces el sistema debe mostrar el botón "Guardar en lista"
    Y al presionarlo debe permitir agregar la propiedad a una lista del usuario

  Escenario: El detalle no muestra el botón Guardar en lista cuando viene de la lista normal
    Dado que el usuario abrió el detalle desde "PaginaBuscaEspacios"
    Cuando se renderiza "PaginaDetalleWidget"
    Entonces el sistema no debe mostrar el botón "Guardar en lista"

  Escenario: El detalle carga las fotos ordenadas si están disponibles
    Dado que la propiedad tiene fotos ordenadas en "getListaFotosOrdenadasProvider"
    Cuando se renderiza la galería
    Entonces el sistema debe usar el orden definido en el provider
    Y debe mostrar las fotos en el orden especificado

  Escenario: El detalle carga las fotos en el orden de llegada si no hay orden guardado
    Dado que la propiedad no tiene orden de fotos guardado
    Cuando se renderiza la galería
    Entonces el sistema debe usar el orden de "listaIdsFotos.rows"
    Y debe mostrar las fotos en el orden en que llegaron
