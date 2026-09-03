# language: es
Característica: Listas de Favoritos, Compartidas y Me Gusta

  Como usuario de Buscobien
  Quiero organizar propiedades en listas, compartirlas con contactos/grupos
  Y marcar favoritos con "Me Gusta"

  Antecedentes:
    Dado que 7 DBs CouchDB separan casos de uso:
    buscobien_listas_usuario, buscobien_listas_propiedades, buscobien_listas_compartidas,
    buscobien_listas_compartidas_usuarios, buscobien_propiedades_compartidas_conocidos,
    buscobien_publicaciones_grupo, buscobien_megusta_propiedades
    Y 5 providers Notifier/AsyncNotifier gestionan estado reactivo

  Escenario: Hub central Listas con 3 tabs (Propias/Recibidas/Enviadas)
    Dado que usuario abre PageMisListas
    Cuando TabBar muestra Propias | Recibidas | Enviadas
    Entonces Propias: crea lista (SHA1 hash ID), ve detalle, borra (Dismissible), comparte
    Recibidas: filtra listasCompartidasProvider donde usuarioDestinoId == currentUser
    Enviadas: filtra donde usuarioOrigenId == currentUser

  Escenario: Crear lista propia con ID SHA1
    Dado que usuario en tab Propias toca "Crear lista"
    Cuando ingresa nombre y confirma
    Entonces listaId = SHA1(userId + timestamp + random)
    Y guarda en buscobien_listas_usuario
    Y UserListsNotifier actualiza reactivamente

  Escenario: Agregar propiedad a lista (Dialog selector checkboxes)
    Dado que usuario en detalle propiedad toca "Guardar en lista"
    Cuando DialogSelectorListas muestra checkboxes de userListsProvider
    Y usuario selecciona lista(s) y confirma
    Entonces ClassListaPropiedadesProvider.addPropiedadALista() guarda relación en buscobien_listas_propiedades
    Y anti-duplicado verifica NO existe misma listaId + propertyId

  Escenario: Compartir lista con máx 5 contactos + notificación chat
    Dado que usuario en tab Propias toca "Compartir" en lista
    Cuando selecciona hasta 5 conocidos/grupos y confirma
    Entonces ListasCompartidasNotifier.compartirLista():
    - Copia propiedades a buscobien_listas_compartidas_usuarios
    - Crea registro en buscobien_listas_compartidas (origen, destino, timestamp)
    - Anti-duplicado: mismo listaOrigenId + usuarioDestinoId → silent skip
    - mensajesChatProvider.enviar(tipo:'lista') notifica a destinatarios

  Escenario: Compartir propiedad individual con conocido/grupo + chat
    Dado que usuario toca "Compartir" en propiedad
    Cuando elige PageCompartirConConocido (checkboxes conocidos, máx 5)
    Entonces PropiedadesCompartidasConocidosNotifier.compartirPropiedad():
    - Crea doc en buscobien_propiedades_compartidas_conocidos (UUID)
    - mensajesChatProvider.enviar(tipo:'propiedad') notifica
    Cuando elige PageCompartirConGrupo (checkboxes grupos)
    Entonces publicacionesGrupoProvider.compartirPropiedad() + mensajesGrupoProvider.enviar()

  Escenario: Toggle Me Gusta → auto-crea lista Favoritas
    Dado que usuario toca corazón en propiedad
    Cuando MeGustaNotifier.toggleMeGusta() ejecuta
    Entonces crea/borra en buscobien_megusta_propiedades
    SI es primer me gusta del usuario:
    - Auto-crea lista "Favoritas" (tipo='favoritos')
    - _agregarPropiedadAFavoritas() anti-duplicado agrega propiedad

  Escenario: Detalle lista con bulk fetch $in Mango
    Dado que usuario abre PageDetalleLista o PageDetalleListaCompartida
    Cuando FutureBuilder carga propiedades
    Entonces propertiesDetailsProvider (FutureProvider.family) usa Mango query $in
    Y trae N propiedades en 1 query
    Y renderiza WrapModernCardPropiedades con fallback endpoints