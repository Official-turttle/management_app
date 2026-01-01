import 'package:flutter/foundation.dart'; // Added for ChangeNotifier
import 'package:to_do_app/data/model/todo.dart';
import 'package:to_do_app/data/repository/todo_repo.dart';

class HomeViewModel extends ChangeNotifier {
  final TodoRepository _todoRepository = TodoRepository();

  // List<Todo> get todos => _todoRepository.todos;
  List<Todo> get todos {
    List<Todo> list = _todoRepository.todos;

    list.sort((a, b) {
      // 1. Sort by completion status (Incomplete first)
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      // 2. Then sort by priority (High = 2, Medium = 1, Low = 0)
      return b.priority.index.compareTo(a.priority.index);
    });

    return list;
  }

  // Load todos and then notify the UI to refresh
  Future<void> loadTodos() async {
    await _todoRepository.loadTodos();
    notifyListeners(); // Tells the UI the data is ready
  }

  // Updated to accept the new fields from our model
  void addTodo(
    String title, {
    String description = "",
    TodoPriority priority = TodoPriority.low,
  }) {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch
          .toString(), // Simple unique ID generation
      title: title,
      description: description,
      priority: priority,
    );

    _todoRepository.addTodo(newTodo);
    notifyListeners();
  }

  // We should toggle by ID or Object rather than Index for safer List manipulation
  void toggleTodoStatus(Todo todo) {
    todo.isCompleted = !todo.isCompleted;
    _todoRepository.updateTodo(
      todo,
    ); // Assuming you add an update method to your repo
    notifyListeners();
  }

  // Swipe-to-delete logic uses this
  void removeTodo(Todo todo) {
    _todoRepository.removeTodo(todo as String);
    notifyListeners();
  }

  // New Feature: Simple filtering
  List<Todo> get completedTodos => todos.where((t) => t.isCompleted).toList();
  List<Todo> get pendingTodos => todos.where((t) => !t.isCompleted).toList();
}
