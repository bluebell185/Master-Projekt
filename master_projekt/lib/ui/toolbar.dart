import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:master_projekt/analysis_results.dart';
import 'package:master_projekt/start_look_generator.dart';
import 'package:master_projekt/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/feature_one.dart';
import 'package:master_projekt/screen_with_deepar_camera.dart';
import 'package:master_projekt/start_analysis.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:master_projekt/ui/buttons.dart';
import 'package:master_projekt/ui/login_feedback.dart';
import 'package:master_projekt/ui/info_dialog.dart';
import 'package:master_projekt/ui/tabs.dart';
import 'package:master_projekt/ui/text.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Toolbar: 
                                  - befindet sich oben rechts und dient auch zur Navigation
                                  - enthält 5 Icons:
                                    * user: öffnet den User-Account-Pop-Up
                                    * flash: soll das Ein- und Ausschalten eines Blitzlichts ermöglichen
                                    * analysis: Feature 1 -> führt die Gesichtsanalyse durch und gibt passende Recommendations + Filterapplikation
                                    * create: Feature 2 -> ermöglicht die "Kreation" eines Looks durch Auswahl von Optionen + Filterapplikation
                                    * eye: blendet nach Bedarf vorhandene Widgets ein/aus
------------------------------------------------------------------------------------------------------------------------------------------------*/

// Zustandsbehaftetes Icon für die Toolbar
class ToolbarIcon extends StatefulWidget {
  final int id;
  final String iconPath;
  final String activeIconPath;
  final VoidCallback onTap;
  final bool initialActive;

  const ToolbarIcon({
    super.key,
    required this.id,
    required this.iconPath,
    required this.activeIconPath,
    required this.onTap,
    this.initialActive = false,
  });

  @override
  State<ToolbarIcon> createState() => ToolbarIconState();
}

bool test = false;
bool isActive = false;

class ToolbarIconState extends State<ToolbarIcon> {
  @override
  void initState() {
    super.initState();
  }

  void _toggleActive() {
    // if (currentFeature == 0 ||
    //     (selectedToolbarIcons[2]! && currentFeature != 1)) {
    //   setState(() {
    //     isActive = !isActive;
    //   });
    // } else {
    if (!(widget.id == 2 && selectedToolbarIcons[2] == true)) {
      selectedToolbarIcons[widget.id] = !selectedToolbarIcons[widget.id]!;
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _toggleActive();
        widget.onTap();
        setState(() {
          test = !test;
        });
      },
      child: SizedBox(
        width: 24,
        height: 24,
        child: SvgPicture.asset(
          selectedToolbarIcons[widget.id]! || isActive
              ? widget.activeIconPath
              : widget.iconPath,
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
            id: 0,
            iconPath: 'assets/icons/user.svg',
            activeIconPath: 'assets/icons/user.svg',
            onTap: () {
              print("User icon tapped");
              // Navigation zum User-Account-Management
              showAccountPopup(context);
            },
          ),
          const SizedBox(height: 25),
          ToolbarIcon(
            id: 1,
            iconPath: 'assets/icons/flash_off.svg',
            activeIconPath: 'assets/icons/flash_active.svg',
            onTap: () {
              // Ein-/Ausschalten des Blitzes & Icon austauschen
              deepArController.toggleFlash();
              print("Flash icon tapped");
            },
          ),
          const SizedBox(height: 25),
          ToolbarIcon(
            id: 2,
            iconPath: 'assets/icons/analysis.svg',
            activeIconPath: 'assets/icons/analysis_active.svg',
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
                if (screenshotTimer != null && screenshotTimer!.isActive) {
                  screenshotTimer!.cancel();
                }

                // Toolbar zurücksetzen
                selectedToolbarIcons = {
                  0: false,
                  1: false,
                  2: true,
                  3: false,
                  4: false
                };

                // Filter zurücksetzen
                deepArController.switchEffect(null);

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
            id: 3,
            iconPath: 'assets/icons/create.svg',
            activeIconPath: 'assets/icons/create_active.svg',
            onTap: () {
              if (widgetCallingToolbar != startLookGeneratorWidgetName &&
                  eyeColorCategory != null) {
                isCameraDisposed = false;
                if (cameraController.value.isInitialized) {
                  cameraController.dispose();
                }
                if (screenshotTimer != null && screenshotTimer!.isActive) {
                  screenshotTimer!.cancel();
                }

                showRecommendationList = false;
                activeFilter = null;
                selectedIndex = 5;

                // Toolbar zurücksetzen
                selectedToolbarIcons = {
                  0: false,
                  1: false,
                  2: false,
                  3: true,
                  4: false
                };

                // Filter zurücksetzen
                deepArController.switchEffect(null);

                // Navigieren zur StartLookGenerator-Seite
                if (currentFeature == 1) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StartLookGenerator(title: 'Look Generator'),
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
              } else if (eyeColorCategory == null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const InfoDialog(
                      title: 'analysis missing',
                      content:
                          'in order to create looks you need to have done an analysis at least once.\nplease start the analysis.',
                      buttonText: 'ok',
                    );
                  },
                );
                selectedToolbarIcons[3] = false;
              }
              print("Create icon tapped");
            },
          ),
          const SizedBox(height: 25),
          ToolbarIcon(
            id: 4,
            iconPath: 'assets/icons/eye.svg',
            activeIconPath: 'assets/icons/eye_hidden.svg',
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

class AccountPopup extends StatelessWidget {
  const AccountPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

// Pop-Up für das User Account Management
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Color.fromARGB(255, 249, 224, 233),
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(25.0),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      selectedToolbarIcons[0] = false;
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const Center(
                  child: Heading(
                    headingText: 'account management',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
// Nutzer NICHT eingeloggt -> Login/Register-Option
            if (user == null) ...[
              const Text(
                  'you are not logged in - please log in or register to store and retrieve your analysis results'),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF342C32),
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
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'e-mail: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: user.email ?? "not available",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              IntrinsicWidth(
                  // https://stackoverflow.com/a/68431507
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    // Passwort ändern
                    PrimaryButton(
                      buttonText: 'change password',
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) => const PasswordResetDialog(),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    // Logout
                    PrimaryButton(
                      buttonText: 'log out',
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        // SnackBar-Nachricht anzeigen für visuelle Rückmeldung
                        giveLoginFeedback(
                            'you successfully logged out', context);
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: 20),
                    // Account löschen - Der einzige Text mit Großbuchstaben, da das Thema ernst ist
                    SecondaryButtonDark(
                      buttonText: 'delete account',
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: const Heading(
                                  headingText: 'Confirm Account Deletion'),
                            ),
                            content: const Text(
                                'Are you sure you want to delete your account and the belonging stored analysis data? This action cannot be undone!'),
                            actionsAlignment: MainAxisAlignment.center,
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
                                  content: Text(
                                    'Error deleting account: $e',
                                    style: TextStyle(color: Color(0xFF342C32)),
                                  ),
                                  backgroundColor:
                                      Color.fromARGB(255, 232, 147, 136)),
                            );
                          }
                        }
                      },
                    ),
                  ]))
            ],
            const SizedBox(height: 40),

            // Pop-Up verlassen
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF342C32),
                    textStyle: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:
                    const Text('cancel', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 30),
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
      title: Align(
        alignment: Alignment.centerLeft,
        child: const Heading(headingText: 'change password'),
      ),
      content:
          const Text('password reset instructions will be sent to your e-mail'),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('cancel'),
        ),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            if (user?.email != null) {
              await FirebaseAuth.instance
                  .sendPasswordResetEmail(email: user!.email!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('password reset e-mail sent'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.pink[50],
                ),
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

// Pop-Up triggern
void showAccountPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const AccountPopup(),
  );
}
