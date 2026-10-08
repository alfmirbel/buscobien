# language: es
Característica: Detalle de propiedad y exportación PDF
  Como usuario
  Quiero consultar la ficha completa de una propiedad y exportar un PDF
  Para compartir o guardar la información relevante

  @REQ-PROP-002 @mapeo-auto
  Escenario: Visualización del detalle de propiedad
    Dado que el usuario abre una propiedad desde el listado
    Cuando se renderiza la pantalla de detalle
    Entonces el usuario ve datos técnicos, ubicación, contacto e imágenes

  @REQ-PROP-007 @mapeo-auto
  Escenario: Exportación de ficha a PDF
    Dado que el usuario está en el detalle de una propiedad
    Y la propiedad tiene foto principal y galería
    Cuando el usuario solicita generar el PDF
    Entonces el sistema genera un documento PDF con portada,datos grid, ubicación y galería
    Y la descarga o previsualización se entrega por Printing.layoutPdf
