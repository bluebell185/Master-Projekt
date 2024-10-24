import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:master_projekt/camera_widget.dart';

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
      home: const CameraWidget(title: 'Home Page'),
    );
  }
}
