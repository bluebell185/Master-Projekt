import 'package:flutter/material.dart';

// UI-Elemente
import 'package:master_projekt/ui/buttons.dart';
import 'package:master_projekt/ui/tabs_for_occasion.dart';

// Das Pop-Up zur Beschreibung der gewünschten Occasion

// Pop Up
class OccasionDescription extends StatefulWidget {
  final String popUpHeading;
  final List<Question> question;
  final ValueChanged<Map<int, String>> onSave; // zum Mapping der Antworten

  const OccasionDescription({
    super.key,
    required this.popUpHeading,
    required this.question,
    required this.onSave,
  });

  @override
  State<OccasionDescription> createState() => OccasionDescriptionState();
}

class OccasionDescriptionState extends State<OccasionDescription> {
  late Map<int, String>
      selectedOptions; // Key: Nummer, Value: ausgewählte Option

  @override
  void initState() {
    super.initState();
    // Initialisiere die ausgewählten Optionen mit den vorgegebenen Werten
    selectedOptions = {
      for (var question in widget.question)
        question.number: question.selectedOption
    };
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
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

                // Occasion-Questions
                ...widget.question.map((question) => _buildQuestion(question)),

                const SizedBox(height: 20),

                // Save Button
                PrimaryButton(
                  buttonText: 'create look',
                  onPressed: () => widget.onSave(selectedOptions),
                ),
              ],
            ),
          ),
        ));
  }

/* Question Element-Block:
- Kreis + Zahl
- Occasion-Question
- Antworten als Tabs
*/

  Widget _buildQuestion(Question question) {
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
                  question.number.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Question zur Occasion
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: question.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // const TextSpan(text: '  '),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ScrollableTabsPopup(
          labels: question.options, // Tab Labels
          onTabSelected: (tab) {
            if (tab != null) {
              setState(() {
                selectedOptions[question.number] = tab;
              });
              question.onOptionSelected(tab);
            }
          },
          selectedTab: selectedOptions[question.number], // Highlight-Logik
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class Question {
  final int number;
  final String title;
  final List<String> options;
  final String selectedOption;
  final Function(String) onOptionSelected;

  Question({
    required this.number,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });
}
