# language: es
Característica: Carga y Visualización de Fotos en Carrusel
  Como usuario final
  Quiero ver las fotos de una propiedad en un carrusel deslizable
  Para explorar visualmente las imágenes disponibles

  Escenario: Visualización de carrusel completo con fotos
    Dado que el usuario abre la pantalla de carrusel de fotos completo
    Y la propiedad tiene 3 fotos registradas
    Y existe un orden guardado de fotos
    Cuando el sistema carga los metadatos de las fotos
    Entonces el sistema muestra el carrusel con dimensiones 300x200 píxeles
    Y muestra la primera foto del orden guardado
    Y muestra el contador "1/3"
    Y el botón "Anterior" está deshabilitado
    Y el botón "Siguiente" está habilitado

  Escenario: Visualización de carrusel mini con fotos
    Dado que el usuario abre la pantalla de carrusel de fotos mini
    Y la propiedad tiene 2 fotos registradas
    Cuando el sistema carga los metadatos de las fotos
    Entonces el sistema muestra el carrusel con dimensiones 200x125 píxeles
    Y muestra la primera foto
    Y muestra el contador "1/2"

  Escenario: Navegación entre fotos con botones
    Dado que el usuario está visualizando el carrusel de fotos en la foto 1 de 3
    Cuando el usuario presiona el botón "Siguiente"
    Entonces el sistema avanza a la foto 2
    Y actualiza el contador a "2/3"
    Cuando el usuario presiona el botón "Anterior"
    Entonces el sistema retrocede a la foto 1
    Y actualiza el contador a "1/3"

  Escenario: Navegación entre fotos con swipe
    Dado que el usuario está visualizando el carrusel de fotos
    Cuando el usuario desliza con el dedo hacia la izquierda
    Entonces el sistema avanza a la siguiente foto
    Y actualiza el índice y el contador automáticamente

  Escenario: Botón anterior deshabilitado en primera foto
    Dado que el usuario está en la primera foto del carrusel (foto 1 de 3)
    Cuando el sistema renderiza los botones de navegación
    Entonces el botón "Anterior" tiene color de fondo `appTheme.onPrimary` (deshabilitado)
    Y el botón "Anterior" no responde a pulsaciones

  Escenario: Botón siguiente deshabilitado en última foto
    Dado que el usuario está en la última foto del carrusel (foto 3 de 3)
    Cuando el sistema renderiza los botones de navegación
    Entonces el botón "Siguiente" tiene color de fondo `appTheme.onPrimary` (deshabilitado)
    Y el botón "Siguiente" no responde a pulsaciones

  Escenario: Estado vacío sin fotos
    Dado que el usuario abre la pantalla de carrusel de fotos
    Y la propiedad no tiene fotos registradas
    Cuando el sistema carga los metadatos
    Entonces el sistema muestra un contenedor con borde `appTheme.outline`
    Y muestra el texto "No se encontró foto" centrado
    Y muestra un botón con icono `fullscreen` y tooltip "Datos de la propiedad"
    Y al presionar el botón navega a la pantalla de detalle de propiedad

  Escenario: Estado de carga mientras se obtienen fotos
    Dado que el usuario abre la pantalla de carrusel de fotos
    Y el sistema está cargando los metadatos desde CouchDB
    Cuando el future está en estado `waiting`
    Entonces el sistema muestra un indicador de progreso circular centrado
    Y el indicador tiene el tamaño del contenedor de foto (300x200 o 200x125)

  Escenario: Estado de error al cargar fotos
    Dado que el usuario abre la pantalla de carrusel de fotos
    Y ocurre un error al recuperar los IDs de fotos
    Cuando el future completa con error
    Entonces el sistema muestra el mensaje de error formateado
    Y el texto del error tiene color `appTheme.error`

  Escenario: Toca foto para ver detalle completo
    Dado que el usuario está visualizando una foto en el carrusel
    Cuando el usuario toca la foto
    Entonces el sistema navega a la ruta `fotospropiedad` con la propiedad como argumento

  Escenario: Menú de opciones en carrusel completo - Ficha
    Dado que el usuario está en el carrusel completo de fotos
    Cuando el usuario presiona el menú de opciones (tres puntos)
    Y selecciona "Ficha"
    Entonces el sistema navega a `PaginaDetalleWidget` con la propiedad y lista de IDs de fotos

  Escenario: Menú de opciones en carrusel completo - Fotos
    Dado que el usuario está en el carrusel completo de fotos
    Cuando el usuario presiona el menú de opciones
    Y selecciona "Fotos"
    Entonces el sistema navega a la ruta `fotospropiedad`

  Escenario: Menú de opciones en carrusel completo - Guardar en lista
    Dado que el usuario está en el carrusel completo de fotos
    Y el usuario ha iniciado sesión
    Cuando el usuario presiona el menú de opciones
    Y selecciona "Guardar"
    Entonces el sistema abre el selector de listas (`DialogSelectorListas`)

  Escenario: Menú de opciones en carrusel completo - Guardar sin sesión
    Dado que el usuario está en el carrusel completo de fotos
    Y el usuario no ha iniciado sesión
    Cuando el usuario presiona el menú de opciones
    Y selecciona "Guardar"
    Entonces el sistema muestra un SnackBar con mensaje "Ingresa o Registrate para crar listas."
    Y el SnackBar tiene color de fondo `appTheme.error`

  Escenario: Menú de opciones en carrusel completo - Compartir con grupo
    Dado que el usuario está en el carrusel completo de fotos
    Y el usuario ha iniciado sesión
    Cuando el usuario presiona el menú de opciones
    Y selecciona "Con Grupo"
    Entonces el sistema abre la página `PageCompartirConGrupo`

  Escenario: Menú de opciones en carrusel completo - Compartir sin sesión
    Dado que el usuario está en el carrusel completo de fotos
    Y el usuario no ha iniciado sesión
    Cuando el usuario presiona el menú de opciones
    Y selecciona "Con Grupo"
    Entonces el sistema muestra un SnackBar con mensaje "Ingresa para compartir."
    Y el SnackBar tiene color de fondo `appTheme.error`

  Escenario: Menú de opciones en carrusel completo - Compartir con conocido
    Dado que el usuario está en el carrusel completo de fotos
    Y el usuario ha iniciado sesión
    Cuando el usuario presiona el menú de opciones
    Y selecciona "Con Conocido"
    Entonces el sistema abre la página `PageCompartirConConocido`
