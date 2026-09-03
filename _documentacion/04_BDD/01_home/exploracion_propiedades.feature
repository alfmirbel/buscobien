# language: es

Característica: Exploración de Propiedades Inmobiliarias
  Como usuario de BuscoBien (comprador, inquilino o interesado)
  Quiero buscar y filtrar propiedades inmobiliarias disponibles
  Para encontrar el espacio que mejor se adapte a mis necesidades y presupuesto

  Antecedentes:
    Dado que el usuario está en la pantalla principal
    Y ha navegado a la sección "Propiedades" (indiceInicial = 1)

  # ---------------------------------------------------------------------------
  # MENÚ PRINCIPAL DE TIPO DE PROPIEDAD
  # ---------------------------------------------------------------------------
  Escenario: Visualización de todas las propiedades disponibles
    Dado que el índice de menú principal es "0" (Todas)
    Cuando el usuario accede a la sección "Propiedades"
    Entonces la lista debe mostrar propiedades de todos los tipos disponibles
    Y el menú "menuSuperiorMenuPrincipal" debe estar visible

  Esquema del escenario: Filtrado de propiedades por tipo desde el menú principal
    Dado que el usuario está en la sección "Propiedades"
    Cuando el usuario presiona la pestaña "<tipo_propiedad>"
    Entonces el estado "indicePrincipal" debe cambiar a "<indice>"
    Y la lista de propiedades debe filtrar solo el tipo "<tipo_propiedad>"

    Ejemplos:
      | tipo_propiedad | indice |
      | Casas          | 0      |
      | Departamentos  | 1      |
      | Oficinas       | 2      |
      | Otros          | 3      |

  # ---------------------------------------------------------------------------
  # FILTRO POR TIPO DE TRANSACCIÓN
  # ---------------------------------------------------------------------------
  Esquema del escenario: Filtrado de propiedades por tipo de transacción
    Dado que el usuario está viendo propiedades
    Cuando el usuario selecciona la opción "<transaccion>" en el menú de tipo de transacción
    Entonces el sistema debe actualizar "indiceTipoTransaccion" al índice correspondiente
    Y las propiedades mostradas deben pertenecer únicamente al tipo "<transaccion>"

    Ejemplos:
      | transaccion  |
      | Todas        |
      | Venta        |
      | Renta        |
      | Venta/Renta  |
      | Traspaso     |

  # ---------------------------------------------------------------------------
  # FILTRO POR NIVEL DE GOBIERNO / ÁMBITO GEOGRÁFICO
  # ---------------------------------------------------------------------------
  Esquema del escenario: Filtrado por ámbito geográfico
    Dado que el usuario está viendo propiedades
    Cuando el usuario selecciona el filtro de ámbito "<ambito>"
    Entonces el estado "indiceNivelGobierno" debe actualizarse al índice correspondiente
    Y las propiedades deben filtrarse según el ámbito "<ambito>"

    Ejemplos:
      | ambito    |
      | Federal   |
      | Estatal   |
      | Municipal |
      | C.P.      |

  # ---------------------------------------------------------------------------
  # FILTRO POR TIPO DE ESPACIO (DESTACADOS, OPORTUNIDADES, ETC.)
  # ---------------------------------------------------------------------------
  Esquema del escenario: Filtrado de propiedades por categoría de espacio
    Dado que el usuario está en la sección de propiedades
    Cuando selecciona la categoría "<categoria>"
    Entonces el estado "indiceTipoEspacio" debe actualizarse
    Y solo deben mostrarse propiedades de la categoría "<categoria>"

    Ejemplos:
      | categoria        |
      | Normales         |
      | Destacados       |
      | Superdestacados  |
      | Oportunidades    |
      | Remates          |

  # ---------------------------------------------------------------------------
  # PAGINACIÓN DE RESULTADOS (10 en 10)
  # ---------------------------------------------------------------------------
  Escenario: Carga inicial de propiedades (primeras 10)
    Dado que el usuario accede a la lista de propiedades
    Cuando la pantalla "PaginaBuscaEspacios" termina de cargar
    Entonces el sistema debe mostrar las primeras 10 propiedades
    Y debe indicar el total de resultados disponibles

  Escenario: Carga de más propiedades al llegar al final de la lista
    Dado que el usuario está viendo las primeras 10 propiedades
    Y hay más propiedades disponibles en el servidor
    Cuando el usuario hace scroll hasta el final de la lista
    Entonces el sistema debe cargar el siguiente lote de 10 propiedades
    Y las nuevas propiedades deben agregarse al final de la lista existente
    Y el indicador de carga debe ser visible durante la petición

  Escenario: No hay más propiedades para cargar
    Dado que el usuario llegó al final de todos los resultados disponibles
    Cuando el usuario intenta cargar más propiedades
    Entonces el sistema no debe realizar una nueva petición HTTP
    Y debe mostrar un indicador de "Fin de resultados"

  # ---------------------------------------------------------------------------
  # VISTA EN MAPA
  # ---------------------------------------------------------------------------
  Escenario: El usuario accede al mapa de propiedades
    Dado que el usuario está viendo la lista de propiedades
    Cuando presiona el botón "Ver en mapa"
    Entonces el sistema debe navegar a la ruta "/mapapropiedades"
    Y el mapa debe mostrar marcadores para cada propiedad de la lista actual
    Y la pantalla debe usar Google Maps ("PaginaMapaPropiedades")

  # ---------------------------------------------------------------------------
  # DETALLE DE UNA PROPIEDAD
  # ---------------------------------------------------------------------------
  Escenario: El usuario selecciona una propiedad para ver su detalle
    Dado que el usuario está en la lista de propiedades
    Cuando presiona la tarjeta de una propiedad específica
    Entonces el sistema debe navegar a la pantalla de detalle de la propiedad
    Y el detalle debe mostrar: título, precio, tipo de transacción, ubicación y fotos

  Escenario: El usuario accede al carrusel de fotos de una propiedad
    Dado que el usuario está viendo el detalle de una propiedad
    Cuando presiona la galería de fotos
    Entonces el sistema debe navegar a la ruta "/carouselfotospropiedad"
    Y el carrusel debe mostrar todas las fotos disponibles de la propiedad
