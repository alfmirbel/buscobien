# language: es
Característica: Mapa de Propiedades y Geocodificación

  Como usuario de Buscobien
  Quiero ver propiedades en mapa interactivo con precios
  Y buscar ubicaciones por nombre

  Antecedentes:
    Dado que GOOGLE_KEY/GOOGLE_MAPS_KEY inyectados via --dart-define
    Y PaginaMapaPropiedades recibe EspaciosCasaGet (lista propiedades)
    Y ClassLocalidadesNotifierProvider gestiona ubicación actual + geocodificación

  Escenario: Mapa con markers personalizados precio + color transacción
    Dado que usuario navega a /mapapropiedades con lista propiedades
    Cuando _cargarMarcadores() ejecuta
    Entonces itera propiedades y crea Marker por cada una
    Y bitmap personalizado: Canvas drawRect(color) + drawText(precio formateado)
    Y color según tipo transacción: Venta=azul, Renta=verde, V/R=naranja, Traspaso=morado
    Y onTap → navega a detalle propiedad

  Escenario: Centrar cámara por geocodificación de nombre (no bounds)
    Dado que usuario quiere ver propiedad en mapa
    Cuando _ajustarCamaraPorNombreNivelGobierno() ejecuta
    Entonces construye query: "calle, localidad, municipio, estado, México"
    Y geocodifica: Android/iOS → geolocator nativo, Web/Windows → REST API Google
    Y si éxito → animateCamera a bounds del resultado
    Si fallo Web → fallback LatLngBounds.fromPoints(markers visibles)

  Escenario: Geocodificación dual strategy por plataforma
    Dado que ClassLocalidadesNotifierProvider.determinaUbicacion() ejecuta
    Cuando platform = Web/Windows
    Entonces usa REST Geocoding API (maps.googleapis.com/maps/api/geocode/json)
    Cuando platform = Android/iOS
    Entonces usa geolocator.getCurrentPosition + geocoding.placemarkFromCoordinates

  Escenario: Permisos ubicación gestionados
    Dado que app necesita ubicación
    Cuando determinePermisosUbicacion() ejecuta
    Entonces solicita permisos (geolocator)
    Y setea permisosUbicacion = true/false en estado
    Y UI reacciona según estado

  Escenario: Modelos completos Geocoding API
    Dado que respuesta Google Geocoding llega
    Cuando _procesarResultadoGeocodingAPI() parsea
    Entonces mapea a GooglemapPlace → Result[] → AddressComponent[] → Geometry → Viewport
    Y extrae postal_code, route, locality, administrative_area_level_1/2