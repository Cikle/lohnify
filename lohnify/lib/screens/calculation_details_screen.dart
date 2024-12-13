import 'package:flutter/material.dart';
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
                _buildDetailRow('grossSalary', '${calculation['grossSalary'].toStringAsFixed(2)} CHF'),
                _buildDetailRow('canton', calculation['canton'] ?? 'N/A'),
                _buildDetailRow('netSalary', '${calculation['netSalary'].toStringAsFixed(2)} CHF'),
              ],
            ),
            _buildSection(
              context,
              'personalInfo',
              [
                _buildDetailRow('married', calculation['isMarried'] == true ? 'Ja' : 'Nein'),
                _buildDetailRow('churchTax', calculation['hasChurchTax'] == true ? 'Ja' : 'Nein'),
                if (calculation['numberOfChildren'] != null)
                  _buildDetailRow('numberOfChildren', calculation['numberOfChildren'].toString()),
              ],
            ),
            _buildSection(
              context,
              'additionalInsurance',
              [
                if (calculation['pensionRate'] != null)
                  _buildDetailRow('pensionFund', '${calculation['pensionRate'].toString()}%'),
                if (calculation['additionalInsurance'] != null)
                  _buildDetailRow('additionalInsuranceCHF', '${calculation['additionalInsurance'].toStringAsFixed(2)} CHF'),
              ],
            ),
            _buildSection(
              context,
              'calculationSettings',
              [
                _buildDetailRow('thirteenthSalary', calculation['has13thSalary'] == true ? 'Ja' : 'Nein'),
                _buildDetailRow('useCustomTaxRate', calculation['useCustomTaxRate'] == true ? 'Ja' : 'Nein'),
                if (calculation['customTaxRate'] != null)
                  _buildDetailRow('customTaxRate', '${calculation['customTaxRate'].toString()}%'),
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
