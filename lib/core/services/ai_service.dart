import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  // TODO: Reemplaza esto con tu API Key real de Google AI Studio
  // Consíguela aquí: https://aistudio.google.com/app/apikey
  static const String _apiKey = 'AIzaSyBmomnysJzFIrqBr7e-47G4UC00ziiAZx8';

  late final GenerativeModel _model;

  AiService() {
    _model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
  }

  Future<String> generateSummary(String text) async {
    if (text.isEmpty) return "El texto está vacío.";

    try {
      final prompt = 'Resume el siguiente texto de manera concisa:\n\n$text';
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? "No se pudo generar el resumen.";
    } catch (e) {
      return "Error al conectar con Gemini: $e. \n\n¿Has puesto tu API Key en ai_service.dart?";
    }
  }

  Future<String> improveText(String text) async {
    if (text.isEmpty) return "El texto está vacío.";

    try {
      final prompt =
          'Mejora la redacción del siguiente texto para que sea más claro y profesional:\n\n$text';
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? "No se pudo mejorar el texto.";
    } catch (e) {
      return "Error al conectar con Gemini: $e. \n\n¿Has puesto tu API Key en ai_service.dart?";
    }
  }
}
