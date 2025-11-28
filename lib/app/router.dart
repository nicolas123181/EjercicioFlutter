import 'package:flutter/material.dart';
import '../features/notes/presentation/pages/notes_list_page.dart';
import '../features/notes/presentation/pages/note_edit_page.dart';

class AppRouter {
  static const String home = '/';
  static const String editNote = '/edit-note';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const NotesListPage());
      case editNote:
        return MaterialPageRoute(builder: (_) => const NoteEditPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
