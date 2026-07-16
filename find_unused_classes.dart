import 'dart:io';

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('lib directory not found.');
    return;
  }

  final allFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  final targetDir = Directory('lib/08_pantallas');
  if (!targetDir.existsSync()) {
    print('Target directory not found.');
    return;
  }

  final targetFiles = targetDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  final RegExp declRegex = RegExp(r'\b(?:class|enum|mixin|extension)\s+([A-Za-z0-9_]+)');

  final unusedFiles = <String>[];
  final fileUnusedElements = <String, List<String>>{};

  for (final file in targetFiles) {
    final content = file.readAsStringSync();
    final matches = declRegex.allMatches(content);
    final elements = matches.map((m) => m.group(1)!).toList();

    elements.removeWhere((e) => e.startsWith('_'));
    
    if (elements.isEmpty) {
      continue;
    }

    bool fileHasUsedElement = false;
    final unusedElementsInFile = <String>[];

    for (final element in elements) {
      bool isUsed = false;
      for (final otherFile in allFiles) {
        if (otherFile.absolute.path == file.absolute.path) continue;
        
        final otherContent = otherFile.readAsStringSync();
        final RegExp usageRegex = RegExp('\\b$element\\b');
        if (usageRegex.hasMatch(otherContent)) {
          isUsed = true;
          break;
        }
      }
      
      if (isUsed) {
        fileHasUsedElement = true;
      } else {
        unusedElementsInFile.add(element);
      }
    }

    if (!fileHasUsedElement) {
      unusedFiles.add(file.path);
    }
    
    if (unusedElementsInFile.isNotEmpty) {
      fileUnusedElements[file.path] = unusedElementsInFile;
    }
  }

  print('--- Archivos en 08_pantallas completamente sin usar (ninguna de sus clases se usa en otro lado) ---');
  if (unusedFiles.isEmpty) {
    print('Ninguno encontrado.');
  } else {
    for (final file in unusedFiles) {
      print(file);
    }
  }

  print('\n--- Clases/Enums/Widgets específicos sin usar en 08_pantallas ---');
  bool anyUnused = false;
  fileUnusedElements.forEach((file, elements) {
    print('$file: ${elements.join(', ')}');
    anyUnused = true;
  });
  if (!anyUnused) print('Ninguno encontrado.');
}
