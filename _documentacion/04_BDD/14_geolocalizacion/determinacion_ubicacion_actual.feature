# language: es
Característica: Determinación de Ubicación Actual
  Como usuario final
  Quiero que la aplicación determine mi ubicación actual automáticamente
  Para ver mi posición en el mapa y obtener mi dirección

  Escenario: Geocodificación nativa en Android
    Dado que el usuario está en la pantalla de búsqueda de ubicación
    Y la plataforma es Android
    Y el permiso de ubicación ha sido concedido
    Y la posición actual tiene latitud y longitud válidas
    Cuando el sistema determina la ubicación actual
    Entonces el sistema utiliza geocodificación nativa para obtener la dirección
    Y extrae el código postal de los resultados
    Y actualiza el provider de localidades con el código postal encontrado
    Y agrega un marcador en el mapa con título "Mi Ubicación"
    Y actualiza la posición de la cámara con zoom 12

  Escenario: Geocodificación nativa en iOS
    Dado que el usuario está en la pantalla de búsqueda de ubicación
    Y la plataforma es iOS
    Y el permiso de ubicación ha sido concedido
    Y la posición actual tiene latitud y longitud válidas
    Cuando el sistema determina la ubicación actual
    Entonces el sistema utiliza geocodificación nativa para obtener la dirección
    Y extrae el código postal de los resultados
    Y actualiza el provider de localidades con el código postal encontrado
    Y agrega un marcador en el mapa con título "Mi Ubicación"
    Y actualiza la posición de la cámara con zoom 12

  Escenario: Geocodificación HTTP en Web
    Dado que el usuario está en la pantalla de búsqueda de ubicación
    Y la plataforma es Web
    Y el permiso de ubicación ha sido concedido
    Y la posición actual tiene latitud y longitud válidas
    Cuando el sistema determina la ubicación actual
    Entonces el sistema consulta la API de Geocoding de Google Maps vía HTTP
    Y procesa el resultado JSON para extraer la dirección formateada
    Y busca componentes de tipo "postal_code" para extraer el código postal
    Y actualiza el provider de localidades con el código postal encontrado
    Y agrega un marcador en el mapa con título "Mi Ubicación"
    Y actualiza la posición de la cámara con zoom 12

  Escenario: Geocodificación HTTP en Windows
    Dado que el usuario está en la pantalla de búsqueda de ubicación
    Y la plataforma es Windows
    Y el permiso de ubicación ha sido concedido
    Y la posición actual tiene latitud y longitud válidas
    Cuando el sistema determina la ubicación actual
    Entonces el sistema consulta la API de Geocoding de Google Maps vía HTTP
    Y procesa el resultado JSON para extraer la dirección formateada
    Y busca componentes de tipo "postal_code" para extraer el código postal
    Y actualiza el provider de localidades con el código postal encontrado
    Y agrega un marcador en el mapa con título "Mi Ubicación"
    Y actualiza la posición de la cámara con zoom 12

  Escenario: Plataforma no soportada para geocodificación nativa
    Dado que el usuario está en la pantalla de búsqueda de ubicación
    Y la plataforma es Linux, macOS o Fuchsia
    Cuando el sistema intenta determinar la ubicación actual
    Entonces el sistema muestra el mensaje "determinaUbicacion(): plataforma no soportada"
    Y no actualiza la ubicación ni los marcadores del mapa

  Escenario: Dirección ya cacheada en HTTP
    Dado que el usuario está en la pantalla de búsqueda de ubicación
    Y la plataforma es Web o Windows
    Y la dirección ya fue obtenida previamente (cache)
    Cuando el sistema intenta determinar la ubicación actual
    Entonces el sistema retorna la dirección cacheada sin consultar la API HTTP

  Escenario: Error en geocodificación nativa
    Dado que el usuario está en la pantalla de búsqueda de ubicación
    Y la plataforma es Android o iOS
    Y ocurre un error en la geocodificación inversa
    Cuando el sistema intenta determinar la ubicación actual
    Entonces el sistema captura el error y lo registra en depuración
    Y no actualiza la dirección actual ni el código postal

  Escenario: Error en consulta HTTP de geocodificación
    Dado que el usuario está en la pantalla de búsqueda de ubicación
    Y la plataforma es Web o Windows
    Y la consulta HTTP a la API de Google Maps falla
    Cuando el sistema intenta determinar la ubicación actual
    Entonces el sistema captura la excepción y la registra en depuración
    Y retorna una cadena vacía como resultado
