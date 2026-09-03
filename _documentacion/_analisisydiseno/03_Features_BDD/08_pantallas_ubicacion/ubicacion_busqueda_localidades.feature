# language: es
Funcionalidad: Ubicación — Búsqueda y Gestión de Localidades (SEPOMEX + Google Maps)

  Como usuario buscando propiedades por zona
  Quiero buscar localidades por código postal y verlas en mapa
  Para filtrar el catálogo de propiedades por ubicación precisa

  Antecedentes:
    Dado que el usuario accede a la sección "Ubicación" (índice 2) de PrincipalSliversMenuInicial
    Y provider_localidades_del_cp.ClassLocalidadesNotifierProvider expone localidades SEPOMEX por CP

  Escenario: Hub de localidades del usuario
    Dado que el usuario abre PaginaPrincipalListaLocalidades
    Cuando ClassLocalidadesNotifierProvider.listaLocalidadesDelUsuario.future resuelve
    Entonces muestra lista de localidades guardadas (CP, asentamiento, municipio, estado)
    Y cada fila tiene CTAs: "Ver en mapa" y "Buscar propiedades en esta zona"

  Escenario: Búsqueda por código postal (CP)
    Dado que el usuario toca "Buscar por CP" en el hub
    Cuando PaginaBuscaLocalidadGMaps abre
    Entonces muestra TextFormField para CP (valida 5 dígitos México)
    Y al ingresar CP válido y buscar
    Entonces consulta data_sepomex_localidades (Freezed) local + Google Maps Geocoding API
    Y retorna lista de asentamientos matcheantes con coords (lat/lng)

  Escenario: Selección de localidad de resultados
    Dado que la búsqueda retornó asentamientos
    Cuando el usuario toca un resultado (asentamiento)
    Entonces navega a PaginaBuscaLocalidadGMaps con CP preseleccionado
    Y muestra el mapa centrado en coords de la localidad

  Escenario: Filtro de propiedades por CP seleccionado
    Dado que el usuario seleccionó una localidad con CP="12345"
    Cuando toca "Buscar propiedades en esta zona"
    Entonces data_localidad_find.FindLocalidadXcp construye Mango query `{"ubicacioncasa.cp": "12345"}`
    Y consulta buscobien_propiedades_publicadas_* filtrando por CP
    Y navega a catálogo filtrado (inicio o propiedades)

  Escenario: Lista maestra de localidades (screen_maestro_localidades)
    Dado que el usuario accede a la vista alternativa
    Cuando LocalidadesListScreen renderiza
    Entonces muestra lista completa de localidades SEPOMEX (paginada)
    Y permite búsqueda por nombre/asentamiento
    Y al seleccionar, navega a búsqueda propiedades con CP

  Escenario: CP inválido
    Dado que el usuario ingresa CP no numérico o ≠ 5 dígitos
    Cuando intenta buscar
    Entonces muestra error "CP inválido: debe ser 5 dígitos"
    Y no dispara consulta

  Escenario: Localidad sin datos SEPOMEX
    Dado que el CP ingresado no existe en data_sepomex_localidades
    Cuando la búsqueda local falla
    Entonces hace fallback a Google Maps Geocoding API
    Y si también falla, muestra "Localidad no encontrada"

  Escenario: Integración con Google Maps
    Dado que la búsqueda por CP fue exitosa
    Cuando se muestran coords (lat, lng)
    Entonces el usuario puede tocar "Ver en Google Maps"
    Y se abre URL `https://maps.google.com/?q=lat,lng` o embed nativo
