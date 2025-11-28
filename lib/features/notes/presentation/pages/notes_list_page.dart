import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/notes_provider.dart';
import '../widgets/note_item.dart';
import 'note_edit_page.dart';

class NotesListPage extends ConsumerWidget {
  const NotesListPage({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('NotesListPage: build called');
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Notas')),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const Center(child: Text('No hay notas. ¡Crea una!'));
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteItem(
                note: note,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteEditPage(note: note),
                    ),
                  );
                },
                onDelete: () {
                  ref.read(notesProvider.notifier).deleteNote(note.id!);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteEditPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
