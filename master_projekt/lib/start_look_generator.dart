import 'package:flutter/material.dart';
import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/feature_one.dart'; // TO DO: ändern zu feature_two
import 'package:master_projekt/main.dart';
import 'package:master_projekt/occasion_description.dart';
// import 'package:master_projekt/json_parse.dart';
// import 'package:master_projekt/screen_with_deepar_camera.dart';
// import 'package:master_projekt/analysis_results.dart';

// UI-Elemente
import 'package:master_projekt/ui/toolbar.dart';
import 'package:master_projekt/ui/text.dart';
import 'package:master_projekt/ui/buttons.dart';

/*-------------- Look Generator: ruft das Pop-Up (OccasionDescrption) auf----------------*/

final String startLookGeneratorWidgetName = 'StartLookGenerator';

// steuert, ob Pop-Up im Stack anzeigen
bool showOccasionDescription = false;

// steuert, ob man zurück navigieren darf
bool isGoingBackAllowedInLookNavigator = false; // hinzugefügt: LOOK Navigator

class StartLookGenerator extends StatefulWidget {
  StartLookGenerator({super.key, required this.title});

  final String title;

  @override
  State<StartLookGenerator> createState() => StartLookGeneratorState();
}

class StartLookGeneratorState extends State<StartLookGenerator> {
  bool isLoading = false; // Ladezustand

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: isGoingBackAllowedInLookNavigator,
        child: CameraWidget(
          title: 'Kamerabild 1',
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                // Main content background container
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title oben
                      ScreenTitle(
                        titleText: 'Look Generator',
                        titleColor: Colors.white,
                      ),
                    ],
                  ),
                ),

                Toolbar(
                  widgetCallingToolbar: startLookGeneratorWidgetName,
                ),

                // CTA Button unten
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 70,
                  child: Center(
                    child: PrimaryButton(
                      buttonText: 'create look',
                      onPressed: () async {
                        setState(() {
                          showOccasionDescription = true;
                          isLoading = true; // falls Ladezustand anzeigen
                        });

/* vielleicht Sparkles hinzufügen?
                          // ScannerWidget in einem Overlay anzeigen
                          await showDialog(
                            context: context,
                            barrierDismissible:
                                false, // nicht manuell schließbar
                            builder: (BuildContext context) {
                              return Scaffold(
                                backgroundColor: Colors.transparent,
                                body: ScannerWidget(),
                              );
                            },
                          );*/
                      },
                    ),
                  ),
                ),

                if (showOccasionDescription)
                  OccasionDescription(
                      popUpHeading: 'Your occasion for today',
                      question: [
                        Question(
                          number: 1,
                          title: 'What is the occasion?',
                          options: [
                            'casual',
                            'business',
                            'party',
                            'wedding',
                            'date night',
                            'festival',
                            'holiday'
                          ], // Antworten zur Frage
                          selectedOption: '', // TO DO
                          onOptionSelected: (selected) {
                            print('Selected for occasion type: $selected');
                          },
                        ),
                        Question(
                          number: 2,
                          title: 'How is the weather like?',
                          options: [
                            'sunny',
                            'rainy',
                            'cloudy',
                            'snowy',
                            'windy',
                            'hot',
                            'cold'
                          ], // Antworten zur Frage
                          selectedOption: '', // TO DO
                          onOptionSelected: (selected) {
                            print('Selected for weather: $selected');
                          },
                        ),
                        Question(
                          number: 3,
                          title: 'What type of look do you desire?',
                          options: [
                            'natural',
                            'glamorous',
                            'bold',
                            'soft',
                            'classic',
                            'minimalistic',
                            'trendy'
                          ], // Antworten zur Frage
                          selectedOption: '', // TO DO
                          onOptionSelected: (selected) {
                            print('Selected for desired look: $selected');
                          },
                        ),
                        Question(
                          number: 4,
                          title: 'What mood do you want to express?',
                          options: [
                            'confident',
                            'romantic',
                            'playful',
                            'edgy',
                            'mysterious',
                            'elegant',
                            'relaxed'
                          ], // Antworten zur Frage
                          selectedOption: '', // TO DO
                          onOptionSelected: (selected) {
                            print('Selected for desired mood: $selected');
                          },
                        ),
                        Question(
                          number: 5,
                          title: 'What kind of vibe do you want to achieve?',
                          options: [
                            'soft & dreamy',
                            'bold & daring',
                            'energetic & fun',
                            'minimalist & clean'
                          ], // Antworten zur Frage
                          selectedOption: '', // TO DO
                          onOptionSelected: (selected) {
                            print('Selected for desired vibe: $selected');
                          },
                        ),
                        Question(
                          number: 6,
                          title: 'How much time do you have to get ready?',
                          options: [
                            '5 minutes',
                            '15 minutes',
                            '30 minutes',
                            'as much as needed'
                          ], // Antworten zur Frage
                          selectedOption: '', // TO DO
                          onOptionSelected: (selected) {
                            print('Selected for available time: $selected');
                          },
                        ),
                      ],
                      onSave: (answersMap) {
                        // Pop-Up ausblenden
                        // TO DO: Antworten speichern!!!!!
                        setState(() {
                          showOccasionDescription = false;
                          isLoading = false;
                        });

                        // Auswertung der Antworten
                        if (answersMap.isNotEmpty) {
                          print("User selections: $answersMap");
                          mapLookToFilter(answersMap);
                        } else {
                          print("Keine Auswahl oder Abbruch des Pop-ups");
                        }
                      }

                      /* async {
                      await stepsToGoToFeatureTwo(context);
                    },*/

                      ),
              ],
            ),
          ),
        ));
  }

  void mapLookToFilter(Map<int, String> selectedOptions) {
    // Mapping der Antworten zu fertigen Look-Filtern
    if (selectedOptions.values
        .toSet()
        .containsAll({'Casual', 'Sunny', 'Natural'})) {
      deepArController.switchEffect('assets/filters/look_natural.deepar');
    } else if (selectedOptions.values
        .toSet()
        .containsAll({'Party', 'Rainy', 'Bold'})) {
      deepArController.switchEffect('assets/filters/look_bold.deepar');
    } else if (selectedOptions.values
        .toSet()
        .containsAll({'Wedding', 'Snowy', 'Soft'})) {
      deepArController.switchEffect('assets/filters/look_romantic.deepar');
    } else {
      // Standard-Look, falls keine passende Kombination gefunden wird
      deepArController.switchEffect('assets/filters/look_default.deepar');
    }
  }

  /*------------------------------------------ needed? ------------------------------------+*/

  Future<void> stepsToGoToFeatureTwo(BuildContext context) async {
    if (cameraController.value.isInitialized) {
      await cameraController.dispose();
    }
    setState(() {
      showOccasionDescription = true;
      isCameraDisposed = true;
    });
    if (isGoingBackAllowedInLookNavigator) {
      isGoingBackAllowedInLookNavigator = false;
      Navigator.pop(context);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => FeatureOne(), // TO DO
        ),
        (route) => false, // Entfernt alle vorherigen Routen
      );
    }
  }
}
