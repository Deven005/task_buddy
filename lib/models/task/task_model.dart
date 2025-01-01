enum TaskPriority { low, medium, high }

extension TaskPriorityExtension on TaskPriority {
  // Capitalizes the first letter of the priority string
  String get name {
    String priorityName = toString().split('.').last;
    if (priorityName.isEmpty) return priorityName;
    return priorityName[0].toUpperCase() + priorityName.substring(1);
  }
}

class Task {
  int id; // Unique identifier
  final String title; // Task title
  final String description; // Task description
  final DateTime startTime; // Start time of the task
  final DateTime endTime; // End time of the task
  final TaskPriority priority; // Task priority
  final bool isCompleted; // Completion status
  final String category; // Category of the task
  final List<String> tags; // Tags for the task
  final String? notes; // Optional notes
  final DateTime createdAt; // Task creation time
  final DateTime updatedAt; // Task last updated time

  Task({
    this.id = 0,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.priority,
    this.isCompleted = false,
    this.category = "General",
    this.tags = const [],
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// CopyWith method to create a new instance of Task with updated fields
  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    TaskPriority? priority,
    bool? isCompleted,
    String? category,
    List<String>? tags,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert Task object to a map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'priority': priority.toString(),
      'isCompleted': isCompleted ? 1 : 0,
      'category': category,
      'tags': tags.join(','), // Store tags as a comma-separated string
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Convert a map to a Task object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      priority: TaskPriority.values.firstWhere(
          (e) => e.toString() == map['priority'],
          orElse: () => TaskPriority.low),
      isCompleted: map['isCompleted'] == 1,
      category: map['category'],
      tags: map['tags'].split(','),
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
