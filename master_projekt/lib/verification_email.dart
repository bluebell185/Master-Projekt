import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:master_projekt/auth_widget.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Verification Email:
                                  - prüft, ob die Email-Adresse des Nutzers authentifiziert ist
                                  - sendet Verifikationsmails und wartet auf deren Bestätigung 
                                  - da die Verifikation erst nach Erstellen eines Kontos möglich ist, wird diese Klasse erst danach aufgerufen
------------------------------------------------------------------------------------------------------------------------------------------------*/

class EmailVerification extends StatefulWidget {
  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool isEmailVerified = false;
  Timer? timer;
  User? user;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    user = FirebaseAuth.instance.currentUser!;

    // Stelle zuerst sicher, dass die Email noch nicht verifiziert ist
    if (!isEmailVerified) {
      sendVerificationMail();
      // Wenn die Verifikationsmail versandt wurde: prüfe alle 5 Sekunden, ob der Nutzer verifiziert ist
      timer = Timer.periodic(Duration(seconds: 5), (_) => checkEmailVerified());
    } else {
      // ... falls der User schon verifiziert ist, gehe direkt weiter
    }
  }

// wenn der Timer nicht mehr genutzt wird, kann er gelöscht werden
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isEmailVerified) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Confirmation'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            titleTextStyle: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
          body: Column(
            children: [
              Expanded(
                  child: Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "We sent you an e-mail with a confirmation link.\n\nPlease confirm your mail address by clicking on the link!",
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                      ))),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  onPressed: sendVerificationMail,
                  child: Text('Send again'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: ElevatedButton(
                  onPressed: cancelSignUp,
                  child: Text('Cancel'),
                ),
              )
            ],
          ));
    } else {
      return AuthWidget(FirebaseFirestore.instance);
    }
  }

  // Sende Verifikationsmail an die registrierte Adresse
  Future sendVerificationMail() async {
    try {
      await user!.sendEmailVerification();
    } catch (e) {
      print(e);
    }
  }

  // Check, ob User seine Email verifiziert hat
  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future cancelSignUp() async {
    timer?.cancel();
    await FirebaseAuth.instance.signOut();
  }
}
