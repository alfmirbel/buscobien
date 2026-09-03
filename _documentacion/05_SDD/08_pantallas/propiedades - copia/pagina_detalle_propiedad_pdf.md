# Especificación SDD: Servicio de Generación de PDF de Propiedad
**Archivo:** `lib/08_pantallas/propiedades/pagina_detalle_propiedad_pdf.dart`

---

## 1. Requerimientos Ubicuos
- El sistema deberá generar documentos PDF en formato carta (`PdfPageFormat.letter`).
- El sistema deberá aplicar márgenes estándar de 40 puntos en todas las páginas del documento.
- El sistema deberá incluir la clave de la propiedad en el pie de página de cada página.
- El sistema deberá codificar correctamente caracteres especiales en el nombre del archivo PDF.
- El sistema deberá utilizar la fuente `MaterialIcons` para renderizar íconos dentro del PDF.

## 2. Requerimientos Controlados por Eventos
- Cuando el usuario solicite generar el PDF de una propiedad, el sistema deberá iniciar la precarga asíncrona de la foto principal y las fotos de la galería.
- Cuando se reciba la foto principal en formato base64, el sistema deberá decodificarla e incluirla en la página principal del PDF.
- Cuando se reciba cada foto de la galería, el sistema deberá decodificarla y limitar la colección a un máximo de 12 imágenes.
- Cuando el documento PDF esté completamente construido, el sistema deberá invocar `Printing.layoutPdf` para presentar el documento al usuario.
- Cuando se detecte un valor de precio de venta distinto de `"0"` y no vacío, el sistema deberá renderizar la etiqueta "Venta" con su valor en la sección de precios.
- Cuando se detecte un valor de precio de renta distinto de `"0"` y no vacío, el sistema deberá renderizar la etiqueta "Renta" con su valor en la sección de precios.

## 3. Requerimientos Controlados por Estados
- Mientras el sistema se encuentre en el estado de generación de PDF, deberá mostrar un indicador de carga implícito al bloquear la interacción del usuario hasta finalizar la operación.
- Mientras se construye la página del PDF, el sistema deberá incluir secciones de encabezado, descripción, imagen principal, precios, ubicación, contacto, descripción larga, datos en cuadrícula y galería en el orden definido.
- Mientras se renderiza la cuadrícula de características, el sistema deberá omitir celdas cuyo valor sea `"0"` o cadena vacía.

## 4. Requerimientos de Comportamiento No Deseado
- Si la foto principal no se puede recuperar o su base64 está vacío, entonces el sistema deberá mostrar el texto "Sin Imagen" en el contenedor principal.
- Si ocurre un error al recuperar una foto de la galería, entonces el sistema deberá continuar con la siguiente imagen sin interrumpir la generación del PDF.
- Si una imagen decodificada de la galería está vacía, entonces el sistema deberá excluirla del listado final de imágenes.
- Si no hay imágenes válidas en la galería, entonces el sistema deberá omitir la sección de galería en el PDF.
- Si el campo `clavedelapropiedad` contiene caracteres no válidos para nombres de archivo, entonces el sistema deberá limpiar la clave antes de usarla en el nombre del archivo.

## 5. Requerimientos de Funciones Opcionales
- Donde la plataforma sea Web, el sistema deberá abrir el PDF generado en una nueva pestaña del navegador.
- Donde la plataforma sea Móvil, el sistema deberá presentar la vista previa de impresión nativa con opciones de guardar o compartir.

## 6. Requerimientos Complejos
- Mientras el sistema se encuentra en el estado de generación de PDF, cuando se inicie la carga de imágenes y alguna falle, el sistema deberá registrar el error en consola y continuar con la generación del documento usando los recursos disponibles.
