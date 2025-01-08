import 'package:json_annotation/json_annotation.dart';

part 'contribution_rates.g.dart';

@JsonSerializable()
class ContributionRates {
  final double ahvEmployee;
  final double ahvEmployer;
  final double ivEmployee;
  final double ivEmployer;
  final double eoEmployee;
  final double eoEmployer;
  final double alvEmployee;
  final double alvEmployer;
  final double maxContributionBase;
  final double alvAdditionalRate;
  final double maxAdditionalAlvBase;
  final double nbuRate;
  final double defaultPensionRate;
  final Map<String, CantonData> cantons;

  ContributionRates({
    this.ahvEmployee = 5.3,
    this.ahvEmployer = 5.3,
    this.ivEmployee = 0.7,
    this.ivEmployer = 0.7,
    this.eoEmployee = 0.25,
    this.eoEmployer = 0.25,
    this.alvEmployee = 1.1,
    this.alvEmployer = 1.1,
    this.maxContributionBase = 148200,
    this.alvAdditionalRate = 0.5,
    this.maxAdditionalAlvBase = 148200,
    this.nbuRate = 1.4,
    this.defaultPensionRate = 7.75,
    Map<String, CantonData>? cantons,
  }) : cantons = cantons ?? defaultCantons;

  factory ContributionRates.fromJson(Map<String, dynamic> json) =>
      _$ContributionRatesFromJson(json);

  Map<String, dynamic> toJson() => _$ContributionRatesToJson(this);

  static final Map<String, CantonData> defaultCantons = {
    'AG': CantonData(name: 'Aargau', taxRate: 34.5),
    'AI': CantonData(name: 'Appenzell Innerrhoden', taxRate: 23.8),
    'AR': CantonData(name: 'Appenzell Ausserrhoden', taxRate: 30.7),
    'BE': CantonData(name: 'Bern', taxRate: 41.2),
    'BL': CantonData(name: 'Basel-Landschaft', taxRate: 42.2),
    'BS': CantonData(name: 'Basel-Stadt', taxRate: 40.5),
    'FR': CantonData(name: 'Fribourg', taxRate: 35.3),
    'GE': CantonData(name: 'Genève', taxRate: 45.0),
    'GL': CantonData(name: 'Glarus', taxRate: 31.1),
    'GR': CantonData(name: 'Graubünden', taxRate: 32.2),
    'JU': CantonData(name: 'Jura', taxRate: 39.0),
    'LU': CantonData(name: 'Luzern', taxRate: 30.6),
    'NE': CantonData(name: 'Neuchâtel', taxRate: 38.1),
    'NW': CantonData(name: 'Nidwalden', taxRate: 25.3),
    'OW': CantonData(name: 'Obwalden', taxRate: 24.2),
    'SG': CantonData(name: 'St. Gallen', taxRate: 32.8),
    'SH': CantonData(name: 'Schaffhausen', taxRate: 30.0),
    'SO': CantonData(name: 'Solothurn', taxRate: 33.7),
    'SZ': CantonData(name: 'Schwyz', taxRate: 25.3),
    'TG': CantonData(name: 'Thurgau', taxRate: 31.7),
    'TI': CantonData(name: 'Ticino', taxRate: 40.1),
    'UR': CantonData(name: 'Uri', taxRate: 25.3),
    'VD': CantonData(name: 'Vaud', taxRate: 41.5),
    'VS': CantonData(name: 'Valais', taxRate: 36.5),
    'ZG': CantonData(name: 'Zug', taxRate: 22.2),
    'ZH': CantonData(name: 'Zürich', taxRate: 39.8),
  };
}

@JsonSerializable()
class CantonData {
  final String name;
  final double taxRate;
  final double? churchTaxRate;
  final Map<String, double>? municipalityRates;

  CantonData({
    required this.name,
    required this.taxRate,
    this.churchTaxRate = 0.08,
    this.municipalityRates,
  });

  factory CantonData.fromJson(Map<String, dynamic> json) =>
      _$CantonDataFromJson(json);

  Map<String, dynamic> toJson() => _$CantonDataToJson(this);
}
