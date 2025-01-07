import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/view_type_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/language_service.dart';
import '../models/salary_calculation.dart';
import 'results_screen.dart';
import '../models/contribution_rates.dart';
import 'dart:convert';

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
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final calculations =
                  prefs.getStringList('saved_calculations') ?? [];

              // Find and remove the current calculation
              final index = calculations.indexWhere((calc) {
                final decodedCalc = json.decode(calc);
                return decodedCalc['date'] == calculation['date'];
              });

              if (index != -1) {
                calculations.removeAt(index);
                await prefs.setStringList('saved_calculations', calculations);

                if (!context.mounted) return;
                Navigator.pop(context, true); // Return with refresh trigger
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(LanguageService.tr(context, 'calculationDeleted')),
                  ),
                );
              }
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
                    context,
                    calculation['isEmployerView'] == true
                        ? LanguageService.tr(context, 'totalEmployerCosts')
                        : LanguageService.tr(context, 'grossSalary'),
                    calculation['isEmployerView'] == true
                        ? '${(calculation['totalEmployerCosts'] ?? 0.0).toStringAsFixed(2)} CHF'
                        : '${(calculation['grossSalary'] ?? 0.0).toStringAsFixed(2)} CHF'),
                _buildDetailRow(
                    context,
                    calculation['useCustomTaxRate'] == true
                        ? LanguageService.tr(context, 'customTaxRate')
                        : LanguageService.tr(context, 'canton'),
                    calculation['useCustomTaxRate'] == true
                        ? '${calculation['effectiveTaxRate'].toStringAsFixed(1)}%'
                        : '${ContributionRates.defaultCantons[calculation['canton']]?.name} - ${calculation['effectiveTaxRate'].toStringAsFixed(1)}%'),
                _buildDetailRow(
                    context,
                    LanguageService.tr(context, 'monthlyNet'),
                    '${calculation['netSalary'].toStringAsFixed(2)} CHF'),
                if (calculation['yearlyGross'] != null) ...[
                  if (calculation['has13thSalary'])
                    _buildDetailRow(
                        context,
                        LanguageService.tr(context, 'yearlyGross'),
                        '${calculation['yearlyGross'].toStringAsFixed(2)} CHF (inkl. 13.)'),
                  if (!calculation['has13thSalary'])
                    _buildDetailRow(
                        context,
                        LanguageService.tr(context, 'yearlyGross'),
                        '${calculation['yearlyGross'].toStringAsFixed(2)} CHF'),
                ],
                if (calculation['yearlyNet'] != null) ...[
                  if (calculation['has13thSalary'])
                    _buildDetailRow(
                        context,
                        LanguageService.tr(context, 'yearlyNet'),
                        '${calculation['yearlyNet'].toStringAsFixed(2)} CHF (inkl. 13.)'),
                  if (!calculation['has13thSalary'])
                    _buildDetailRow(
                        context,
                        LanguageService.tr(context, 'yearlyNet'),
                        '${calculation['yearlyNet'].toStringAsFixed(2)} CHF'),
                ],
                _buildDetailRow(
                    context,
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
                    context,
                    LanguageService.tr(context, 'married'),
                    calculation['isMarried'] == true
                        ? LanguageService.tr(context, 'yes')
                        : LanguageService.tr(context, 'no')),
                _buildDetailRow(
                    context,
                    LanguageService.tr(context, 'churchTax'),
                    calculation['hasChurchTax'] == true
                        ? LanguageService.tr(context, 'yes')
                        : LanguageService.tr(context, 'no')),
                if (calculation['numberOfChildren'] != null)
                  _buildDetailRow(
                      context,
                      LanguageService.tr(context, 'numberOfChildren'),
                      calculation['numberOfChildren'].toString()),
              ],
            ),
            _buildSection(
              context,
              'additionalInsurance',
              [
                if (calculation['pensionRate'] != null)
                  _buildDetailRow(
                      context,
                      LanguageService.tr(context, 'pensionFund'),
                      '${calculation['pensionRate'].toString()}%'),
                if (calculation['additionalInsurance'] != null)
                  _buildDetailRow(
                      context,
                      LanguageService.tr(context, 'additionalInsuranceCHF'),
                      '${calculation['additionalInsurance'].toStringAsFixed(2)} CHF'),
              ],
            ),
            _buildSection(
              context,
              'calculationSettings',
              [
                _buildDetailRow(
                    context,
                    LanguageService.tr(context, 'thirteenthSalary'),
                    calculation['has13thSalary'] == true
                        ? LanguageService.tr(context, 'yes')
                        : LanguageService.tr(context, 'no')),
                _buildDetailRow(
                    context,
                    LanguageService.tr(context, 'useCustomTaxRate'),
                    calculation['useCustomTaxRate'] == true
                        ? LanguageService.tr(context, 'yes')
                        : LanguageService.tr(context, 'no')),
                if (calculation['useCustomTaxRate'] == true)
                  _buildDetailRow(
                      context,
                      LanguageService.tr(context, 'customTaxRate'),
                      '${calculation['customTaxRate'].toStringAsFixed(1)}%'),
              ],
            ),
            if (calculation['deductions'] != null)
              _buildSection(
                context,
                'deductions',
                (calculation['deductions'] as List).map((deduction) {
                  return _buildDetailRow(
                    context,
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

  Widget _buildDetailRow(BuildContext context, String labelKey, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(LanguageService.tr(context, labelKey) != labelKey
              ? LanguageService.tr(context, labelKey)
              : labelKey),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
