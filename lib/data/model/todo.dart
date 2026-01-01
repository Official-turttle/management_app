enum TodoPriority { low, medium, high }

class Todo {
  final String id; // Unique ID is better for list management
  String title;
  String description;
  bool isCompleted;
  TodoPriority priority;

  Todo({
    required this.id,
    required this.title,
    this.description = "",
    this.isCompleted = false,
    this.priority = TodoPriority.low,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority.index, // Save as integer
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'] ?? "",
      isCompleted: map['isCompleted'],
      priority: TodoPriority.values[map['priority'] ?? 0],
    );
  }
}
