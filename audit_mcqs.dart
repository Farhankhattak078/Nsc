import 'dart:convert';
import 'dart:io';

void main() {
  final dir = Directory('assets/mcqs');
  final files = dir.listSync().where((f) => f.path.endsWith('.json'));
  
  final allQuestions = <String, List<String>>{}; // text -> filenames
  final counts = <String, int>{};

  for (final file in files) {
    if (file is File) {
      final content = file.readAsStringSync();
      try {
        final List<dynamic> json = jsonDecode(content);
        counts[file.path.split(Platform.pathSeparator).last] = json.length;
        
        for (var q in json) {
          final text = q['question'].toString().trim().toLowerCase();
          allQuestions.putIfAbsent(text, () => []).add(file.path.split(Platform.pathSeparator).last);
        }
      } catch (e) {
        print('Error parsing ${file.path}: $e');
      }
    }
  }

  print('\n--- QUESTION COUNTS ---');
  counts.forEach((file, count) => print('$file: $count'));

  print('\n--- DUPLICATES ACROSS FILES ---');
  var dupCount = 0;
  allQuestions.forEach((text, files) {
    if (files.length > 1) {
      print('Duplicate found in: ${files.join(', ')}');
      print('Question: ${text.substring(0, 50)}...\n');
      dupCount++;
    }
  });

  if (dupCount == 0) print('No duplicates found across files.');
}
