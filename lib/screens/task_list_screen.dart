import 'package:flutter/material.dart';

import '../models/task.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';

/// Schermata principale: elenco delle attività (S2), aggiornamento dello
/// stato (S3), eliminazione (S4) e punto di partenza della creazione (S1).
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];

  int get _completedCount => _tasks.where((t) => t.isDone).length;

  // S1 – Aggiungere un'attività.
  Future<void> _openAddTask() async {
    final newTask = await Navigator.of(context)
        .push<Task>(MaterialPageRoute(builder: (_) => const AddTaskScreen()));

    // Rinuncia (es. tasto indietro): nessuna attività, nessun messaggio.
    if (newTask == null || !mounted) return;

    setState(() => _tasks.add(newTask));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Attività "${newTask.title}" aggiunta')),
      );
  }

  // S3 – Aggiornare lo stato di un'attività.
  void _toggleDone(Task task) {
    setState(task.toggleDone);
  }

  // S4 – Eliminare un'attività, previa conferma.
  Future<void> _confirmDelete(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.delete_outline),
        title: const Text('Eliminare l\'attività?'),
        content: Text('"${task.title}" verrà rimossa definitivamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _tasks.remove(task));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Le mie attività'),
        bottom: _tasks.isEmpty
            ? null
            : _ProgressHeader(completed: _completedCount, total: _tasks.length),
      ),
      body: _tasks.isEmpty
          ? const _EmptyState()
          : ListView.separated(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: _tasks.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return TaskTile(
                  key: ValueKey(task.id),
                  task: task,
                  onToggleDone: () => _toggleDone(task),
                  onDelete: () => _confirmDelete(task),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTask,
        icon: const Icon(Icons.add),
        label: const Text('Nuova attività'),
      ),
    );
  }
}

/// Conteggio delle attività completate sul totale, con barra di avanzamento.
class _ProgressHeader extends StatelessWidget implements PreferredSizeWidget {
  const _ProgressHeader({required this.completed, required this.total});

  final int completed;
  final int total;

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$completed di $total completate',
            key: const Key('completed-counter'),
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: completed / total,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

/// Variante S2 "nessuna attività": indica come aggiungerne una.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.checklist_rounded,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('Nessuna attività', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Tocca "Nuova attività" in basso a destra per aggiungerne una.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
