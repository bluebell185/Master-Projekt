import 'package:flutter/material.dart';
import 'package:master_projekt/main.dart';
import 'package:master_projekt/occasion_description.dart';
import 'package:master_projekt/screen_with_deepar_camera.dart';
import 'package:master_projekt/ui/save_look.dart';

// UI-Elemente
import 'package:master_projekt/ui/toolbar.dart';
import 'package:master_projekt/ui/text.dart';
import 'package:master_projekt/ui/buttons.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Look Generator: 
                                  - ruft das Pop-Up (OccasionDescrption) auf für Input zur passenden Filterauswahl
                                  - Anwendung des Filters
                                  - ermöglicht Modifikation des gegebenen Inputs
                                  - ermöglicht Speichern des Looks durch einen Screenshot
------------------------------------------------------------------------------------------------------------------------------------------------*/

final String startLookGeneratorWidgetName = 'StartLookGenerator';

bool hideWidgets =
    false; // boolean, der vom Auge-Icon in der Toolbar angesprochen wird und die Sichtbarkeit der Komponenten bestimmt

// GlobalKey für FeatureTwo
final GlobalKey<StartLookGeneratorState> featureTwoKey =
    GlobalKey<StartLookGeneratorState>();

class StartLookGenerator extends StatefulWidget {
  StartLookGenerator({Key? key, required this.title})
      : super(key: featureTwoKey);

  final String title;

  @override
  State<StartLookGenerator> createState() => StartLookGeneratorState();
}

class StartLookGeneratorState extends State<StartLookGenerator> {
  // Ladezustand
  bool isLoading = false;

  // Animation, wenn ein Screenshot gemacht wird
  bool takeScreenshotAnimation = false;

  // steuert, ob Pop-Up im Stack angezeigt wird
  bool showOccasionDescription = false;

  // checkt, ob das Pop-Up schon geöffnet wurde
  bool isLookCreated = false;

  // um die selektierten Antworten zu speichern (zur Modifikation des Looks)
  Map<int, String> savedOptions = {};

  // Questions im Pop-Up mit dazugehörigen Antwortmöglichkeiten "options"
  List<Question> questions = [
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
      ],
      selectedOption: '',
      onOptionSelected: (selected) {
        print('Selected for occasion type: $selected');
      },
    ),
    Question(
      number: 2,
      title: 'How is the weather like?',
      options: ['sunny', 'rainy', 'cloudy', 'snowy', 'windy', 'hot', 'cold'],
      selectedOption: '',
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
      ],
      selectedOption: '',
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
      ],
      selectedOption: '',
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
      ],
      selectedOption: '',
      onOptionSelected: (selected) {
        print('Selected for desired vibe: $selected');
      },
    ),
    Question(
      number: 6,
      title: 'How much time do you have to get ready?',
      options: ['5 minutes', '15 minutes', '30 minutes', 'as much as needed'],
      selectedOption: '',
      onOptionSelected: (selected) {
        print('Selected for available time: $selected');
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Am Anfang soll Pop-up angezeigt werden
    showOccasionDescription = false;
    isLookCreated = false;
  }

  void toggleWidgetHidingFeature2() {
    setState(() {
      hideWidgets = !hideWidgets;
    });
  }

  @override
  Widget build(BuildContext context) {
    currentFeature = 2;

    return PopScope(
      canPop: false,
      child: ScreenWithDeeparCamera(
        deepArPreviewKey: GlobalKey(),
        isAfterAnalysis: false,
        isFeatureOne: false,
        child: Scaffold(
          backgroundColor: takeScreenshotAnimation
              ? Colors.white.withOpacity(0.4)
              : Colors.transparent,
          body: Stack(
            children: [
              // Main content background container
              !hideWidgets
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 70),
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
                    )
                  : Container(),

              Toolbar(
                widgetCallingToolbar: startLookGeneratorWidgetName,
              ),

              // Falls noch kein Look erstellt wurde und das Pop-up nicht sichtbar ist, wird der erste CTA "create look" angezeigt
              if (!showOccasionDescription && !isLookCreated && !hideWidgets)
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
                          isLoading = true;
                        });
                      },
                    ),
                  ),
                ),

              // Anzeige des Pop-ups, wenn showOccasionDescription = true
              if (showOccasionDescription)
                OccasionDescription(
                  popUpHeading: 'Your occasion for today',
                  question: questions,
                  onSave: (answersMap) {
                    // Pop-up schließen, Filter anwenden und Antworten speichern
                    setState(() {
                      showOccasionDescription = false;
                      isLoading = false;
                      isLookCreated = true;
                      savedOptions = answersMap;
                    });
                    print("User selections: $savedOptions");
                    mapLookToFilter(savedOptions);
                  },
                ),

              // Sobald der Look erstellt wurde, werden zwei Buttons angezeigt: "save look" und "modify look"
              if (isLookCreated && !hideWidgets)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // CTA "save look": speichert den Look durch einen Screenshot
                      PrimaryButton(
                        buttonText: 'save look',
                        onPressed: saveCreatedLook,
                      ),
                      SizedBox(height: 15),
                      // CTA "modify look": öffnet das Pop-up erneut mit bereits selektierten Antworten
                      SecondaryButtonLight(
                        buttonText: 'modify look',
                        onPressed: () {
                          // Aktualisieren/Check, sodass die bisherigen Auswahlen übernommen werden
                          setState(() {
                            questions = questions.map((question) {
                              if (savedOptions.containsKey(question.number)) {
                                return Question(
                                  number: question.number,
                                  title: question.title,
                                  options: question.options,
                                  selectedOption:
                                      savedOptions[question.number]!,
                                  onOptionSelected: question.onOptionSelected,
                                );
                              }
                              return question;
                            }).toList();
                            showOccasionDescription = true;
                            isLookCreated = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Mapping der Antworten zu fertigen Look-Filtern
  void mapLookToFilter(Map<int, String> selectedOptions) {
    final selectedOptionsSet = selectedOptions.values.toSet();
    if (selectedOptionsSet.contains('casual') ||
        selectedOptionsSet.contains('sunny') ||
        selectedOptionsSet.contains('natural')) {
      deepArController.switchEffect('assets/filters/look_natural.deepar');
    } else if (selectedOptionsSet.contains('party') ||
        selectedOptionsSet.contains('rainy') ||
        selectedOptionsSet.contains('bold')) {
      deepArController.switchEffect('assets/filters/look_bold.deepar');
    } else if (selectedOptionsSet.contains('wedding') ||
        selectedOptionsSet.contains('snowy') ||
        selectedOptionsSet.contains('soft')) {
      deepArController.switchEffect('assets/filters/look_romantic.deepar');
    } else {
      deepArController.switchEffect('assets/filters/look_default.deepar');
    }
  }

  // Bild von Look in Galerie speichern
  Future<void> saveCreatedLook() async {
    print('saveLook() aufgerufen – Screenshot wird erstellt.');

    setState(() {
      takeScreenshotAnimation = true;
    });

    await saveLook();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'screenshot successfully saved in gallery',
          style: TextStyle(color: Colors.grey[800]!),
        ),
        backgroundColor: Color.fromARGB(255, 174, 214, 200),
      ),
    );

    setState(() {
      takeScreenshotAnimation = false;
    });
  }
}
