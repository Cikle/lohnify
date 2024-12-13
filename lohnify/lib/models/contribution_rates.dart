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
  final double alvAdditionalRate; // Additional ALV rate for high incomes
  final double maxAdditionalAlvBase; // Threshold for additional ALV
  final double nbuRate; // Non-occupational accident insurance
  final double defaultPensionRate; // Default BVG rate

  ContributionRates({
    this.ahvEmployee = 5.3,
    this.ahvEmployer = 5.3,
    this.ivEmployee = 0.7,
    this.ivEmployer = 0.7,
    this.eoEmployee = 0.25,
    this.eoEmployer = 0.25,
    this.alvEmployee = 1.1,
    this.alvEmployer = 1.1,
    this.maxContributionBase = 148200, // Updated 2024 value
    this.alvAdditionalRate = 0.5,
    this.maxAdditionalAlvBase = 148200,
    this.nbuRate = 1.4,
    this.defaultPensionRate = 7.75,
  });

  static final Map<String, double> cantonalTaxRates = {
    'ZH': 0.0,
    'BE': 0.0,
    'LU': 0.0,
    // Add more cantons as needed
  };
}
