import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() async {
  final apiKey = 'AIzaSyBkyS4ueNW-6OS0PM8MgHGl2VbQ_3bIcKY';
  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey',
  );

  try {
    print('Querying $url...');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Available models:');
      if (data['models'] != null) {
        final file = File('models.txt');
        if (file.existsSync()) {
          file.deleteSync();
        }
        for (var model in data['models']) {
          final methods = List<String>.from(
            model['supportedGenerationMethods'] ?? [],
          );
          final name = model['name'].toString();
          if (methods.contains('generateContent') && name.contains('gemini')) {
            print('FOUND: $name');
            file.writeAsStringSync('$name\n', mode: FileMode.append);
          }
        }
      } else {
        print('No models found in response.');
      }
    } else {
      print('Failed to list models. Status code: ${response.statusCode}');
      print('Body: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
