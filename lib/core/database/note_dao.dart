import 'package:sqflite/sqflite.dart';
import '../models/note.dart';
import 'app_database.dart';

class NoteDao {
  final AppDatabase _appDatabase = AppDatabase.instance;

  Future<Note> create(Note note) async {
    final db = await _appDatabase.database;
    final id = await db.insert('notes', note.toMap());
    return note.copyWith(id: id);
  }

  Future<Note?> read(int id) async {
    final db = await _appDatabase.database;
    final maps = await db.query(
      'notes',
      columns: ['id', 'title', 'content'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await _appDatabase.database;
    final orderBy = 'id ASC';
    final result = await db.query('notes', orderBy: orderBy);

    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await _appDatabase.database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _appDatabase.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
