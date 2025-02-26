import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:master_projekt/analysis_results.dart';
import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/face_analysis.dart';
import 'package:master_projekt/feature_one.dart';
import 'package:master_projekt/json_parse.dart';
import 'package:master_projekt/main.dart';
import 'package:master_projekt/results_check.dart';
import 'package:master_projekt/scanning_animation.dart';
import 'package:master_projekt/screen_with_deepar_camera.dart';
import 'package:master_projekt/ui/info_dialog.dart';

// UI-Elemente
import 'package:master_projekt/ui/toolbar.dart';
import 'package:master_projekt/ui/text.dart';
import 'package:master_projekt/ui/buttons.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Start Analysis: 
                                  - führt Gesichtanalyse im Background durch
                                  - Scanning-Animation
                                  - ruft das Pop-Up mit Analyseergebnissen(ResulstsCheckPopUp) auf zum Check & Modifikation
                                  - führt durch CTA weiter zu den Recommendations
------------------------------------------------------------------------------------------------------------------------------------------------*/

final String startAnalysisWidgetName = 'StartAnalysis';

bool isAnalysisStarted = false;
late RoisData roiData;
bool isGoingBackAllowedInNavigator = false;

class StartAnalysis extends StatefulWidget {
  StartAnalysis({super.key, required this.title});

  final String title;

  @override
  State<StartAnalysis> createState() => _StartAnalysisState();
}

bool faceAnalysed = false; // Ladezustand Analyse

class _StartAnalysisState extends State<StartAnalysis> {
  bool isLoadingForSkip = false; // Ladezustand Skip Analyse

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: isGoingBackAllowedInNavigator,
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
                        titleText: 'Analysis',
                        titleColor: Colors.white,
                      ),
                    ],
                  ),
                ),

                Toolbar(
                  widgetCallingToolbar: startAnalysisWidgetName,
                ),

                if (showRecommendations)
                  // CTA Button unten
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: eyeColorCategory == null ? 70 : 140,
                    child: Center(
                      child: PrimaryButton(
                        buttonText: eyeColorCategory == null
                            ? 'start analysis'
                            : 'repeat analysis',
                        onPressed: _performAnalysis,
                      ),
                    ),
                  ),
                if (showRecommendations && eyeColorCategory != null)
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 70,
                      child: Center(
                          child: PrimaryButton(
                              buttonText: 'skip analysis',
                              onPressed: !isLoadingForSkip
                                  ? () async {
                                      setState(() {
                                        isLoadingForSkip = true;
                                      });
                                      roiData = await loadRoisData();

                                      setState(() {
                                        isLoadingForSkip = false;
                                      });

                                      if (cameraController
                                          .value.isStreamingImages) {
                                        cameraController.stopImageStream();
                                      }

                                      await stepsToGoToFeatureOne(context);
                                    }
                                  : () {
                                      print('Nicht am Laden');
                                    }))),
                if (isLoadingForSkip)
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 10,
                      child: Center(
                        child: CircularProgressIndicator(),
                      )),
                if (!showRecommendations)
                  ResultsCheckPopUp(
                    popUpHeading: 'your analysis results',
                    analysisElements: [
                      AnalysisElement(
                        number: 1,
                        title: 'Eye color',
                        result: eyeColorCategory!
                            .name, // Results der Gesichtsanalyse
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
                        result: eyeShapeCategory!
                            .name, // Results der Gesichtsanalyse
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
                        result:
                            blushCategory!.name, // Results der Gesichtsanalyse
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
                        result: blushShapeCategory!
                            .name, // Results der Gesichtsanalyse
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
                    onSave: () async {
                      await stepsToGoToFeatureOne(context);
                    },
                  ),
              ],
            ),
          ),
        ));
  }

  Future<void> _performAnalysis() async {
    int minAnimationDuration = 3;

    // Zeige den Lade-Dialog mit ScannerWidget an
    showDialog(
      context: context,
      barrierDismissible:
          false, // Verhindert das Schließen durch Tippen außerhalb
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: ScannerWidget(), // Dein benutzerdefiniertes Widget
          ),
        );
      },
    );

    try {
      // Warte entweder auf die Mindestdauer oder den Abschluss der Operation, je nachdem, was länger dauert
      await Future.wait([
        getDataAndDoAnalysis(),
        Future.delayed(Duration(seconds: minAnimationDuration)),
      ]);

      if (!faceAnalysed) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return const InfoDialog(
              title: 'analysis not successful',
              content:
                  'the analysis was not successful.\nplease repeat it under good lighting conditions and keep the camera still before starting the analysis.',
              buttonText: 'okay',
            );
          },
        );

        setState(() {
          isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartAnalysis(title: 'Analysis'),
          ),
        );
      } else {
        // Analyse war erfolgreich
        setState(() {
          isLoading = false;
          showRecommendations = false;
        });
      }
    } catch (e) {
      print('Fehler während der Analyse: $e');
    } finally {
      // Schließe den Lade-Dialog
      Navigator.of(context).pop();
    }
  }

  Future<void> getDataAndDoAnalysis() async {
    roiData = await loadRoisData();
    // Gesichtsanalyse starten
    faceAnalysed = await FaceAnalysis.analyseColorsInFace(faceForAnalysis);
  }

  Future<void> stepsToGoToFeatureOne(BuildContext context) async {
    if (cameraController.value.isStreamingImages) {
      cameraController.stopImageStream();
    }

    setState(() {
      showRecommendations = true;
      isCameraDisposed = true;
      shouldCalcRoiButtons = true;
    });

    updateDataInDb();

    activeFilter = null;

    // Toolbar und Tabs zurücksetzen
    selectedToolbarIcons = {0: false, 1: false, 2: true, 3: false, 4: false};
    selectedButtonsRois = {0: false, 1: false, 2: false, 3: false};

    if (isGoingBackAllowedInNavigator) {
      isGoingBackAllowedInNavigator = false;
      Navigator.pop(context);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => FeatureOne(),
        ),
        (route) => false, // Entfernt alle vorherigen Routen
      );
    }
  }

  void updateDataInDb() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String useruid = user.uid;
      final roiData = {
        'blushCategory': blushCategory!.name,
        'blushShapeCategory': blushShapeCategory!.name,
        'browCategory': browCategory!.name,
        'browShapeCategory': browShapeCategory!.name,
        'eyeColorCategory': eyeColorCategory!.name,
        'eyeShapeCategory': eyeShapeCategory!.name,
        'lipCategory': lipCategory!.name,
        'userId': useruid,
      };
      final userTable = FirebaseFirestore.instance.collection('roiData');
      userTable.doc(useruid).set(roiData);
    }
  }
}
