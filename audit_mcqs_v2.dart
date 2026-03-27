import 'dart:convert';
import 'dart:io';

void main() {
  final dir = Directory('assets/mcqs');
  final files = dir.listSync().where((f) => f.path.endsWith('.json'));
  
  final allQuestions = <String, List<String>>{}; // text -> filenames
  final counts = <String, int>{};
  final report = StringBuffer();

  for (final file in files) {
    if (file is File) {
      final content = file.readAsStringSync();
      try {
        final List<dynamic> json = jsonDecode(content);
        final fileName = file.path.split(Platform.pathSeparator).last;
        counts[fileName] = json.length;
        
        for (var q in json) {
          final text = q['question'].toString().trim().toLowerCase();
          allQuestions.putIfAbsent(text, () => []).add(fileName);
        }
      } catch (e) {
        report.writeln('Error parsing ${file.path}: $e');
      }
    }
  }

  report.writeln('\n--- QUESTION COUNTS ---');
  counts.forEach((file, count) => report.writeln('$file: $count'));

  report.writeln('\n--- DUPLICATES ACROSS FILES ---');
  var dupCount = 0;
  allQuestions.forEach((text, files) {
    if (files.length > 1) {
      report.writeln('Duplicate found in: ${files.join(', ')}');
      report.writeln('Question: ${text.length > 50 ? text.substring(0, 50) : text}...\n');
      dupCount++;
    }
  });

  if (dupCount == 0) report.writeln('No duplicates found across files.');
  
  File('audit_report.txt').writeAsStringSync(report.toString());
  print('Audit report saved to audit_report.txt');
}
