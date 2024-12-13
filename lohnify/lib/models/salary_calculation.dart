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
  });

  factory SalaryCalculation.calculate(
    double grossSalary,
    ContributionRates rates, {
    required bool has13thSalary,
    required double pensionRate,
    required double additionalInsurance,
    required bool hasChurchTax,
  }) {
    final baseAmount = grossSalary.clamp(0, rates.maxContributionBase);

    final ahvDeduction = baseAmount * (rates.ahvEmployee / 100);
    final ivDeduction = baseAmount * (rates.ivEmployee / 100);
    final eoDeduction = baseAmount * (rates.eoEmployee / 100);
    final alvDeduction = baseAmount * (rates.alvEmployee / 100);

    final pensionDeduction = baseAmount * (pensionRate / 100);
    final churchTaxAmount =
        hasChurchTax ? (baseAmount * 0.08) : 0.0; // Example church tax rate

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
}
