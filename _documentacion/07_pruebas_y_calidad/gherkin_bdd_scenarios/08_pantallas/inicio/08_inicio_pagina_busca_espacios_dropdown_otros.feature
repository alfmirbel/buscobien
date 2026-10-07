# language: es
Característica: Dropdown de Tipo de Propiedad "Otros"
  Como usuario de BuscoBien
  Quiero seleccionar un tipo de propiedad específico dentro de la categoría "Otros"
  Para filtrar con mayor precisión los resultados

  Escenario: El dropdown se muestra solo cuando el tipo de propiedad es "Otros"
    Dado que el usuario está en la sección "Propiedades"
    Y "indicePrincipal" es 3 ("Otros")
    Cuando se renderiza "PaginaBuscaEspacios"
    Entonces el sistema debe mostrar "_buildDropdownOtros()"
    Y el dropdown debe contener la lista reducida "otrosTiposDeInmueble"

  Escenario: El dropdown no se muestra para otros tipos de propiedad
    Dado que el usuario está en la sección "Propiedades"
    Y "indicePrincipal" es 1 ("Casas")
    Cuando se renderiza "PaginaBuscaEspacios"
    Entonces el sistema no debe mostrar "_buildDropdownOtros()"

  Escenario: El usuario selecciona un tipo del dropdown "Otros"
    Dado que el usuario está en la categoría "Otros"
    Y el dropdown está abierto
    Cuando el usuario selecciona "Oficina" del dropdown
    Entonces el sistema debe actualizar "selectedDropDownMenuPrincipalValue" a "Oficina"
    Y debe ejecutar "_resetPaginacion()"
    Y debe disparar una nueva consulta con el filtro de "Oficina"

  Escenario: El dropdown tiene estilo consistente con el tema
    Dado que el usuario está en la categoría "Otros"
    Cuando se renderiza el dropdown
    Entonces el contenedor debe tener borde de 2px en "appTheme.primary"
    Y el fondo del dropdown debe ser "appTheme.onPrimary"
    Y el radio de borde debe ser de 9
