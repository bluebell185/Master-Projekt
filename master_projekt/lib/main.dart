import 'package:deepar_flutter_lib/deepar_flutter.dart';
//import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:master_projekt/base_screen_with_camera.dart';
import 'package:master_projekt/start_analysis.dart';
import 'package:master_projekt/ui/buttons.dart';

late List<CameraDescription> camerasOfPhone;
final DeepArController deepArController = DeepArController();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  camerasOfPhone = await availableCameras();

  deepArController.initialize(
      androidLicenseKey:
          "1d81a1e3d04ae4f558fb6cea2af08afbe173c8e660ce68c2be2a0ca981bce3c02703ded82b8cc3f9",
      iosLicenseKey:
          "bd36fd6e5b55bf93100f8a4188e1a16f797be4c07b102eb5a29c577511836491b050cf80020512f9",
      resolution: Resolution.medium);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // TODO 
  // deepArController.dispose();

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
      //const CameraWidget(title: 'Home Page'),
    );
  }
}

// Diese Klasse ruft den Homescreen auf, über den man durch den CTA-Button "continue" weitergeleitet wird
class HomeScreen extends StatelessWidget {
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

          // CTA Button unten, führt zu StartAnalysis()
          Positioned(
            left: 0,
            right: 0,
            bottom: 70,
            child: Center(
              child: PrimaryButton(
                buttonText: 'continue',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StartAnalysis(title: 'Analysis'),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
