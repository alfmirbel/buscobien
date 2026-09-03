# language: es
Característica: Estructura y Layout de la Pantalla de Búsqueda de Propiedades
  Como usuario de BuscoBien
  Quiero ver las propiedades en una interfaz clara y organizada
  Para navegar y filtrar inmuebles fácilmente

  Escenario: La pantalla muestra el FAB de mapa en dispositivos cortos
    Dado que el usuario está en la sección "Propiedades"
    Y el ancho de pantalla es menor a "smallScreenMin"
    Cuando se renderiza "PaginaBuscaEspacios"
    Entonces el sistema debe mostrar un "FloatingActionButton" con ícono "Symbols.map"
    Y el FAB debe tener color "appTheme.primary" con ícono en "appTheme.onPrimary"
    Y el tooltip debe decir "Mapa"

  Escenario: La pantalla muestra el NavigationRail en dispositivos anchos
    Dado que el usuario está en la sección "Propiedades"
    Y el ancho de pantalla es mayor o igual a "smallScreenMin"
    Cuando se renderiza "PaginaBuscaEspacios"
    Entonces el sistema debe mostrar "navigationRailTipoTransaccion" en el lado izquierdo
    Y el NavigationRail debe mostrar los tipos de transacción como destinos

  Escenario: La pantalla muestra el menú inferior de transacción en dispositivos cortos
    Dado que el usuario está en la sección "Propiedades"
    Y el ancho de pantalla es menor a "smallScreenMin"
    Y "indicePrincipal" está entre 0 y 3
    Cuando se renderiza "PaginaBuscaEspacios"
    Entonces el sistema debe mostrar "MenuInferiorTipoDeTransaccion" como "bottomNavigationBar"
    Y debe ocultar el NavigationRail lateral

  Escenario: El contenido principal se limita al ancho máximo de escritorio
    Dado que el usuario abre la aplicación en una tablet o escritorio
    Cuando se renderiza el cuerpo de "PaginaBuscaEspacios"
    Entonces el sistema debe envolver el contenido en "ConstrainedBox" con "maxWidth: desktopContentMaxWidth"
    Y el contenido debe estar centrado horizontalmente

  Escenario: Los filtros de nivel de gobierno y tipo de espacio se muestran en slivers
    Dado que el usuario está en la sección "Propiedades"
    Y "indicePrincipal" está entre 0 y 3
    Cuando se renderiza "PaginaBuscaEspacios"
    Entonces el sistema debe mostrar "MenuSuperiorPaginaInicioNivelGobierno" en el CustomScrollView
    Y debe mostrar "MenuSuperiorPaginaTipoDeEspacios" en el CustomScrollView
    Y ambos deben estar dentro de slivers condicionales
