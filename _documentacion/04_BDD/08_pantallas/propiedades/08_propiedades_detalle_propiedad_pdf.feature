# language: es
Característica: Generación y Descarga de PDF de Propiedad
  Como usuario de BuscoBien
  Quiero generar un documento PDF con la información de una propiedad
  Para compartir o guardar el detalle del inmueble

  Escenario: El sistema genera un PDF con formato carta y todos los datos
    Dado que el usuario está en el detalle de una propiedad
    Cuando el sistema ejecuta "PdfGeneratorService.generarYDescargarPDF"
    Entonces el sistema debe crear un documento PDF con formato "PdfPageFormat.letter"
    Y debe incluir el título de la propiedad en el header
    Y debe incluir descripción, imagen principal, precios, ubicación y contacto

  Escenario: El nombre del archivo PDF incluye la clave de la propiedad
    Dado que la propiedad tiene "clavedelapropiedad = 'ABC123'"
    Cuando se genera el PDF
    Entonces el nombre del archivo debe ser "buscobien-ABC123.pdf"

  Escenario: El PDF muestra la imagen principal si existe
    Dado que la propiedad tiene foto principal
    Cuando se genera el PDF
    Entonces el sistema debe descargar la imagen por "recuperaFotoPorIdFoto"
    Y debe mostrarla en un contenedor de 250px de alto con bordes redondeados

  Escenario: El PDF muestra texto 'Sin Imagen' si no hay foto principal
    Dado que la propiedad no tiene foto principal
    Cuando se genera el PDF
    Entonces el sistema debe mostrar el texto "Sin Imagen" en el lugar de la imagen

  Escenario: El PDF muestra los precios de venta y renta
    Dado que la propiedad tiene precios definidos
    Cuando se genera el PDF
    Entonces el sistema debe mostrar "Venta: [precio]" si el precio no es "0" ni vacío
    Y debe mostrar "Renta: [precio]" si el precio no es "0" ni vacío
    Y ambos deben estar en fuente 14 bold

  Escenario: El PDF muestra la sección de Datos de la Propiedad con iconos
    Dado que se genera el PDF
    Entonces el sistema debe mostrar un grid de características con iconos de Material Symbols
    Y cada celda debe tener borde gris, padding de 5 y radio de 4
    Y las celdas vacías (valor "0" o "") deben ocultarse

  Escenario: El PDF muestra la sección de Ubicación
    Dado que se genera el PDF
    Entonces el sistema debe mostrar "Ubicación" como título bold
    Y debe mostrar calle, colonia/ciudad y C.P. en formato de lista con viñetas

  Escenario: El PDF muestra la sección de Contacto
    Dado que se genera el PDF
    Entonces el sistema debe mostrar "Contacto" como título bold
    Y debe mostrar nombre, teléfono y correo en un contenedor con fondo gris claro

  Escenario: El PDF muestra la galería de imágenes limitada a 12 fotos
    Dado que la propiedad tiene más de 12 fotos
    Cuando se genera el PDF
    Entonces el sistema debe incluir solo las primeras 12 fotos en la galería
    Y cada foto debe estar en un contenedor de 150x100 con "BoxFit.cover"

  Escenario: El PDF muestra la clave de propiedad en el pie de página
    Dado que se genera el PDF
    Entonces el sistema debe mostrar "Clave de propiedad: [clave]" alineado a la derecha
    Y debe mostrarlo en tamaño 10 y color gris
    Y debe aparecer tanto al final de la primera página como en el pie de página final

  Escenario: El PDF se descarga/visualiza en todas las plataformas
    Dado que el usuario genera el PDF
    Cuando se completa la generación
    Entonces el sistema debe ejecutar "Printing.layoutPdf" con el nombre del archivo
    Y en Web debe abrir el PDF en una nueva pestaña
    Y en Móvil debe abrir la vista previa de impresión

  Escenario: El PDF omite características adicionales
    Dado que se genera el PDF
    Entonces el sistema no debe incluir la sección "Más datos de la propiedad" del detalle web
    Y solo debe incluir las características del grid principal
