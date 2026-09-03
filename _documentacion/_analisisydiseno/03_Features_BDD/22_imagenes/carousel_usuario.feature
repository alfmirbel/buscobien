# language: es
Funcionalidad: Carousel de fotos de usuario en catálogo y detalle

  Como comprador/arrendatario navegando Buscobien
  Quiero ver fotos de propiedades en un carousel responsivo dentro del catálogo y el detalle
  Para evaluar visualmente las propiedades antes de contactar al promotor

  Antecedentes:
    Dado que el usuario navega el catálogo / detalle de una propiedad
    Y Selecciona ver fotos → PaginaCarouselFotosUsuario recibe ValueEspaciosCasaGet
    Y el sistema inicializa CarouselSliderController (v5.0+)
    Y recupera IDs de fotos vía future_recupera_ids_fotos_propiedad

  Escenario: Visualización carousel completo (fullscreen)
    Dado que PaginaCarouselFotosUsuario se renderiza con datos válidos
    Cuando el widget construye CarouselSlider con options.autoPlay=false
    Entonces muestra fotos en loop enableInfiniteScroll
    Y el índice actual se actualiza en estado (_current)
    Y un indicador inferior muestra "Foto X de N"
    Y BoxDecoration glass-morphism aplica overlay a la mini info de la propiedad

  Escenario: Versión mini para listados (PaginaCarouselFotosMini)
    Dado que el usuario está en un ListView de propiedades (catálogo/recomendados)
    Cuando cada tarjeta usa PaginaCarouselFotosMini(valueEspaciosParameter)
    Entonces muestra carousel compacto (height ~150px) sin controles completos
    Y permite tap para navegar a detalle conHero animation

  Escenario: Controles de navegación programática
    Dado que el carousel está en pantalla
    Cuando el usuario toca flecha siguiente/anterior
    Entonces controllerCarousel.nextPage()/previousPage() se invoca
    Y CarouselSliderController anima la transición (duration 300ms, curve Curves.ease)
    Y _current se actualiza con el índice resultado

  Escenario: Acciones rápidas desde carousel
    Dado que el usuario ve una foto en el carousel
    Cuando toca los botones inferiores (overlayActions)
    Entonces puede: Navegar al detalle (PaginaDetallePropiedad), Guardar en lista (lista_select_lista_save_propiedad), Compartir con Conocido/Grupo (page_compartir_con_*)

  Escenario: Propiedad sin fotos
    Dado que ValueEspaciosCasaGet.espacioscasa.fotoprincipal == ""
    Y future_recupera_ids_fotos_propiedad retorna 0 fotos
    Cuando PaginaCarouselFotosUsuario intenta construir el carousel
    Entonces muestra fotoPlaceholder (variables_imagenes.dart) centrada
    Y oculta los botones de acción (no hay nada para ver)

  Escenario: FutureBuilder con estado de carga y error
    Dado que futureMetaData está en progreso
    Cuando FutureBuilderStateWidgets evalúa ConnectionState.waiting
    Entonces muestra spinner M3 con appTheme.colorScheme.primary
    Y cuando ocurre error, muestra mensaje + botón reintentar
