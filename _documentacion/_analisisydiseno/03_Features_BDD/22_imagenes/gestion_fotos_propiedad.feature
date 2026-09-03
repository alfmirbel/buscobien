# language: es
Funcionalidad: Gestión de fotos de propiedad (Carousel, Cuadros, Listado)

  Como promotor/propietario de una propiedad en Buscobien
  Quiero ver, ordenar y gestionar las fotos de mis propiedades en tres vistas sincronizadas
  Para mantener un catálogo visual ordenado y atractivo para compradores/arrendatarios

  Antecedentes:
    Dado que el usuario está autenticado y accede a "Tus Espacios"
    Y selecciona una propiedad (ValueEspaciosCasaGet)
    Y toca el menú de fotos → PaginaFotosPropiedad
    Y el sistema inicializa TabController con 3 pestañas (Carousel, Cuadros, Listado)
    Y recupera IDs de fotos vía future_recupera_ids_fotos_propiedad
    Y carga el orden custom vía provider_get_lista_fotos_ordenadas

  Escenario: Visualización carousel (swipe fullscreen)
    Dado que la pestaña Carousel está activa
    Cuando el usuario desliza horizontalmente
    Entonces las fotos se muestran en loop con CarouselSlider
    Y el indicador de página actualiza (indiceFotos/numeroDeFotos)
    Y el PageStorageKey preserva la posición al cambiar de tab

  Escenario: Visualización cuadros (grid 2-3 columnas responsivo)
    Dado que la pestaña Cuadros está activa
    Y el dispositivo es móvil (isMobile=true)
    Cuando se renderiza el GridView
    Entonces muestra grid de 2 columnas con crossAxisCount responsivo
    Y cada foto tiene su ID accesible para menú contextual

  Escenario: Visualización listado con drag & drop
    Dado que la pestaña Listado está activa
    Cuando el usuario arrastra una foto hacia otra posición (ReorderableListView.onReorder)
    Entonces fotosOrden se reorganiza localmente
    Y el sistema persiste el nuevo orden vía future_put_fotos_orden (PUT a CouchDB)
    Y muestra SnackBar de confirmación "Orden guardado"

  Escenario: Sincronización entre vistas al cambiar de tab
    Dado que el usuario selecciona la foto "foto:abc-123" en vista Carousel
    Cuando cambia a la pestaña Cuadros
    Entonces la misma foto aparece resaltada/seleccionada
    Y idFoto = "foto:abc-123" se preserva en PaginaFotosPropiedadState
    Y el scroll position se restaura vía PageStorageKey

  Escenario: Menú contextual por foto
    Dado que el usuario hace long-press / tap en una foto
    Cuando se abre el PopupMenuButton
    Entonces muestra opciones: Ver detalle, Compartir con Conocido, Compartir con Grupo, Agregar a lista, Editar/Eliminar
    Y navega a la pantalla correspondiente (page_compartir_con_*)

  Escenario: Selección de foto principal
    Dado que el usuario toca "Marcar como principal" en una foto
    Cuando el sistema actualiza el documento propiedad (fotoprincipal=idFoto)
    Entonces la miniatura en listados futuros usará esta foto
