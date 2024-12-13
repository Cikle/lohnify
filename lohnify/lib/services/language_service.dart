import 'package:flutter/material.dart';
import 'package:shared_preferences.dart';

class LanguageService extends ChangeNotifier {
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
  }
  
  String get currentLanguage => 
    _currentLocale.languageCode == 'de' ? 'Deutsch' : 'English';
}
