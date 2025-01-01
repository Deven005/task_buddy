import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_buddy/main.dart';

import '../../providers/app/app_settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeData = ref.watch(appSettingsNotifierProvider);
    final ThemeMode theme = themeData['themeMode'];
    bool isDarkTheme = theme == ThemeMode.dark ? true : false;
    Color selectedColor = isDarkTheme
        ? themeData['appDarkThemeColor']
        : themeData['appLightThemeColor'];
    final bool isNotificationEnabled = themeData['isNotificationEnabled'];

    return Scaffold(
      appBar:
          AppBar(title: const Text('Settings'), backgroundColor: selectedColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle('Appearance', selectedColor),
            const SizedBox(height: 10),

            // Theme Toggle
            _buildTile(
              title: 'Dark Theme',
              icon: Icons.dark_mode,
              selectedColor: selectedColor,
              trailing: Switch(
                value: isDarkTheme,
                onChanged: (value) {
                  setState(() {
                    isDarkTheme = value;
                  });
                  // Implement theme change logic here
                  ref.read(appSettingsNotifierProvider.notifier).toggleTheme();
                },
              ),
            ),
            const Divider(),

            // App Color Picker
            _buildTile(
              title: 'App Color',
              icon: Icons.color_lens,
              selectedColor: selectedColor,
              trailing: ElevatedButton(
                onPressed: () => _showColorPicker(context, isDarkTheme),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedColor,
                  shape: const CircleBorder(),
                ),
                child: const Icon(Icons.palette, color: Colors.white),
              ),
            ),
            const Divider(),

            _buildSectionTitle('Account', selectedColor),
            const SizedBox(height: 10),

            // Notifications Setting
            _buildTile(
              title: 'Notifications',
              icon: Icons.notifications,
              selectedColor: selectedColor,
              trailing: Switch(
                value: isNotificationEnabled,
                onChanged: (value) {
                  if (!value) {
                    // Show confirmation dialog when disabling notifications
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Disable Notifications',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                              'Are you sure you want to disable notifications? You may miss important updates.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await ref
                                    .read(appSettingsNotifierProvider.notifier)
                                    .toggleNotificationEnable(value);
                                utils.showSnackBar("Notification is disabled!");
                                Navigator.pop(navigatorKey
                                    .currentContext!); // Dismiss the dialog
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Enable notifications directly
                    ref
                        .read(appSettingsNotifierProvider.notifier)
                        .toggleNotificationEnable(value);
                    utils.showSnackBar("Notification is enabled!");
                  }
                },
              ),
            ),

            const Divider(),

            // Privacy and Security
            _buildTile(
              title: 'Privacy & Security',
              icon: Icons.lock,
              trailing: const Icon(Icons.arrow_forward_ios),
              selectedColor: selectedColor,
              onTap: () {
                // Navigate to privacy settings screen
                utils.showSnackBar('Coming soon!');
              },
            ),
            const Divider(),

            _buildSectionTitle('Other', selectedColor),
            const SizedBox(height: 10),

            // About the App
            _buildTile(
              title: 'About Task Manager',
              icon: Icons.info,
              trailing: const Icon(Icons.arrow_forward_ios),
              selectedColor: selectedColor,
              onTap: () {
                // Navigate to about screen
                utils.showSnackBar('Coming soon!');
              },
            ),
            const Divider(),

            // Log Out Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Implement logout logic
                    await utils.logOutUser();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Log Out'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a section title
  Widget _buildSectionTitle(String title, Color appLightThemeColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: appLightThemeColor,
      ),
    );
  }

  // Builds a list tile for settings options
  Widget _buildTile({
    required String title,
    required IconData icon,
    required Widget trailing,
    required Color selectedColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: selectedColor),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context, bool isDarkTheme) {
    // Define the color palette based on the current app
    List<Color> colorOptions = isDarkTheme
        ? [
            Colors.blueGrey, // Muted dark blue-grey
            Colors.deepPurple, // Rich dark purple
            Colors.indigo.shade900, // Very dark indigo
            Colors.teal.shade800, // Dark teal
            Colors.cyan.shade900, // Deep cyan
            Colors.green.shade900, // Dark forest green
            Colors.brown.shade900, // Deep brown
            Colors.grey.shade800, // Neutral dark grey
            Colors.black, // Pure black
            Colors.deepOrange.shade900, // Deep orange for accents
            Colors.red.shade900, // Dark red
            Colors.lime.shade800, // Muted lime for a subtle pop
            Colors.amber.shade800, // Dark amber for warm tones
            Colors.pink.shade900, // Deep pink for highlights
            Colors.yellow.shade800, // Subtle dark yellow
            Colors.lightBlue.shade900 // Deep light blue
          ]
        : Colors.primaries;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose App Color'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: colorOptions.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      // selectedColor = color;
                      // Save the selected color depending on the current app
                      if (isDarkTheme) {
                        // Save color for dark app
                        ref
                            .read(appSettingsNotifierProvider.notifier)
                            .updateDarkThemeColor(color);
                      } else {
                        // Save color for light app
                        ref
                            .read(appSettingsNotifierProvider.notifier)
                            .updateLightThemeColor(color);
                      }
                    });
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 20,
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
