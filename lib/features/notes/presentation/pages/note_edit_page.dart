import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/note.dart';
import '../../providers/notes_provider.dart';
import '../widgets/note_form.dart';

class NoteEditPage extends ConsumerWidget {
  final Note? note;

  const NoteEditPage({super.key, this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(note == null ? 'Nueva Nota' : 'Editar Nota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NoteForm(
          initialTitle: note?.title,
          initialContent: note?.content,
          onSave: (title, content) async {
            if (note == null) {
              await ref.read(notesProvider.notifier).addNote(title, content);
            } else {
              final updatedNote = note!.copyWith(
                title: title,
                content: content,
              );
              await ref.read(notesProvider.notifier).updateNote(updatedNote);
            }
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
