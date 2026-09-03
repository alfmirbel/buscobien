# language: es
Característica: Detalle de Propiedad y Visualización de Información
  Como usuario de BuscoBien
  Quiero ver toda la información de una propiedad en una pantalla organizada
  Para evaluar si el inmueble se adapta a mis necesidades

  Escenario: El detalle muestra el letrero promocional y la descripción
    Dado que el usuario abre el detalle de una propiedad
    Cuando se renderiza "PaginaDetalleWidget"
    Entonces el sistema debe mostrar "espacios.letreropromocional" como título centrado
    Y debe mostrar "espacios.descripcion" como texto alineado a la izquierda
    Y ambos textos deben usar colores de "appTheme.onPrimaryContainer"

  Escenario: El detalle muestra la foto principal con iconos de características
    Dado que la propiedad tiene al menos una foto
    Cuando se renderiza "_buildFotoPrincipalYIconos"
    Entonces el sistema debe mostrar la primera foto en un contenedor de 350x200
    Y debe mostrar iconos de terreno, construcción, recámaras, baños y estacionamientos
    Y cada icono debe tener tamaño 16 y texto tamaño 10

  Escenario: El detalle muestra estado vacío si no hay foto principal
    Dado que la propiedad no tiene fotos ("listaIdsFotos.rows.isEmpty")
    Cuando se renderiza "_buildFotoPrincipalYIconos"
    Entonces el sistema debe mostrar el texto "Sin foto" centrado
    Y no debe mostrar el contenedor de imagen

  Escenario: El detalle muestra precios de venta y renta
    Dado que la propiedad tiene precios definidos
    Cuando se renderiza "_buildPrecioFila"
    Entonces el sistema debe mostrar "Precio venta: [valor]" si el valor no está vacío ni es "0"
    Y debe mostrar "Precio renta: [valor]" si el valor no está vacío ni es "0"
    Y cada precio debe estar en un contenedor de altura 30 con fondo "appTheme.surface"

  Escenario: Los campos vacíos o con "0" no se muestran en precios
    Dado que "espacios.precioventa" es "0" o vacío
    Cuando se renderiza "_buildPrecioFila('Precio venta', '0')"
    Entonces el sistema debe retornar "SizedBox.shrink()"
    Y no debe mostrar ninguna fila de precio

  Escenario: El detalle muestra la sección Datos de la Propiedad
    Dado que el usuario abre el detalle de una propiedad
    Cuando se renderiza la sección de datos
    Entonces el sistema debe mostrar Terreno, Construcción, Recámaras, Cuartos de servicio, Baños, Medios baños, Estacionamientos y Cubiertos
    Y cada dato debe estar en un contenedor con borde "appTheme.secondary" y radio 3

  Escenario: El detalle muestra la sección Ubicación
    Dado que la propiedad tiene datos de ubicación
    Cuando se renderiza la sección de ubicación
    Entonces el sistema debe mostrar Dirección (calle, numeroexterior, numerointerior)
    Y debe mostrar Colonia, Ciudad, Municipio y C.P.
    Y cada campo debe tener un "maxWidth" específico (Dirección: 700, Colonía/Municipio/CP: 350)

  Escenario: El detalle muestra la sección Datos del contacto
    Dado que la propiedad tiene datos de contacto
    Cuando se renderiza la sección de contacto
    Entonces el sistema debe mostrar Nombre, Teléfono y Correo
    Y cada campo debe tener tamaño de fuente 12 y peso "FontWeight.bold"

  Escenario: El detalle muestra características adicionales cuando existen
    Dado que la propiedad tiene características adicionales (paneles solares, alberca, etc.)
    Cuando se renderiza "_buildListaMasDatos"
    Entonces el sistema debe mostrar cada característica en un chip con borde "appTheme.outline"
    Y cada chip debe tener radio 8 y padding de 8
    Y si no hay características, debe retornar "SizedBox.shrink()"

  Escenario: El detalle muestra la galería de fotos
    Dado que la propiedad tiene fotos en la galería
    Cuando se renderiza "_buildGaleriaFotos"
    Entonces el sistema debe mostrar cada foto en un "SizedBox" de 150x100
    Y cada foto debe tener "BoxFit.cover"
    Y las fotos deben estar organizadas en un "Wrap" con spacing 10 y runSpacing 10

  Escenario: La galería muestra estado de carga mientras obtiene los IDs
    Dado que el usuario acaba de abrir el detalle de la propiedad
    Cuando "recuperaIdsFotosDePropiedades" está en progreso
    Entonces el sistema debe mostrar "stateWaiting" con dimensiones estándar

  Escenario: La galería muestra estado vacío si no hay fotos
    Dado que la propiedad no tiene fotos registradas
    Cuando "recuperaIdsFotosDePropiedades" completa sin error
    Entonces el sistema debe mostrar el texto "No se encontraron fotos" centrado

  Escenario: La foto individual muestra placeholder si falla la carga
    Dado que una foto específica falla al cargar
    Cuando se renderiza "_FotoItemWidget"
    Entonces el sistema debe mostrar un contenedor de 150x100 con icono "Symbols.broken_image"
    Y el icono debe tener color "appTheme.onSurface"

  Escenario: El botón Me Gusta funciona sin sesión iniciada
    Dado que el usuario no ha iniciado sesión
    Cuando presiona el botón de me gusta en el detalle
    Entonces el sistema debe abrir "dialogBoxFichaLogin"
    Y no debe agregar la propiedad a favoritos

  Escenario: El botón Me Gusta cambia de estado al presionarlo
    Dado que el usuario ha iniciado sesión
    Y la propiedad no está en favoritos
    Cuando presiona el botón de me gusta
    Entonces el icono debe cambiar a "Symbols.favorite" en color rojo (#E91E63)
    Y al presionarlo nuevamente debe cambiar a "Symbols.favorite_border"
