import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:master_projekt/analysis_results.dart';
import 'package:master_projekt/main.dart';
import 'package:master_projekt/start_analysis.dart';
import 'dart:async';

import 'package:master_projekt/verification_email.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Auth Widget: 
                                  - Widget nach Willkommensbildschirm mit Login und Registrierung
                                  - Nutzt Firebase UI Elemente
------------------------------------------------------------------------------------------------------------------------------------------------*/

class AuthWidget extends StatefulWidget {
  const AuthWidget(FirebaseFirestore db, {super.key});

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          // Nutzer ist nicht angemeldet, bleibe auf der AuthPage
          return SignInScreen(
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
          );
        } else {
          // Nutzer ist angemeldet:
          // Prüfe zuerst, ob die Email-Adresse schon verifiziert wurde
          bool isEmailVerified =
              FirebaseAuth.instance.currentUser!.emailVerified;
          if (!isEmailVerified) {
            // Falls die Email noch nicht verifiziert wurde, gehe auf den Verifikationsscreen
            return EmailVerification();
          } else {
            // Nutzerdaten holen und falls Analyse-Ergebnis vorhanden, einziehen
            getUserAnalysisData().then((roiData) {
              if (roiData != null) {
                fillAnalysisResultsIntoApp(roiData);
              }
            });

            selectedToolbarIcons[2] = true;

            Future.delayed(Duration(seconds: 2), () {
              // Falls der Nutzer angemeldet und verifiziert ist, gehe weiter zum Analysis-Screen
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StartAnalysis(title: 'Analysis'),
                  ),
                  (route) => false,
                ),
              );
            });
          }
        }

        // Übergangshintergrund bis alles vollständig geladen wurde
        return Scaffold(
            body: Stack(children: [
          // Background Image
          Positioned.fill(
            //
            child: Image(
              image: AssetImage('assets/images/homescreen_background.png'),
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: SizedBox(
              width: 50.0, // Breite des Indikators
              height: 50.0, // Höhe des Indikators
              child: CircularProgressIndicator(),
            ),
          )
        ]));
      },
    );
  }

  void fillAnalysisResultsIntoApp(DocumentSnapshot<Object?> roiData) {
    String eyeColor = roiData.get('eyeColorCategory');
    for (EyeColorCategory category in EyeColorCategory.values) {
      if (category.name == eyeColor) {
        eyeColorCategory = category;
        break;
      }
    }

    String eyeShape = roiData.get('eyeShapeCategory');
    for (EyeShapeCategory category in EyeShapeCategory.values) {
      if (category.name == eyeShape) {
        eyeShapeCategory = category;
        break;
      }
    }

    String blushColor = roiData.get('blushCategory');
    for (BlushCategory category in BlushCategory.values) {
      if (category.name == blushColor) {
        blushCategory = category;
        break;
      }
    }

    String blushShape = roiData.get('blushShapeCategory');
    for (BlushShapeCategory category in BlushShapeCategory.values) {
      if (category.name == blushShape) {
        blushShapeCategory = category;
        break;
      }
    }

    String lipColor = roiData.get('lipCategory');
    for (LipCategory category in LipCategory.values) {
      if (category.name == lipColor) {
        lipCategory = category;
        break;
      }
    }

    String browColor = roiData.get('browCategory');
    for (BrowCategory category in BrowCategory.values) {
      if (category.name == browColor) {
        browCategory = category;
        break;
      }
    }

    String browShape = roiData.get('browShapeCategory');
    for (BrowShapeCategory category in BrowShapeCategory.values) {
      if (category.name == browShape) {
        browShapeCategory = category;
        break;
      }
    }
  }

  Future<DocumentSnapshot<Object?>?> getUserAnalysisData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String useruid = user.uid;
      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('roiData')
            .doc(useruid)
            .get();

        if (documentSnapshot.exists) {
          return documentSnapshot;
        } else {}
      } catch (error) {
        print('Konnte Nutzerdaten nicht finden');
      }
    } else {}
    return null;
  }
}
