# language: es
Característica: Estados de Carga y Vacío en la Búsqueda de Propiedades
  Como usuario de BuscoBien
  Quiero ver indicadores claros mientras se cargan las propiedades
  Para entender el estado de la aplicación y no repetir acciones innecesarias

  Escenario: El sistema muestra un indicador circular mientras carga el conteo
    Dado que el usuario acaba de navegar a la sección "Propiedades"
    Cuando el provider "viewCountFilterPropiedadesProvider" está en estado "loading"
    Entonces el sistema debe mostrar un "CircularProgressIndicator" centrado
    Y no debe mostrar contenido parcial ni tarjetas de propiedades

  Escenario: El sistema muestra un indicador lineal mientras carga la lista
    Dado que el provider "viewCountFilterPropiedadesProvider" ya cargó el conteo
    Y el provider "findPropiedadesEstadosde10en10Provider" está en estado "loading"
    Cuando se renderiza la lista de propiedades
    Entonces el sistema debe mostrar un "LinearProgressIndicator" con padding de 20
    Y no debe mostrar tarjetas de propiedades incompletas

  Escenario: El sistema muestra un mensaje de error si falla la carga del conteo
    Dado que el usuario está en la sección "Propiedades"
    Cuando "viewCountFilterPropiedadesProvider" emite un estado "error"
    Entonces el sistema debe mostrar el texto "Error: $err" centrado en la pantalla

  Escenario: El sistema muestra un mensaje de error si falla la carga de la lista
    Dado que el conteo de propiedades ya cargó exitosamente
    Cuando "findPropiedadesEstadosde10en10Provider" emite un estado "error"
    Entonces el sistema debe mostrar el texto "Error al cargar lista: $e"

  Escenario: El sistema muestra un estado vacío cuando no hay propiedades
    Dado que el usuario aplicó filtros que no arrojan resultados
    Cuando "findPropiedadesEstadosde10en10Provider" retorna "rows.isEmpty"
    Entonces el sistema debe mostrar el texto "No hay propiedades que mostrar"
    Y no debe mostrar el paginador superior ni inferior
    Y no debe mostrar el FAB de mapa

  Escenario: El sistema oculta el FAB cuando no hay propiedades
    Dado que no hay propiedades que mostrar
    Cuando se renderiza "PaginaBuscaEspacios"
    Entonces la variable "mostrarmapa" debe ser "false"
    Y el "FloatingActionButton" no debe estar visible
