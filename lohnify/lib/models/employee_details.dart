class EmployeeDetails {
  final String? canton;
  final bool hasChildren;
  final int numberOfChildren;
  final bool isMarried;
  final bool hasChurchTax;
  final String? taxClass;
  final double? pensionContribution;
  final double? accidentInsurance;
  final double? healthInsurance;

  EmployeeDetails({
    this.canton,
    this.hasChildren = false,
    this.numberOfChildren = 0,
    this.isMarried = false,
    this.hasChurchTax = false,
    this.taxClass,
    this.pensionContribution,
    this.accidentInsurance,
    this.healthInsurance,
  });
}
