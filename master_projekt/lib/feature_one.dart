import 'package:flutter/material.dart';
import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/feature_one_results.dart';
import 'package:master_projekt/toolbar.dart';

// TO DO:
// pngs übel unscharf, Flutter an sich kann nicht mit svgs -> flutter plugin zur svg static image verarbeitung

class FeatureOne extends StatelessWidget {
  const FeatureOne({super.key, required this.title});

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
          const CameraWidget(title: 'Camera'),
          // Main content background container
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
            // decoration: const BoxDecoration(
            //     color: Color(
            //         0xFFA4ABB3)), // momentan noch einfarbiger Background; sollte dann durch Kamerabild ersetzt werden

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title oben
                // wie, damit es 100px padding oben hat?
                const Text(
                  'Analysis',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Chicle',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.48,
                  ),
                ),

                // CTA Button unten, führt zu FeatureOne_Results()

                Positioned(
                  // bottom: 50, // klappt nicht? Positioned dann raus?
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      child: TextButton(
                        onPressed: () {
                          // Navigation zu FeatureOne
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeatureOneResults(
                                  title: 'Feature One Results'),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF342C32), // Background color
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                        ),
                        child: Text(
                          'start analysis',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Sans Serif Collection',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Toolbar(),
        ],
      ),
    );
  }
}
