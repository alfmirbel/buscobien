# language: es
Funcionalidad: Subida múltiple de fotos con compresión

  Como promotor/propietario
  Quiero agregar varias fotos a la vez (_multi-selección) ya comprimidas
  Para mantener un catálogo visual completo sin consumir ancho de banda excesivo

  Antecedentes:
    Dado que el usuario está en PaginaFotosPropiedad de una propiedad con idPropiedad="propiedad:uuid-001"
    Y el idPropiedad tiene N fotos existentes (N < maxFotosPorPropiedad)
    Y el usuario toca "Agregar fotos" → navega a AgregaMultiplesFotos

  Escenario: Selección múltiple desde galería
    Dado que FilePicker.platform.pickFiles(allowMultiple:true, type:image) se invoca
    Cuando el usuario selecciona 5 fotos desde la galería
    Entonces PlatformFile[] retorna con 5 entradas (path, name, size, bytes)
    Y se muestra preview thumbnails de cada una

  Escenario: Compresión antes de subir
    Dado que 5 fotos han sido seleccionadas (JPEG 12MP cada una ~5MB)
    Cuando se invoca funciones_compress_image.compressImage(File, {quality:70, maxWidth:1920, maxHeight:1080})
    Entonces cada imagen se reduce a <500KB (quality 70%)
    Y retorna Uint8List base64 para POST a Node.js API

  Escenario: Subida a CouchDB vía API
    Dado que 5 fotos comprimidas están listas
    Cuando se llama http_funciones_gestion_foto.uploadMultiplePhotos()
    Entonces se hace POST multipart a Node.js API con idUsuario, idPropiedad, archivo
    Y la API crea documento "foto:uuid-NNN" + attachment en CouchDB
    Y retorna CouchDbReturnValue con éxito/fallo por cada foto

  Escenario: Cancelación de FilePicker
    Dado que FilePicker retorna null (usuario cancela diálogo)
    Cuando AgregaMultiplesFotos recibe resultado vacío
    Entonces muestra SnackBar "Selección cancelada"
    Y retorna a PaginaFotosPropiedad sin subir nada

  Escenario: Fallo de compresión / archivo corrupto
    Dado que una foto seleccionada está corrupta
    Cuando compressImage lanza excepción
    Entonces se captura en try-catch por archivo (no aborta el batch)
    Y se registra error en debugPrintLevels
    Y las fotos válidas del batch se suben normalmente

  Escenario: Límite máximo alcanzado
    Dado que la propiedad ya tiene maxFotosPorPropiedad fotos
    Cuando el usuario intenta agregar más
    Entonces el sistema bloquea la subida
    Y muestra SnackBar "Máximo de N fotos alcanzado"
