import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:master_projekt/start_look_generator.dart';
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
import 'package:master_projekt/ui/save_look.dart';

// Zustandsbehaftetes Icon für die Toolbar
class ToolbarIcon extends StatefulWidget {
  final String iconPath;
  final String activeIconPath;
  final VoidCallback onTap;
  final bool initialActive;

  const ToolbarIcon({
    super.key,
    required this.iconPath,
    required this.activeIconPath,
    required this.onTap,
    this.initialActive = false,
  });

  @override
  State<ToolbarIcon> createState() => ToolbarIconState();
}

class ToolbarIconState extends State<ToolbarIcon> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.initialActive;
  }

  void _toggleActive() {
    setState(() {
      isActive = !isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toggleActive();
        widget.onTap();
      },
      child: SizedBox(
        width: 24,
        height: 24,
        child: SvgPicture.asset(
          isActive ? widget.activeIconPath : widget.iconPath,
          semanticsLabel: 'Toolbar Icon',
        ),
      ),
    );
  }
}

// Toolbar, welche die ToolbarIcon-Komponenten verwendet
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
          ToolbarIcon(
            iconPath: 'assets/icons/user.svg',
            activeIconPath: 'assets/icons/user_active.svg', // TO DO
            onTap: () {
              // Navigation zum User-Account
              print("User icon tapped");
            },
          ),
          const SizedBox(height: 25),
          ToolbarIcon(
            iconPath: 'assets/icons/flash.svg',
            activeIconPath: 'assets/icons/flash_active.svg', // TO DO
            onTap: () {
              // Ein-/Ausschalten des Blitzes & Icon austauschen
              deepArController.toggleFlash();
              print("Flash icon tapped");
            },
          ),
          const SizedBox(height: 25),
          ToolbarIcon(
            iconPath: 'assets/icons/analysis.svg',
            activeIconPath: 'assets/icons/analysis_active.svg', // TO DO
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartAnalysis(title: 'Analysis'),
                  ),
                );
                print("Analysis icon tapped");
              }
            },
          ),
          const SizedBox(height: 25),
          ToolbarIcon(
            iconPath: 'assets/icons/create.svg',
            activeIconPath: 'assets/icons/create_active.svg', // TO DO
            onTap: () {
              if (widgetCallingToolbar != startLookGeneratorWidgetName) {
                isCameraDisposed = false;
                // if (widgetCallingToolbar == featureTwoWidgetName) {
                //   isGoingBackAllowedInLookNavigator = true;
                // }
                if (cameraController.value.isInitialized) {
                  cameraController.dispose();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StartLookGenerator(title: 'Look Generator'),
                  ),
                );
                print("Create icon tapped");
              }
            },
          ),
          const SizedBox(height: 25),
          ToolbarIcon(
            iconPath: 'assets/icons/eye.svg',
            activeIconPath: 'assets/icons/eye_close.svg',
            onTap: () {
             if (featureOneKey.currentState != null) {
                featureOneKey.currentState!.toggleWidgetHiding();
              }
              if (featureTwoKey.currentState != null) {
                featureTwoKey.currentState!.toggleWidgetHidingFeature2();
              }
              print("Eye icon tapped");
            },
          ),
        ],
      ),
    );
  }
}

  /*
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
              currentFeature = 0;

              if (widgetCallingToolbar != startAnalysisWidgetName) {
                shouldCalcRoiButtons = false;
                isCameraDisposed = false;

                if (widgetCallingToolbar == featureOneWidgetName) {
                  isGoingBackAllowedInNavigator = true;
                }
                if (cameraController.value.isInitialized) {
                  cameraController.dispose();
                }

                // Filter zurücksetzen
                deepArController.switchEffect(null);
                
                // if (currentFeature == 2 && deepArController.isInitialized){
                //   deepArController.destroy();
                // }
                // Navigieren zur StartAnalysis-Seite
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartAnalysis(title: 'Analysis'),
                  ),
                  //(route) => false, // Entfernt alle vorherigen Routen
                );
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => StartAnalysis(title: 'Analysis'),
                //   ),
                //   (route) => false, // Entfernt alle vorherigen Routen
                // );
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

                // if (widgetCallingToolbar == featureTwoWidgetName) {
                //   isGoingBackAllowedInLookNavigator = true;
                // }
                if (cameraController.value.isInitialized) {
                  cameraController.dispose();
                }
                // if (currentFeature != 2 && deepArController.isInitialized){
                //   deepArController.destroy();
                // }

                // Filter zurücksetzen
                deepArController.switchEffect(null);

                // Navigieren zur StartLookGenerator-Seite
                if (currentFeature == 1) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StartLookGenerator(title: 'Look Generator'), // TO DO
                    ),
                    (route) => false, // Entfernt alle vorherigen Routen
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StartLookGenerator(title: 'Look Generator'),
                    ),
                    //(route) => false, // Entfernt alle vorherigen Routen
                  );
                }
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
              if (featureTwoKey.currentState != null) {
                featureTwoKey.currentState!.toggleWidgetHidingFeature2();
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
}*/

class AccountPopup extends StatelessWidget {
  const AccountPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

// Popup für das User Account Management
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Color.fromARGB(255, 249, 224, 233),
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(25.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'account management',
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
                  'you are not logged in - please log in or register to store and retrieve your analysis results'),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800]!,
                    textStyle: TextStyle(color: Colors.white)),
                onPressed: () async {
                  // Listener für Authentifizierungsstatus, damit sich der Login-Screen nach Login/Registrierung wieder schließt
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
                      giveLoginFeedback('you successfully logged in', context);
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
                                    'sign in to store and retrieve your analysis results!')
                                : const Text(
                                    'register to store and retrieve your analysis results!'),
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
                child: const Text('log in / register',
                    style: TextStyle(color: Colors.white)),
              ),
// User eingeloggt -> versch. Account-Optionen
            ] else ...[
              // Anzeige: Hinterlegte Email
              Text('e-mail: ${user.email ?? "not available"}'),
              const SizedBox(height: 16.0),
              IntrinsicWidth( // https://stackoverflow.com/a/68431507
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    // Passwort ändern
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800]!,
                    foregroundColor: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) => const PasswordResetDialog(),
                        );
                      },
                      child: const Text('change password'),
                    ),

                    // Logout
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800]!,
                    foregroundColor: Colors.white),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        // SnackBar-Nachricht anzeigen für visuelle Rückmeldung
                        giveLoginFeedback(
                            'you successfully logged out', context);
                        Navigator.of(context).pop();
                      },
                      child: const Text('log out'),
                    ),

                    // Account löschen - Der einzige Text mit Großbuchstaben, da das Thema ernst ist
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom( backgroundColor: Colors.grey[800]!, foregroundColor: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Account Deletion'),
                            content: const Text(
                                'Are you sure you want to delete your account and the belonging stored analysis data? This action cannot be undone!'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          try {
                            // Löschen der Analyseergebnisse
                            await FirebaseFirestore.instance
                                .collection('roiData')
                                .doc(user.uid)
                                .delete();
                            // Löschen des Accounts
                            await user.delete();
                            // SnackBar-Nachricht anzeigen für visuelle Rückmeldung
                            giveLoginFeedback(
                                'You successfully deleted your account',
                                context);
                            Navigator.of(context).pop();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Error deleting account: $e')),
                            );
                          }
                        }
                      },
                      child: const Text('delete account'),
                    ),
                  ]))
            ],
            const SizedBox(height: 16.0),

            // Popup verlassen
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800]!,
                    textStyle: TextStyle(color: Colors.white)),
                onPressed: () => Navigator.of(context).pop(),
                child:
                    const Text('cancel', style: TextStyle(color: Colors.white)),
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
      title: const Text('change password'),
      content:
          const Text('password reset instructions will be sent to your e-mail'),
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
                const SnackBar(content: Text('password reset e-mail sent')),
              );
            }
            Navigator.of(context).pop();
          },
          child: const Text('send e-mail'),
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

