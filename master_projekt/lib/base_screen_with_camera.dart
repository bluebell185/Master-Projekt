import 'package:deepar_flutter_lib/deepar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/main.dart';

class BaseScreenWithCamera extends StatelessWidget {
  final Widget child;

  const BaseScreenWithCamera({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hintergrund: CameraWidget
          Transform.scale(
            // TODO
            scale: 1.36,
            child: Center(
              child: 
                deepArController.isInitialized
                 ? DeepArPreview(deepArController)
                  : CircularProgressIndicator(),
            ),
           ),

          // Vordergrund-Inhalt
          child,
        ],
      ),
    );
  }
}
