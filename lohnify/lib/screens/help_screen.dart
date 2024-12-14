import 'package:flutter/material.dart';
import '../services/language_service.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageService.tr(context, 'helpAndSupport')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHelpSection(
            context,
            'calculatorHelp',
            'calculatorHelpContent',
            Icons.calculate,
          ),
          _buildHelpSection(
            context,
            'viewDifference',
            'employerViewInfo',
            Icons.business,
          ),
          _buildHelpSection(
            context,
            'taxesHelp',
            'taxesHelpContent',
            Icons.account_balance,
          ),
          _buildHelpSection(
            context,
            'insuranceHelp',
            'insuranceHelpContent',
            Icons.health_and_safety,
          ),
          _buildHelpSection(
            context,
            'savingHelp',
            'savingHelpContent',
            Icons.save,
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(
    BuildContext context,
    String titleKey,
    String contentKey,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        leading: Icon(icon),
        title: Text(LanguageService.tr(context, titleKey)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(LanguageService.tr(context, contentKey)),
          ),
        ],
      ),
    );
  }
}
