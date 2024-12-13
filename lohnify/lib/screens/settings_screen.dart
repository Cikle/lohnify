import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Sprache'),
              subtitle: const Text('Deutsch'),
              onTap: () {
                // TODO: Implement language selection
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Erscheinungsbild'),
              subtitle: const Text('Dunkel'),
              onTap: () {
                // TODO: Implement theme selection
              },
            ),
          ),
        ],
      ),
    );
  }
}
