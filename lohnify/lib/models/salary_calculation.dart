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
  });

  factory SalaryCalculation.calculate(
    double grossSalary,
    ContributionRates rates, {
    required bool has13thSalary,
    required double pensionRate,
    required double additionalInsurance,
    required bool hasChurchTax,
    required bool isMarried,
    int numberOfChildren = 0,
    double? customTaxRate,
  }) {
    final baseAmount = grossSalary.clamp(0, rates.maxContributionBase);

    final ahvDeduction = baseAmount * (rates.ahvEmployee / 100);
    final ivDeduction = baseAmount * (rates.ivEmployee / 100);
    final eoDeduction = baseAmount * (rates.eoEmployee / 100);
    final alvDeduction = baseAmount * (rates.alvEmployee / 100);

    final pensionDeduction = baseAmount * (pensionRate / 100);
    // Adjust tax rates based on marriage status
    final churchTaxRate = hasChurchTax ? (isMarried ? 0.10 : 0.08) : 0.0;
    final churchTaxAmount = baseAmount * churchTaxRate;

    final totalDeductions = ahvDeduction +
        ivDeduction +
        eoDeduction +
        alvDeduction +
        pensionDeduction +
        additionalInsurance +
        churchTaxAmount;

    final netSalary = grossSalary - totalDeductions;
    final yearlyGross = has13thSalary ? grossSalary * 13 : grossSalary * 12;
    final yearlyNet = has13thSalary ? netSalary * 13 : netSalary * 12;

    return SalaryCalculation(
      grossSalary: grossSalary,
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
    );
  }

  List<DeductionItem> get deductionItems => [
    DeductionItem('AHV', ahvDeduction, isDeduction: true),
    DeductionItem('IV', ivDeduction, isDeduction: true),
    DeductionItem('EO', eoDeduction, isDeduction: true),
    DeductionItem('ALV', alvDeduction, isDeduction: true),
    DeductionItem('Pensionskasse', pensionDeduction, isDeduction: true),
    if (additionalInsurance > 0)
      DeductionItem('Zusatzversicherungen', additionalInsurance, isDeduction: true),
    if (churchTax > 0)
      DeductionItem('Kirchensteuer', churchTax, isDeduction: true),
    if (numberOfChildren > 0)
      DeductionItem(
        'Kinderzulage (${numberOfChildren} ${numberOfChildren == 1 ? 'Kind' : 'Kinder'})',
        numberOfChildren * 200.0, // Standard children allowance in Switzerland
        isDeduction: false,
      ),
  ];
}

class DeductionItem {
  final String label;
  final double amount;
  final bool isDeduction;

  DeductionItem(this.label, this.amount, {this.isDeduction = true});
}
