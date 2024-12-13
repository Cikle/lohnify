import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/contribution_rates.dart';
import '../models/salary_calculation.dart';
import '../services/language_service.dart'; // Import the LanguageService
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _salaryController = TextEditingController();
  final _childrenController = TextEditingController();
  final _pensionController = TextEditingController();
  final _additionalInsuranceController = TextEditingController();
  final _customTaxRateController = TextEditingController();
  late SharedPreferences _prefs;
  bool _useCustomTaxRate = false;
  SalaryCalculation? _calculation;
  final _rates = ContributionRates();

  bool _isMarried = false;
  bool _hasChurchTax = false;
  String _selectedCanton = 'ZH';
  bool _has13thSalary = true;

  void _calculateSalary() {
    if (_formKey.currentState?.validate() ?? false) {
      final grossSalary = double.parse(_salaryController.text);
      final childrenCount = int.tryParse(_childrenController.text) ?? 0;
      final customTaxRate = double.tryParse(_customTaxRateController.text);
      setState(() {
        _calculation = SalaryCalculation.calculate(
          grossSalary,
          _rates,
          has13thSalary: _has13thSalary,
          pensionRate: double.tryParse(_pensionController.text) ??
              _rates.defaultPensionRate,
          additionalInsurance:
              double.tryParse(_additionalInsuranceController.text) ?? 0.0,
          hasChurchTax: _hasChurchTax,
          isMarried: _isMarried,
          numberOfChildren: childrenCount,
          customTaxRate: customTaxRate,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _useCustomTaxRate = _prefs.getBool('use_custom_tax_rate') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageService.tr(context, 'calculator')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                        LanguageService.tr(context, 'basicInfo'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _salaryController,
                        decoration: InputDecoration(
                          labelText: LanguageService.tr(context, 'grossSalary'),
                          hintText:
                              LanguageService.tr(context, 'enterGrossSalary'),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LanguageService.tr(
                                context, 'pleaseEnterSalary');
                          }
                          if (double.tryParse(value) == null) {
                            return LanguageService.tr(
                                context, 'pleaseEnterValidNumber');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (!_useCustomTaxRate)
                        ListTile(
                          title: Text(LanguageService.tr(context, 'canton')),
                          subtitle: Text(
                              '${ContributionRates.defaultCantons[_selectedCanton]?.name ?? ''} ($_selectedCanton)'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => SimpleDialog(
                                title: Text(LanguageService.tr(
                                    context, 'chooseCanton')),
                                children:
                                    ContributionRates.defaultCantons.entries
                                        .map(
                                          (canton) => SimpleDialogOption(
                                            onPressed: () {
                                              setState(() =>
                                                  _selectedCanton = canton.key);
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                                '${canton.value.name} (${canton.key})'),
                                          ),
                                        )
                                        .toList(),
                              ),
                            );
                          },
                        ),
                      if (_useCustomTaxRate) ...[
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _customTaxRateController,
                          decoration: InputDecoration(
                            labelText:
                                LanguageService.tr(context, 'customTaxRate'),
                            hintText: ContributionRates
                                .defaultCantons[_selectedCanton]?.taxRate
                                .toString(),
                            suffixText: '%',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LanguageService.tr(
                                  context, 'pleaseEnterTaxRate');
                            }
                            final rate = double.tryParse(value);
                            if (rate == null || rate < 0 || rate > 100) {
                              return LanguageService.tr(
                                  context, 'invalidTaxRate');
                            }
                            return null;
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Persönliche Angaben',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Verheiratet'),
                        value: _isMarried,
                        onChanged: (value) {
                          setState(() => _isMarried = value);
                          _calculateSalary();
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Kirchensteuer'),
                        value: _hasChurchTax,
                        onChanged: (value) {
                          setState(() => _hasChurchTax = value);
                        },
                      ),
                      TextFormField(
                        controller: _childrenController,
                        decoration: const InputDecoration(
                          labelText: 'Anzahl Kinder',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _calculateSalary();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Zusätzliche Versicherungen',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _pensionController,
                        decoration: const InputDecoration(
                          labelText: 'Pensionskasse (%)',
                          hintText: 'Optional',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _additionalInsuranceController,
                        decoration: const InputDecoration(
                          labelText: 'Zusatzversicherungen (CHF)',
                          hintText: 'Optional',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('13. Monatslohn'),
                subtitle: const Text('Auf Jahresbasis berechnen'),
                value: _has13thSalary,
                onChanged: (value) {
                  setState(() => _has13thSalary = value);
                  _calculateSalary(); // Recalculate when 13th month is toggled
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateSalary,
                child: const Text('Calculate'),
              ),
              if (_calculation != null) ...[
                const SizedBox(height: 20),
                _buildResultCard('Bruttolohn', _calculation!.grossSalary),
                const Divider(),
                ..._calculation!.deductionItems.map(
                  (item) => _buildResultCard(
                    item.label,
                    item.amount,
                    isDeduction: item.isDeduction,
                  ),
                ),
                const Divider(thickness: 2),
                _buildResultCard(
                  'Nettolohn',
                  _calculation!.netSalary,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                if (_has13thSalary) ...[
                  const Divider(),
                  _buildResultCard(
                      'Jahresbrutto (inkl. 13.)', _calculation!.yearlyGross),
                  _buildResultCard(
                      'Jahresnetto (inkl. 13.)', _calculation!.yearlyNet),
                ] else ...[
                  const Divider(),
                  _buildResultCard('Jahresbrutto', _calculation!.yearlyGross),
                  _buildResultCard('Jahresnetto', _calculation!.yearlyNet),
                ],
              ],
            ],
          ),
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

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }
}
