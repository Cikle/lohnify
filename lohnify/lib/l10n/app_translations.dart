class AppTranslations {
  static final Map<String, Map<String, String>> _translations = {
    'de': {
      'appTitle': 'Lohnify',
      'settings': 'Einstellungen',
      'calculator': 'Lohnrechner',
      'calculatorSubtitle': 'Berechnen Sie Ihren Nettolohn',
      'information': 'Informationen',
      'infoSubtitle': 'Sozialversicherungen & Steuern',
      'language': 'Sprache',
      'chooseLanguage': 'Sprache wählen',
      'appearance': 'Erscheinungsbild',
      'dark': 'Dunkel',
      'light': 'Hell',
      'generalSettings': 'Allgemeine Einstellungen',
      'lastUpdate': 'Letzte Aktualisierung',
      'calculationSettings': 'Berechnungseinstellungen',
      'defaultCanton': 'Standardkanton',
      'chooseCanton': 'Kanton wählen',
      'useDefaultRates': 'Standardsätze verwenden',
      'defaultRatesActive': 'Standardsätze aktiv',
      'customRates': 'Benutzerdefinierte Sätze',
    },
    'en': {
      'appTitle': 'Lohnify',
      'settings': 'Settings',
      'calculator': 'Salary Calculator',
      'calculatorSubtitle': 'Calculate your net salary',
      'information': 'Information',
      'infoSubtitle': 'Social security & taxes',
      'language': 'Language',
      'chooseLanguage': 'Choose language',
      'appearance': 'Appearance',
      'dark': 'Dark',
      'light': 'Light',
      'generalSettings': 'General Settings',
      'lastUpdate': 'Last Update',
      'calculationSettings': 'Calculation Settings',
      'defaultCanton': 'Default Canton',
      'chooseCanton': 'Choose Canton',
      'useDefaultRates': 'Use Default Rates',
      'defaultRatesActive': 'Default rates active',
      'customRates': 'Custom rates',
    },
  };

  static String translate(String key, String languageCode) {
    return _translations[languageCode]?[key] ?? key;
  }
}
