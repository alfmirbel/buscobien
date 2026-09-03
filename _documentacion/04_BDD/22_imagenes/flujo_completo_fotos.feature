# language: es
Característica: Flujo Completo de Gestión de Fotos
  Como usuario final
  Quiero gestionar las fotos de mi propiedad de principio a fin
  Para publicar mi propiedad con las mejores imágenes

  Escenario: Flujo completo de carga de fotos desde cero
    Dado que el usuario es propietario de una propiedad sin fotos
    Y accede a la sección de gestión de fotos
    Cuando el sistema carga la pantalla
    Entonces el sistema muestra "Número de fotos: 0"
    Y el usuario puede presionar "Agregar" para seleccionar imágenes
    Y después de seleccionar, el sistema navega a la captura de fotos
    Y al confirmar, retorna a la gestión con las fotos cargadas
    Y el sistema actualiza el contador de fotos

  Escenario: Flujo de visualización, reordenamiento y guardado
    Dado que el usuario tiene 5 fotos en su propiedad
    Y accede a la pestaña "Ordenar"
    Cuando el usuario reordena las fotos arrastrando
    Y presiona el botón "Guardar"
    Entonces el sistema valida si existe orden previo
    Y actualiza o crea el documento de orden en CouchDB
    Y recarga la lista mostrando el nuevo orden

  Escenario: Flujo de visualización en carrusel con orden guardado
    Dado que el usuario ha guardado un orden personalizado de fotos
    Y accede a la pestaña "Mostrar"
    Cuando el sistema carga el carrusel
    Entonces el sistema recupera el orden guardado desde CouchDB
    Y valida que la cantidad de fotos en el orden coincida con los IDs
    Y muestra las fotos en el orden guardado
    Y el usuario puede navegar entre ellas con botones o swipe

  Escenario: Flujo de eliminación de foto con actualización de orden
    Dado que el usuario tiene 4 fotos con un orden guardado
    Y elimina la foto en posición 2
    Cuando el sistema confirma la eliminación
    Entonces el sistema elimina la foto de CouchDB
    Y remueve la foto de la lista general
    Y remueve la foto de la lista de orden
    Y actualiza el documento de orden en CouchDB
    Y recarga la UI mostrando 3 fotos

  Escenario: Flujo de detección de desincronización y recuperación
    Dado que el usuario tiene 3 fotos con orden guardado
    Y se agrega una foto desde otro dispositivo
    Cuando el usuario abre la gestión de fotos en modo cuadrícula
    Entonces el sistema detecta que hay 4 IDs pero el orden tiene 3
    Y genera un nuevo orden basado en los IDs actuales
    Y limpia el orden guardado obsoleto
    Y renderiza la cuadrícula con las 4 fotos en orden natural

  Escenario: Flujo de carga diferida de imágenes en lista
    Dado que el usuario está visualizando la lista de fotos
    Y la lista tiene 10 fotos
    Cuando el sistema renderiza cada item
    Entonces cada item muestra un thumbnail de 80x50 píxeles
    Y la imagen se carga individualmente con `recuperaFotoPorIdFoto`
    Y mientras carga, muestra un CircularProgressIndicator
    Y al completar, muestra la imagen decodificada desde base64
    Y cada imagen se carga de forma independiente sin bloquear las demás

  Escenario: Flujo de navegación entre vistas de fotos
    Dado que el usuario está visualizando el carrusel de fotos
    Y presiona una foto
    Entonces navega a la vista de galería completa
    Y desde la galería puede regresar al carrusel
    Y desde el menú de opciones puede cambiar a modo listado o cuadrícula
    Y todas las vistas comparten el mismo estado de fotos y orden

  Escenario: Flujo de carga con error de red
    Dado que el usuario abre la gestión de fotos
    Y el servidor CouchDB no responde
    Cuando el sistema intenta cargar los metadatos
    Entonces el sistema captura la excepción de socket
    Y retorna código 503 o 500
    Y muestra el estado de error con el mensaje formateado
