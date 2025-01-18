import 'package:flutter/material.dart';
import 'package:master_projekt/start_look_generator.dart';
import 'package:master_projekt/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/feature_one.dart';
import 'package:master_projekt/feature_two.dart';
import 'package:master_projekt/screen_with_deepar_camera.dart';
import 'package:master_projekt/start_analysis.dart';

// Tool Bar rechts
// muss noch für die Navigation mit den anderen Screens connected werden
// verschiedene States:
// --- für "Flash" und "Eye" einbauen -> On/Off
// --- "active" Icons state? -> default/active

class Toolbar extends StatelessWidget {
  final String widgetCallingToolbar;

  const Toolbar({super.key, required this.widgetCallingToolbar});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 75,
      right: 15,
      child: Column(
        children: [
          _buildToolbarIcon(
            iconPath: 'assets/icons/user.svg',
            onTap: () {
              // TO DO: Zum User-Account
              print("User icon tapped");
            },
          ),
          const SizedBox(height: 25),
          _buildToolbarIcon(
            iconPath: 'assets/icons/flash.svg',
            onTap: () {
              // TO DO: Ein-/Ausschalten Blitz & Icon austauschen
              deepArController.toggleFlash();
              print("Flash icon tapped");
            },
          ),
          const SizedBox(height: 25),
          _buildToolbarIcon(
            iconPath: 'assets/icons/analysis.svg',
            onTap: () {
              if (widgetCallingToolbar != startAnalysisWidgetName) {
                shouldCalcRoiButtons = false;
                isCameraDisposed = false;

                if (widgetCallingToolbar == featureOneWidgetName) {
                  isGoingBackAllowedInNavigator = true;
                }
                if (cameraController.value.isInitialized) {
                  cameraController.dispose();
                }
                // Navigieren zur StartAnalysis-Seite
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartAnalysis(title: 'Analysis'),
                  ),
                  //(route) => false, // Entfernt alle vorherigen Routen
                );
                print("Analysis icon tapped");
              }
            },
          ),
          const SizedBox(height: 25),
          _buildToolbarIcon(
            iconPath: 'assets/icons/create.svg',
            onTap: () {
              // TO DO: Öffnen von Feature Zwei: Create Look
              if (widgetCallingToolbar != startLookGeneratorWidgetName) {
                isCameraDisposed = false;

                if (widgetCallingToolbar == featureTwoWidgetName) {
                  isGoingBackAllowedInLookNavigator = true;
                }
                if (cameraController.value.isInitialized) {
                  cameraController.dispose();
                }
                // Navigieren zur StartLookGenerator-Seite
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StartLookGenerator(title: 'Look Generator'),
                  ),
                  //(route) => false, // Entfernt alle vorherigen Routen
                );
                print("Create icon tapped");
              }
            },
          ),
          const SizedBox(height: 25),
          _buildToolbarIcon(
            iconPath: 'assets/icons/eye.svg',
            onTap: () {
              if (featureOneKey.currentState != null) {
                featureOneKey.currentState!.toggleWidgetHiding();
              }
              print("Eye icon tapped");
            },
          ),
        ],
      ),
    );
  }

  // Methode zur onTap-Funktion für jedes Icon
  Widget _buildToolbarIcon(
      {required String iconPath, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 24,
        height: 24,
        child: SvgPicture.asset(
          iconPath, // Verwendet SvgPicture.asset für SVG-Dateien
          semanticsLabel: 'Toolbar Icon',
        ),
      ),
    );
  }
}
