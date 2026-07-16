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
      .where((f) => f.path.endsWith('.dart') || f.path.endsWith('.json'))
      .toList();

  final Map<String, Set<String>> dbToFiles = {};
  
  // Regex to find things that look like buscobien_database
  final RegExp dbRegex = RegExp(r"(buscobien_[a-zA-Z0-9_]+)");

  for (final file in allFiles) {
    final content = file.readAsStringSync();
    final matches = dbRegex.allMatches(content);
    for (final match in matches) {
      final dbName = match.group(1)!;
      // Filter out variables that happen to start with buscobien_ 
      // but usually the DB names are exactly 'buscobien_...'
      if (!dbToFiles.containsKey(dbName)) {
        dbToFiles[dbName] = {};
      }
      dbToFiles[dbName]!.add(file.path);
    }
  }

  print('# Bases de Datos de CouchDB Utilizadas');
  print('');
  dbToFiles.forEach((db, files) {
    print('## `$db`');
    for (final file in files) {
      print('- `$file`');
    }
    print('');
  });
}
