import 'package:flutter/material.dart';

import '../models/task.dart';

/// Schermata di creazione di una nuova attività (S1).
///
/// Alla conferma restituisce la [Task] creata con `Navigator.pop`; se l'utente
/// torna indietro senza confermare, il risultato è `null`.
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  bool _isImportant = false;

  // Prima del primo tentativo di conferma non mostriamo errori; dopo, il campo
  // si rivalida a ogni modifica, così l'errore sparisce appena viene corretto.
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Il titolo è obbligatorio';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
      return;
    }
    Navigator.of(
      context,
    ).pop(Task(title: _titleController.text.trim(), isImportant: _isImportant));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuova attività')),
      body: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Titolo',
                hintText: 'Es. Comprare il pane',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit_note),
              ),
              validator: _validateTitle,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _isImportant,
              onChanged: (value) => setState(() => _isImportant = value),
              secondary: Icon(_isImportant ? Icons.star : Icons.star_border),
              title: const Text('Importante'),
              subtitle: const Text('Evidenzia l\'attività nell\'elenco'),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('Aggiungi attività'),
            ),
          ],
        ),
      ),
    );
  }
}
