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
    'AG': CantonData(name: 'Aargau', taxRate: 21.5),
    'AI': CantonData(name: 'Appenzell Innerrhoden', taxRate: 14.2),
    'AR': CantonData(name: 'Appenzell Ausserrhoden', taxRate: 18.7),
    'BE': CantonData(name: 'Bern', taxRate: 21.2),
    'BL': CantonData(name: 'Basel-Landschaft', taxRate: 20.7),
    'BS': CantonData(name: 'Basel-Stadt', taxRate: 22.3),
    'FR': CantonData(name: 'Fribourg', taxRate: 19.9),
    'GE': CantonData(name: 'Genève', taxRate: 24.5),
    'GL': CantonData(name: 'Glarus', taxRate: 18.5),
    'GR': CantonData(name: 'Graubünden', taxRate: 17.4),
    'JU': CantonData(name: 'Jura', taxRate: 22.0),
    'LU': CantonData(name: 'Luzern', taxRate: 17.8),
    'NE': CantonData(name: 'Neuchâtel', taxRate: 23.4),
    'NW': CantonData(name: 'Nidwalden', taxRate: 13.7),
    'OW': CantonData(name: 'Obwalden', taxRate: 14.3),
    'SG': CantonData(name: 'St. Gallen', taxRate: 19.5),
    'SH': CantonData(name: 'Schaffhausen', taxRate: 20.2),
    'SO': CantonData(name: 'Solothurn', taxRate: 21.4),
    'SZ': CantonData(name: 'Schwyz', taxRate: 14.1),
    'TG': CantonData(name: 'Thurgau', taxRate: 18.8),
    'TI': CantonData(name: 'Ticino', taxRate: 20.6),
    'UR': CantonData(name: 'Uri', taxRate: 15.2),
    'VD': CantonData(name: 'Vaud', taxRate: 22.7),
    'VS': CantonData(name: 'Valais', taxRate: 21.0),
    'ZG': CantonData(name: 'Zug', taxRate: 14.0),
    'ZH': CantonData(name: 'Zürich', taxRate: 22.0),
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
