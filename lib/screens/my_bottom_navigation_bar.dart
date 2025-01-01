import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_buddy/providers/my_bottom_nav_provider.dart';
import 'package:task_buddy/screens/settings/settings_screen.dart';
import 'package:task_buddy/screens/task/task_list_screen.dart';

class MyBottomNavigationBar extends ConsumerStatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  ConsumerState<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends ConsumerState<MyBottomNavigationBar> {
  // List of screens to navigate between
  final List<Widget> _screens = [
    const TaskListScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(myBottomNavNotifierProvider);

    return Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref
            .read(myBottomNavNotifierProvider.notifier)
            .changeCurrentIndex(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
