import 'contribution_rates.dart';

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
  }) {
    // Convert yearly to monthly if needed
    final monthlyGross = isYearlyCalculation ? inputSalary / 12 : inputSalary;
    final baseAmount = monthlyGross.clamp(0, rates.maxContributionBase);

    final ahvDeduction = baseAmount * (rates.ahvEmployee / 100);
    final ivDeduction = baseAmount * (rates.ivEmployee / 100);
    final eoDeduction = baseAmount * (rates.eoEmployee / 100);
    final alvDeduction = baseAmount * (rates.alvEmployee / 100);

    final pensionDeduction = baseAmount * (pensionRate / 100);
    // Apply tax rate from user input
    final taxAmount = baseAmount * ((customTaxRate ?? 22.0) / 100);

    // Calculate church tax after tax deduction
    final churchTaxRate = hasChurchTax ? (isMarried ? 0.10 : 0.08) : 0.0;
    final churchTaxAmount = baseAmount * churchTaxRate;

    // Calculate base deductions
    final totalDeductions = ahvDeduction +
        ivDeduction +
        eoDeduction +
        alvDeduction +
        pensionDeduction +
        additionalInsurance +
        taxAmount +
        churchTaxAmount;

    // Children benefits calculation
    final childrenAllowance = numberOfChildren * 200.0; // Base allowance
    double childTaxBenefit = 0.0;

    if (numberOfChildren > 0) {
      // Progressive tax benefit per child
      for (int i = 0; i < numberOfChildren; i++) {
        childTaxBenefit +=
            baseAmount * (0.02 + (i * 0.005)); // Increasing benefit per child
      }
    }

    // Marriage tax benefit
    double marriageBenefit = isMarried ? baseAmount * 0.02 : 0.0;

    final netSalary = monthlyGross -
        totalDeductions +
        childrenAllowance + // Direct child allowance
        childTaxBenefit + // Tax benefits for children
        marriageBenefit; // Marriage benefits
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
    );
  }

  List<DeductionItem> get deductionItems {
    final items = [
      DeductionItem('AHV', ahvDeduction, isDeduction: true),
      DeductionItem('IV', ivDeduction, isDeduction: true),
      DeductionItem('EO', eoDeduction, isDeduction: true),
      DeductionItem('ALV', alvDeduction, isDeduction: true),
      DeductionItem('Pensionskasse', pensionDeduction, isDeduction: true),
    ];

    // Add tax deduction
    final taxAmount = grossSalary * ((customTaxRate ?? 22.0) / 100);
    items.add(DeductionItem('Steuern', taxAmount,
        isDeduction: true,
        info: 'Steuersatz: ${(customTaxRate ?? 22.0).toStringAsFixed(1)}%'));

    if (additionalInsurance > 0) {
      items.add(DeductionItem('Zusatzversicherungen', additionalInsurance,
          isDeduction: true));
    }

    if (churchTax > 0) {
      items.add(DeductionItem('Kirchensteuer', churchTax, isDeduction: true));
    }

    // Add benefits
    if (numberOfChildren > 0) {
      // Base children's allowance
      final baseAllowance = numberOfChildren * 200.0;
      items.add(DeductionItem(
          'Kinderzulage (${numberOfChildren} ${numberOfChildren == 1 ? 'Kind' : 'Kinder'})',
          baseAllowance,
          isDeduction: false,
          info:
              'Grundzulage: ${numberOfChildren} × 200 CHF = ${baseAllowance.toStringAsFixed(2)} CHF'));

      // Progressive tax benefits for children
      for (int i = 0; i < numberOfChildren; i++) {
        final percentage = 2.0 + (i * 0.5);
        final benefit = grossSalary * (percentage / 100);
        items.add(DeductionItem(
          'Steuerabzug Kind ${i + 1}',
          benefit,
          isDeduction: false,
          info:
              'Steuerermässigung: ${percentage.toStringAsFixed(1)}% vom Bruttolohn (${grossSalary.toStringAsFixed(2)} CHF × ${percentage.toStringAsFixed(1)}% = ${benefit.toStringAsFixed(2)} CHF)',
        ));
      }
    }

    if (isMarried) {
      items.add(DeductionItem('Steuerabzug Verheiratet', grossSalary * 0.02,
          isDeduction: false, info: 'Steuerermässigung für Verheiratete: 2%'));
    }

    return items;
  }
}

class DeductionItem {
  final String label;
  final double amount;
  final bool isDeduction;
  final String? info;

  DeductionItem(
    this.label,
    this.amount, {
    this.isDeduction = true,
    this.info,
  });
}
