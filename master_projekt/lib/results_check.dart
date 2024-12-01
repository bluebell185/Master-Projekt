import 'package:flutter/material.dart';
import 'package:master_projekt/analysis_results.dart';
import 'package:master_projekt/ui/buttons.dart';
import 'package:master_projekt/ui/tabs.dart';
import 'package:master_projekt/ui/text.dart';
import 'package:master_projekt/ui/toolbar.dart';

// Das Pop-Up zur Überprüfung der Analysis Results und möglicher Modifikation des Users

class ResultsCheck extends StatelessWidget {
  const ResultsCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background container
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                ScreenTitle(
                  titleText: 'Analysis Results',
                  titleColor: Colors.black,
                ),
              ],
            ),
          ),
          Toolbar(),
          // Container mit Text und CTA
          Positioned(
            left: 0,
            right: 0,
            bottom: 70,
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BodyText(
                        bodyText:
                            'Your AIssistant has finished analyzing your face and found the following key facts. To give you the best recommendations, please check the results and adjust them if needed.',
                      ),
                      const SizedBox(height: 40),

                      // CTA öffnet Pop Up
                      Center(
                        child: PrimaryButton(
                          onPressed: () {
                            _showResultsCheckDialog(
                                context); // und Hintergrund clearen?
                          },
                          buttonText: 'show analysis results',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Spezifizieren von Content in Pop Up
  void _showResultsCheckDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ResultsCheckPopUp(
        popUpHeading: 'Your analysis results',
        analysisElements: [
          // TO DO: ROI-Analyse-Ergebnis aus den Tabs rausnehmen? Drinlassen, aber als default selected?
          AnalysisElement(
            number: 1,
            title: 'Eye color',
            result: 'blue', // Results der Gesichtsanalyse
            options: [
              'blue',
              'green',
              'brown',
              'grey'
            ], // Optionen der Kategorie
            //selectedOption: $result,
            onOptionSelected: (selected) {
              print('Selected for Eye color: $selected');
            },
          ),
          AnalysisElement(
            number: 2,
            title: 'Eye shape',
            result: 'round', // Results der Gesichtsanalyse
            options: [
              'almond',
              'round',
              'upturned',
              'downturned',
              'monolid'
            ], // Optionen der Kategorie
            //selectedOption: $result,
            onOptionSelected: (selected) {
              print('Selected for Eye shape: $selected');
            },
          ),
          AnalysisElement(
            number: 3,
            title: 'Teint color',
            result: 'beige', // Results der Gesichtsanalyse
            options: [
              'light/pale',
              'beige',
              'olive',
              'tanned',
              'dark'
            ], // Optionen der Kategorie
            //selectedOption: $result,
            onOptionSelected: (selected) {
              print('Selected for Head shape: $selected');
            },
          ),
          AnalysisElement(
            number: 3,
            title: 'Head shape',
            result: 'oval', // Results der Gesichtsanalyse
            options: ['square', 'round', 'oval'], // Optionen der Kategorie
            //selectedOption: $result,
            onOptionSelected: (selected) {
              print('Selected for Head shape: $selected');
            },
          ),
        ],
        onSave: () {
          print('save');
          Navigator.pop(context);
        },
        title: '',
      ),
    );
  }
}

// Pop Up
class ResultsCheckPopUp extends StatelessWidget {
  final String title;
  final String popUpHeading;
  final List<AnalysisElement> analysisElements;
  final VoidCallback onSave;

  const ResultsCheckPopUp({
    super.key,
    required this.popUpHeading,
    required this.analysisElements,
    required this.onSave,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF1EADD),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Heading
            Text(
              popUpHeading,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Chicle',
              ),
            ),
            const SizedBox(height: 20),

            // Analysis Elements
            ...analysisElements
                .map((element) => _buildAnalysisElement(element)),

            const SizedBox(height: 40),

            // Save Button
            PrimaryButton(
              buttonText: 'save',
              onPressed: () {
                // Navigiert zu AnalysisResults
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AnalysisResults(title: 'Analysis Results'),
                  ),
                  // sollte die Key Facts abspeichern bzw. überschreiben
                );
              },
            ),
          ],
        ),
      ),
    );
  }

/* Analysis Element-Block:
- Kreis + Zahl
- ROI-Titel + ROI-Analyse-Ergebnis
- Kategorie basierende Tabs
*/

  Widget _buildAnalysisElement(AnalysisElement element) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Kreis mit Zahl drin
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFBA4C1),
              ),
              child: Center(
                child: Text(
                  element.number.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // ROI Titel und ROI-Analyse-Ergebnis
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: element.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: '  '),
                  TextSpan(
                    text: element.result,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ScrollableTabs(
          labels: element.options, // Tab Labels
          onTabSelected: (index) {
            if (index == null) {
              print('No option selected');
            } else {
              element.onOptionSelected(element.options[index]);
            }
          },
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class AnalysisElement {
  final int number;
  final String title;
  final String result;
  final List<String> options;
  //final String selectedOption;
  final Function(String) onOptionSelected;

  AnalysisElement({
    required this.number,
    required this.title,
    required this.result,
    required this.options,
    //required.this.selectedOption,
    required this.onOptionSelected,
  });
}
