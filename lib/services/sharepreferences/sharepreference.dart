import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  Future<void> saveTodoList(List<Map<String, dynamic>> todos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'todos',
      todos.map((todo) => todo.toString()).toList(),
    );
  }

  Future<List<Map<String, dynamic>>> getTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedTodos = prefs.getStringList('todos');
    if (savedTodos != null) {
      return savedTodos
          .map(
            (todo) => Map<String, dynamic>.from(todo as Map<dynamic, dynamic>),
          )
          .toList();
    }
    return [];
  }
}
