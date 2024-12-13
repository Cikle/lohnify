import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/navigation_service.dart';
import '../services/language_service.dart';
import 'calculator_screen.dart';
import 'settings_screen.dart';
import 'info_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageService.tr(context, 'appTitle')),
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
                title: Text(LanguageService.tr(context, 'calculator')),
                subtitle: Text(LanguageService.tr(context, 'calculatorSubtitle')),
                onTap: () => NavigationService.navigateToPage(
                  context,
                  const CalculatorScreen(),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.info),
                title: Text(LanguageService.tr(context, 'information')),
                subtitle: Text(LanguageService.tr(context, 'infoSubtitle')),
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
