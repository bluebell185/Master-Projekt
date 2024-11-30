import 'dart:io';

import 'package:deepar_flutter_lib/deepar_flutter.dart';
//import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter/material.dart';
//import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/main.dart';
//=======
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
//import 'dart:ui/painting.dart' as ui;

import 'package:camera/camera.dart';
import 'package:deepar_flutter_lib/deepar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/face_painter.dart';
import 'package:master_projekt/main.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

class BaseScreenWithCamera extends StatefulWidget {
  const BaseScreenWithCamera({super.key, required this.child});
  final Widget child;

  @override
  State<BaseScreenWithCamera> createState() => _BaseScreenWithCamera();
}

class _BaseScreenWithCamera extends State<BaseScreenWithCamera> {
  int i = 0;
  List<Face> faces = [];
  late FaceDetector faceDetector;
  static GlobalKey deepArPreviewKey = GlobalKey();
  Timer? _screenshotTimer;

  // Auf true setzen, um Landmarks etc angezeigt zu bekommen
  bool isContourVisible = true;

  @override
  void initState() {
    super.initState();

    final detectorOptions = FaceDetectorOptions(
        enableClassification: false,
        enableLandmarks: true,
        enableContours: true,
        enableTracking: true,
        minFaceSize: 0.3,
        performanceMode: FaceDetectorMode.accurate);
    faceDetector = FaceDetector(options: detectorOptions);

// Starte regelmäßige Screenshots
    startScreenshotTimer();
  }

  @override
  void dispose() {
    faceDetector.close();
    deepArController.destroy();
    _screenshotTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lösung für ein verzerrtes Kamerabild von: https://stackoverflow.com/a/61487358
    final screenSize = MediaQuery.of(context).size;

    double scale = screenSize.aspectRatio * deepArController.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return RepaintBoundary(
        key: deepArPreviewKey,
        child: Scaffold(
          body: Stack(
            children: [
              // Hintergrund: CameraWidget
              Transform.scale(
                scale: scale, //scale,
                child: Center(
                    child: deepArController.isInitialized
                        ? DeepArPreview(deepArController)
                        : //deepArController.hasPermission ?
                        CircularProgressIndicator()
                    //: TODO Error Widget wegen Kamera/Mikrofon-Berechtigung
                    ),
              ),
              // CustomPaint für das Malen von Kästchen um ROIs auf das Bild
              if (isContourVisible)
                CustomPaint(
                  foregroundPainter: FacePainter(null, faces, scale, 0.0, 0.0,
                      screenSize, InputImageRotation.rotation270deg),
                ),
              // Vordergrund-Inhalt: UI-Features
              widget.child,
            ],
          ),
        ));
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

  void startScreenshotTimer() {
    _screenshotTimer =
        Timer.periodic(const Duration(milliseconds: 800), (timer) {
      takeScreenshot();
    });
  }

  Future<void> takeScreenshot() async {
    try {
      final boundary = deepArPreviewKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        print("RepaintBoundary nicht gefunden");
        return;
      }

      // Nimm das Bild als ui.Image
      final ui.Image image = await boundary.toImage(pixelRatio: 1.0);

      // Wandle ui.Image in Byte-Daten um (PNG-Format)
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final nv21Bytes = convertPngToNv21(
          pngBytes, image.width.toInt(), image.height.toInt());

      // TODO iOS -> convertPngToBgra8888

      InputImage inputImage = InputImage.fromBytes(
        bytes: nv21Bytes,
        metadata: InputImageMetadata(
          size: Size(boundary.size.width, boundary.size.height),
          rotation: InputImageRotation
              .rotation0deg, // TODO Passe je nach Kameraposition an
          format: InputImageFormat.nv21,
          bytesPerRow: boundary.size.width.toInt() *
              4, // 4 Bytes pro Pixel bei RGBA/BGRA
        ),
      );

      // Gesichtskonturen rausziehen
      if (inputImage.bytes != null) {
        final detectedFaces = await faceDetector.processImage(inputImage);
        if (detectedFaces.isNotEmpty) {
          setState(() {
            faces = detectedFaces;
          });
        }
      }
    } catch (e) {
      print("Error bei der Aufnahme von Screenshot: $e");
    }
  }

  Uint8List convertPngToNv21(Uint8List pngBytes, int width, int height) {
    // Schritt 1: PNG in RGBA umwandeln
    final decodedImage = img.decodePng(pngBytes);
    if (decodedImage == null) {
      throw Exception("Failed to decode PNG");
    }

    // Schritt 2: RGBA-Daten extrahieren
    final rgbaBytes = decodedImage.getBytes();

    // Schritt 3: NV21 initialisieren
    final yuvSize = width * height + (width * height / 2).round();
    final nv21Bytes = Uint8List(yuvSize);

    // Schritt 4: Konvertierung RGBA zu YUV (Y, U, V)
    int yIndex = 0;
    int uvIndex = width * height;

    for (int j = 0; j < height - 1; j++) {
      for (int i = 0; i < width - 1; i++) {
        final rgbaIndex = (j * width + i) * 4;
        final r = rgbaBytes[rgbaIndex];
        final g = rgbaBytes[rgbaIndex + 1];
        final b = rgbaBytes[rgbaIndex + 2];

        // YUV-Werte berechnen
        final y = ((66 * r + 129 * g + 25 * b + 128) >> 8) + 16;
        final u = ((-38 * r - 74 * g + 112 * b + 128) >> 8) + 128;
        final v = ((112 * r - 94 * g - 18 * b + 128) >> 8) + 128;

        // Y in NV21 speichern
        nv21Bytes[yIndex++] = y.clamp(0, 255);

        // U und V nur für jeden zweiten Pixel (2x2 Block)
        if (j % 2 == 0 && i % 2 == 0) {
          nv21Bytes[uvIndex++] = v.clamp(0, 255);
          nv21Bytes[uvIndex++] = u.clamp(0, 255);
        }
      }
    }

    return nv21Bytes;
  }
}
