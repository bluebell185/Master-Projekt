import 'package:flutter/material.dart';
import 'package:master_projekt/screen_with_deepar_camera.dart';
import 'package:master_projekt/ui/tabs.dart';
import 'results_check.dart';
import 'analysis_results.dart';

// UI-Elemente
import 'package:master_projekt/ui/text.dart';
import 'package:master_projekt/ui/toolbar.dart';

class FeatureOne extends StatefulWidget {
  const FeatureOne({super.key});

  @override
  State<FeatureOne> createState() => FeatureOneState();
}

bool showRecommendations =
    false; // boolean zum Anzeigen von Frame mit Box 2 und 3

final DraggableScrollableController draggableController =
    DraggableScrollableController();

class FeatureOneState extends State<FeatureOne> {
  bool isBox2Or3Visible = false; // Zustandsabfrage: ist Box 2 oder 3 sichtbar?
  String? newSelectedTab;
  bool isBoxThreeOpen = false; // zur Navigation zwischen Box 2 und 3

  // DraggableScrollableController für die Position
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  void navigateToBoxThree() {
    setState(() {
      isBoxThreeOpen = true;
    });
  }

  void navigateToBoxTwo() {
    setState(() {
      isBoxThreeOpen = false;
    });
  }

  void updateSelectedTab(String? tab) {
    setState(() {
      //newSelectedTab = tab; // Update den Parent state
      if (newSelectedTab == tab) {
        // Wenn der Tab bereits ausgewählt ist, deselektiere ihn
        newSelectedTab = null;
        selectedIndex = null;
        isBox2Or3Visible = false;
        print('Deselected Tab');
      } else {
        // Andernfalls wähle den neuen Tab aus
        newSelectedTab = tab;
        print('Selected Tab: $newSelectedTab');
      }
      if (tab == null) {
        // Box 2/3 ist nicht (mehr) sichtbar, sobald ein Tab deselected wurde
        isBox2Or3Visible = false;
      } else {
        // Box 2/3 ist sichtbar, sobald ein Tab ausgewählt wurde
        isBox2Or3Visible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWithDeeparCamera(
      deepArPreviewKey: GlobalKey(),
      isAfterAnalysis: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ScreenTitle(
                    titleText: 'Analysis',
                    titleColor: Colors.white,
                  ),
                ],
              ),
            ),
            Toolbar(),
            if (!showRecommendations)
              ResultsCheckPopUp(
                popUpHeading: 'Your analysis results',
                analysisElements: [
                  // TO DO: ROI-Analyse-Ergebnis aus den Tabs rausnehmen? Drinlassen, aber als default selected?
                  AnalysisElement(
                    number: 1,
                    title: 'Eye color',
                    result:
                        eyeColorCategory!.name, // Results der Gesichtsanalyse
                    options: [
                      'blue',
                      'green',
                      'brown',
                      'grey'
                    ], // Optionen der Kategorie
                    selectedOption: eyeColorCategory!.name,
                    onOptionSelected: (selected) {
                      print('Selected for Eye color: $selected');
                      setEyeColorCategory(selected);
                    },
                  ),
                  AnalysisElement(
                    number: 2,
                    title: 'Eye shape',
                    result:
                        eyeShapeCategory!.name, // Results der Gesichtsanalyse
                    options: [
                      'almond',
                      'round',
                      'upturned',
                      'downturned' //,
                      //'monolid'
                    ], // Optionen der Kategorie
                    selectedOption: eyeShapeCategory!.name,
                    onOptionSelected: (selected) {
                      print('Selected for Eye shape: $selected');
                      setEyeShapeCategory(selected);
                    },
                  ),
                  AnalysisElement(
                    number: 3,
                    title: 'Teint color',
                    result: blushCategory!.name, // Results der Gesichtsanalyse
                    options: [
                      'light',
                      'beige',
                      'olive',
                      'tanned',
                      'dark'
                    ], // Optionen der Kategorie
                    selectedOption: blushCategory!.name,
                    onOptionSelected: (selected) {
                      print('Selected for Head shape: $selected');
                      setBlushCategory(selected);
                    },
                  ),
                  AnalysisElement(
                    number: 4,
                    title: 'Head shape',
                    result:
                        blushShapeCategory!.name, // Results der Gesichtsanalyse
                    options: [
                      'square',
                      'round',
                      'oval'
                    ], // Optionen der Kategorie
                    selectedOption: blushShapeCategory!.name,
                    onOptionSelected: (selected) {
                      print('Selected for Head shape: $selected');
                      setBlushShapeCategory(selected);
                    },
                  ),
                ],
                onSave: () {
                  setState(() {
                    showRecommendations = true;
                  });
                },
              ),
            if (showRecommendations)
              DraggableScrollableSheet(
                key: const GlobalObjectKey(
                    'DraggableScrollableSheet'), // https://github.com/flutter/flutter/issues/140603#issuecomment-1871077425
                controller: draggableController,
                initialChildSize: 0.25,
                minChildSize: 0.25,
                maxChildSize: isBox2Or3Visible ? 0.8 : 0.25,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: AnalysisResults(
                      selectedTab:
                          newSelectedTab, // weitergeben des geupdateten ausgewählten Tabs an AnalysisResults
                      isBoxThreeOpen: isBoxThreeOpen,
                      onNavigateToBoxThree: navigateToBoxThree,
                      onNavigateToBoxTwo: navigateToBoxTwo,
                      onTabSelected:
                          updateSelectedTab, // Update an widget.selectedTab in AnalysisResults, wenn sich Tab ändert
                      scrollController: scrollController,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    //_draggableController.dispose();
    super.dispose();
  }
}
