import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../../models/task/task_model.dart';
import '../../providers/task/task_provider.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  AddTaskScreenState createState() => AddTaskScreenState();
}

class AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '',
      _description = '',
      _category = '',
      _priority = 'Low',
      _notes = '';
  late DateTime _startTime, _endTime;
  List<String> _tags = [],
      categories = ['General', 'Personal', 'Work', 'Other'],
      priorities = ['Low', 'Medium', 'High'];
  bool _isCompleted = false, _isLoading = false;

  Future<void> _pickDateTime(BuildContext context,
      {required bool isStart}) async {
    final currentDateTime = isStart ? _startTime : _endTime;
    final date = await showDatePicker(
      context: context,
      initialDate: currentDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: navigatorKey.currentContext!,
      initialTime: TimeOfDay.fromDateTime(currentDateTime ?? DateTime.now()),
    );

    if (time == null) return;

    setState(() {
      final selectedDateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (isStart) {
        _startTime = selectedDateTime;
      } else {
        _endTime = selectedDateTime;
      }
    });
  }

  void _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      utils.showSnackBar('Form is not valid, try again!');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _formKey.currentState!.save();

    Task newTask = Task(
      title: _title,
      description: _description,
      startTime: _startTime!,
      endTime: _endTime!,
      priority: TaskPriority.values.firstWhere(
        (e) => e.toString().split('.').last == _priority.toLowerCase(),
        orElse: () => TaskPriority.low,
      ),
      isCompleted: _isCompleted,
      category: _category,
      notes: _notes,
      tags: _tags,
    );

    try {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final task = ModalRoute.of(context)?.settings.arguments as Task;
        await ref.read(taskNotifierProvider.notifier).updateTask(
            task.copyWith(
              title: _title,
              description: _description,
              startTime: _startTime,
              endTime: _endTime,
              priority: newTask.priority,
              isCompleted: _isCompleted,
              category: _category,
              notes: _notes,
              tags: _tags,
            ),
            task.startTime);
        setState(() {
          _isLoading = false;
        });
      } else {
        await ref.read(taskNotifierProvider.notifier).addTask(newTask);
        setState(() {
          _isLoading = false;
        });
      }
      Navigator.pop(navigatorKey.currentContext!);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      utils.showSnackBar('Failed to save task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = ModalRoute.of(context)?.settings.arguments != null;
    final task =
        isEditMode ? ModalRoute.of(context)?.settings.arguments as Task : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        label: 'Title',
                        initialValue: task?.title ?? '',
                        onSaved: (value) => _title = value!,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter a title'
                            : null,
                      ),
                      _buildTextField(
                        label: 'Description',
                        initialValue: task?.description ?? '',
                        onSaved: (value) => _description = value!,
                        maxLines: 3,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter a title'
                            : null,
                      ),
                      _buildDropdown(
                        label: 'Category',
                        value: task?.category ?? _category,
                        onChanged: (value) =>
                            setState(() => _category = value!),
                        items: categories,
                      ),
                      _buildDropdown(
                        label: 'Priority',
                        value: task?.priority.name ?? _priority,
                        onChanged: (value) =>
                            setState(() => _priority = value!),
                        items: priorities,
                      ),
                      _buildTimePickerRow(),
                      Text(
                        'Duration: ${utils.getDuration(startTime: _startTime, endTime: _endTime)}',
                        style: const TextStyle(
                          fontSize: 18,
                          // Adjust based on the screen size or needs
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          // Use a color that contrasts well with the background
                          letterSpacing:
                              0.5, // Adding some spacing between letters for clarity
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: _buildTextField(
                          label: 'Notes',
                          initialValue: task?.notes ?? '',
                          onSaved: (value) => _notes = value!,
                          maxLines: 3,
                        ),
                      ),
                      _buildTextField(
                        label: 'Tags (comma-separated)',
                        initialValue: task?.tags.join(', ') ?? '',
                        onSaved: (value) => _tags =
                            value!.split(',').map((tag) => tag.trim()).toList(),
                      ),
                      CheckboxListTile(
                        title: const Text('Mark as Completed'),
                        value: _isCompleted,
                        onChanged: (value) =>
                            setState(() => _isCompleted = value!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _saveTask,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(isEditMode ? 'Update Task' : 'Add Task'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    int? maxLines,
    required FormFieldSetter<String> onSaved,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          hintText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        maxLines: maxLines ?? 1,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
    required List<String> items,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        items: items
            .map((priority) =>
                DropdownMenuItem(value: priority, child: Text(priority)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTimePickerRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimePickerTile(
            label: 'Start Time',
            selectedDate: _startTime,
            isStart: true,
          ),
          _buildTimePickerTile(
            label: 'End Time',
            selectedDate: _endTime,
            isStart: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerTile({
    required String label,
    DateTime? selectedDate,
    required bool isStart,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(label),
          subtitle: Text(
            selectedDate != null
                ? DateFormat('yyyy-MM-dd HH:mm').format(selectedDate)
                : 'Select Time',
          ),
          onTap: () => _pickDateTime(context, isStart: isStart),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _category = categories.first;
    _priority = priorities.first;
    _startTime = DateTime.now();
    _endTime = DateTime.now().add(const Duration(hours: 1));
  }
}
