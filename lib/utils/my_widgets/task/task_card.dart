import 'package:flutter/material.dart';
import 'package:task_buddy/main.dart';
import '../../../models/task/task_model.dart';

// Card Widget to show each task
class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '/task-details',
        arguments: task,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(task.priority),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.priority.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                task.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Align the text to the start
                    children: [
                      Text(
                        "Start: ${utils.formatDateTime(task.startTime)}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "End: ${utils.formatDateTime(task.endTime)}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.category, size: 16),
                  const SizedBox(width: 4),
                  Text(task.category, style: const TextStyle(fontSize: 12)),
                  const Spacer(),
                  task.tags.isEmpty
                      ? const SizedBox()
                      : Wrap(
                          spacing: 6,
                          children: task.tags
                              .take(3) // Display first 3 tags
                              .map((tag) => Chip(
                                    label: Text(
                                      tag,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ))
                              .toList(),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    final theme = Theme.of(navigatorKey.currentContext!); // Access the current theme

    switch (priority) {
      case TaskPriority.low:
        return theme.primaryColorLight; // Low priority color from theme
      case TaskPriority.medium:
        return theme.primaryColorDark; // Medium priority color from theme
      case TaskPriority.high:
        return theme.primaryColor; // High priority color from theme
      default:
        return Colors.grey; // Default color
    }
  }

}
