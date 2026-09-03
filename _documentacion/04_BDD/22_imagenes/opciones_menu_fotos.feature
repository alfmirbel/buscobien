# language: es
Característica: Menú de Opciones de Fotos de Propiedad
  Como usuario final
  Quiero cambiar entre diferentes vistas de gestión de fotos
  Para elegir cómo quiero ver y organizar las imágenes de mi propiedad

  Escenario: Pantalla principal con tres pestañas
    Dado que el usuario abre la gestión de fotos de la propiedad
    Cuando el sistema renderiza la pantalla
    Entonces el sistema muestra el AppBar con título "Manejo de Fotos de la Propiedad"
    Y muestra el botón de retroceso con icono `arrow_back`
    Y muestra el TabBar con 3 pestañas: "Cargar", "Ordenar", "Mostrar"

  Escenario: Pestaña Cargar activa por defecto
    Dado que el usuario abre la gestión de fotos de la propiedad
    Cuando el sistema inicializa el TabController
    Entonces el sistema selecciona la pestaña "Cargar" (índice 0)
    Y muestra el icono `view_comfy_alt` en la pestaña activa
    Y aplica estilo inverso: fondo `appTheme.onPrimary`, texto e icono en `appTheme.primary`

  Escenario: Cambio a pestaña Ordenar
    Dado que el usuario está en la pestaña "Cargar"
    Cuando el usuario toca la pestaña "Ordenar"
    Entonces el sistema cambia el TabController al índice 1
    Y actualiza el estilo de la pestaña: fondo `appTheme.onPrimary`, texto en `appTheme.primary`
    Y la pestaña "Cargar" pasa a estilo inactivo: fondo `appTheme.primary`, texto en `appTheme.onPrimary`
    Y muestra la vista de lista reordenable (`PropiedadesListaFotosPromotor`)

  Escenario: Cambio a pestaña Mostrar
    Dado que el usuario está en la pestaña "Cargar"
    Cuando el usuario toca la pestaña "Mostrar"
    Entonces el sistema cambia el TabController al índice 2
    Y actualiza el estilo de la pestaña
    Y muestra la vista de carrusel (`PaginaCarouselFotosWidget`)

  Escenario: Navegación por swipe entre pestañas
    Dado que el usuario está en la pestaña "Cargar"
    Cuando el usuario desliza horizontalmente hacia la izquierda
    Entonces el sistema detecta el cambio en el TabController
    Y actualiza el estilo de las pestañas automáticamente
    Y muestra la pestaña "Ordenar"

  Escenario: Estilo de pestañas activas e inactivas
    Dado que el usuario está visualizando el TabBar
    Y la pestaña "Ordenar" está activa
    Cuando el sistema renderiza las pestañas
    Entonces la pestaña activa tiene: fondo `appTheme.onPrimary`, icono e texto en `appTheme.primary`
    Y las pestañas inactivas tienen: fondo `appTheme.primary`, icono e texto en `appTheme.onPrimary`
    Y todas las pestañas tienen border radius de 6 píxeles
    Y el indicador tiene border de 1 píxel en `appTheme.primary`

  Escenario: Descarte de diálogo al presionar retroceso
    Dado que el usuario está en la gestión de fotos
    Cuando el usuario presiona el botón de retroceso en el AppBar
    Entonces el sistema navega a la pantalla anterior con `Navigator.pop`

  Escenario: Contenido de pestaña Cargar
    Dado que el usuario está en la pestaña "Cargar"
    Cuando el sistema renderiza el contenido
    Entonces muestra la pantalla `PropiedadesMiniFotoListaPromotor` con cuadrícula de fotos
    Y muestra barra inferior con botones Agregar y Refrescar

  Escenario: Contenido de pestaña Ordenar
    Dado que el usuario está en la pestaña "Ordenar"
    Cuando el sistema renderiza el contenido
    Entonces muestra la pantalla `PropiedadesListaFotosPromotor` con lista reordenable
    Y muestra barra inferior con botones Agregar, Guardar y Refrescar

  Escenario: Contenido de pestaña Mostrar
    Dado que el usuario está en la pestaña "Mostrar"
    Cuando el sistema renderiza el contenido
    Entonces muestra la pantalla `PaginaCarouselFotosWidget` con carrusel de fotos
