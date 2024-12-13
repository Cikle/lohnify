import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/language_service.dart';
import 'results_screen.dart';
import '../models/salary_calculation.dart';

class SavedCalculationsScreen extends StatefulWidget {
  const SavedCalculationsScreen({super.key});

  @override
  State<SavedCalculationsScreen> createState() => _SavedCalculationsScreenState();
}

class _SavedCalculationsScreenState extends State<SavedCalculationsScreen> {
  List<Map<String, dynamic>> _savedCalculations = [];

  @override
  void initState() {
    super.initState();
    _loadSavedCalculations();
  }

  Future<void> _loadSavedCalculations() async {
    final prefs = await SharedPreferences.getInstance();
    final calculations = prefs.getStringList('saved_calculations') ?? [];
    setState(() {
      _savedCalculations = calculations
          .map((str) => json.decode(str) as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> _deleteCalculation(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final calculations = prefs.getStringList('saved_calculations') ?? [];
    calculations.removeAt(index);
    await prefs.setStringList('saved_calculations', calculations);
    setState(() {
      _savedCalculations.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageService.tr(context, 'savedCalculations')),
      ),
      body: _savedCalculations.isEmpty
          ? Center(
              child: Text(LanguageService.tr(context, 'noSavedCalculations')),
            )
          : ListView.builder(
              itemCount: _savedCalculations.length,
              itemBuilder: (context, index) {
                final calculation = _savedCalculations[index];
                final date = DateTime.parse(calculation['date']);
                final isEmployerView = calculation['isEmployerView'] as bool;
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      isEmployerView ? Icons.business : Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      '${calculation['grossSalary'].toStringAsFixed(2)} CHF',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${LanguageService.tr(context, isEmployerView ? 'employerView' : 'employeeView')}\n'
                      '${date.day}.${date.month}.${date.year}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteCalculation(index),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
