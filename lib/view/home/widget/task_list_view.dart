import 'package:flutter/material.dart';
import 'package:to_do_app/components/ui/input.dart';
import 'package:to_do_app/view/home/widget/home_empty_state.dart';
import 'package:to_do_app/view/home/widget/home_summary_card.dart';
import 'package:to_do_app/view/home/widget/todo.item.widget.dart';
import 'package:to_do_app/viewmodel/home/home.viewmodel.dart';

class TaskListView extends StatelessWidget {
  final HomeViewModel viewModel;
  final VoidCallback onRefresh;

  const TaskListView({
    super.key,
    required this.viewModel,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. Progress Summary Dashboard
        HomeSummaryCard(
          totalTasks: viewModel.todos.length,
          completedTasks: viewModel.completedTodos.length,
        ),

        // 2. Quick Input Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: InputField(
            onSubmit: (value) {
              if (value.isNotEmpty) {
                viewModel.addTodo(value);
                onRefresh(); // Trigger UI update in parent
              }
            },
          ),
        ),

        // 3. Scrollable List of Tasks
        Expanded(
          child: viewModel.todos.isEmpty
              ? const HomeEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 100),
                  itemCount: viewModel.todos.length,
                  itemBuilder: (context, index) {
                    final todo = viewModel.todos[index];
                    return TodoItem(
                      todo: todo,
                      onToggle: () {
                        viewModel.toggleTodoStatus(todo);
                        onRefresh();
                      },
                      onDelete: () {
                        viewModel.removeTodo(todo);
                        onRefresh();
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
