# language: es
Característica: Visualización del Detalle de una Propiedad Inmobiliaria
  Como usuario interesado en una propiedad
  Quiero ver toda la información detallada del inmueble
  Para evaluar si cumple con mis requisitos de compra o renta

  Escenario: Visualización del contenido promocional y descriptivo
    Dado que el usuario accede al detalle de una propiedad
    Y la propiedad tiene letrero promocional definido
    Y la propiedad tiene descripción e inmobiliaria asociada
    Cuando el sistema renderiza la pantalla de detalle
    Entonces el sistema debe mostrar el letrero promocional centrado y con estilo de título
    Y el sistema debe mostrar la descripción del inmueble
    Y el sistema debe mostrar el nombre de la inmobiliaria

  Escenario: Visualización de la foto principal con estados de carga y error
    Dado que el usuario está en la pantalla de detalle de propiedad
    Y la propiedad tiene identificadores de fotos asociados
    Cuando el sistema intenta cargar la foto principal
    Entonces el sistema debe mostrar un indicador de carga mientras espera la imagen
    Y si la carga falla, el sistema debe mostrar un mensaje de error de formato
    Y si la propiedad no tiene fotos, el sistema debe mostrar el texto "Sin foto"
    Y si la carga es exitosa, el sistema debe mostrar la imagen con borde y esquinas redondeadas

  Escenario: Visualización de precios de venta y renta
    Dado que el usuario está en la pantalla de detalle de propiedad
    Y la propiedad tiene precios de venta y/o renta definidos
    Cuando el sistema renderiza la sección de precios
    Entonces si el precio de venta es válido, el sistema debe mostrarlo con etiqueta "Precio venta"
    Y si el precio de renta es válido, el sistema debe mostrarlo con etiqueta "Precio renta"
    Y los precios deben mostrarse con estilo bold sobre un contenedor de color surface

  Escenario: Visualización de datos estructurados de la propiedad
    Dado que el usuario está en la pantalla de detalle de propiedad
    Y la propiedad tiene datos de metros de terreno, construcción, recámaras, baños, estacionamientos, etc.
    Cuando el sistema renderiza la sección "Datos de la Propiedad"
    Entonces el sistema debe mostrar cada dato en un contenedor con borde secondary
    Y cada dato debe mostrar su etiqueta y valor correspondiente
    Y si un valor está vacío o es "0", el sistema debe omitir ese campo

  Escenario: Visualización de ubicación de la propiedad
    Dado que el usuario está en la pantalla de detalle de propiedad
    Y la propiedad tiene datos de ubicación (calle, colonia, ciudad, municipio, CP)
    Cuando el sistema renderiza la sección "Ubicación"
    Entonces el sistema debe mostrar la dirección completa (calle y número)
    Y el sistema debe mostrar el asentamiento y ciudad
    Y el sistema debe mostrar el código postal

  Escenario: Visualización de datos de contacto del inmueble
    Dado que el usuario está en la pantalla de detalle de propiedad
    Y la propiedad tiene datos de contacto (nombre, teléfono, correo)
    Cuando el sistema renderiza la sección "Datos del contacto"
    Entonces el sistema debe mostrar el nombre del contacto
    Y el sistema debe mostrar el número celular
    Y el sistema debe mostrar el correo electrónico
    Y si algún campo de contacto está vacío, el sistema debe omitirlo

  Escenario: Visualización de características adicionales de la propiedad
    Dado que el usuario está en la pantalla de detalle de propiedad
    Y la propiedad tiene características adicionales (paneles solares, jardín, alberca, etc.)
    Cuando el sistema renderiza la sección "Más datos de la propiedad"
    Entonces el sistema debe mostrar cada característica en un chip con borde outline
    Y el sistema debe mostrar el texto de la característica con su valor
    Y si no hay características adicionales, el sistema debe ocultar la sección completa

  Escenario: Visualización de galería de fotos ordenada
    Dado que el usuario está en la pantalla de detalle de propiedad
    Y la propiedad tiene múltiples fotos en su galería
    Y existe un orden definido para las fotos
    Cuando el sistema renderiza la sección "Fotos propiedad"
    Entonces el sistema debe mostrar las fotos en el orden especificado
    Y cada foto debe mostrarse en un contenedor de 150x100 píxeles
    Y mientras se cargan las fotos, el sistema debe mostrar un indicador de espera
    Y si una foto falla al cargar, el sistema debe mostrar un ícono de imagen rota

  Escenario: Interacción con el botón de favoritos (Me Gusta)
    Dado que el usuario está en la pantalla de detalle de propiedad
    Y el usuario no ha iniciado sesión
    Cuando el usuario presiona el botón de favoritos
    Entonces el sistema debe mostrar el diálogo de inicio de sesión
    Y no debe agregar la propiedad a favoritos

  Escenario: Interacción con el botón de favoritos (Me Gusta) con sesión activa
    Dado que el usuario está en la pantalla de detalle de propiedad
    Y el usuario ha iniciado sesión
    Y la propiedad no está marcada como favorita
    Cuando el usuario presiona el botón de favoritos
    Entonces el sistema debe cambiar el ícono a favorito activado
    Y el sistema debe cambiar el color del ícono a rojo de marca
    Y el sistema debe agregar la propiedad a la lista de favoritos del usuario
