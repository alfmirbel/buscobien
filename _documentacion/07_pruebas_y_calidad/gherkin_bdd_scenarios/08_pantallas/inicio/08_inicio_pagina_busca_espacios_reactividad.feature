# language: es
Característica: Reactividad a Cambios de Filtros en la Búsqueda
  Como usuario de BuscoBien
  Quiero que los resultados se actualicen automáticamente cuando cambio los filtros
  Para ver siempre las propiedades que coinciden con mi búsqueda

  Escenario: El sistema resetea la paginación al cambiar el tipo de propiedad
    Dado que el usuario está en la página 2 de resultados de "Casas"
    Cuando el usuario cambia a "Departamentos" en el menú principal
    Entonces el sistema debe resetear "paramSkip" a 0
    Y debe invalidar "currentQueryProvider"
    Y debe invalidar "viewCountFilterPropiedadesProvider"
    Y debe invalidar "findPropiedadesEstadosde10en10Provider"
    Y debe mostrar la primera página de "Departamentos"

  Escenario: El sistema resetea la paginación al cambiar el nivel de gobierno
    Dado que el usuario está en la página 2 de resultados de "Nacional"
    Cuando el usuario cambia a "Estado" en el menú de nivel de gobierno
    Entonces el sistema debe resetear "paramSkip" a 0
    Y debe invalidar los providers de consulta y lista
    Y debe mostrar la primera página del nuevo filtro

  Escenario: El sistema resetea la paginación al cambiar el tipo de espacio
    Dado que el usuario está en la página 2 de "Normales"
    Cuando el usuario cambia a "Destacados"
    Entonces el sistema debe resetear "paramSkip" a 0
    Y debe recargar las propiedades desde la primera página

  Escenario: El sistema resetea la paginación al cambiar el tipo de transacción
    Dado que el usuario está en la página 2 de "Venta"
    Cuando el usuario cambia a "Renta"
    Entonces el sistema debe resetear "paramSkip" a 0
    Y debe recargar las propiedades desde la primera página

  Escenario: El sistema resetea la paginación al cambiar el tipo de propiedad a "Otros"
    Dado que el usuario está en la página 2 de "Casas"
    Cuando el usuario cambia a "Otros" y selecciona "Oficina" del dropdown
    Entonces el sistema debe resetear "paramSkip" a 0
    Y debe actualizar "selectedDropDownMenuPrincipalValue" a "Oficina"
    Y debe recargar las propiedades filtradas por "Oficina"

  Escenario: El sistema resetea la paginación al cambiar la transacción desde el NavigationRail
    Dado que el usuario está en una pantalla ancha
    Y está en la página 2 de "Venta"
    Cuando el usuario cambia a "Renta" en el NavigationRail
    Entonces el sistema debe resetear "paramSkip" a 0
    Y debe actualizar el provider de transacción
    Y debe recargar las propiedades

  Escenario: El sistema escucha cambios en homeNavigationProvider para invalidar providers
    Dado que el usuario está en la pantalla "PaginaBuscaEspacios"
    Cuando cambia "indicePrincipal", "indiceNivelGobierno", "indiceTipoEspacio" o "indiceTipoTransaccion"
    Entonces el sistema debe ejecutar el "ref.listen" de "homeNavigationProvider"
    Y debe invalidar "viewCountFilterPropiedadesProvider", "currentQueryProvider" y "findPropiedadesEstadosde10en10Provider"
    Y debe resetear "paramSkip" a 0
