// Widget nach Willkommensbildschirm mit Login und Registrierung
// Nutzt Firebase UI Elemente

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:master_projekt/analysis_results.dart';
import 'package:master_projekt/start_analysis.dart';
import 'dart:async';

import 'package:master_projekt/verification_email.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget(FirebaseFirestore db, {Key? key}) : super(key: key);

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
                child: const Text('Sign in'),
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
            // Falls der Nutzer angemeldet und verifiziert ist, gehe weiter
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StartAnalysis(title: 'Analysis'),
              ),
            );
          }
        }

        return Container();
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
        // TODO????
      }
    } else {}
    return null;
  }
}
