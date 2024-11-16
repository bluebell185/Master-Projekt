import 'package:flutter/material.dart';
import 'package:master_projekt/feature_one_results.dart';

// TO DO:
// pngs übel unscharf, Flutter an sich kann nicht mit svgs -> flutter plugin zur svg static image verarbeitung

class FeatureOne extends StatelessWidget {
  const FeatureOne({super.key, required this.title});

  final String title;

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

/*
                // Button "Start Analysis" unten
                Container(
                  width: 280,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF342C32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Start Analysis',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Sans Serif Collection',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.32,
                    ),
                  ),
                ),*/

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

          // Tool Bar rechts
          // muss noch für die Navigation mit den anderen Screens connected werden
          // verschiedene States:
          // --- für "Flash" und "Eye" einbauen -> On/Off
          // --- "active" Icons state? -> default/active

          Positioned(
            top: 75, // 705x Padding top
            right: 15, // 15px Padding right
            child: Column(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'assets/icons/user.png',
                  ),
                ),
                SizedBox(height: 25), // 25px vertical gap

                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'assets/icons/flash.png',
                  ),
                ),
                SizedBox(height: 25), // 25px vertical gap

                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'assets/icons/analysis.png',
                  ),
                ),
                SizedBox(height: 25), // 25px vertical gap

                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'assets/icons/create.png',
                  ),
                ),
                SizedBox(height: 25), // 25px vertical gap

                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'assets/icons/eye.png',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
