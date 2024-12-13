import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_translations.dart';

class LanguageService extends ChangeNotifier {
  static String tr(BuildContext context, String key) {
    final service = context.findAncestorStateOfType<_LohnifyAppState>();
    final languageCode = service?.languageService.currentLocale.languageCode ?? 'en';
    return AppTranslations.translate(key, languageCode);
  }
  static const String _languageKey = 'selected_language';
  final SharedPreferences _prefs;
  
  Locale _currentLocale;
  
  LanguageService(this._prefs) 
    : _currentLocale = Locale(_prefs.getString(_languageKey) ?? 'de', 'CH');
  
  Locale get currentLocale => _currentLocale;
  
  Future<void> setLocale(String languageCode) async {
    if (languageCode == _currentLocale.languageCode) return;
    
    _currentLocale = Locale(languageCode, languageCode == 'de' ? 'CH' : '');
    await _prefs.setString(_languageKey, languageCode);
    notifyListeners();
    
    // Force rebuild of MaterialApp
    WidgetsBinding.instance.performReassemble();
  }
  
  String get currentLanguage => 
    _currentLocale.languageCode == 'de' ? 'Deutsch' : 'English';
}
