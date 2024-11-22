import 'package:flutter/material.dart';

// Tool Bar rechts
// muss noch für die Navigation mit den anderen Screens connected werden
// verschiedene States:
// --- für "Flash" und "Eye" einbauen -> On/Off
// --- "active" Icons state? -> default/active

class Toolbar extends StatelessWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 75,
      right: 15,
      child: Column(
        children: [
          _buildToolbarIcon(
            iconPath: 'assets/icons/user.png',
            onTap: () {
              // TO DO: Zum User-Account
              print("User icon tapped");
            },
          ),
          const SizedBox(height: 25),
          _buildToolbarIcon(
            iconPath: 'assets/icons/flash.png',
            onTap: () {
              // TO DO: Ein-/Ausschalten Blitz & Icon austauschen
              print("Flash icon tapped");
            },
          ),
          const SizedBox(height: 25),
          _buildToolbarIcon(
            iconPath: 'assets/icons/analysis.png',
            onTap: () {
              // TO DO: Öffnen von Feature One: Analysis
              print("Analysis icon tapped");
            },
          ),
          const SizedBox(height: 25),
          _buildToolbarIcon(
            iconPath: 'assets/icons/create.png',
            onTap: () {
              // TO DO: Öffnen von Feature Zwei: Create Look
              print("Create icon tapped");
            },
          ),
          const SizedBox(height: 25),
          _buildToolbarIcon(
            iconPath: 'assets/icons/eye.png',
            onTap: () {
              // TO DO: Ausblenden von ROI-Kästchen (und ContainerBoxen?)
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
        child: Image.asset(iconPath),
      ),
    );
  }
}
