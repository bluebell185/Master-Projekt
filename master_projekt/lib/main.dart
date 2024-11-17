import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/feature_one.dart';

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

// In eine eigene File moven?
// Diese Klasse ruft den Homescreen auf, über den man durch den CTA-Button "continue" weitergeleitet wird
// Kamera muss aber noch eingebaut werden -> in FeatureOne?
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
              image: AssetImage('assets/homescreen_background.png'),
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

          // CTA Button unten, führt zu FeatureOne
          Positioned(
            left: 0,
            right: 0,
            bottom: 70, // 70px Padding von bottom
            child: Center(
              child: SizedBox(
                width: 300,
                child: TextButton(
                  onPressed: () {
                    // Navigation zu FeatureOne
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeatureOne(title: 'Feature One'),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF342C32), // Background color
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                  ),
                  child: Text(
                    'continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Sans Serif Collection',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.32,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
