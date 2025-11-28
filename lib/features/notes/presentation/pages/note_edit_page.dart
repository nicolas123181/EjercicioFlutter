import 'package:flutter/material.dart';

class NoteEditPage extends StatelessWidget {
  const NoteEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Note')),
      body: const Center(child: Text('Edit Note Form')),
    );
  }
}
