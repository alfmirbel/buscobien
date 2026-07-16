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

  final allContents = <String, String>{};
  for (final file in allFiles) {
    allContents[file.path] = file.readAsStringSync();
  }

  final unusedFiles = <String>[];

  for (final targetFile in allFiles) {
    // Check if the filename is mentioned in any other file
    final filename = targetFile.uri.pathSegments.last;
    if (filename == 'main.dart') continue; // Entry point
    
    // Ignore some files? No, just check if imported
    bool isUsed = false;
    for (final otherFile in allFiles) {
      if (otherFile.path == targetFile.path) continue;
      
      final content = allContents[otherFile.path]!;
      // Checking if filename is included in any other file.
      // This covers imports like import 'pages/my_page.dart';
      if (content.contains(filename)) {
        isUsed = true;
        break;
      }
    }
    
    if (!isUsed) {
      unusedFiles.add(targetFile.path);
    }
  }

  if (unusedFiles.isEmpty) {
    print('No unused files found.');
  } else {
    for (final file in unusedFiles) {
      print(file);
    }
  }
}
