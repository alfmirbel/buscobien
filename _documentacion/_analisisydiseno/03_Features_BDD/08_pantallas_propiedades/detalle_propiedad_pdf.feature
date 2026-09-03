# language: es
Funcionalidad: Detalle de propiedad y exportación PDF

  Como comprador/arrendatario interesado en una propiedad
  Quiero ver el detalle completo de la propiedad y poder exportar la ficha a PDF
  Para evaluarla offline y compartirla

  Antecedentes:
    Dado que el usuario navega desde catálogo/listas/carousel a PaginaDetalleWidget con idPropiedad
    Y el sistema usa findPropiedades([idPropiedad]) (Mango $in) para obtener el documento completo

  Escenario: Carga del detalle con fotos carousel + ficha
    Dado que PaginaDetalleWidget se inicializa con idPropiedad="propiedad:uuid-001"
    Cuando findPropiedades.future resuelve con un Doc válido
    Entonces PaginaCarouselFotosUsuario renderiza carousel completo
    Y la ficha técnica muestra precio, ubicación, características, datos contacto promotor
    Y CTAs: Contactar / Compartir / Guardar en lista / Exportar PDF

  Escenario: Propiedad no encontrada (404 / 0 docs)
    Dado que findPropiedades.future resuelve rows=[]
    Cuando el FutureBuilder recibe stateErrorFS
    Entonces muestra mensaje "Propiedad no encontrada" + botón "Volver" (Navigator.pop)

  Escenario: CTA Contactar al promotor
    Dado que el usuario toca "Contactar"
    Cuando se dispara el callback
    Entonces abre o crea conversación en buscobien_mensajes con el promotor
    Y navega a pantalla de chat

  Escenario: CTA Compartir
    Dado que el usuario toca "Compartir"
    Cuando se abre el bottom sheet
    Entonces ofrece Compartir con Conocido / Compartir con Grupo / Cancelar
    Y navega a PageCompartirConConocido o PageCompartirConGrupo (en 03_listas)

  Escenario: CTA Guardar en lista
    Dado que el usuario toca "Guardar en lista"
    Cuando se abre DialogSelectorListas (de 03_listas)
    Entonces lista sus listas con checkboxes y confirma si agregó/quita propiedad

  Escenario: Toggle Me Gusta en ficha
    Dado que el usuario ve _MeGustaButtonFicha en la ficha
    Cuando toca el corazón
    Entonces MeGustaNotifier.toggleMeGusta dispara optimistic visual
    Y POST/DELETE a buscobien_megusta_propiedades
    Y el corazón cambia de outline a filled (o viceversa)

  Escenario: CTA Exportar PDF
    Dado que el usuario toca "Exportar PDF"
    Cuando PdfGeneratorService.generate(propiedad) se ejecuta
    Entonces genera PDF con foto principal, datos, precio, ubicación y branding Buscobien
    Y lo ofrece para guardar (mobile: local file + compartir / web: download)

  Escenario: Ver foto principal en _FotoItemWidget
    Dado que el detalle muestra una grilla de miniaturas _FotoItemWidget
    Cuando el usuario toca una miniatura
    Entonces el carousel salta a esa foto (PaginaCarouselFotosUsuario.controllerCarousel.jumpToPage)

  Escenario: Contactar con sesión no iniciada
    Dado que el usuario no está logueado
    Cuando toca "Contactar"
    Entonces se le ofrece iniciar sesión primero (redirect login)
    Y no se crea conversación
