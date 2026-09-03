# language: es
Característica: Gestión de Fotos en Modo Cuadrícula
  Como usuario final
  Quiero ver y administrar las fotos de mi propiedad en una cuadrícula visual
  Para organizar el contenido visual de mi publicación

  Escenario: Carga inicial de cuadrícula de fotos
    Dado que el usuario abre la gestión de fotos en modo cuadrícula
    Y la propiedad tiene 4 fotos registradas
    Cuando el sistema carga los datos iniciales
    Entonces el sistema muestra el título "Número de fotos: 4"
    Y renderiza una cuadrícula con 4 thumbnails de 150x100 píxeles
    Y cada thumbnail muestra la imagen con `BoxFit.cover`

  Escenario: Cuadrícula vacía sin fotos
    Dado que el usuario abre la gestión de fotos en modo cuadrícula
    Y la propiedad no tiene fotos
    Cuando el sistema carga los datos iniciales
    Entonces el sistema muestra el título "Número de fotos: 0"
    Y muestra el mensaje "No se encontraron fotos" centrado

  Escenario: Agregar fotos desde modo cuadrícula
    Dado que el usuario está en la gestión de fotos en modo cuadrícula
    Y el usuario está en la sección "Mi cuenta"
    Cuando el usuario presiona el botón "Agregar"
    Entonces el sistema limpia las posiciones de la lista ordenada
    Y navega a la ruta `agregamultiplesfotos`
    Y al regresar, activa el botón "Guardar" y desactiva "Refrescar" temporalmente

  Escenario: Refrescar cuadrícula de fotos
    Dado que el usuario está visualizando la cuadrícula de fotos
    Cuando el usuario presiona el botón "Refrescar"
    Entonces el sistema recarga el número de fotos, IDs y orden desde CouchDB

  Escenario: Detección de desincronización en orden de fotos
    Dado que el usuario abre la gestión de fotos en modo cuadrícula
    Y el orden guardado tiene diferente cantidad de fotos que los IDs actuales
    Cuando el sistema procesa los datos
    Entonces el sistema detecta la desincronización
    Y genera una lista local con el orden de los IDs base
    Y programa la actualización del provider después del build
    Y renderiza la cuadrícula con la lista local generada

  Escenario: Uso de orden guardado cuando está sincronizado
    Dado que el usuario abre la gestión de fotos en modo cuadrícula
    Y el orden guardado coincide en cantidad con los IDs de fotos
    Cuando el sistema procesa los datos
    Entonces el sistema usa la lista ordenada del provider
    Y renderiza la cuadrícula en el orden guardado

  Escenario: Visualización de thumbnail en cuadrícula
    Dado que el usuario está visualizando la cuadrícula de fotos
    Y una foto tiene contenido base64 válido
    Cuando el sistema renderiza el thumbnail
    Entonces muestra la imagen en un contenedor de 150x100 píxeles
    Y aplica `BoxFit.cover` para ajustar la imagen

  Escenario: Placeholder para foto sin contenido
    Dado que el usuario está visualizando la cuadrícula de fotos
    Y una foto tiene contenido vacío o null
    Cuando el sistema renderiza el thumbnail
    Entonces muestra el texto "No se encontró foto" centrado
    Y el texto tiene color gris y tamaño 12

  Escenario: Estado de carga mientras se obtiene foto individual
    Dado que el usuario está visualizando la cuadrícula de fotos
    Y el sistema está cargando una foto individual
    Cuando el future de la foto está en estado `waiting`
    Entonces muestra un indicador de progreso circular de 150x100 píxeles

  Escenario: Estado de error al cargar foto individual
    Dado que el usuario está visualizando la cuadrícula de fotos
    Y ocurre un error al cargar una foto individual
    Cuando el future completa con error
    Entonces muestra el mensaje de error formateado en el placeholder de 150x100 píxeles

  Escenario: Menú inferior en modo cuadrícula - Solo cancelar (visita)
    Dado que el usuario está en la gestión de fotos desde una visita
    Y no está en la sección "Mi cuenta"
    Cuando el sistema renderiza la barra inferior
    Entonces muestra solo el botón "Cancelar" con icono `cancel`
    Y al presionarlo, cierra la pantalla con `Navigator.pop`
