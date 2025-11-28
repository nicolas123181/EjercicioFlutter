import '../../../core/database/note_dao.dart';
import '../../../core/models/note.dart';

class NotesRepository {
  final NoteDao _noteDao;

  NotesRepository({NoteDao? noteDao}) : _noteDao = noteDao ?? NoteDao();

  Future<List<Note>> getNotes() async {
    return await _noteDao.readAllNotes();
  }

  Future<Note> addNote(Note note) async {
    return await _noteDao.create(note);
  }

  Future<int> updateNote(Note note) async {
    return await _noteDao.update(note);
  }

  Future<int> deleteNote(int id) async {
    return await _noteDao.delete(id);
  }
}
