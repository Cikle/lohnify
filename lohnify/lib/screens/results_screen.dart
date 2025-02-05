import 'package:flutter/material.dart';
import '../models/salary_calculation.dart';
import '../services/language_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contribution_rates.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../services/view_type_provider.dart';

class ResultsScreen extends StatefulWidget {
  final SalaryCalculation calculation;
  final bool has13thSalary;
  final bool isMarried;
  final bool hasChurchTax;
  final int numberOfChildren;

  const ResultsScreen({
    super.key,
    required this.calculation,
    required this.has13thSalary,
    required this.isMarried,
    required this.hasChurchTax,
    required this.numberOfChildren,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  String _getLabelKey(String label, BuildContext context) {
    // First check if the label is already a key
    if (label == 'AHV' || label == 'IV' || label == 'EO' || label == 'ALV') {
      return label;
    }

    // Map of translated texts to their keys
    final labelToKey = {
      LanguageService.tr(context, 'pensionFund'): 'pensionFund',
      LanguageService.tr(context, 'taxes'): 'taxes',
      LanguageService.tr(context, 'ahvEmployer'): 'ahvEmployer',
      LanguageService.tr(context, 'ivEmployer'): 'ivEmployer',
      LanguageService.tr(context, 'eoEmployer'): 'eoEmployer',
      LanguageService.tr(context, 'alvEmployer'): 'alvEmployer',
      LanguageService.tr(context, 'employerNPAIU'): 'employerNPAIU',
      LanguageService.tr(context, 'employerPensionFund'): 'employerPensionFund',
      'AHV (Employer)': 'ahvEmployer',
      'IV (Employer)': 'ivEmployer',
      'EO (Employer)': 'eoEmployer',
      'ALV (Employer)': 'alvEmployer',
      'AVS (Employeur)': 'ahvEmployer',
      'AI (Employeur)': 'ivEmployer',
      'APG (Employeur)': 'eoEmployer',
      'AC (Employeur)': 'alvEmployer',
    };

    return labelToKey[label] ?? label;
  }

  @override
  Widget build(BuildContext context) {
    final isEmployerView =
        Provider.of<ViewTypeProvider>(context, listen: false).isEmployerView;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEmployerView
            ? LanguageService.tr(context, 'employerResults')
            : LanguageService.tr(context, 'results')),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final calculations =
                  prefs.getStringList('saved_calculations') ?? [];

              final calculationData = {
                'date': DateTime.now().toIso8601String(),
                'grossSalary': widget.calculation.grossSalary,
                'netSalary': widget.calculation.netSalary,
                'yearlyGross': widget.calculation.yearlyGross,
                'yearlyNet': widget.calculation.yearlyNet,
                'isEmployerView': isEmployerView,
                'canton': widget.calculation.canton,
                'useCustomTaxRate': widget.calculation.useCustomTaxRate,
                'customTaxRate': widget.calculation.customTaxRate,
                'effectiveTaxRate': widget.calculation.useCustomTaxRate
                    ? widget.calculation.customTaxRate
                    : ContributionRates
                        .defaultCantons[widget.calculation.canton ?? 'ZH']
                        ?.taxRate,
                'hasChurchTax': widget.hasChurchTax,
                'numberOfChildren': widget.numberOfChildren,
                'has13thSalary': widget.has13thSalary,
                'isMarried': widget.isMarried,
                'deductions': widget.calculation
                    .getDeductionItems(context)
                    .where((item) =>
                        item.label !=
                        LanguageService.tr(context, 'marriageTaxDeduction'))
                    .map((item) => {
                          'label': _getLabelKey(item.label, context),
                          'amount': item.amount,
                          'isDeduction': item.isDeduction,
                          'info': item.info,
                          'isEmployerContribution': item.isEmployerContribution,
                        })
                    .toList(),
                'totalEmployerCosts': widget.calculation.totalEmployerCosts,
              };

              calculations.add(json.encode(calculationData));
              await prefs.setStringList('saved_calculations', calculations);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(LanguageService.tr(context, 'calculationSaved')),
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
            _buildResultCard(
              isEmployerView
                  ? LanguageService.tr(context, 'totalEmployerCosts')
                  : LanguageService.tr(context, 'monthlyGross'),
              isEmployerView
                  ? widget.calculation.totalEmployerCosts
                  : widget.calculation.grossSalary,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.green,
              ),
            ),
            const Divider(thickness: 1.5),
            ...widget.calculation.getDeductionItems(context).where((item) {
              if (!isEmployerView) {
                // In employee view, exclude ALL employer-related items
                if (item.isEmployerContribution ||
                    item.label.contains('(Employer)') ||
                    item.label.contains('(Arbeitgeber)') ||
                    item.label.contains('(Employeur)') ||
                    item.label.contains('Employer') ||
                    item.label.contains('employer') ||
                    item.label.contains('Arbeitgeber') ||
                    item.label.contains('Employeur')) {
                  return false;
                }
              }
              return item.label !=
                  LanguageService.tr(context, 'marriageTaxDeduction');
            }).map(
              (item) => _buildResultCard(
                item.label,
                item.amount,
                isDeduction: item.isDeduction,
              ),
            ),
            const Divider(thickness: 2),
            _buildResultCard(
              LanguageService.tr(context, 'totalDeductions'),
              widget.calculation
                  .getDeductionItems(context)
                  .where((item) =>
                      item.isDeduction &&
                      (!item.isEmployerContribution || isEmployerView))
                  .fold(0.0, (sum, item) => sum + item.amount),
              isDeduction: true,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            if (widget.isMarried) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LanguageService.tr(context, 'marriageTaxDeduction'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        LanguageService.tr(context, 'marriageTaxBenefitInfo'),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(LanguageService.tr(context, 'monthlyBenefit')),
                          Text(
                            '${(widget.calculation.grossSalary * 0.02).toStringAsFixed(2)} CHF',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (widget.numberOfChildren > 0) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LanguageService.tr(context, 'childBenefits'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${LanguageService.tr(context, 'baseAllowance')} (${LanguageService.tr(context, 'perChild')})'),
                          Text('200.00 CHF'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(LanguageService.tr(context, 'monthlyBenefit')),
                          Text(
                              '${(widget.numberOfChildren * 200).toStringAsFixed(2)} CHF'),
                        ],
                      ),
                      const Divider(height: 16),
                      ...List.generate(widget.numberOfChildren, (index) {
                        final percentage = 2.0 + (index * 0.5);
                        final benefit =
                            widget.calculation.grossSalary * (percentage / 100);
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${LanguageService.tr(context, 'childTaxReduction')} ${index + 1}'),
                                Text('${percentage.toStringAsFixed(1)}%'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(LanguageService.tr(
                                    context, 'monthlyBenefit')),
                                Text('${benefit.toStringAsFixed(2)} CHF'),
                              ],
                            ),
                            if (index < widget.numberOfChildren - 1)
                              const Divider(height: 16),
                          ],
                        );
                      }),
                      const SizedBox(height: 8),
                      Text(
                        '${LanguageService.tr(context, 'totalChildBenefits')}: ${(widget.numberOfChildren * 200 + List.generate(widget.numberOfChildren, (index) => widget.calculation.grossSalary * ((2.0 + (index * 0.5)) / 100)).reduce((a, b) => a + b)).toStringAsFixed(2)} CHF',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            _buildResultCard(
              LanguageService.tr(context, 'monthlyNet'),
              widget.calculation.netSalary,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            if (widget.has13thSalary) ...[
              const Divider(),
              _buildResultCard(
                '${LanguageService.tr(context, 'yearlyGross')} (inkl. 13.)',
                widget.calculation.yearlyGross,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildResultCard(
                '${LanguageService.tr(context, 'yearlyNet')} (inkl. 13.)',
                widget.calculation.yearlyNet,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ] else ...[
              const Divider(),
              _buildResultCard(
                LanguageService.tr(context, 'yearlyGross'),
                widget.calculation.yearlyGross,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildResultCard(
                LanguageService.tr(context, 'yearlyNet'),
                widget.calculation.yearlyNet,
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
    final deductionItem = widget.calculation
        .getDeductionItems(context)
        .firstWhere((item) => item.label == label,
            orElse: () => DeductionItem(
                  label,
                  amount,
                  isDeduction: isDeduction,
                  info: null,
                  isEmployerContribution: false,
                ));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label),
                Text(
                  '${isDeduction ? "-" : ""}${amount.toStringAsFixed(2)} CHF',
                  style: style ??
                      TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDeduction ? Colors.red : Colors.green,
                      ),
                ),
              ],
            ),
            if (deductionItem.info != null) ...[
              const SizedBox(height: 4),
              Text(
                deductionItem.info!,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
