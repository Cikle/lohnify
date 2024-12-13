import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/language_service.dart';

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              'basicInfo',
              [
                _buildDetailRow(LanguageService.tr(context, 'grossSalary'), '${calculation['grossSalary'].toStringAsFixed(2)} CHF'),
                _buildDetailRow(LanguageService.tr(context, 'canton'), calculation['canton'] ?? 'N/A'),
                _buildDetailRow(LanguageService.tr(context, 'monthlyNet'), '${calculation['netSalary'].toStringAsFixed(2)} CHF'),
                if (calculation['yearlyGross'] != null) ...[
                  if (calculation['has13thSalary'])
                    _buildDetailRow(LanguageService.tr(context, 'yearlyGross'), '${calculation['yearlyGross'].toStringAsFixed(2)} CHF (inkl. 13.)'),
                  if (!calculation['has13thSalary'])
                    _buildDetailRow(LanguageService.tr(context, 'yearlyGross'), '${calculation['yearlyGross'].toStringAsFixed(2)} CHF'),
                ],
                if (calculation['yearlyNet'] != null) ...[
                  if (calculation['has13thSalary'])
                    _buildDetailRow(LanguageService.tr(context, 'yearlyNet'), '${calculation['yearlyNet'].toStringAsFixed(2)} CHF (inkl. 13.)'),
                  if (!calculation['has13thSalary'])
                    _buildDetailRow(LanguageService.tr(context, 'yearlyNet'), '${calculation['yearlyNet'].toStringAsFixed(2)} CHF'),
                ],
                _buildDetailRow(LanguageService.tr(context, 'date'), DateFormat('dd.MM.yyyy HH:mm').format(DateTime.parse(calculation['date']).toLocal())),
              ],
            ),
            _buildSection(
              context,
              'personalInfo',
              [
                _buildDetailRow(
                  LanguageService.tr(context, 'married'),
                  calculation['isMarried'] == true ? LanguageService.tr(context, 'yes') : LanguageService.tr(context, 'no')
                ),
                _buildDetailRow(
                  LanguageService.tr(context, 'churchTax'),
                  calculation['hasChurchTax'] == true ? LanguageService.tr(context, 'yes') : LanguageService.tr(context, 'no')
                ),
                if (calculation['numberOfChildren'] != null)
                  _buildDetailRow(LanguageService.tr(context, 'numberOfChildren'), calculation['numberOfChildren'].toString()),
              ],
            ),
            _buildSection(
              context,
              'additionalInsurance',
              [
                if (calculation['pensionRate'] != null)
                  _buildDetailRow(LanguageService.tr(context, 'pensionFund'), '${calculation['pensionRate'].toString()}%'),
                if (calculation['additionalInsurance'] != null)
                  _buildDetailRow(LanguageService.tr(context, 'additionalInsuranceCHF'), '${calculation['additionalInsurance'].toStringAsFixed(2)} CHF'),
              ],
            ),
            _buildSection(
              context,
              'calculationSettings',
              [
                _buildDetailRow(
                  LanguageService.tr(context, 'thirteenthSalary'),
                  calculation['has13thSalary'] == true ? LanguageService.tr(context, 'yes') : LanguageService.tr(context, 'no')
                ),
                _buildDetailRow(
                  LanguageService.tr(context, 'useCustomTaxRate'),
                  calculation['useCustomTaxRate'] == true ? LanguageService.tr(context, 'yes') : LanguageService.tr(context, 'no')
                ),
                if (calculation['customTaxRate'] != null)
                  _buildDetailRow(LanguageService.tr(context, 'customTaxRate'), '${calculation['customTaxRate'].toString()}%'),
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

  Widget _buildSection(BuildContext context, String titleKey, List<Widget> children) {
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
