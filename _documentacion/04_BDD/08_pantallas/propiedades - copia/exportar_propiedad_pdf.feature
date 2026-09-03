# language: es
Característica: Exportación del Detalle de Propiedad a PDF
  Como usuario interesado en una propiedad
  Quiero exportar la información del inmueble a un documento PDF
  Para compartirla o consultarla offline

  Escenario: Generación exitosa de PDF con toda la información
    Dado que el usuario está en la pantalla de detalle de propiedad
    Y la propiedad tiene foto principal, galería, precios, ubicación, contacto y características
    Cuando el usuario solicita generar el PDF
    Entonces el sistema debe crear un documento PDF en formato carta
    Y el sistema debe incluir el título de la propiedad en el encabezado
    Y el sistema debe incluir la descripción promocional
    Y el sistema debe incluir el nombre de la inmobiliaria
    Y el sistema debe incluir la foto principal si está disponible
    Y el sistema debe mostrar "Sin Imagen" si no hay foto principal
    Y el sistema debe incluir los precios de venta y/o renta válidos
    Y el sistema debe incluir la dirección completa de ubicación
    Y el sistema debe incluir los datos de contacto (nombre, teléfono, correo)
    Y el sistema debe incluir todas las características de la propiedad
    Y el sistema debe incluir la galería de fotos (hasta 12 imágenes)

  Escenario: Formato y diseño del documento PDF
    Dado que el sistema está generando el PDF de la propiedad
    Cuando el documento se está construyendo
    Entonces el sistema debe usar márgenes estándar de aproximadamente 2 cm
    Y el sistema debe mostrar la clave de la propiedad en el pie de página
    Y el sistema debe mostrar la clave de la propiedad en una página adicional
    Y el sistema debe usar la fuente Material Icons para los íconos en la cuadrícula de datos
    Y el sistema debe organizar las características en una cuadrícula adaptable (Wrap)

  Escenario: Manejo de errores en la carga de imágenes para el PDF
    Dado que el usuario solicita generar el PDF de una propiedad
    Y la propiedad tiene fotos en su galería
    Cuando el sistema intenta recuperar las imágenes
    Entonces si una imagen falla al cargar, el sistema debe continuar con las siguientes imágenes
    Y el sistema debe incluir en el PDF solo las imágenes que se recuperaron exitosamente
    Y si no hay imágenes principales, el PDF debe generarse sin esa sección

  Escenario: Nombre del archivo PDF generado
    Dado que el usuario genera el PDF de una propiedad
    Y la propiedad tiene una clave única asignada
    Cuando el sistema finaliza la generación del PDF
    Entonces el nombre del archivo debe ser "buscobien-{clave}.pdf"
    Y el sistema debe abrir el PDF en una nueva pestaña del navegador (en plataforma web)
    Y el sistema debe mostrar la vista previa de impresión con opción de guardar o compartir (en móvil)
