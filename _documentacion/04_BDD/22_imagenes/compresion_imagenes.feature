# language: es
Característica: Compresión de Imágenes
  Como usuario final
  Quiero que las imágenes se compriman antes de subirse
  Para ahorrar datos de almacenamiento y mejorar la velocidad de carga

  Escenario: Compresión de archivo en Android/iOS con flutter_image_compress
    Dado que el usuario selecciona una imagen desde su dispositivo móvil
    Y la plataforma es Android o iOS
    Y la imagen original es de 2300x1500 píxeles
    Cuando el sistema comprime la imagen
    Entonces el sistema utiliza `FlutterImageCompress.compressWithFile`
    Y respeta el mínimo de ancho 2300 y alto 1500
    Y aplica calidad 80%
    Y retorna la imagen comprimida como `Uint8List`

  Escenario: Compresión de archivo en Windows con Dart puro
    Dado que el usuario selecciona una imagen desde su dispositivo Windows
    Y la imagen original es de 2000x2000 píxeles
    Cuando el sistema comprime la imagen
    Entonces el sistema detecta la plataforma Windows
    Y utiliza `fotoCompressListWin` con lógica Dart pura
    Y redimensiona la imagen a ancho máximo 800 píxeles manteniendo aspecto
    Y comprime a JPEG con calidad 80%
    Y retorna la imagen comprimida como `Uint8List`

  Escenario: Compresión y guardado de archivo en Android/iOS
    Dado que el usuario selecciona una imagen desde su dispositivo móvil
    Y la plataforma es Android o iOS
    Cuando el sistema comprime y guarda la imagen en una ruta específica
    Entonces el sistema utiliza `FlutterImageCompress.compressAndGetFile`
    Y retorna un `XFile` con la imagen comprimida en la ruta destino

  Escenario: Compresión de asset de imagen
    Dado que el sistema necesita comprimir un asset de imagen
    Y el asset tiene resolución 1920x1080
    Cuando el sistema comprime el asset
    Entonces el sistema utiliza `FlutterImageCompress.compressAssetImage`
    Y respeta el mínimo de ancho 1080 y alto 1920
    Y aplica calidad 80%
    Y retorna la imagen comprimida como `Uint8List`

  Escenario: Compresión de imagen en Web
    Dado que el usuario sube una imagen desde la plataforma Web
    Y la imagen está en formato JPEG o PNG
    Cuando el sistema comprime la imagen
    Entonces el sistema utiliza `compressImageWeb` con lógica Dart pura
    Y decodifica la imagen desde los bytes
    Y comprime a JPEG con calidad 80%
    Y retorna la imagen comprimida como `Uint8List`

  Escenario: Compresión WebP desde bytes en Android/iOS/Web
    Dado que el sistema necesita convertir una imagen a formato WebP
    Y la imagen original es de 1080x1080 píxeles
    Y la plataforma no es Windows
    Cuando el sistema comprime a WebP
    Entonces el sistema utiliza `FlutterImageCompress.compressWithList`
    Y respeta el mínimo de ancho 620 y alto 480
    Y aplica la calidad especificada
    Y retorna la imagen en formato WebP como `Uint8List`

  Escenario: Compresión WebP en Windows con fallback
    Dado que el sistema necesita convertir una imagen a formato WebP
    Y la plataforma es Windows
    Cuando el sistema comprime a WebP
    Entonces el sistema detecta Windows y usa `fotoCompressListWebP`
    Y decodifica la imagen con `img.decodeImage`
    Y redimensiona a ancho 620 píxeles
    Y comprime a JPEG con calidad especificada (fallback seguro)
    Y retorna la imagen comprimida como `Uint8List`

  Escenario: Compresión de imagen en Windows desde archivo
    Dado que el usuario selecciona una imagen desde Windows
    Y el archivo existe en la ruta especificada
    Cuando el sistema comprime la imagen con `fotoCompressListWin`
    Entonces el sistema lee el archivo como bytes
    Y decodifica la imagen con `img.decodeImage`
    Y redimensiona a ancho máximo 800 píxeles
    Y comprime a JPEG con calidad 80%
    Y retorna los bytes comprimidos

  Escenario: Error al decodificar imagen en Web
    Dado que el usuario sube una imagen corrupta desde Web
    Cuando el sistema intenta comprimir con `compressImageWeb`
    Entonces el sistema no puede decodificar la imagen
    Y retorna la imagen original sin comprimir para no romper el flujo

  Escenario: Error al decodificar imagen en Windows
    Dado que el usuario selecciona un archivo que no es una imagen válida en Windows
    Cuando el sistema intenta comprimir con `fotoCompressListWin`
    Entonces el sistema lanza una excepción "No se pudo decodificar la imagen."

  Escenario: Archivo no existe en Windows
    Dado que el sistema intenta comprimir una imagen en Windows
    Y la ruta del archivo no existe
    Cuando el sistema ejecuta `fotoCompressListWin`
    Entonces el sistema lanza una excepción "El archivo no existe: [ruta]"

  Escenario: Conversión a WebP desde bytes en Windows
    Dado que el sistema necesita convertir bytes de imagen a WebP en Windows
    Cuando el sistema ejecuta `convertToWebP`
    Entonces el sistema detecta Windows y redirige a `fotoCompressListWebP`
    Y aplica redimensión y compresión JPEG como fallback
