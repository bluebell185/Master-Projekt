import 'package:flutter/material.dart';
import 'package:master_projekt/analysis_results.dart';
import 'package:master_projekt/ui/buttons.dart';

// Das Pop-Up zur Überprüfung der Analysis Results und möglicher Modifikation des Users
// TO DO

class ResultsCheck extends StatelessWidget {
  const ResultsCheck({super.key, required this.title});

  final String title;

// ALS POP UP BAUEN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // CTA Button unten, schließt das Pop-Up und switched zu AnalysisResults()
          PrimaryButton(
            buttonText: 'save',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AnalysisResults(title: 'Analysis Results'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
