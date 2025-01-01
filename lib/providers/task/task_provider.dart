import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:task_buddy/main.dart';
import 'package:task_buddy/utils/database/database_helper.dart';
import '../../models/task/task_model.dart';
import '../../service/notification/notification_service.dart';

part 'task_provider.g.dart';

// command to run for auto-update changes: dart run build_runner watch

final db = DatabaseHelper.instance;

@riverpod
class TaskNotifier extends _$TaskNotifier {
  @override
  FutureOr<List<Task>> build() async {
    return (await db.getTasks())
        .toList(); // Fetch tasks from the global DatabaseHelper instance
  }

  Future<void> addTask(Task task) async {
    int id = await db
        .addTask(task); // Add the task using the global DatabaseHelper instance
    task.id = id;
    final currentState =
        state.value ?? []; // Get current task list or an empty list if none
    state = AsyncData([
      ...currentState,
      task
    ]); // Append the new task to the current list and update state
    utils.showSnackBar('Task is added!');

    if (!task.isCompleted) {
      // Schedule the notification
      NotificationService.scheduleNotification(
        task.id,
        'Task Reminder',
        'Your task "${task.title}" is starting in 5 minutes.',
        task.startTime.subtract(const Duration(minutes: 5)),
      );
    }
  }

  Future<void> updateTask(Task task, DateTime oldStartTime) async {
    try {
      await db.updateTask(
          task); // Update the task using the global DatabaseHelper instance
      final currentState =
          state.value ?? []; // Get current task list or an empty list if none
      // Find the index of the task to update
      final taskIndex = currentState.indexWhere((t) => t.id == task.id);

      if (taskIndex != -1) {
        // Replace the old task with the updated one
        currentState[taskIndex] = task;
      }
      debugPrint('task update: ${task.priority}');
      // Update the state with the modified task list
      state = AsyncData(List.from(currentState));
      utils.showSnackBar('Task is Updated!');

      try {
        if (!task.isCompleted &&
            task.startTime != oldStartTime &&
            task.startTime
                .subtract(const Duration(minutes: 5))
                .isAfter(DateTime.now())) {
          debugPrint('Notification is updated after task!');
          await NotificationService.flutterLocalNotificationsPlugin.cancel(task.id);
          await NotificationService.scheduleNotification(
            task.id,
            'Task Reminder',
            'Your task "${task.title}" is starting in 5 minutes.',
            task.startTime.subtract(const Duration(minutes: 5)),
          );
          utils.showSnackBar('Notification is scheduled!');
        } else {
          utils.showSnackBar('Notification is not scheduled!');
        }
      } catch (e) {
        debugPrint(
            'updateTask NotificationService.scheduleNotification catch: $e');
        utils.showSnackBar('Error: $e');
        rethrow;
      }
    } catch (e) {
      debugPrint('updateTask catch: $e');
      utils.showSnackBar('Error: $e');
      rethrow;
    }
  }

  Future<void> refreshTasks() async {
    state = const AsyncLoading(); // Set state to loading
    state =
        AsyncData(await db.getTasks()); // Fetch tasks again and update state
  }

  // Delete a task by ID
  Future<void> deleteTask(int id) async {
    try {
      await db.deleteTask(id);
      await refreshTasks();
      utils.showSnackBar('Task is deleted!');
    } catch (e, s) {
      debugPrint('err: $e | $s');
      utils.showSnackBar('Error while deleting task!');
    }
  }
}
