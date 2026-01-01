import 'package:flutter/material.dart';
import 'package:to_do_app/viewmodel/home/note.viewmodel.dart';
import 'note_item_widget.dart';
import 'home_empty_state.dart';

class NoteGridView extends StatelessWidget {
  final NoteViewModel viewModel;
  final VoidCallback onRefresh;

  const NoteGridView({
    super.key,
    required this.viewModel,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final notes = viewModel.notes;

    if (notes.isEmpty) return const HomeEmptyState();

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.9,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return NoteItem(
          note: notes[index],
          viewModel: viewModel,
          onRefresh: onRefresh,
        );
      },
    );
  }
}
