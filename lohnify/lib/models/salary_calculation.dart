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
  }) {
    // Convert yearly to monthly if needed
    final monthlyGross = isYearlyCalculation ? inputSalary / 12 : inputSalary;
    final baseAmount = monthlyGross.clamp(0, rates.maxContributionBase);

    final ahvDeduction = baseAmount * (rates.ahvEmployee / 100);
    final ivDeduction = baseAmount * (rates.ivEmployee / 100);
    final eoDeduction = baseAmount * (rates.eoEmployee / 100);
    final alvDeduction = baseAmount * (rates.alvEmployee / 100);

    final pensionDeduction = baseAmount * (pensionRate / 100);
    // Adjust tax rates based on marriage status
    final churchTaxRate = hasChurchTax ? (isMarried ? 0.10 : 0.08) : 0.0;
    final churchTaxAmount = baseAmount * churchTaxRate;

    // Calculate base deductions
    final totalDeductions = ahvDeduction +
        ivDeduction +
        eoDeduction +
        alvDeduction +
        pensionDeduction +
        additionalInsurance +
        churchTaxAmount;

    // Add children allowance (200 CHF per child is standard in most cantons)
    final childrenAllowance = numberOfChildren * 200.0;

    // Marriage and children tax benefits (simplified example)
    double taxBenefit = 0.0;
    if (isMarried) {
      taxBenefit += baseAmount * 0.02; // 2% tax benefit for married couples
    }
    if (numberOfChildren > 0) {
      taxBenefit += baseAmount * (0.01 * numberOfChildren); // 1% per child
    }

    final netSalary =
        monthlyGross - totalDeductions + childrenAllowance + taxBenefit;
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

    if (additionalInsurance > 0) {
      items.add(DeductionItem('Zusatzversicherungen', additionalInsurance,
          isDeduction: true));
    }

    if (churchTax > 0) {
      items.add(DeductionItem('Kirchensteuer', churchTax, isDeduction: true));
    }

    // Add benefits
    if (numberOfChildren > 0) {
      // Children's allowance
      items.add(DeductionItem(
          'Kinderzulage (${numberOfChildren} ${numberOfChildren == 1 ? 'Kind' : 'Kinder'})',
          numberOfChildren * 200.0,
          isDeduction: false,
          info:
              'Monatliche Zulage: ${numberOfChildren} × 200 CHF = ${(numberOfChildren * 200.0).toStringAsFixed(2)} CHF'));

      // Tax benefit for children
      final childTaxBenefit = grossSalary * (0.01 * numberOfChildren);
      items.add(DeductionItem('Steuerabzug Kinder', childTaxBenefit,
          isDeduction: false,
          info:
              'Steuerermässigung: ${numberOfChildren}% vom Bruttolohn (${(0.01 * numberOfChildren * 100).toStringAsFixed(0)}% × ${grossSalary.toStringAsFixed(2)} = ${childTaxBenefit.toStringAsFixed(2)} CHF)'));
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
