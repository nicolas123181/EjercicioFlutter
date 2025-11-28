import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/note.dart';
import '../data/notes_repository.dart';

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return NotesRepository();
});

final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(() {
  return NotesNotifier();
});

class NotesNotifier extends AsyncNotifier<List<Note>> {
  late final NotesRepository _repository;

  @override
  Future<List<Note>> build() async {
    _repository = ref.read(notesRepositoryProvider);
    return _fetchNotes();
  }

  Future<List<Note>> _fetchNotes() async {
    return await _repository.getNotes();
  }

  Future<void> addNote(String title, String content) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final note = Note(title: title, content: content);
      await _repository.addNote(note);
      return _fetchNotes();
    });
  }

  Future<void> updateNote(Note note) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.updateNote(note);
      return _fetchNotes();
    });
  }

  Future<void> deleteNote(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteNote(id);
      return _fetchNotes();
    });
  }
}
