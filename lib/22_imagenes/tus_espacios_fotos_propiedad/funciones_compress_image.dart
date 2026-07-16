import 'dart:io';

import 'package:flutter/foundation.dart'; // Necesario para kIsWeb y debugPrint
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

import '../../60_global_widgets/debugprint.dart';
// -------------------------------------------------------------------
// OPTIMIZADO

// 1. compress file and get Uint8List
// NOTA: Esta función requiere un objeto 'File' de dart:io.
// NO debe ser llamada desde Flutter Web (usar bytes en su lugar).
Future<Uint8List?> testCompressFile(File file) async {
  debugPrintLevels(0, "testCompressFile START");

  // VALIDACIÓN: Windows no soporta flutter_image_compress nativo, usamos Dart puro
  if (!kIsWeb && Platform.isWindows) {
    return await fotoCompressListWin(file.path);
  }

  // Android / iOS
  var result = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    minWidth: 2300,
    minHeight: 1500,
    quality: 80,
    rotate: 0,
  );

  debugPrintLevels(0, "file original size: ${file.lengthSync()}");
  debugPrintLevels(0, "result size: ${result?.length}");
  return result;
}

// 2. compress file and get file.
// NOTA: Retorna XFile (cross_file) compatible con todas las plataformas
Future<XFile?> testCompressAndGetFile(File file, String targetPath) async {
  debugPrintLevels(0, "testCompressAndGetFile START");

  // VALIDACIÓN WINDOWS: Procesamiento manual
  if (!kIsWeb && Platform.isWindows) {
    final bytes = await fotoCompressListWin(file.path);
    final newFile = File(targetPath);
    await newFile.writeAsBytes(bytes);
    return XFile(targetPath);
  }

  // Android / iOS
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 80,
    rotate: 0,
  );

  debugPrintLevels(0, "original size: ${file.lengthSync()}");
  // CORRECCIÓN: length() es un Future en XFile
  debugPrintLevels(0, "result size: ${await result?.length()}");

  return result;
}

// 3. compress asset and get Uint8List.
Future<Uint8List?> testCompressAsset(String assetName) async {
  debugPrintLevels(0, "testCompressAsset START");

  // Nota: flutter_image_compress puede fallar en Windows/Web con assets.
  // Si falla, se debería cargar el asset como bytes y usar el método de bytes.

  var list = await FlutterImageCompress.compressAssetImage(
    assetName,
    minHeight: 1920,
    minWidth: 1080,
    quality: 80,
    rotate: 0,
  );

  return list;
}

// -----------------------------------------------------------
// IA & WEB
/// Comprime una imagen (JPEG o PNG) al 50% de calidad.
/// OPTIMIZADO: Usa lógica pura de Dart, compatible con Web y Windows.
Future<Uint8List> compressImageWeb(Uint8List imageBytes) async {
  debugPrintLevels(7, "compressImageWeb START");

  try {
    // Decodificar la imagen desde los bytes
    // img.decodeImage es agnóstico al formato (detecta jpg, png, webp)
    final originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) {
      throw Exception('No se pudo decodificar la imagen.');
    }

    // Opcional: Redimensionar si es muy grande para ahorrar memoria en Web
    // final resized = img.copyResize(originalImage, width: 1024);

    debugPrintLevels(7, "compressImageWeb processing...");

    // Comprimir a formato JPEG con calidad del 50%
    // encodeJpg devuelve Uint8List en versiones recientes de 'image'
    Uint8List compressedBytes = img.encodeJpg(originalImage, quality: 80);

    return compressedBytes;
  } catch (e) {
    debugPrintLevels(7, "Error en compressImageWeb: $e");
    // Si falla la compresión, devolvemos la original para no romper el flujo
    return imageBytes;
  }
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++

// 4. compress Uint8List and get another Uint8List.
// Compatible: Móvil, Web y Windows (con fallback)
Future<Uint8List> fotoCompressListWebP(Uint8List list, int compress) async {
  debugPrintLevels(0, "********* Future fotoCompressListWebP");
  debugPrintLevels(0, "fotoCompressList original size: ${list.length}");

  // FALLBACK PARA WINDOWS (El plugin nativo no soporta Windows usualmente)
  if (!kIsWeb && Platform.isWindows) {
    debugPrintLevels(0, "Detectado Windows: Usando Image Package Fallback");
    final image = img.decodeImage(list);
    if (image == null) return list;

    // Redimensionar para igualar la lógica (minWidth ~620)
    final resized = img.copyResize(image, width: 620);

    // Nota: encodeJpg es más rápido que encodeWebP en Dart puro,
    // pero si requieres WebP estricto usa encodeWebP (puede ser lento).
    // Usamos JPEG calidad 80 como fallback seguro y rápido.
    return img.encodeJpg(resized, quality: compress);
  }

  // Android, iOS y Web (si CanvasKit/Wasm está activo)
  var result = await FlutterImageCompress.compressWithList(
    list,
    minHeight: 480,
    minWidth: 620,
    quality: compress,
    format: CompressFormat.webp,
    rotate: 0,
  );

  debugPrintLevels(0, "fotoCompressList result size: ${result.length}");
  return result;
}

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//++++++++++++++++++++++++++++++++++++++++++++++++++++++
// COMPRESS FOR WINDOWS (Dart Puro)

Future<Uint8List> fotoCompressListWin(String imagePath) async {
  debugPrintLevels(0, "fotoCompressListWin START: $imagePath");

  final File file = File(imagePath);

  if (!file.existsSync()) {
    throw Exception("El archivo no existe: $imagePath");
  }

  final Uint8List bytes = await file.readAsBytes();

  // Decodificar la imagen usando el paquete 'image'
  final img.Image? image = img.decodeImage(bytes);

  if (image == null) {
    throw Exception("No se pudo decodificar la imagen.");
  }

  // Redimensionar la imagen (ancho máximo de 800 píxeles para optimizar)
  // Mantener el ratio de aspecto
  final img.Image resizedImage = img.copyResize(image, width: 800);

  // Codificar de nuevo a JPEG
  final Uint8List compressedBytes = img.encodeJpg(resizedImage, quality: 80);

  debugPrintLevels(
    0,
    "fotoCompressListWin END. New Size: ${compressedBytes.length}",
  );
  return compressedBytes;
}

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------

Future<Uint8List?> convertToWebP(Uint8List list, int compress) async {
  debugPrintLevels(7, 'convertToWebP START Original size: ${list.length}');

  // VALIDACIÓN WINDOWS
  if (!kIsWeb && Platform.isWindows) {
    // Reutilizamos la lógica pura de Dart para Windows
    return await fotoCompressListWebP(list, compress);
  }

  final result = await FlutterImageCompress.compressWithList(
    list,
    minHeight: 1080,
    minWidth: 1080,
    quality: compress,
    format: CompressFormat.webp,
  );

  debugPrintLevels(7, 'WebP size: ${result.length} bytes');
  return result;
}
// -------------------------------------------------------------------


/*
// 1. compress file and get Uint8List
Future<Uint8List?> testCompressFile(File file) async {
  var result = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    // minWidth: 2300,
    //minHeight: 1500,
    quality: 80,
    rotate: 0,
  );
  debugPrintLevels(0, "file: ${file.lengthSync()}");
  debugPrintLevels(0, "result: ${result?.length}");
  return result;
}

// 2. compress file and get file.
Future<XFile?> testCompressAndGetFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 80,
    rotate: 0,
  );
  debugPrintLevels(0, "original siza: ${file.lengthSync()}");
  debugPrintLevels(0, "result size: ${result?.length()}");

  return result;
}

// 3. compress asset and get Uint8List.
Future<Uint8List?> testCompressAsset(String assetName) async {
  var list = await FlutterImageCompress.compressAssetImage(
    assetName,
    minHeight: 1920,
    minWidth: 1080,
    quality: 80,
    rotate: 0,
  );

  return list;
}

// -----------------------------------------------------------
// IA
/// Comprime una imagen (JPEG o PNG) al 50% de calidad.
/// Compatible con Flutter Web.
///
/// [imageBytes]: datos binarios de la imagen original.
/// Retorna una nueva Uint8List con la imagen comprimida.
Future<Uint8List> compressImageWeb(Uint8List imageBytes) async {
  // Decodificar la imagen desde los bytes
  final originalImage = img.decodeImage(imageBytes);
  if (originalImage == null) {
    throw Exception('No se pudo decodificar la imagen.');
  }
  debugPrintLevels(
    7,
    "compressImageWeb originalImage: ${originalImage.format}.",
  );

  // Comprimir a formato JPEG con calidad del 50%
  Uint8List compressedBytes = img.encodeJpg(
    originalImage,
    quality: 50, // Nivel de compresión (0–100)
  );

  // Convertir la lista resultante a Uint8List
  return compressedBytes;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++
//++++++++++++++++++++++++++++++++++++++++++++++++++++++

// 4. compress Uint8List and get another Uint8List.
Future<Uint8List> fotoCompressListWebP(Uint8List list, int compress) async {
  debugPrintLevels(0, "********* Future fotoComporessList");

  debugPrintLevels(0, "fotoComporessList original siza: ${list.length}");

  var result = await FlutterImageCompress.compressWithList(
    list,
    minHeight: 480, // 1920, 620
    minWidth: 620, // 1080, 480
    quality: compress, // 80 RECOMENDABLE
    format: CompressFormat.webp, // Specify the target format
    rotate: 0,
  );
  debugPrintLevels(0, "fotoComporessList original siza: ${list.length}");
  debugPrintLevels(0, "fotoComporessList result size: ${result.length}");
  return result;
}

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//++++++++++++++++++++++++++++++++++++++++++++++++++++++
// COMPRESS FOR WINDOWS

Future<Uint8List> fotoCompressListWin(String imagePath) async {
  // Leer el archivo original desde la ruta
  final File file = File(imagePath);
  final Uint8List bytes = await file.readAsBytes();

  // Decodificar la imagen usando el paquete 'image'
  final img.Image? image = img.decodeImage(bytes);

  if (image == null) {
    throw Exception("No se pudo decodificar la imagen.");
  }

  // Redimensionar la imagen (ejemplo: ancho máximo de 800 píxeles)
  final img.Image resizedImage = img.copyResize(image, width: 800);

  // Codificar de nuevo a JPEG (ajusta la calidad si es necesario, 80 es un buen balance)
  final Uint8List compressedBytes = img.encodeJpg(resizedImage, quality: 80);

  return compressedBytes;
}
/*
Future<Uint8List> convertImageWinToWebP(String imagePath) async {
   // Leer el archivo original desde la ruta
  final File file = File(imagePath);
  final Uint8List inputBytes = await file.readAsBytes();

  // 1. Decodificar los bytes de entrada


  final image = img.decodeImage(inputBytes);

  // 2. Codificar a WebP (esto devuelve un Uint8List)
 // final webpBytes = img.encodeWebP(image, quality: 80); // 80 recomendable

  return webpBytes;
}

Future<void> fileCompressWin2WebP(String inputPath, String outputPath) async {
  // 1. Leer el archivo de imagen desde el disco
  final bytes = await File(inputPath).readAsBytes();

  // 2. Decodificar la imagen (detecta automáticamente el formato original)
  final image = img.decodeImage(bytes);

  if (image != null) {
    // 3. Codificar a formato WebP
    // Puedes ajustar la calidad de 0 a 100
  final webpBytes = img.encodeWebP(image, quality: 80);

    // 4. Guardar el resultado en Windows
    await File(outputPath).writeAsBytes(webpBytes);
    print('Conversión completada: $outputPath');
  }
  */
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------

Future<Uint8List?> convertToWebP(Uint8List list, int compress) async {
  final result = await FlutterImageCompress.compressWithList(
    list,
    minHeight: 1080, // Optional: specify min height = 1000
    minWidth: 1080, // Optional: specify min width = 1000
    quality: compress, // Adjust quality (0-100)
    format: CompressFormat.webp, // Specify the target format
  );
  debugPrintLevels(7, 'Original size: ${list.length} bytes');
  debugPrintLevels(7, 'WebP size: ${result.length} bytes');
  return result;
}
*/