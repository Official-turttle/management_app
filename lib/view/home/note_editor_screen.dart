import 'package:flutter/material.dart';
import 'package:to_do_app/components/ui/appBar.dart';
import 'package:to_do_app/data/model/note.dart';
import '../../viewmodel/home/note.viewmodel.dart';

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

  @override
  void initState() {
    super.initState();
    // Pre-fill controllers if an existing note is passed for editing
    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _contentController = TextEditingController(
      text: widget.note?.content ?? "",
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }

    if (widget.note == null) {
      // Logic for NEW note
      widget.viewModel.addNote(title, content);
    } else {
      // Logic for EDITING existing note
      widget.viewModel.updateNote(widget.note!.id, title, content);
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      appBar: CustomAppBar(
        // Dynamic Title
        title: widget.note == null ? 'New Note' : 'Edit Note',
        extraActions: [
          // DELETE ACTION (Only shows if editing)
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () {
                widget.viewModel.deleteNote(widget.note!.id);
                Navigator.pop(context, true);
              },
            ),
          IconButton(icon: const Icon(Icons.check), onPressed: _handleSave),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                style: TextStyle(
                  fontSize: 18,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                decoration: const InputDecoration(
                  hintText: "Start writing your thoughts...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
