import 'package:flutter/material.dart';
import 'package:to_do_app/data/model/note.dart';
import 'package:to_do_app/view/home/note_editor_screen.dart';
import 'package:to_do_app/viewmodel/home/note.viewmodel.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final NoteViewModel viewModel; // Added this
  final VoidCallback onRefresh; // Added this

  const NoteItem({
    super.key,
    required this.note,
    required this.viewModel,
    required this.onRefresh,
  });

  // Helper function for Delete Confirmation
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Note?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteNote(note.id);
              Navigator.pop(context);
              onRefresh(); // Refresh grid after delete
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onLongPress: () => _confirmDelete(context), // Swipe-less delete
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NoteEditorScreen(viewModel: viewModel, note: note),
          ),
        );
        // Refresh if the editor returned 'true' (saved/deleted)
        if (result == true) onRefresh();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Using theme surface for better consistency
          color: isDark ? theme.colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Expanded(
              // Use expanded to prevent overflow in fixed grid heights
              child: Text(
                note.content,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
