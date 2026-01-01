import 'package:flutter/material.dart';
import '../../data/model/todo.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final Function(String title, String desc, TodoPriority priority) onSave;

  const AddTaskBottomSheet({super.key, required this.onSave});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  TodoPriority _selectedPriority = TodoPriority.low;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "New Task",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              hintText: "Description (Optional)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Priority", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: TodoPriority.values.map((priority) {
              return ChoiceChip(
                label: Text(priority.name.toUpperCase()),
                selected: _selectedPriority == priority,
                onSelected: (selected) {
                  setState(() => _selectedPriority = priority);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              onPressed: () {
                widget.onSave(
                  _titleController.text,
                  _descController.text,
                  _selectedPriority,
                );
                Navigator.pop(context);
              },
              child: const Text("Create Task"),
            ),
          ),
        ],
      ),
    );
  }
}
