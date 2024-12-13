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
      'calculate': 'Berechnen',
      'basicInfo': 'Grundangaben',
      'grossSalary': 'Bruttolohn (CHF)',
      'enterGrossSalary': 'Geben Sie Ihren Bruttolohn ein',
      'pleaseEnterSalary': 'Bitte geben Sie einen Lohn ein',
      'pleaseEnterValidNumber': 'Bitte geben Sie eine gültige Zahl ein',
      'canton': 'Kanton',
      'personalInfo': 'Persönliche Angaben',
      'married': 'Verheiratet',
      'churchTax': 'Kirchensteuer',
      'numberOfChildren': 'Anzahl Kinder',
      'additionalInsurance': 'Zusätzliche Versicherungen',
      'pensionFund': 'Pensionskasse (%)',
      'optional': 'Optional',
      'additionalInsuranceCHF': 'Zusatzversicherungen (CHF)',
      'thirteenthSalary': '13. Monatslohn',
      'calculateOnYearlyBasis': 'Auf Jahresbasis berechnen',
      'socialInsurance': 'Sozialversicherungen',
      'socialInsuranceInfo': 'AHV: Alters- und Hinterlassenenversicherung\nIV: Invalidenversicherung\nEO: Erwerbsersatzordnung\nALV: Arbeitslosenversicherung',
      'child': 'Kind',
      'children': 'Kinder',
      'customTaxRate': 'Benutzerdefinierter Steuersatz',
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
      'calculate': 'Calculate',
      'basicInfo': 'Basic Information',
      'grossSalary': 'Gross Salary (CHF)',
      'enterGrossSalary': 'Enter your gross salary',
      'pleaseEnterSalary': 'Please enter a salary',
      'pleaseEnterValidNumber': 'Please enter a valid number',
      'canton': 'Canton',
      'personalInfo': 'Personal Information',
      'married': 'Married',
      'churchTax': 'Church Tax',
      'numberOfChildren': 'Number of Children',
      'additionalInsurance': 'Additional Insurance',
      'pensionFund': 'Pension Fund (%)',
      'optional': 'Optional',
      'additionalInsuranceCHF': 'Additional Insurance (CHF)',
      'thirteenthSalary': '13th Month Salary',
      'calculateOnYearlyBasis': 'Calculate on yearly basis',
      'socialInsurance': 'Social Insurance',
      'socialInsuranceInfo': 'AHV: Old Age and Survivors Insurance\nIV: Disability Insurance\nEO: Loss of Earnings Insurance\nALV: Unemployment Insurance',
      'child': 'child',
      'children': 'children',
      'customTaxRate': 'Custom Tax Rate',
    },
  };

  static String translate(String key, String languageCode) {
    return _translations[languageCode]?[key] ?? key;
  }
}
