// Widget nach Willkommensbildschirm mit Login und Registrierung
// Nutzt Firebase UI Elemente

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            // sideBuilder: (context, constraints) {
            //   return Padding(
            //     padding: const EdgeInsets.all(20),
            //     child: FractionallySizedBox(
            //       widthFactor: 0.7,
            //       heightFactor: 0.5,
            //       child: AspectRatio(
            //         aspectRatio: 1,
            //         child: SvgPicture.asset('images/CampusConnect_orange.svg',
            //             fit: BoxFit.scaleDown),
            //       ),
            //     ),
            //   );
            // },
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
            // User? user = snapshot.data;
            // TODO Daten rausziehen und in analysis_results speisen

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
}
