import 'package:flutter/material.dart';

// UI-Elemente
import 'package:master_projekt/ui/buttons.dart';
import 'package:master_projekt/ui/tabs.dart';
import 'package:master_projekt/ui/tabs_for_popup.dart';

// Das Pop-Up zur Überprüfung der Analysis Results und möglicher Modifikation des Users

// Pop Up
class ResultsCheckPopUp extends StatefulWidget {
  final String popUpHeading;
  final List<AnalysisElement> analysisElements;
  final VoidCallback onSave;

  const ResultsCheckPopUp({
    super.key,
    required this.popUpHeading,
    required this.analysisElements,
   required this.onSave,
  });

  @override
  State<ResultsCheckPopUp> createState() => ResultsCheckPopUpState();
}
class ResultsCheckPopUpState extends State<ResultsCheckPopUp> {
  late Map<int, String> selectedOptions; // Key: Nummer, Value: ausgewählte Option

  @override
  void initState() {
    super.initState();
    // Initialisiere die ausgewählten Optionen mit den vorgegebenen Werten
    selectedOptions = {
      for (var element in widget.analysisElements)
        element.number: element.selectedOption
    };
  }

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
              widget.popUpHeading,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Chicle',
              ),
            ),
            const SizedBox(height: 20),

            // Analysis Elements
            ...widget.analysisElements
                .map((element) => _buildAnalysisElement(element)),

            const SizedBox(height: 40),

            // Save Button
            PrimaryButton(
              buttonText: 'save',
              onPressed: widget.onSave,
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
      ScrollableTabsPopup(
          labels: element.options, // Tab Labels
          onTabSelected: (tab) {
            if (tab != null) {
              setState(() {
                selectedOptions[element.number] = tab;
              });
              element.onOptionSelected(tab);
            }
          },
          selectedTab: selectedOptions[element.number], // Highlight-Logik
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
  final String selectedOption;
  final Function(String) onOptionSelected;

  AnalysisElement({
    required this.number,
    required this.title,
    required this.result,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });
}
