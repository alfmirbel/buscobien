# language: es
Funcionalidad: Catálogo de Inicio — Propiedades destacadas paginadas 10-en-10

  Como usuario explorando Buscobien
  Quiero ver un catálogo paginado de propiedades destacadas con tarjetas, precio y Me Gusta
  Para descubrir propiedades relevantes y marcar mis favoritas

  Antecedentes:
    Dado que el usuario navega a la sección "Inicio" de PrincipalSliversMenuInicial
    Y PaginaBuscaEspacios (ConsumerStatefulWidget) se inicializa con postFrameCallback
    Y los providers de menú (tipoEspacio, nivelGobierno) están configurados con el contexto de búsqueda

  Escenario: Primera carga del catálogo con filtros por defecto
    Dado que PaginaBuscaEspacios dispara su postFrameCallback
    Cuando findPropiedadesEstadosde10en10Provider(skip=0, limit=10).future se evalúa
    Entonces se hace HTTP a la API Node.js con los filtros activos
    Y la respuesta EspaciosCasaGet.rows[] alimenta a WrapModernCardPropiedades
    Y el estado FutureBuilder pasa de stateWaiting a stateActive con las 10 cards

  Escenario: Paginación incremental con scroll
    Dado que el usuario hace scroll al final del Wrap
    Cuando alcanza el borde inferior
    Entonces PaginacionBusqueda.increment() actualiza skip += 10
    Y findPropiedadesEstadosde10en10Provider.family(skip=10).future consulta la siguiente página
    Y las nuevas cards se añaden al final del Wrap

  Escenario: Toggle Me Gusta en card de propiedad
    Dado que el usuario ve una card con un botón corazón
    Cuando toca _MeGustaButton
    Entonces MeGustaNotifier.toggleMeGusta(propertyId) ejecuta optimistic update
    Y el corazón cambia de outline a filled (sincronía visual inmediata)
    Y en background, se POSTea a buscobien_megusta_propiedades con _id=SHA1(userId+propertyId)

  Escenario: Filtros por tipo transacción y tipo espacio
    Dado que el usuario seleccionó TipoTransaccion="Venta" y TipoEspacio="Casa"
    Cuando el catálogo se requery
    Entonces los HTTP params incluyen las selecciones
    Y sólo aparecen propiedades coincidentes

  Escenario: Catálogo vacío por filtros muy restrictivos
    Dado que el usuario combinó filtros que no matchean nada
    Cuando la API devuelve rows=[]
    Entonces la UI muestra stateNone (mensaje "Sin resultados, ajusta tus filtros")
    Y se ofrece botón "Limpiar filtros"

  Escenario: Error HTTP con endpoints fallback
    Dado que el endpoint principal de Catálogo falla (timeout o 500)
    Cuando http_view_count_filter_propiedades intenta el primary
    Entonces reintenta con el fallback (endpointsCaptura/ endpointsPublicados alternos)
    Y si todos fallan, muestra stateErrorFS con botón reintentar

  Escenario: Catálogo con catálogo de características (otras)
    Dado que el usuario expande "Otras características"
    Cuando catalogo_otras_caracteristicas.dart expone el listado
    Entonces el usuario puede marcar checkboxes (habitaciones, baños, antigüedad, estacionamiento)
    Y al confirmar, el filtro se añade a los HTTP params

  Escenario: Contador de documentos totales (view count)
    Dado que el catálogo renderiza "Mostrando X de Y propiedades"
    Cuando viewCountFilterPropiedadesProvider se evalúa con los mismos filtros
    Entonces CountViewDoctos.rows[0].value = Y (total docs matcheantes)
    Y la UI muestra el contador actualizado junto al paginado "10 de Y"
