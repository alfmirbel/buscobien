# language: es
Característica: Paginación de Resultados de Propiedades
  Como usuario de BuscoBien
  Quiero navegar por páginas de propiedades
  Para ver todos los resultados sin saturar la pantalla

  Escenario: El paginador superior se muestra solo cuando hay resultados
    Dado que el usuario aplicó filtros que arrojan resultados
    Y el total de documentos es mayor a 0
    Cuando se renderiza "PaginaBuscaEspacios"
    Entonces el sistema debe mostrar el paginador superior encima de la lista
    Y debe mostrar el paginador inferior debajo de la lista

  Escenario: El paginador se oculta cuando no hay resultados
    Dado que el total de documentos es 0
    Cuando se renderiza "PaginaBuscaEspacios"
    Entonces el sistema no debe mostrar el paginador superior
    Y no debe mostrar el paginador inferior

  Escenario: El usuario avanza a la siguiente página de propiedades
    Dado que el usuario está viendo la página 1 de resultados
    Y hay más propiedades disponibles
    Cuando el usuario presiona el botón de siguiente página
    Entonces el sistema debe aumentar "paramSkip" en "numerodefichas"
    Y debe disparar una nueva petición de propiedades
    Y el texto del paginador debe actualizarse al nuevo rango

  Escenario: El usuario retrocede a la página anterior
    Dado que el usuario está viendo la página 2 de resultados
    Y "paramSkip" es mayor a 0
    Cuando el usuario presiona el botón de página anterior
    Entonces el sistema debe disminuir "paramSkip" en "numerodefichas"
    Y debe disparar una nueva petición de propiedades
    Y el texto del paginador debe actualizarse al nuevo rango

  Escenario: El botón de página anterior está deshabilitado en la primera página
    Dado que el usuario está en la página 1 de resultados
    Y "paramSkip" es 0
    Cuando se renderiza el botón de página anterior
    Entonces el botón debe estar deshabilitado ("onPressed: null")

  Escenario: El botón de siguiente página está deshabilitado en la última página
    Dado que el usuario está en la última página de resultados
    Y "paramSkip + numerodefichas" es mayor o igual al total
    Cuando se renderiza el botón de siguiente página
    Entonces el botón debe estar deshabilitado ("onPressed: null")

  Escenario: El paginador muestra el rango correcto de resultados
    Dado que el total de propiedades es 25
    Y "paramSkip" es 10
    Y "numerodefichas" es 10
    Cuando se renderiza el paginador
    Entonces el sistema debe mostrar "11-20 de 25"

  Escenario: El paginador ajusta el rango cuando la última página es parcial
    Dado que el total de propiedades es 25
    Y "paramSkip" es 20
    Y "numerodefichas" es 10
    Cuando se renderiza el paginador
    Entonces el sistema debe mostrar "21-25 de 25" (no "21-30")
