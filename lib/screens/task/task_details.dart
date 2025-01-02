import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_buddy/main.dart';
import 'package:task_buddy/providers/task/task_provider.dart';
import '../../models/task/task_model.dart';

class TaskDetailsScreen extends ConsumerWidget {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    var taskId = (ModalRoute.of(context)?.settings.arguments as Task).id;

    var tasks = (ref
        .watch(taskNotifierProvider)
        .value!
        .where((task) => task.id == taskId)
        .toList());
    Task? task;
    if (tasks.isNotEmpty) {
      task = tasks.where((task) => task.id == taskId).toList().first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: tasks.isEmpty || task == null
          ? const Center(
              child: Text('No Details!'),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Title
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            // color: Theme.of(context).primaryColorLight,
                          ),
                    ),
                    const SizedBox(height: 20),

                    // Task Status
                    Row(
                      children: [
                        Icon(
                          task.isCompleted ? Icons.check_circle : Icons.pending,
                          color: task.isCompleted
                              ? (Theme.of(context).colorScheme.primary)
                              : Theme.of(context).colorScheme.secondary,
                          size: 30,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          task.isCompleted ? 'Completed' : 'Pending',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: task.isCompleted
                                        ? userSelectedColor
                                        : Theme.of(context).colorScheme.error,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Task Details
                    _buildSectionHeader(context, "Description"),
                    Text(
                      task.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),

                    // Priority
                    _buildSectionHeader(context, "Priority"),
                    Text(
                      task.priority.toString().split('.').last,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: utils.getPriorityColor(task.priority),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Schedule
                    _buildSectionHeader(context, "Schedule"),
                    _buildKeyValueRow("Start Time", task.startTime),
                    _buildKeyValueRow("End Time", task.endTime),
                    Text(
                      'Duration: ${utils.getDuration(startTime: task.startTime, endTime: task.endTime)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    // Category
                    _buildSectionHeader(context, "Category"),
                    Text(
                      task.category,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                    ),
                    const SizedBox(height: 20),

                    // Tags
                    _buildSectionHeader(context, "Tags"),
                    task.tags.isEmpty
                        ? Text(
                            'NA',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                          )
                        : Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: task.tags
                                .map<Widget>(
                                  (tag) => Chip(
                                    label: Text(tag),
                                    // backgroundColor: Colors.blue.shade100,
                                    // labelStyle: TextStyle(
                                    //   color: Colors.blue.shade900,
                                    //   fontWeight: FontWeight.w600,
                                    // ),
                                  ),
                                )
                                .toList(),
                          ),
                    const SizedBox(height: 20),

                    // Notes
                    if (task.notes != null) ...[
                      _buildSectionHeader(context, "Notes"),
                      task.notes!.isEmpty
                          ? Text(
                              'NA',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                            )
                          : Text(
                              task.notes!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                      const SizedBox(height: 20),
                    ],

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              '/add-update-task',
                              arguments: task,
                            ),
                            icon: const Icon(Icons.edit, color: Colors.white),
                            label: const Text("Edit Task"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showDeleteDialog(context, ref, task!);
                            },
                            icon: const Icon(Icons.delete, color: Colors.white),
                            label: const Text("Delete Task"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Task Image for Larger Screens
                    if (screenWidth > 600)
                      Center(
                        child: Image.asset(
                          'assets/task_image.png',
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildKeyValueRow(String key, DateTime value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$key: ",
            style: Theme.of(navigatorKey.currentContext!)
                .textTheme
                .bodyMedium
                ?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            value.toLocal().toString().split(' ')[0],
            style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Handle deletion
                await ref
                    .read(taskNotifierProvider.notifier)
                    .deleteTask(task.id);
                Navigator.pop(navigatorKey.currentContext!);
                Navigator.pop(navigatorKey.currentContext!);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
