// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_rates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContributionRates _$ContributionRatesFromJson(Map<String, dynamic> json) =>
    ContributionRates(
      ahvEmployee: (json['ahvEmployee'] as num).toDouble(),
      ahvEmployer: (json['ahvEmployer'] as num).toDouble(),
      ivEmployee: (json['ivEmployee'] as num).toDouble(),
      ivEmployer: (json['ivEmployer'] as num).toDouble(),
      eoEmployee: (json['eoEmployee'] as num).toDouble(),
      eoEmployer: (json['eoEmployer'] as num).toDouble(),
      alvEmployee: (json['alvEmployee'] as num).toDouble(),
      alvEmployer: (json['alvEmployer'] as num).toDouble(),
      maxContributionBase: (json['maxContributionBase'] as num).toDouble(),
      alvAdditionalRate: (json['alvAdditionalRate'] as num).toDouble(),
      maxAdditionalAlvBase: (json['maxAdditionalAlvBase'] as num).toDouble(),
      nbuRate: (json['nbuRate'] as num).toDouble(),
      defaultPensionRate: (json['defaultPensionRate'] as num).toDouble(),
      cantons: (json['cantons'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, CantonData.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$ContributionRatesToJson(ContributionRates instance) =>
    <String, dynamic>{
      'ahvEmployee': instance.ahvEmployee,
      'ahvEmployer': instance.ahvEmployer,
      'ivEmployee': instance.ivEmployee,
      'ivEmployer': instance.ivEmployer,
      'eoEmployee': instance.eoEmployee,
      'eoEmployer': instance.eoEmployer,
      'alvEmployee': instance.alvEmployee,
      'alvEmployer': instance.alvEmployer,
      'maxContributionBase': instance.maxContributionBase,
      'alvAdditionalRate': instance.alvAdditionalRate,
      'maxAdditionalAlvBase': instance.maxAdditionalAlvBase,
      'nbuRate': instance.nbuRate,
      'defaultPensionRate': instance.defaultPensionRate,
      'cantons': instance.cantons,
    };

CantonData _$CantonDataFromJson(Map<String, dynamic> json) => CantonData(
      name: json['name'] as String,
      taxRate: (json['taxRate'] as num).toDouble(),
      churchTaxRate: (json['churchTaxRate'] as num?)?.toDouble(),
      municipalityRates: (json['municipalityRates'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$CantonDataToJson(CantonData instance) => <String, dynamic>{
      'name': instance.name,
      'taxRate': instance.taxRate,
      'churchTaxRate': instance.churchTaxRate,
      'municipalityRates': instance.municipalityRates,
    };
