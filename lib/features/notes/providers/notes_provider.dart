import 'package:flutter/material.dart';
import '../../../core/models/note.dart';

class NotesProvider with ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => _notes;

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }
}
