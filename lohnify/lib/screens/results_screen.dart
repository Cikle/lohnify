import 'package:flutter/material.dart';
import '../models/salary_calculation.dart';
import '../services/language_service.dart';

class ResultsScreen extends StatelessWidget {
  final SalaryCalculation calculation;
  final bool has13thSalary;

  const ResultsScreen({
    super.key,
    required this.calculation,
    required this.has13thSalary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageService.tr(context, 'results')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultCard(
              LanguageService.tr(context, 'monthlyGross'),
              calculation.grossSalary,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.green,
              ),
            ),
            const Divider(thickness: 1.5),
            ...calculation.deductionItems.map(
              (item) => _buildResultCard(
                item.label,
                item.amount,
                isDeduction: item.isDeduction,
              ),
            ),
            const Divider(thickness: 2),
            _buildResultCard(
              LanguageService.tr(context, 'totalDeductions'),
              calculation.deductionItems
                  .where((item) => item.isDeduction)
                  .fold(0.0, (sum, item) => sum + item.amount),
              isDeduction: true,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            _buildResultCard(
              LanguageService.tr(context, 'monthlyNet'),
              calculation.netSalary,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            if (has13thSalary) ...[
              const Divider(),
              _buildResultCard(
                '${LanguageService.tr(context, 'yearlyGross')} (inkl. 13.)',
                calculation.yearlyGross,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildResultCard(
                '${LanguageService.tr(context, 'yearlyNet')} (inkl. 13.)',
                calculation.yearlyNet,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ] else ...[
              const Divider(),
              _buildResultCard(
                LanguageService.tr(context, 'yearlyGross'),
                calculation.yearlyGross,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildResultCard(
                LanguageService.tr(context, 'yearlyNet'),
                calculation.yearlyNet,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(
    String label,
    double amount, {
    bool isDeduction = false,
    TextStyle? style,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              '${isDeduction ? "-" : ""}${amount.toStringAsFixed(2)} CHF',
              style: style ??
                  TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDeduction ? Colors.red : null,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
