import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/todo.dart';

class TodoRepository {
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedTodos = prefs.getString('todos');
    if (savedTodos != null) {
      final List<dynamic> todoList = json.decode(savedTodos);
      _todos = todoList.map((todo) => Todo.fromMap(todo)).toList();
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedTodos = json.encode(
      _todos.map((todo) => todo.toMap()).toList(),
    );
    await prefs.setString('todos', encodedTodos);
  }

  // Pass the whole object now
  void addTodo(Todo todo) {
    _todos.insert(0, todo); // Newest at the top
    _saveTodos();
  }

  void updateTodo(Todo todo) {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      _saveTodos();
    }
  }

  void removeTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    _saveTodos();
  }
}
