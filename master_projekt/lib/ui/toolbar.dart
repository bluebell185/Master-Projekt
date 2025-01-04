import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:master_projekt/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/feature_one.dart';
import 'package:master_projekt/screen_with_deepar_camera.dart';
import 'package:master_projekt/start_analysis.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:master_projekt/start_analysis.dart';
import 'package:master_projekt/ui/login_feedback.dart';

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
            iconPath: 'assets/icons/user.png',
            onTap: () => showAccountPopup(context),
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
              if (widgetCallingToolbar != startAnalysisWidgetName){
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
            }},
          ),
          const SizedBox(height: 25),
          _buildToolbarIcon(
            iconPath: 'assets/icons/create.svg',
            onTap: () {
              // TO DO: Öffnen von Feature Zwei: Create Look
              print("Create icon tapped");
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

class AccountPopup extends StatelessWidget {
  const AccountPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

// Popup für das User Account Management TODO Design
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      insetPadding: const EdgeInsets.all(20.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Account Management',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Popup verlassen
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
// Nutzer NICHT eingeloggt -> Login/Register-Option
            if (user == null) ...[
              const Text(
                  'You are not logged in. Please log in or register to store and retrieve your analysis results.'),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Listener für Authentifizierungsstatus hinzufügen, damit sich der Login-Screen nach Login/Registrierung wieder schließt
                  late final StreamSubscription<User?> authSubscription;
                  authSubscription = FirebaseAuth.instance
                      .authStateChanges()
                      .listen((User? user) {
                    if (user != null) {
                      // Benutzer ist eingeloggt, SignInScreen schließen
                      authSubscription.cancel(); // Listener entfernen

                      Navigator.of(context).pop(); // Schließt den SignInScreen
                      Navigator.of(context).pop(); // Popup schließen

                      // SnackBar-Nachricht anzeigen für visuelle Rückmeldung
                      giveLoginFeedback('You successfully logged in', context);
                    }
                  });

                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      // Derselbe SignIn-Screen wie auch in auth_widget.dart TODO rausziehen?
                      builder: (context) => SignInScreen(
                        providers: [EmailAuthProvider()],
                        headerBuilder: (context, constraints, shrinkOffset) {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: FractionallySizedBox(
                                widthFactor: 0.8,
                                heightFactor: 0.6,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset(
                                    'assets/logo.png',
                                  ),
                                )),
                          );
                        },
                        subtitleBuilder: (context, action) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: action == AuthAction.signIn
                                ? const Text(
                                    'Sign in to store and retrieve your analysis results!')
                                : const Text(
                                    'Register to store and retrieve your analysis results!'),
                          );
                        },
                        sideBuilder: (context, constraints) {
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: FractionallySizedBox(
                                widthFactor: 0.7,
                                heightFactor: 0.5,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset(
                                    'assets/logo.png',
                                  ),
                                )),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: const Text('Log In / Register'),
              ),
// User eingeloggt -> versch. Account-Optionen
            ] else ...[
              // Anzeige: Hinterlegte Email
              Text('Email: ${user.email ?? "Not available"}'),
              const SizedBox(height: 16.0),

              // Passwort ändern
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => const PasswordResetDialog(),
                  );
                },
                child: const Text('Change Password'),
              ),

              // Logout
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // SnackBar-Nachricht anzeigen für visuelle Rückmeldung
                  giveLoginFeedback('You successfully logged out', context);
                  Navigator.of(context).pop();
                },
                child: const Text('Log Out'),
              ),

              // Account löschen
              ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Account Deletion'),
                      content: const Text(
                          'Are you sure you want to delete your account and the belonging stored analysis data? This action cannot be undone!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    try {
                      // Löschen der Analyseergebnisse
                      await FirebaseFirestore.instance.collection('roiData').doc(user.uid).delete();
                      // Löschen des Accounts
                      await user.delete();
                      // SnackBar-Nachricht anzeigen für visuelle Rückmeldung
                      giveLoginFeedback('You successfully deleted your account', context);
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error deleting account: $e')),
                      );
                    }
                  }
                },
                child: const Text('Delete Account'),
              ),
            ],
            const SizedBox(height: 16.0),

            // Popup verlassen
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordResetDialog extends StatelessWidget {
  const PasswordResetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content:
          const Text('Password reset instructions will be sent to your email.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            if (user?.email != null) {
              await FirebaseAuth.instance
                  .sendPasswordResetEmail(email: user!.email!);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password reset email sent.')),
              );
            }
            Navigator.of(context).pop();
          },
          child: const Text('Send Email'),
        ),
      ],
    );
  }
}

// Popup triggern
void showAccountPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const AccountPopup(),
  );
}
