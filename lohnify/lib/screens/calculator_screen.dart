import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/contribution_rates.dart';
import '../models/salary_calculation.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _salaryController = TextEditingController();
  SalaryCalculation? _calculation;
  final _rates = ContributionRates();

  void _calculateSalary() {
    if (_formKey.currentState?.validate() ?? false) {
      final grossSalary = double.parse(_salaryController.text);
      setState(() {
        _calculation = SalaryCalculation.calculate(grossSalary, _rates);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swiss Salary Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(
                  labelText: 'Gross Salary (CHF)',
                  hintText: 'Enter your gross salary',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a salary';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateSalary,
                child: const Text('Calculate'),
              ),
              if (_calculation != null) ...[
                const SizedBox(height: 20),
                _buildResultCard('Gross Salary', _calculation!.grossSalary),
                _buildResultCard('AHV Deduction', _calculation!.ahvDeduction),
                _buildResultCard('IV Deduction', _calculation!.ivDeduction),
                _buildResultCard('EO Deduction', _calculation!.eoDeduction),
                _buildResultCard('ALV Deduction', _calculation!.alvDeduction),
                _buildResultCard('Net Salary', _calculation!.netSalary),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(String label, double amount) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              '${amount.toStringAsFixed(2)} CHF',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }
}
