import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

Uint8List emptyBytes = Uint8List(0);

class PlatformFileNoFinal {
  String path;
  String name;
  int size;
  Uint8List? bytes;
  Stream<List<int>>? readStream;
  String? identifier;

  PlatformFileNoFinal({
    this.path = "",
    this.name = "",
    this.size = 0,
    this.bytes,
    this.readStream =
        const Stream.empty(), // Stream.empty() Stream.fromIterable([])
    this.identifier = "",
  });
}

void copiaPlatformFile2NoFinal(
    PlatformFileNoFinal platformFile, PlatformFile result) {
  platformFile.path = result.path!;
  platformFile.name = result.name;
  platformFile.size = result.size;
  platformFile.bytes = result.bytes!;
  platformFile.readStream = result.readStream!;
  platformFile.identifier = result.identifier!;
}
