import 'package:flutter/material.dart';
import 'package:master_projekt/analysis_results.dart';
import 'package:master_projekt/base_screen_with_camera.dart';
import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/main.dart';
import 'package:master_projekt/ui/toolbar.dart';
import 'package:master_projekt/ui/text.dart';
import 'package:master_projekt/ui/buttons.dart';
// import 'package:deepar_flutter_lib/deepar_flutter.dart';

// TO DO:
// pngs übel unscharf, Flutter an sich kann nicht mit svgs -> flutter plugin zur svg static image verarbeitung

class StartAnalysis extends StatelessWidget {
  StartAnalysis({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BaseScreenWithCamera(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            //CameraWidget(title: 'Camera'),
            // Main content background container
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
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

            Toolbar(),

            // CTA Button unten, führt zu AnalysisResults()
            PrimaryButton(
              buttonText: 'start analysis',
              onPressed: () {
                // TO DO: Funktion aufrufen, die die Gesichtsanalyse startet

                /* HIER: Gesichtsanalyse!

                      - Loading Screen bzw. Scan-Effekt sollte laufen
                      - nach Analyse poppt Pop-Up auf, das die Analysis-Results anzeigt, die User modifizieren kann -> results_check.dart - ResultsCheck()
                      - erst nach Tap auf CTA_Button "save" -> erster ContentBox-Abschnitt erscheint mit ROIs -> analysis_results.dart - AnalysisResults()
                      - nach Auswahl einer ROI (Tab) -> zweiter ContentBox-Abschnitt mit Recommendations & Looks erscheint -> analysis_results.dart - AnalysisResults()

                      */

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AnalysisResults(title: 'AnalysisResults'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
