import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deepar_flutter_lib/deepar_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:master_projekt/analysis_results.dart';
import 'package:master_projekt/auth_widget.dart';
import 'package:master_projekt/start_analysis.dart';
import 'package:master_projekt/ui/buttons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

late List<CameraDescription> camerasOfPhone;
final DeepArController deepArController = DeepArController();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Identifizieren der verbauten Kameras im Gerät
  camerasOfPhone = await availableCameras();

  // Initialisierung DeepAR Kamera
  deepArController.initialize(
      androidLicenseKey:
          "1d81a1e3d04ae4f558fb6cea2af08afbe173c8e660ce68c2be2a0ca981bce3c02703ded82b8cc3f9",
      iosLicenseKey:
          "bd36fd6e5b55bf93100f8a4188e1a16f797be4c07b102eb5a29c577511836491b050cf80020512f9",
      resolution: Resolution.high);

  // Initialisierung Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Basis-Widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name TBD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

// Diese Klasse ruft den Homescreen auf, über den man durch den CTA-Button "continue" weitergeleitet wird
class HomeScreen extends StatelessWidget {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Home')),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            //
            child: Image(
              image: AssetImage('assets/images/homescreen_background.png'),
              fit: BoxFit.fill,
            ),
          ),

          // Willkommens-Text
          Positioned(
            top: 300,
            left: 40,
            child: SizedBox(
              width: 240,
              //height: 192,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'welcome to',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Sans Serif Collection',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: 0.40,
                    ),
                  ),
                  SizedBox(height: 25), // 25px vertical gap

                  Container(
                    width: 238,
                    height: 104,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: Image.asset(
                      'assets/logo.png',
                    ),
                  ),
                  SizedBox(height: 10), // 25px vertical gap

                  Text(
                    '- your personal make up guide',
                    textAlign: TextAlign.center,
                    softWrap: false, // verhindert Zeilenumbruch
                    overflow: TextOverflow.visible, // Text bleibt sichtbar
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Sans Serif Collection',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: 0.32,
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData) {
                  // CTA Button unten, führt zu StartAnalysis()
                  Stack(children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 140,
                      child: Center(
                        child: PrimaryButton(
                          buttonText: 'continue',
                          onPressed: () {
                            // Nutzerdaten holen und falls Analyse-Ergebnis vorhanden, einziehen
                            getUserAnalysisData().then((roiData) {
                              if (roiData != null) {
                                fillAnalysisResultsIntoApp(roiData);
                              }
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    StartAnalysis(title: 'Analysis'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 70,
                      child: Center(
                        child: PrimaryButton(
                          buttonText: 'sign in',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AuthWidget(db),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ]);
                } else {
                  return Positioned(
                    left: 0,
                    right: 0,
                    bottom: 70,
                    child: Center(
                      child: PrimaryButton(
                        buttonText: 'continue',
                        onPressed: () {
                          // Nutzerdaten holen und falls Analyse-Ergebnis vorhanden, einziehen
                          getUserAnalysisData().then((roiData) {
                            if (roiData != null) {
                              fillAnalysisResultsIntoApp(roiData);
                            }
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StartAnalysis(title: 'Analysis'),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                return Container();
              }),
        ],
      ),
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
