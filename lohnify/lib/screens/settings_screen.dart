import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/canton_rates_service.dart';
import '../services/language_service.dart';
import '../models/contribution_rates.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _useDefaultRates = true;
  bool _isDarkMode = true;
  String _selectedCanton = 'ZH';
  DateTime? _lastRatesUpdate;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _checkLastUpdate();
  }

  Future<void> _checkLastUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    final cantonService = CantonRatesService(prefs);
    setState(() {
      _lastRatesUpdate = cantonService.getLastUpdate();
    });
  }

  Future<void> _updateRates() async {
    setState(() => _isUpdating = true);

    final prefs = await SharedPreferences.getInstance();
    final cantonService = CantonRatesService(prefs);

    await cantonService.fetchCantonRates();
    await _checkLastUpdate();

    setState(() => _isUpdating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageService.tr(context, 'settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Allgemeine Einstellungen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                if (_lastRatesUpdate != null)
                  ListTile(
                    leading: const Icon(Icons.update),
                    title: const Text('Letzte Aktualisierung'),
                    subtitle: Text(DateFormat('dd.MM.yyyy HH:mm')
                        .format(_lastRatesUpdate!)),
                    trailing: _isUpdating
                        ? const CircularProgressIndicator()
                        : IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _updateRates,
                          ),
                  ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Sprache'),
                  subtitle:
                      Text(context.watch<LanguageService>().currentLanguage),
                  onTap: () async {
                    final selectedLanguage = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sprache wählen'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile<String>(
                              title: const Text('Deutsch'),
                              value: 'de',
                              groupValue: context
                                  .read<LanguageService>()
                                  .currentLocale
                                  .languageCode,
                              onChanged: (value) {
                                Navigator.pop(context, value);
                              },
                            ),
                            RadioListTile<String>(
                              title: const Text('English'),
                              value: 'en',
                              groupValue: context
                                  .read<LanguageService>()
                                  .currentLocale
                                  .languageCode,
                              onChanged: (value) {
                                Navigator.pop(context, value);
                              },
                            ),
                          ],
                        ),
                      ),
                    );

                    if (selectedLanguage != null) {
                      if (!context.mounted) return;
                      await context
                          .read<LanguageService>()
                          .setLocale(selectedLanguage);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.brightness_6),
                  title: const Text('Erscheinungsbild'),
                  subtitle: Text(_isDarkMode ? 'Dunkel' : 'Hell'),
                  trailing: Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() => _isDarkMode = value);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Berechnungseinstellungen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.location_city),
                  title: const Text('Standardkanton'),
                  subtitle: Text(_selectedCanton),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: const Text('Kanton wählen'),
                        children: [
                          ...ContributionRates.defaultCantons.entries
                              .map(
                                (canton) => SimpleDialogOption(
                                  onPressed: () {
                                    setState(
                                        () => _selectedCanton = canton.key);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                      '${canton.value.name} (${canton.key})'),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.percent),
                  title: const Text('Standardsätze verwenden'),
                  subtitle: Text(_useDefaultRates
                      ? 'Standardsätze aktiv'
                      : 'Benutzerdefinierte Sätze'),
                  trailing: Switch(
                    value: _useDefaultRates,
                    onChanged: (value) {
                      setState(() => _useDefaultRates = value);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
