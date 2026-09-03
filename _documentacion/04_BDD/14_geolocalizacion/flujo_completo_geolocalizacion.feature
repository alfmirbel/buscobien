# language: es
Característica: Flujo Completo de Geolocalización
  Como usuario final
  Quiero usar todas las funcionalidades de geolocalización en conjunto
  Para buscar y visualizar propiedades por ubicación

  Escenario: Flujo completo desde solicitud de permiso hasta visualización en mapa
    Dado que el usuario abre la aplicación por primera vez
    Y los servicios de ubicación están habilitados
    Y el usuario concede el permiso de localización
    Cuando el sistema determina la ubicación actual
    Entonces obtiene la posición GPS del dispositivo
    Y realiza geocodificación inversa para obtener la dirección
    Y extrae el código postal de la dirección
    Y actualiza el provider de localidades con el código postal
    Y agrega un marcador en el mapa con la ubicación actual
    Y el usuario puede ver su ubicación en el mapa

  Escenario: Flujo de búsqueda por código postal y visualización
    Dado que el usuario está en la pantalla de búsqueda por código postal
    Y el código postal 44100 está disponible
    Cuando el usuario ingresa "44100" y presiona "Busca ubicaciones"
    Entonces el sistema valida el código postal
    Y actualiza el provider con el nuevo código postal
    Y refresca las localidades asociadas
    Y navega a la lista de localidades
    Y el usuario puede seleccionar una localidad
    Y al regresar al mapa de propiedades, la cámara se ajusta a la nueva ubicación

  Escenario: Visualización de propiedades filtradas por ubicación
    Dado que el usuario ha seleccionado un nivel de gobierno y ubicación
    Y existe una lista de propiedades filtradas
    Cuando el usuario abre el "Mapa de propiedades"
    Entonces el sistema carga los marcadores de todas las propiedades filtradas
    Y asigna colores según el tipo de transacción (Venta/Renta/Otro)
    Y genera imágenes personalizadas con el precio para cada marcador
    Y ajusta la cámara del mapa según el nivel de gobierno seleccionado
    Y muestra un indicador de carga mientras se generan los marcadores
    Y cuando termina, el usuario ve todos los pines en el mapa
    Y puede presionar "Reajustar" para recentrar el mapa

  Escenario: Cambio dinámico de nivel de gobierno en mapa
    Dado que el usuario está visualizando el "Mapa de propiedades"
    Y el nivel de gobierno actual es "Estado"
    Cuando el usuario cambia el nivel de gobierno a "Municipio"
    Entonces el sistema detecta el cambio en el provider
    Y actualiza la variable local de nivel de gobierno
    Y vuelve a ejecutar el ajuste de cámara
    Y la consulta de geocodificación cambia a nivel de municipio
    Y el zoom se ajusta de 8.0 a 11.0
