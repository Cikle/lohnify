import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/contribution_rates.dart';
import '../models/salary_calculation.dart';
import '../services/language_service.dart'; // Import the LanguageService
import 'results_screen.dart'; // Import the ResultsScreen
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'dart:convert'; // Import dart:convert for json encoding

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
  bool _isEmployerView = false; // Define _isEmployerView

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
                              '${ContributionRates.defaultCantons[_selectedCanton]?.name ?? ''} ($_selectedCanton) - ${ContributionRates.defaultCantons[_selectedCanton]?.taxRate.toStringAsFixed(1)}%'),
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
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _calculateSalary();
                        if (_calculation != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultsScreen(
                                calculation: _calculation!,
                                has13thSalary: _has13thSalary,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(LanguageService.tr(context, 'calculate')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: _calculation == null
                          ? null
                          : () async {
                              await _saveCalculation();
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    LanguageService.tr(
                                        context, 'calculationSaved'),
                                  ),
                                ),
                              );
                            },
                      icon: const Icon(Icons.save),
                      label:
                          Text(LanguageService.tr(context, 'saveCalculation')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _formKey.currentState?.reset();
                          _calculation = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              LanguageService.tr(context, 'calculationDeleted'),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                      label:
                          Text(LanguageService.tr(context, 'resetCalculator')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveCalculation() async {
    if (_calculation == null) return;

    final calculations = _prefs.getStringList('saved_calculations') ?? [];
    final calculationData = {
      'date': DateTime.now().toIso8601String(),
      'grossSalary': _calculation!.grossSalary,
      'netSalary': _calculation!.netSalary,
      'isEmployerView': _isEmployerView,
      'canton': _selectedCanton,
    };

    calculations.add(json.encode(calculationData));
    await _prefs.setStringList('saved_calculations', calculations);
  }

  @override
  void dispose() {
    _salaryController.dispose();
    super.dispose();
  }
}
