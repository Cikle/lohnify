import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/navigation_service.dart';
import '../services/language_service.dart';
import '../services/view_type_provider.dart';
import 'calculator_screen.dart';
import 'settings_screen.dart';
import 'info_screen.dart';
import 'help_screen.dart';
import 'saved_calculations_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool _isEmployerView;

  @override
  void initState() {
    super.initState();
    _isEmployerView =
        Provider.of<ViewTypeProvider>(context, listen: false).isEmployerView;
  }

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
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<bool>(
                    segments: [
                      ButtonSegment<bool>(
                        value: false,
                        label:
                            Text(LanguageService.tr(context, 'arbeitnehmer')),
                      ),
                      ButtonSegment<bool>(
                        value: true,
                        label: Text(LanguageService.tr(context, 'arbeitgeber')),
                      ),
                    ],
                    selected: {_isEmployerView},
                    onSelectionChanged: (Set<bool> newSelection) {
                      setState(() {
                        _isEmployerView = newSelection.first;
                        Provider.of<ViewTypeProvider>(context, listen: false)
                            .toggleView();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calculate),
                title: Text(LanguageService.tr(context, 'calculator')),
                subtitle:
                    Text(LanguageService.tr(context, 'calculatorSubtitle')),
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
            Card(
              child: ListTile(
                leading: const Icon(Icons.help),
                title: Text(LanguageService.tr(context, 'helpAndSupport')),
                subtitle: const Text('Get help with calculations and features'),
                onTap: () => NavigationService.navigateToPage(
                  context,
                  const HelpScreen(),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.save),
                title: Text(LanguageService.tr(context, 'savedCalculations')),
                subtitle: Text(LanguageService.tr(context, 'viewDifference')),
                onTap: () => NavigationService.navigateToPage(
                  context,
                  const SavedCalculationsScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
