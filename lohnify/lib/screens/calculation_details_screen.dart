import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/view_type_provider.dart';
import 'package:intl/intl.dart';
import '../services/language_service.dart';
import '../models/salary_calculation.dart';
import 'results_screen.dart';
import '../models/contribution_rates.dart';

class CalculationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> calculation;

  const CalculationDetailsScreen({
    super.key,
    required this.calculation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageService.tr(context, 'calculationDetails')),
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment),
            onPressed: () {
              // Arbeitgeberbeiträge extrahieren
              final employerContributions = (calculation['deductions'] as List)
                  .where((d) => d['isEmployerContribution'] == true)
                  .toList();

              // Arbeitnehmerbeiträge extrahieren
              final employeeDeductions = (calculation['deductions'] as List)
                  .where((d) => d['isEmployerContribution'] != true)
                  .toList();

              final calc = SalaryCalculation(
                grossSalary: calculation['grossSalary'],
                ahvDeduction: employeeDeductions
                    .firstWhere((d) => d['label'] == 'AHV')['amount'],
                ivDeduction: employeeDeductions
                    .firstWhere((d) => d['label'] == 'IV')['amount'],
                eoDeduction: employeeDeductions
                    .firstWhere((d) => d['label'] == 'EO')['amount'],
                alvDeduction: employeeDeductions
                    .firstWhere((d) => d['label'] == 'ALV')['amount'],
                pensionDeduction: employeeDeductions
                    .firstWhere((d) => d['label'] == 'Pensionskasse')['amount'],
                additionalInsurance: employeeDeductions.firstWhere(
                    (d) => d['label'] == 'Zusatzversicherungen',
                    orElse: () => {'amount': 0.0})['amount'],
                churchTax: employeeDeductions.firstWhere(
                    (d) => d['label'] == 'Kirchensteuer',
                    orElse: () => {'amount': 0.0})['amount'],
                netSalary: calculation['netSalary'],
                yearlyGross: calculation['yearlyGross'],
                yearlyNet: calculation['yearlyNet'],
                numberOfChildren: calculation['numberOfChildren'] ?? 0,
                isMarried: calculation['isMarried'] ?? false,
                customTaxRate: calculation['customTaxRate'],
                canton: calculation['canton'],
                useCustomTaxRate: calculation['useCustomTaxRate'] ?? false,
                ahvEmployerContribution: employerContributions.firstWhere(
                    (d) => d['label'] == 'AHV (Arbeitgeber)')['amount'],
                ivEmployerContribution: employerContributions.firstWhere(
                    (d) => d['label'] == 'IV (Arbeitgeber)')['amount'],
                eoEmployerContribution: employerContributions.firstWhere(
                    (d) => d['label'] == 'EO (Arbeitgeber)')['amount'],
                alvEmployerContribution: employerContributions.firstWhere(
                    (d) => d['label'] == 'ALV (Arbeitgeber)')['amount'],
                nbuContribution: employerContributions
                    .firstWhere((d) => d['label'] == 'NBU')['amount'],
                pensionEmployerContribution: employerContributions.firstWhere(
                    (d) =>
                        d['label'] == 'Pensionskasse (Arbeitgeber)')['amount'],
                totalEmployerCosts: calculation['totalEmployerCosts'],
              );

              // Create a copy of the original calculation
              final originalCalc = SalaryCalculation(
                grossSalary: calculation['grossSalary'],
                ahvDeduction: (calculation['deductions'] as List)
                    .firstWhere((d) => d['label'] == 'AHV')['amount'],
                ivDeduction: (calculation['deductions'] as List)
                    .firstWhere((d) => d['label'] == 'IV')['amount'],
                eoDeduction: (calculation['deductions'] as List)
                    .firstWhere((d) => d['label'] == 'EO')['amount'],
                alvDeduction: (calculation['deductions'] as List)
                    .firstWhere((d) => d['label'] == 'ALV')['amount'],
                pensionDeduction: (calculation['deductions'] as List)
                    .firstWhere((d) => d['label'] == 'Pensionskasse')['amount'],
                additionalInsurance: (calculation['deductions'] as List)
                    .firstWhere((d) => d['label'] == 'Zusatzversicherungen',
                        orElse: () => {'amount': 0.0})['amount'],
                churchTax: (calculation['deductions'] as List)
                    .firstWhere((d) => d['label'] == 'Kirchensteuer',
                        orElse: () => {'amount': 0.0})['amount'],
                netSalary: calculation['netSalary'],
                yearlyGross: calculation['yearlyGross'],
                yearlyNet: calculation['yearlyNet'],
                numberOfChildren: calculation['numberOfChildren'] ?? 0,
                isMarried: calculation['isMarried'] ?? false,
                customTaxRate: calculation['customTaxRate'],
                canton: calculation['canton'],
                useCustomTaxRate: calculation['useCustomTaxRate'] ?? false,
                ahvEmployerContribution: (calculation['deductions'] as List)
                    .firstWhere((d) => d['label'] == 'AHV (Arbeitgeber)')['amount'],
                ivEmployerContribution: (calculation['deductions'] as List)
                    .firstWhere((d) => d['label'] == 'IV (Arbeitgeber)')['amount'],
                eoEmployerContribution: (calculation['deductions'] as List)
                    .firstWhere((d) => d['label'] == 'EO (Arbeitgeber)')['amount'],
                alvEmployerContribution: (calculation['deductions'] as List)
                    .firstWhere((d) => d['label'] == 'ALV (Arbeitgeber)')['amount'],
                nbuContribution: (calculation['deductions'] as List)
                    .firstWhere((d) => d['label'] == 'NBU')['amount'],
                pensionEmployerContribution: (calculation['deductions'] as List)
                    .firstWhere((d) => d['label'] == 'Pensionskasse (Arbeitgeber)')['amount'],
                totalEmployerCosts: calculation['totalEmployerCosts'],
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsScreen(
                    calculation: originalCalc,
                    has13thSalary: calculation['has13thSalary'] ?? false,
                    isMarried: calculation['isMarried'] ?? false,
                    hasChurchTax: calculation['hasChurchTax'] ?? false,
                    numberOfChildren: calculation['numberOfChildren'] ?? 0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      calculation['isEmployerView'] == true
                          ? LanguageService.tr(context, 'totalEmployerCosts')
                          : LanguageService.tr(context, 'monthlyGross'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      calculation['isEmployerView'] == true
                          ? '${(calculation['totalEmployerCosts'] ?? 0.0).toStringAsFixed(2)} CHF'
                          : '${(calculation['grossSalary'] ?? 0.0).toStringAsFixed(2)} CHF',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              'basicInfo',
              [
                _buildDetailRow(
                    calculation['isEmployerView'] == true
                        ? LanguageService.tr(context, 'totalEmployerCosts')
                        : LanguageService.tr(context, 'grossSalary'),
                    calculation['isEmployerView'] == true
                        ? '${(calculation['totalEmployerCosts'] ?? 0.0).toStringAsFixed(2)} CHF'
                        : '${(calculation['grossSalary'] ?? 0.0).toStringAsFixed(2)} CHF'),
                _buildDetailRow(
                    calculation['useCustomTaxRate'] == true
                        ? LanguageService.tr(context, 'customTaxRate')
                        : LanguageService.tr(context, 'canton'),
                    calculation['useCustomTaxRate'] == true
                        ? '${calculation['effectiveTaxRate'].toStringAsFixed(1)}%'
                        : '${ContributionRates.defaultCantons[calculation['canton']]?.name} - ${calculation['effectiveTaxRate'].toStringAsFixed(1)}%'),
                _buildDetailRow(LanguageService.tr(context, 'monthlyNet'),
                    '${calculation['netSalary'].toStringAsFixed(2)} CHF'),
                if (calculation['yearlyGross'] != null) ...[
                  if (calculation['has13thSalary'])
                    _buildDetailRow(LanguageService.tr(context, 'yearlyGross'),
                        '${calculation['yearlyGross'].toStringAsFixed(2)} CHF (inkl. 13.)'),
                  if (!calculation['has13thSalary'])
                    _buildDetailRow(LanguageService.tr(context, 'yearlyGross'),
                        '${calculation['yearlyGross'].toStringAsFixed(2)} CHF'),
                ],
                if (calculation['yearlyNet'] != null) ...[
                  if (calculation['has13thSalary'])
                    _buildDetailRow(LanguageService.tr(context, 'yearlyNet'),
                        '${calculation['yearlyNet'].toStringAsFixed(2)} CHF (inkl. 13.)'),
                  if (!calculation['has13thSalary'])
                    _buildDetailRow(LanguageService.tr(context, 'yearlyNet'),
                        '${calculation['yearlyNet'].toStringAsFixed(2)} CHF'),
                ],
                _buildDetailRow(
                    LanguageService.tr(context, 'date'),
                    DateFormat('dd.MM.yyyy HH:mm')
                        .format(DateTime.parse(calculation['date']).toLocal())),
              ],
            ),
            _buildSection(
              context,
              'personalInfo',
              [
                _buildDetailRow(
                    LanguageService.tr(context, 'married'),
                    calculation['isMarried'] == true
                        ? LanguageService.tr(context, 'yes')
                        : LanguageService.tr(context, 'no')),
                _buildDetailRow(
                    LanguageService.tr(context, 'churchTax'),
                    calculation['hasChurchTax'] == true
                        ? LanguageService.tr(context, 'yes')
                        : LanguageService.tr(context, 'no')),
                if (calculation['numberOfChildren'] != null)
                  _buildDetailRow(
                      LanguageService.tr(context, 'numberOfChildren'),
                      calculation['numberOfChildren'].toString()),
              ],
            ),
            _buildSection(
              context,
              'additionalInsurance',
              [
                if (calculation['pensionRate'] != null)
                  _buildDetailRow(LanguageService.tr(context, 'pensionFund'),
                      '${calculation['pensionRate'].toString()}%'),
                if (calculation['additionalInsurance'] != null)
                  _buildDetailRow(
                      LanguageService.tr(context, 'additionalInsuranceCHF'),
                      '${calculation['additionalInsurance'].toStringAsFixed(2)} CHF'),
              ],
            ),
            _buildSection(
              context,
              'calculationSettings',
              [
                _buildDetailRow(
                    LanguageService.tr(context, 'thirteenthSalary'),
                    calculation['has13thSalary'] == true
                        ? LanguageService.tr(context, 'yes')
                        : LanguageService.tr(context, 'no')),
                _buildDetailRow(
                    LanguageService.tr(context, 'useCustomTaxRate'),
                    calculation['useCustomTaxRate'] == true
                        ? LanguageService.tr(context, 'yes')
                        : LanguageService.tr(context, 'no')),
                if (calculation['useCustomTaxRate'] == true)
                  _buildDetailRow(LanguageService.tr(context, 'customTaxRate'),
                      '${calculation['customTaxRate'].toStringAsFixed(1)}%'),
              ],
            ),
            if (calculation['deductions'] != null)
              _buildSection(
                context,
                'deductions',
                (calculation['deductions'] as List).map((deduction) {
                  return _buildDetailRow(
                    deduction['label'],
                    '${deduction['isDeduction'] ? '-' : ''}${deduction['amount'].toStringAsFixed(2)} CHF',
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String titleKey, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LanguageService.tr(context, titleKey),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String labelKey, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(labelKey),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
