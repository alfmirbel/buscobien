# language: es
Característica: Búsqueda de Ubicación por Código Postal
  Como usuario final
  Quiero buscar ubicaciones ingresando un código postal
  Para filtrar propiedades por zona geográfica

  Escenario: Validación de código postal vacío
    Dado que el usuario está en la pantalla "Busca ubicación por Código Postal"
    Y el campo de "Código Postal" está vacío
    Cuando el usuario presiona el botón "Busca ubicaciones"
    Entonces el sistema muestra el mensaje de error "Proporciona un código postal"
    Y no navega a la lista de localidades

  Escenario: Búsqueda exitosa por código postal
    Dado que el usuario está en la pantalla "Busca ubicación por Código Postal"
    Y el campo de "Código Postal" contiene "44100"
    Cuando el usuario presiona el botón "Busca ubicaciones"
    Entonces el sistema valida el formulario exitosamente
    Y actualiza el provider de localidades con el código postal 44100
    Y refresca el provider de localidades del código postal
    Y navega a la pantalla de lista de localidades con el código postal como argumento

  Escenario: Visualización de ubicación actual en pantalla de búsqueda
    Dado que el usuario está en la pantalla "Busca ubicación por Código Postal"
    Y la geolocalización ha determinado la ubicación actual
    Cuando la pantalla se renderiza
    Entonces el sistema muestra "Ubicación actual: [dirección formateada]"
    Y muestra "Latitud: [valor], Longitud: [valor]"
    Y renderiza un mapa en miniatura con la ubicación actual
    Y el mapa muestra la brújula habilitada
    Y el mapa muestra el punto de ubicación actual del usuario
    Y el mapa muestra los controles de zoom

  Escenario: Mapa en miniatura con marcador de ubicación actual
    Dado que el usuario está en la pantalla "Busca ubicación por Código Postal"
    Y la geolocalización ha determinado la ubicación actual
    Y se han agregado marcadores al mapa
    Cuando el mapa se crea
    Entonces el controlador del mapa se asigna al provider de ubicación actual
    Y la posición inicial de la cámara corresponde a la última posición guardada
    Y se muestran los marcadores de ubicación en el mapa
