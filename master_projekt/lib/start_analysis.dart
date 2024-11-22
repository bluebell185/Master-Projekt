import 'package:flutter/material.dart';
import 'package:master_projekt/analysis_results.dart';
import 'package:master_projekt/ui/toolbar.dart';
import 'package:master_projekt/ui/text.dart';
import 'package:master_projekt/ui/buttons.dart';

// TO DO:
// pngs übel unscharf, Flutter an sich kann nicht mit svgs -> flutter plugin zur svg static image verarbeitung

class StartAnalysis extends StatelessWidget {
  const StartAnalysis({super.key, required this.title});

  final String title;

/*
  // DeepAR Controller initialisieren

  final  DeepArController _controller = DeepArController();
  _controller.initialize(
          androidLicenseKey:"1d81a1e3d04ae4f558fb6cea2af08afbe173c8e660ce68c2be2a0ca981bce3c02703ded82b8cc3f9",
          iosLicenseKey:"bd36fd6e5b55bf93100f8a4188e1a16f797be4c07b102eb5a29c577511836491b050cf80020512f9",
          resolution: Resolution.high);

  // DeepArPreview widget um Vorschau zu displayen
  @override

Widget  build(BuildContext  context) {
return  _controller.isInitialized
                ? DeepArPreview(_controller)
                : const  Center(
                  child: Text("Loading Preview")
                );
}
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content background container
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
            decoration: const BoxDecoration(
                color: Color(
                    0xFFA4ABB3)), // momentan noch einfarbiger Background; sollte dann durch Kamerabild ersetzt werden

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title oben
                ScreenTitle(
                  titleText: 'Analysis',
                  textColor: Colors.white,
                ),

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
          // Toolbar rechts oben
          Toolbar(),
        ],
      ),
    );
  }
}
