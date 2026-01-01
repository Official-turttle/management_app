import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/data/model/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  // Helper to get priority color
  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return Colors.redAccent;
      case TodoPriority.medium:
        return Colors.orangeAccent;
      case TodoPriority.low:
        return Colors.blueAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the current theme colors
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          // Use theme surface color instead of hardcoded white
          color: todo.isCompleted
              ? (isDark ? Colors.white10 : Colors.grey[50])
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: todo.isCompleted
                ? Colors.transparent
                : (isDark ? Colors.white12 : Colors.grey.shade200),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onToggle();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: todo.isCompleted ? Colors.green : Colors.transparent,
                border: Border.all(
                  color: todo.isCompleted ? Colors.green : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(
                  Icons.check,
                  size: 20,
                  color: todo.isCompleted ? Colors.white : Colors.transparent,
                ),
              ),
            ),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              // Dynamically choose text color
              color: todo.isCompleted
                  ? Colors.grey
                  : (isDark ? Colors.white : Colors.black87),
            ),
          ),
          subtitle: todo.description.isNotEmpty
              ? Text(
                  todo.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                )
              : null,
          trailing: Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: _getPriorityColor(todo.priority),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
