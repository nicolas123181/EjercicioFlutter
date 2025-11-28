import 'package:flutter/material.dart';
import '../../../../core/services/ai_service.dart';

class NoteForm extends StatefulWidget {
  final String? initialTitle;
  final String? initialContent;
  final Function(String title, String content) onSave;

  const NoteForm({
    super.key,
    this.initialTitle,
    this.initialContent,
    required this.onSave,
  });

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();
  final _aiService = AiService();
  bool _isAiLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _generateAiContent(bool isSummary) async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe algo primero para usar la IA')),
      );
      return;
    }

    setState(() => _isAiLoading = true);
    try {
      final result = isSummary
          ? await _aiService.generateSummary(_contentController.text)
          : await _aiService.improveText(_contentController.text);

      if (mounted) {
        _contentController.text = result;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contenido actualizado por IA')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error de IA: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isAiLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Título'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa un título';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _contentController,
            decoration: const InputDecoration(labelText: 'Contenido'),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa contenido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          if (_isAiLoading)
            const CircularProgressIndicator()
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _generateAiContent(true),
                  icon: const Icon(Icons.summarize),
                  label: const Text('Resumir (IA)'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _generateAiContent(false),
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text('Mejorar (IA)'),
                ),
              ],
            ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSave(_titleController.text, _contentController.text);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
