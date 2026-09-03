# language: es
Característica: Búsqueda de Propiedades Inmobiliarias
  Como usuario interesado en adquirir o rentar un inmueble
  Quiero buscar propiedades disponibles en la plataforma
  Para encontrar opciones que se ajusten a mis necesidades

  Escenario: Visualización de resultados de búsqueda con paginación
    Dado que el usuario ha realizado una búsqueda de propiedades
    Y el sistema ha consultado el servicio de propiedades
    Cuando la respuesta contiene una lista de documentos
    Entonces el sistema debe mostrar cada propiedad con su identificador único
    Y el sistema debe mostrar la clave de la propiedad asociada
    Y el sistema debe mostrar la información de espacios de la propiedad
    Y el sistema debe almacenar el marcador de paginación para cargar más resultados

  Escenario: Estructura de datos de cada propiedad encontrada
    Dado que el usuario ve los resultados de búsqueda
    Y cada resultado contiene un documento de propiedad
    Cuando el sistema procesa el documento
    Entonces el documento debe tener un identificador único de CouchDB
    Y el documento debe tener un identificador de revisión
    Y el documento debe contener la información estructurada de espacios de la casa
