import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_buddy/main.dart';
import 'package:task_buddy/providers/app/app_settings_provider.dart';
import 'package:task_buddy/providers/task/task_provider.dart';
import 'package:task_buddy/utils/utils.dart';
import '../../utils/my_widgets/task/task_card.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  String _searchQuery = ''; // Variable to store search query
  List<String> sortByList = ['title', 'startTime', 'priority'];
  String _sortBy =
      'title'; // Sorting criteria (can be 'title', 'startTime', or 'priority')
  final FocusNode _focusNode = FocusNode(); // FocusNode for the search bar

  @override
  Widget build(BuildContext context) {
    final taskListAsync = ref.watch(taskNotifierProvider);

    return GestureDetector(
      onTap: () {
        if (_focusNode.hasFocus) {
          _focusNode.unfocus(); // Unfocus the search bar
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: _buildSearchBar(),
          actions: [
            // Sort Button
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: _showSortDialog,
            ),
          ],
        ),
        body: taskListAsync.when(
          data: (tasks) {
            // Filter tasks based on search query
            if (_searchQuery.isNotEmpty) {
              tasks = tasks
                  .where((task) => task.title
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()))
                  .toList();
            }

            // Sort tasks based on criteria
            if (_sortBy == 'title') {
              tasks.sort((a, b) => a.title.compareTo(b.title));
            } else if (_sortBy == 'startTime') {
              tasks.sort((a, b) => a.startTime.compareTo(b.startTime));
            } else if (_sortBy == 'priority') {
              tasks.sort((a, b) => utils
                  .priorityValue(b.priority.name.toLowerCase())
                  .compareTo(
                      utils.priorityValue(a.priority.name.toLowerCase())));
            }

            return tasks.isEmpty
                ? const Center(
                    child: Text(
                      "No tasks available.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TaskCard(task: tasks[index]),
                    ),
                  );
          },
          error: (err, stack) => Center(
            child: Text('Error: $err'),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        floatingActionButton: Opacity(
          opacity: 0.7,
          child: FloatingActionButton(
            tooltip: 'Add new task!',
            onPressed: () => Navigator.pushNamed(
                navigatorKey.currentContext!, '/add-update-task'),
            foregroundColor: Colors.white,
            child: const Icon(Icons.add_outlined),
          ),
        ),
      ),
    );
  }

  // Builds the search bar for the AppBar
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      child: TextField(
        focusNode: _focusNode,
        // Assign focusNode to the search bar
        autofocus: false,
        decoration: const InputDecoration(
          hintText: 'Search tasks...',
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
      ),
    );
  }

  // Show sort dialog
  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Tasks'),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: sortByList
                .map(
                  (e) => ListTile(
                    title: Text('Sort by ${e.capitalizeFirst}'),
                    onTap: () async {
                      try {
                        await ref
                            .read(appSettingsNotifierProvider.notifier)
                            .updateSelectedSortBY(e);
                        setState(() {
                          _sortBy = e;
                        });
                        Navigator.pop(navigatorKey.currentContext!);
                      } catch (e) {
                        utils.showSnackBar("Err while sorting: $e");
                      }
                    },
                  ),
                )
                .toList()
            // [
            //   ListTile(
            //     title: const Text('Sort by Title'),
            //     onTap: () {
            //       setState(() {
            //         _sortBy = 'title';
            //       });
            //       Navigator.pop(context);
            //     },
            //   ),
            //   ListTile(
            //     title: const Text('Sort by Start Time'),
            //     onTap: () {
            //       setState(() {
            //         _sortBy = 'startTime';
            //       });
            //       Navigator.pop(context);
            //     },
            //   ),
            //   ListTile(
            //     title: const Text('Sort by Priority'),
            //     onTap: () {
            //       setState(() {
            //         _sortBy = 'priority';
            //       });
            //       Navigator.pop(context);
            //     },
            //   ),
            // ],
            ),
      ),
    );
  }
}
