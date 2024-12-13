import 'package:flutter/material.dart';
import '../services/navigation_service.dart';
import 'calculator_screen.dart';
import 'settings_screen.dart';
import 'info_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lohnify'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => NavigationService.navigateToPage(
              context,
              const SettingsScreen(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calculate),
                title: const Text('Lohnrechner'),
                subtitle: const Text('Berechnen Sie Ihren Nettolohn'),
                onTap: () => NavigationService.navigateToPage(
                  context,
                  const CalculatorScreen(),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Informationen'),
                subtitle: const Text('Sozialversicherungen & Steuern'),
                onTap: () => NavigationService.navigateToPage(
                  context,
                  const InfoScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
