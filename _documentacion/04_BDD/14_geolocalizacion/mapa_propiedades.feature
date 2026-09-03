# language: es
Característica: Visualización de Propiedades en Mapa
  Como usuario final
  Quiero ver las propiedades inmobiliarias en un mapa interactivo
  Para explorar visualmente las opciones disponibles por zona

  Escenario: Visualización de marcadores de propiedades con precio
    Dado que el usuario abre la pantalla de "Mapa de propiedades"
    Y existe una lista de propiedades con coordenadas válidas
    Cuando el mapa carga los marcadores
    Entonces cada propiedad muestra un marcador personalizado con el precio
    Y las propiedades de "Venta" usan el color primario del tema
    Y las propiedades de "Renta" usan el color secundario del tema
    Y las propiedades de otro tipo usan el color terciario del tema

  Escenario: Información de marcador al seleccionar propiedad
    Dado que el mapa muestra marcadores de propiedades
    Cuando el usuario selecciona un marcador de propiedad de "Venta"
    Entonces la ventana de información muestra "Tipo de propiedad en Venta"
    Y muestra "Venta: [precio de venta]"
    Cuando el usuario selecciona un marcador de propiedad de "Renta"
    Entonces la ventana de información muestra "Tipo de propiedad en Renta"
    Y muestra "Renta: [precio de renta]"
    Cuando el usuario selecciona un marcador de propiedad de "Venta/Renta"
    Entonces la ventana de información muestra "Tipo de propiedad en Venta/Renta"
    Y muestra "Venta/Renta: [precio venta]/[precio renta]"

  Escenario: Ajuste de cámara por nivel de gobierno - Nacional
    Dado que el usuario está en la pantalla de "Mapa de propiedades"
    Y el nivel de gobierno seleccionado es "Nacional"
    Cuando el sistema ajusta la cámara del mapa
    Entonces la consulta de geocodificación es "México"
    Y el nivel de zoom se ajusta a 5.0

  Escenario: Ajuste de cámara por nivel de gobierno - Estado
    Dado que el usuario está en la pantalla de "Mapa de propiedades"
    Y el nivel de gobierno seleccionado es "Estado"
    Y la localidad seleccionada tiene estado "Jalisco"
    Cuando el sistema ajusta la cámara del mapa
    Entonces la consulta de geocodificación es "Jalisco, México."
    Y el nivel de zoom se ajusta a 8.0

  Escenario: Ajuste de cámara por nivel de gobierno - Municipio
    Dado que el usuario está en la pantalla de "Mapa de propiedades"
    Y el nivel de gobierno seleccionado es "Municipio"
    Y la localidad seleccionada tiene municipio "Guadalajara" y estado "Jalisco"
    Cuando el sistema ajusta la cámara del mapa
    Entonces la consulta de geocodificación es "Guadalajara, Jalisco, México."
    Y el nivel de zoom se ajusta a 11.0

  Escenario: Ajuste de cámara por nivel de gobierno - Código Postal
    Dado que el usuario está en la pantalla de "Mapa de propiedades"
    Y el nivel de gobierno seleccionado es "C.P."
    Y la localidad seleccionada tiene código postal 44100
    Cuando el sistema ajusta la cámara del mapa
    Entonces la consulta de geocodificación es "44100, Guadalajara, Jalisco, México."
    Y el nivel de zoom se ajusta a 14.0

  Escenario: Ajuste de cámara por nivel de gobierno - Asentamiento
    Dado que el usuario está en la pantalla de "Mapa de propiedades"
    Y el nivel de gobierno seleccionado es "Asentamiento"
    Y la localidad seleccionada tiene asentamiento "Colonia Centro"
    Cuando el sistema ajusta la cámara del mapa
    Entonces la consulta de geocodificación es "Colonia Centro, 44100, Guadalajara, Jalisco, México."
    Y el nivel de zoom se ajusta a 16.0

  Escenario: Fallback a municipio cuando colonia no existe
    Dado que el usuario está en la pantalla de "Mapa de propiedades"
    Y el nivel de gobierno es "Asentamiento" o "Colonia"
    Y la geocodificación no encuentra resultados para la colonia
    Cuando el sistema intenta ajustar la cámara
    Entonces el sistema realiza un fallback buscando solo "municipio, estado, México"
    Y ajusta la cámara con zoom 12 a la ubicación del municipio

  Escenario: Estado vacío cuando no hay propiedades
    Dado que el usuario abre la pantalla de "Mapa de propiedades"
    Y la lista de propiedades está vacía
    Cuando el mapa intenta cargar
    Entonces el sistema muestra el mensaje "No hay propiedades que mostrar."
    Y no se renderizan marcadores en el mapa

  Escenario: Indicador de carga durante obtención de marcadores
    Dado que el usuario abre la pantalla de "Mapa de propiedades"
    Y la lista de propiedades tiene elementos
    Cuando el sistema está generando los marcadores personalizados
    Entonces el mapa muestra un indicador de progreso circular
    Y el fondo del indicador tiene opacidad del 30% en negro
    Y el color del progreso es el color primario del tema

  Escenario: Reajuste manual de cámara del mapa
    Dado que el usuario está visualizando el "Mapa de propiedades"
    Y el mapa está en cualquier nivel de zoom
    Cuando el usuario presiona el botón flotante "Reajustar"
    Entonces el sistema vuelve a ejecutar el ajuste de cámara por nombre de nivel de gobierno
    Y la cámara se anima hacia la ubicación correspondiente

  Escenario: Ajuste de cámara por bounds en Web
    Dado que el usuario está en la pantalla de "Mapa de propiedades"
    Y la plataforma es Web
    Y existen marcadores de propiedades cargados
    Cuando el sistema ajusta la cámara por bounds
    Entonces calcula el rectángulo delimitador que contiene todos los marcadores
    Y ajusta la cámara con padding de 50.0 para mostrar todos los pines

  Escenario: Sin ajuste de cámara por bounds sin marcadores
    Dado que el usuario está en la pantalla de "Mapa de propiedades"
    Y la lista de propiedades está vacía
    Cuando el sistema intenta ajustar la cámara por bounds
    Entonces el sistema no realiza ningún ajuste de cámara
