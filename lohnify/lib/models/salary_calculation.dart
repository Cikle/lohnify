class SalaryCalculation {
  final double grossSalary;
  final double ahvDeduction;
  final double ivDeduction;
  final double eoDeduction;
  final double alvDeduction;
  final double netSalary;

  SalaryCalculation({
    required this.grossSalary,
    required this.ahvDeduction,
    required this.ivDeduction,
    required this.eoDeduction,
    required this.alvDeduction,
    required this.netSalary,
  });

  factory SalaryCalculation.calculate(double grossSalary, ContributionRates rates) {
    final baseAmount = grossSalary.clamp(0, rates.maxContributionBase);
    
    final ahvDeduction = baseAmount * (rates.ahvEmployee / 100);
    final ivDeduction = baseAmount * (rates.ivEmployee / 100);
    final eoDeduction = baseAmount * (rates.eoEmployee / 100);
    final alvDeduction = baseAmount * (rates.alvEmployee / 100);
    
    final totalDeductions = ahvDeduction + ivDeduction + eoDeduction + alvDeduction;
    final netSalary = grossSalary - totalDeductions;

    return SalaryCalculation(
      grossSalary: grossSalary,
      ahvDeduction: ahvDeduction,
      ivDeduction: ivDeduction,
      eoDeduction: eoDeduction,
      alvDeduction: alvDeduction,
      netSalary: netSalary,
    );
  }
}
