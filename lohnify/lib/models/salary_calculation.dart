import 'contribution_rates.dart';
import '../services/language_service.dart';
import 'package:flutter/widgets.dart';

class SalaryCalculation {
  final double grossSalary;
  final double ahvDeduction;
  final double ivDeduction;
  final double eoDeduction;
  final double alvDeduction;
  final double pensionDeduction;
  final double additionalInsurance;
  final double churchTax;
  final double netSalary;
  final double yearlyGross;
  final double yearlyNet;
  final int numberOfChildren;
  final bool isMarried;
  final double? customTaxRate;
  final String? canton;
  final bool useCustomTaxRate;

  // Arbeitgeber-spezifische Felder
  final double ahvEmployerContribution;
  final double ivEmployerContribution;
  final double eoEmployerContribution;
  final double alvEmployerContribution;
  final double nbuContribution;
  final double pensionEmployerContribution;
  final double totalEmployerCosts;

  SalaryCalculation({
    required this.grossSalary,
    required this.ahvDeduction,
    required this.ivDeduction,
    required this.eoDeduction,
    required this.alvDeduction,
    required this.pensionDeduction,
    required this.additionalInsurance,
    required this.churchTax,
    required this.netSalary,
    required this.yearlyGross,
    required this.yearlyNet,
    this.numberOfChildren = 0,
    required this.isMarried,
    this.customTaxRate,
    this.canton,
    this.useCustomTaxRate = false,
    required this.ahvEmployerContribution,
    required this.ivEmployerContribution,
    required this.eoEmployerContribution,
    required this.alvEmployerContribution,
    required this.nbuContribution,
    required this.pensionEmployerContribution,
    required this.totalEmployerCosts,
  });

  factory SalaryCalculation.calculate(
    double inputSalary,
    ContributionRates rates, {
    required bool has13thSalary,
    required bool isYearlyCalculation,
    required double pensionRate,
    required double additionalInsurance,
    required bool hasChurchTax,
    required bool isMarried,
    int numberOfChildren = 0,
    double? customTaxRate,
    bool useCustomTaxRate = false,
    String? canton,
  }) {
    // Convert yearly to monthly if needed
    final monthlyGross = isYearlyCalculation ? inputSalary / 12 : inputSalary;
    // Base salary calculations
    final baseAmount = monthlyGross.clamp(0, rates.maxContributionBase);
    
    // Employee social security deductions
    final ahvDeduction = baseAmount * (rates.ahvEmployee / 100);
    final ivDeduction = baseAmount * (rates.ivEmployee / 100);
    final eoDeduction = baseAmount * (rates.eoEmployee / 100);
    final alvDeduction = baseAmount * (rates.alvEmployee / 100);
    final pensionDeduction = baseAmount * (pensionRate / 100);

    // Tax calculations
    final effectiveTaxRate = useCustomTaxRate
        ? (customTaxRate ?? 0.0)
        : ContributionRates.defaultCantons[canton ?? 'ZH']!.taxRate;
    
    // Calculate social security deductions first
    final socialSecurityDeductions = ahvDeduction + ivDeduction + eoDeduction + alvDeduction;
    
    // Calculate pension and insurance deductions
    final insuranceDeductions = pensionDeduction + additionalInsurance;
    
    // Calculate taxable base after mandatory deductions
    final taxableBase = baseAmount - socialSecurityDeductions - insuranceDeductions;
    
    // Apply family status adjustments to taxable base
    double adjustedTaxableBase = taxableBase;
    if (isMarried) {
        adjustedTaxableBase *= 0.98; // 2% reduction for married status
    }
    
    // Apply child deductions to taxable base
    if (numberOfChildren > 0) {
        for (int i = 0; i < numberOfChildren; i++) {
            final childDeductionRate = 0.02 + (i * 0.005); // Progressive rate per child
            adjustedTaxableBase *= (1 - childDeductionRate);
        }
    }
    
    // Calculate income tax on adjusted base
    final taxAmount = adjustedTaxableBase * (effectiveTaxRate / 100);
    
    // Calculate church tax if applicable
    final churchTaxRate = hasChurchTax ? (isMarried ? 0.10 : 0.08) : 0.0;
    final churchTaxAmount = taxAmount * churchTaxRate;

    // Calculate employer contributions
    final ahvEmployerContribution = baseAmount * (rates.ahvEmployer / 100);
    final ivEmployerContribution = baseAmount * (rates.ivEmployer / 100);
    final eoEmployerContribution = baseAmount * (rates.eoEmployer / 100);
    final alvEmployerContribution = baseAmount * (rates.alvEmployer / 100);
    final nbuContribution = baseAmount * (rates.nbuRate / 100);
    final pensionEmployerContribution = baseAmount * (pensionRate / 100);

    // Calculate total employer contributions
    final employerContributions = ahvEmployerContribution +
        ivEmployerContribution +
        eoEmployerContribution +
        alvEmployerContribution +
        nbuContribution +
        pensionEmployerContribution;

    // Calculate child benefits
    final childrenAllowance = numberOfChildren * 200.0; // Base monthly allowance per child
    
    // Calculate total deductions
    final totalDeductions = socialSecurityDeductions +
        insuranceDeductions +
        taxAmount +
        churchTaxAmount;

    // Total employer costs
    final totalEmployerCosts = monthlyGross + employerContributions;

    // Calculate final net salary
    final netSalary = monthlyGross - totalDeductions + childrenAllowance;
    final yearlyGross = has13thSalary ? monthlyGross * 13 : monthlyGross * 12;
    final yearlyNet = has13thSalary ? netSalary * 13 : netSalary * 12;

    return SalaryCalculation(
      grossSalary: monthlyGross,
      ahvDeduction: ahvDeduction,
      ivDeduction: ivDeduction,
      eoDeduction: eoDeduction,
      alvDeduction: alvDeduction,
      pensionDeduction: pensionDeduction,
      additionalInsurance: additionalInsurance,
      churchTax: churchTaxAmount,
      netSalary: netSalary,
      yearlyGross: yearlyGross,
      yearlyNet: yearlyNet,
      isMarried: isMarried,
      customTaxRate: customTaxRate,
      canton: canton,
      useCustomTaxRate: useCustomTaxRate,
      ahvEmployerContribution: ahvEmployerContribution,
      ivEmployerContribution: ivEmployerContribution,
      eoEmployerContribution: eoEmployerContribution,
      alvEmployerContribution: alvEmployerContribution,
      nbuContribution: nbuContribution,
      pensionEmployerContribution: pensionEmployerContribution,
      totalEmployerCosts: totalEmployerCosts,
    );
  }

  List<DeductionItem> getDeductionItems(BuildContext context) {
    final items = [
      DeductionItem('AHV', ahvDeduction, isDeduction: true),
      DeductionItem('IV', ivDeduction, isDeduction: true),
      DeductionItem('EO', eoDeduction, isDeduction: true),
      DeductionItem('ALV', alvDeduction, isDeduction: true),
      DeductionItem(
          LanguageService.tr(context, 'pensionFund'), pensionDeduction,
          isDeduction: true),
    ];

    // Add tax deduction
    final canton = useCustomTaxRate ? null : (this.canton ?? 'ZH');
    final effectiveTaxRate = useCustomTaxRate
        ? (customTaxRate ?? ContributionRates.defaultCantons['ZH']!.taxRate)
        : ContributionRates.defaultCantons[canton]!.taxRate;
    final taxAmount = grossSalary * (effectiveTaxRate / 100);
    items.add(DeductionItem(LanguageService.tr(context, 'taxes'), taxAmount,
        isDeduction: true,
        info: canton != null
            ? '${LanguageService.tr(context, 'taxRate')} ${ContributionRates.defaultCantons[canton]!.name}: ${effectiveTaxRate.toStringAsFixed(1)}%'
            : 'Custom tax rate: ${effectiveTaxRate.toStringAsFixed(1)}%'));

    if (additionalInsurance > 0) {
      items.add(DeductionItem('Additional Insurance', additionalInsurance,
          isDeduction: true));
    }

    if (churchTax > 0) {
      items.add(DeductionItem('Church Tax', churchTax, isDeduction: true));
    }

    // Add benefits
    if (numberOfChildren > 0) {
      // Base children's allowance
      final baseAllowance = numberOfChildren * 200.0;
      items.add(DeductionItem(
          'Child Allowance ($numberOfChildren ${numberOfChildren == 1 ? 'child' : 'children'})',
          baseAllowance,
          isDeduction: false,
          info:
              'Grundzulage: $numberOfChildren × 200 CHF = ${baseAllowance.toStringAsFixed(2)} CHF'));

      // Progressive tax benefits for children
      for (int i = 0; i < numberOfChildren; i++) {
        final percentage = 2.0 + (i * 0.5);
        final benefit = grossSalary * (percentage / 100);
        items.add(DeductionItem(
          'Tax Deduction Child ${i + 1}',
          benefit,
          isDeduction: false,
          info:
              'Tax reduction: ${percentage.toStringAsFixed(1)}% of gross salary (${grossSalary.toStringAsFixed(2)} CHF × ${percentage.toStringAsFixed(1)}% = ${benefit.toStringAsFixed(2)} CHF)',
        ));
      }
    }

    if (isMarried) {
      items.add(DeductionItem(
          LanguageService.tr(context, 'marriageTaxDeduction'),
          grossSalary * 0.02,
          isDeduction: false,
          info: LanguageService.tr(context, 'marriageTaxBenefitInfo')));
    }

    // Arbeitgeber-Beiträge
    items.add(DeductionItem(
      LanguageService.tr(context, 'ahvEmployer'),
      ahvEmployerContribution,
      isDeduction: true,
      info:
          '${LanguageService.tr(context, 'employerContribution')} AHV: ${ContributionRates().ahvEmployer}%',
      isEmployerContribution: true,
    ));
    items.add(DeductionItem(
      LanguageService.tr(context, 'ivEmployer'),
      ivEmployerContribution,
      isDeduction: true,
      info:
          '${LanguageService.tr(context, 'employerContribution')} IV: ${ContributionRates().ivEmployer}%',
      isEmployerContribution: true,
    ));
    items.add(DeductionItem(
      LanguageService.tr(context, 'eoEmployer'),
      eoEmployerContribution,
      isDeduction: true,
      info:
          '${LanguageService.tr(context, 'employerContribution')} EO: ${ContributionRates().eoEmployer}%',
      isEmployerContribution: true,
    ));
    items.add(DeductionItem(
      LanguageService.tr(context, 'alvEmployer'),
      alvEmployerContribution,
      isDeduction: true,
      info:
          '${LanguageService.tr(context, 'employerContribution')} ALV: ${ContributionRates().alvEmployer}%',
      isEmployerContribution: true,
    ));
    items.add(DeductionItem(
      LanguageService.tr(context, 'employerNPAIU'),
      nbuContribution,
      isDeduction: true,
      info:
          '${LanguageService.tr(context, 'employerNPAIU')}: ${ContributionRates().nbuRate}%',
      isEmployerContribution: true,
    ));
    items.add(DeductionItem(
      LanguageService.tr(context, 'employerPensionFund'),
      pensionEmployerContribution,
      isDeduction: true,
      info: LanguageService.tr(context, 'employerContribution'),
      isEmployerContribution: true,
    ));

    return items;
  }
}

class DeductionItem {
  final String label;
  final double amount;
  final bool isDeduction;
  final String? info;
  final bool isEmployerContribution;

  DeductionItem(
    this.label,
    this.amount, {
    this.isDeduction = true,
    this.info,
    this.isEmployerContribution = false,
  });
}
