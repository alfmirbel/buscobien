# language: es
Funcionalidad: Ordenamiento personalizado de fotos con persistencia en CouchDB

  Como propietario
  Quiero arrastrar y reordenar las fotos para que la más atractiva aparezca primero
  Para que el listado y catálogo muestren siempre la foto más representativa

  Antecedentes:
    Dado que el usuario está en PaginaFotosPropiedad → pestaña "Listado"
    Y provider_get_lista_fotos_ordenadas ha cargado ListaFotosOrdenadas
    Y fotosOrden[] contiene N IDs de fotos con un orden inicial

  Escenario: Reordenamiento local en ReorderableListView
    Dado que ReorderableListView renderiza la lista de fotos
    Cuando el usuario arrastra el item de índice iArch a newIndex (onReorder)
    Entonces fotosOrden se reorganiza con list.insert/remove
    Y la tarjeta se re-pinta en la nueva posición
    Y el handle de arrastre (ReorderableDragStartListener) aparece onHover

  Escenario: Persistencia del nuevo orden (PUT a CouchDB)
    Dado que el usuario soltó la foto en nueva posición
    Y fotosOrden ha cambiado localmente
    Cuando el sistema invoca future_put_fotos_orden o future_update_fotos_orden
    Entonces se construye payload ListaFotosOrdenadas con timestamp actualizado
    Y se envía PUT a CouchDB (doc "fotosordenadas:<idPropiedad>")
    Y el sistema muestra SnackBar con el resultado

  Escenario: Actualización reactiva vía provider
    Dado que ClassListaFotosCasaNotifierProvider (provider_get_lista_fotos_ordenadas)
    Y el notificador expone state.data.value = ListaFotosOrdenadas (nuevo orden)
    Cuando el PUT retorna OK
    Entonces ref.read(provider).estadoOrden.value = "guardado"
    Y el resto de vistas (Carousel/Cuadros) refrescan el nuevo orden automáticamente

  Escenario: Conflicto de orden concurrente (409)
    Dado que dos dispositivos están editando el mismo idPropiedad
    Y el último PUT trae _rev = rev_viejo (otro lo actualizó)
    Cuando CouchDB responde 409 Conflict
    Entonces el sistema muestra SnackBar "Conflicto, recarga lista"
    Y vuelve a hacer GET vía future_get_fotos_by_idpr_orden

  Escenario: Creación inicial del orden (primera vez)
    Dado que provider_get_lista_fotos_ordenadas retorna null (no existe doc)
    Cuando el usuario hace el primer reorden
    Entonces se invoca future_put_fotos_orden (POST → PUT nuevo doc)
    Y se crea "fotosordenadas:<idPropiedad>" con fotosOrden inicial
