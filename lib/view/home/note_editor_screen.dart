import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/components/ui/appBar.dart';
import 'package:to_do_app/data/model/note.dart';
import 'package:to_do_app/viewmodel/home/note.viewmodel.dart';

class NoteEditorScreen extends StatefulWidget {
  final NoteViewModel viewModel;
  final Note? note;

  const NoteEditorScreen({super.key, required this.viewModel, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final FocusNode _contentFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _contentController = TextEditingController(
      text: widget.note?.content ?? "",
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Note?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red,
              elevation: 0,
            ),
            onPressed: () {
              widget.viewModel.deleteNote(widget.note!.id);
              Navigator.pop(context);
              Navigator.pop(context, true); // Return to home
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _handleSave() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }

    if (widget.note != null) {
      widget.viewModel.updateNote(widget.note!.id, title, content);
    } else {
      widget.viewModel.addNote(title, content);
    }

    HapticFeedback.lightImpact();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: widget.note == null ? 'New Note' : 'Edit Note',
        extraActions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: _confirmDelete,
            ),
          IconButton(
            icon: const Icon(Icons.check_circle_outline, size: 28),
            onPressed: _handleSave,
          ),
        ],
      ),
      body: Container(
        // 1. Move the decoration here to cover the whole screen
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [theme.scaffoldBackgroundColor, theme.colorScheme.surface]
                : [
                    theme.primaryColor,
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.8),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Hero(
            tag: widget.note?.id ?? 'new_note_fab',
            child: Material(
              color: Colors.transparent, // Keeps the background visible
              child: Column(
                children: [
                  // Character Count Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: _contentController,
                          builder: (context, value, _) {
                            return Text(
                              "${value.text.length} characters",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isDark ? Colors.white70 : Colors.white,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        // This creates the "Sheet" effect for typing
                        color: isDark
                            ? Colors.white.withValues(alpha: .03)
                            : Colors.white.withValues(alpha: 0.9),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            TextField(
                              controller: _titleController,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              onSubmitted: (_) => _contentFocus.requestFocus(),
                              decoration: const InputDecoration(
                                hintText: "Title",
                                border: InputBorder.none,
                              ),
                            ),
                            const Divider(),
                            TextField(
                              controller: _contentController,
                              focusNode: _contentFocus,
                              maxLines: null,
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.6,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Type something...",
                                border: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
