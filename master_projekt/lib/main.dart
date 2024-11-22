import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/start_analysis.dart';
import 'package:master_projekt/ui/buttons.dart';

late List<CameraDescription> camerasOfPhone;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  camerasOfPhone = await availableCameras();

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
          PrimaryButton(
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
        ],
      ),
    );
  }
}
