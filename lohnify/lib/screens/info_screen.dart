import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informationen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sozialversicherungen',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'AHV: Alters- und Hinterlassenenversicherung\n'
                    'IV: Invalidenversicherung\n'
                    'EO: Erwerbsersatzordnung\n'
                    'ALV: Arbeitslosenversicherung',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
