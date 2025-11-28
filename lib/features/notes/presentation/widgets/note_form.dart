import 'package:flutter/material.dart';

class NoteForm extends StatelessWidget {
  const NoteForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(decoration: const InputDecoration(labelText: 'Title')),
        TextFormField(decoration: const InputDecoration(labelText: 'Content')),
      ],
    );
  }
}
