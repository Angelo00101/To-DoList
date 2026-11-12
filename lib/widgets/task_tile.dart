import 'package:flutter/material.dart';

import '../models/task.dart';

/// Riga dell'elenco: mostra titolo, stato e importanza di un'attività.
/// Toccare la riga (o la casella) cambia lo stato; il cestino la elimina.
class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onToggleDone,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggleDone;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListTile(
      onTap: onToggleDone,
      leading: Checkbox(value: task.isDone, onChanged: (_) => onToggleDone()),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isDone ? TextDecoration.lineThrough : null,
          color: task.isDone ? scheme.onSurfaceVariant : null,
          fontWeight: task.isImportant ? FontWeight.w600 : null,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            _Badge(
              label: task.isDone ? 'Completata' : 'Da fare',
              icon: task.isDone
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              background: task.isDone
                  ? scheme.primaryContainer
                  : scheme.surfaceContainerHighest,
              foreground: task.isDone
                  ? scheme.onPrimaryContainer
                  : scheme.onSurfaceVariant,
            ),
            if (task.isImportant)
              _Badge(
                label: 'Importante',
                icon: Icons.star,
                background: scheme.tertiaryContainer,
                foreground: scheme.onTertiaryContainer,
              ),
          ],
        ),
      ),
      trailing: IconButton(
        tooltip: 'Elimina',
        icon: const Icon(Icons.delete_outline),
        onPressed: onDelete,
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
