import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  // TODO: Reemplaza esto con tu API Key real de Google AI Studio
  // Consíguela aquí: https://aistudio.google.com/app/apikey
  static const String _apiKey = 'AIzaSyBkyS4ueNW-6OS0PM8MgHGl2VbQ_3bIcKY';

  late final GenerativeModel _model;

  AiService() {
    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _apiKey);
  }

  Future<String> generateSummary(String text) async {
    if (text.isEmpty) return "El texto está vacío.";

    try {
      final prompt =
          '''Eres un especialista en síntesis de información. Tu tarea es extraer la idea principal del siguiente texto y condensarla en un resumen breve, conciso y profesional.

REQUISITOS DEL OUTPUT:
1.  Tu respuesta debe contener **solamente** el texto del resumen final.
2.  **Está estrictamente prohibido** presentar alternativas, opciones numeradas, listas, o cualquier tipo de preámbulo o justificación.
3.  Genera una **única versión final** del resumen.

TEXTO DE ENTRADA:\n\n$text''';
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
          '''Eres un editor de contenido profesional y debes optimizar la claridad, el tono y la gramática del texto de entrada.

INSTRUCCIONES CLAVE:
1.  Tu respuesta debe contener **solamente** el texto revisado y mejorado.
2.  **Prohibido** listar múltiples opciones, presentar el texto original, añadir introducciones o justificaciones.
3.  Selecciona y genera **una única versión final** que cumpla con los estándares de claridad y profesionalismo requeridos.

TEXTO A MEJORAR:\n\n$text''';
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? "No se pudo mejorar el texto.";
    } catch (e) {
      return "Error al conectar con Gemini: $e. \n\n¿Has puesto tu API Key en ai_service.dart?";
    }
  }
}
