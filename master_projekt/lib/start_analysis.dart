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

// TODO
bool isFaceAnalysisDoneAtLeastOnce = false;

class StartAnalysis extends StatefulWidget {
  StartAnalysis({super.key, required this.title});

  final String title;

  @override
  State<StartAnalysis> createState() => _StartAnalysisState();
}

class _StartAnalysisState extends State<StartAnalysis> {
  bool isLoading = false; // Ladezustand

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
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

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
                          );

                          if (cameraController.value.isInitialized) {
                            cameraController.stopImageStream();
                          }

                          try {
                            roiData = await loadRoisData();

                            // Gesichtsanalyse starten
                            bool faceAnalysed =
                                await FaceAnalysis.analyseColorsInFace(
                                    faceForAnalysis);

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

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StartAnalysis(title: 'Analysis'),
                                ),
                              );
                            } else {
                              setState(() {
                                showRecommendations = false;
                              });
                            }
                          } catch (e) {
                            print('Error during analysis: $e');
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
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
                        onPressed: () async {
                          roiData = await loadRoisData();
                          await stepsToGoToFeatureOne(context);
                        },
                      ))),
                if (!showRecommendations)
                  ResultsCheckPopUp(
                    popUpHeading: 'Your analysis results',
                    analysisElements: [
                      // TO DO: ROI-Analyse-Ergebnis aus den Tabs rausnehmen? Drinlassen, aber als default selected?
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

  Future<void> stepsToGoToFeatureOne(BuildContext context) async {
    if (cameraController.value.isInitialized) {
      //cameraController.stopImageStream();
      await cameraController.dispose();
    }

    setState(() {
      showRecommendations = true;
      isCameraDisposed = true;
      shouldCalcRoiButtons = true;
    });

    updateDataInDb();

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
