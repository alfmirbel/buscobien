# language: es
Característica: Búsqueda y listado de propiedades
  Como usuario final
  Quiero buscar propiedades con filtros y ver resultados paginados
  Para encontrar espacios que me interesen

  Escenario: Búsqueda con filtros combinados
    Dado que el usuario está en la pantalla de búsqueda
    Y selecciona "Casas"
    Y selecciona "Renta"
    Y selecciona una ubicación válida
    Cuando confirma la búsqueda
    Entonces el sistema muestra un listado paginado de propiedades
    Y el total de resultados se muestra en la interfaz

  Escenario: Página siguiente mantiene filtros
    Dado que el usuario ya tiene una búsqueda activa
    Y existen más resultados en la página siguiente
    Cuando el usuario avanza de página
    Entonces se cargan 10 propiedades adicionales
    Y los filtros seleccionados se mantienen

  Escenario: Sin resultados
    Dado que el usuario aplica filtros sin coincidencias
    Cuando la consulta se ejecuta
    Entonces el sistema muestra el estado vacío
