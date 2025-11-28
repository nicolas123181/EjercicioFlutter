import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/notes/presentation/pages/notes_list_page.dart';
import '../config/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Mini Bloc de Notas',
        theme: AppTheme.lightTheme,
        home: const NotesListPage(),
      ),
    );
  }
}
