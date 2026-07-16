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

  final Map<String, List<String>> imports = {};

  for (final file in allFiles) {
    final content = file.readAsStringSync();
    final fileImports = <String>[];
    for (final otherFile in allFiles) {
      if (file.path == otherFile.path) continue;
      final filename = otherFile.uri.pathSegments.last;
      if (content.contains(filename)) {
        fileImports.add(otherFile.path);
      }
    }
    imports[file.path] = fileImports;
  }

  // Files that are roots (like main.dart)
  final reachableFiles = <String>{};
  
  // Find main.dart
  String? mainFile;
  for (final file in allFiles) {
    if (file.path.replaceAll('\\', '/').endsWith('lib/main.dart')) {
      mainFile = file.path;
      break;
    }
  }

  if (mainFile == null) {
    print('main.dart not found in lib.');
    return;
  }

  void traverse(String currentFile) {
    if (reachableFiles.contains(currentFile)) return;
    reachableFiles.add(currentFile);
    for (final imported in imports[currentFile] ?? []) {
      traverse(imported);
    }
  }

  traverse(mainFile);

  final unusedFiles = allFiles
      .map((f) => f.path)
      .where((path) => !reachableFiles.contains(path))
      .toList();

  if (unusedFiles.isEmpty) {
    print('No unused files found.');
  } else {
    for (final file in unusedFiles) {
      print(file);
    }
  }
}
