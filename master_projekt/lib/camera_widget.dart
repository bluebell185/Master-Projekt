import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:master_projekt/main.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key, required this.title});

  final String title;

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    // Auswahl der Selfie-Kamera
    final CameraDescription selfieCam = chooseSelfieCamera();
    // Kamera initialisieren - Hier Audio auf false, da sonst auch nach Mikrofonberechtigung gefragt wird
    controller = CameraController(selfieCam, ResolutionPreset.medium,
        enableAudio: false);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("Access Camera Denied");
            // TODO Error-Widget/-Anzeige -> Kamera wird benötigt
            break;
          default:
            print("Problem with permissions");
            break;
        }
      }
    });
  }

  CameraDescription chooseSelfieCamera() {
    for (final camera in camerasOfPhone) {
      if (camera.lensDirection == CameraLensDirection.front) {
        return camera;
      }
    }
    // TODO Error-Screen weil keine Front-Kamera erlaubt ist
    return camerasOfPhone[0];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }

    // Solution by https://stackoverflow.com/a/61487358
    var camera = controller.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(controller),
      ),
    );
  }
}
