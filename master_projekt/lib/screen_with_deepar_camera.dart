import 'dart:io';

import 'package:deepar_flutter_lib/deepar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:master_projekt/feature_one.dart';
import 'package:master_projekt/main.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:master_projekt/face_painter.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

class ScreenWithDeeparCamera extends StatefulWidget {
  const ScreenWithDeeparCamera(
      {required this.child,
      required this.deepArPreviewKey,
      required this.isAfterAnalysis});
  final Widget child;
  final GlobalKey deepArPreviewKey;
  final bool isAfterAnalysis;

  @override
  State<ScreenWithDeeparCamera> createState() => _ScreenWithDeeparCamera();
}

Map<int, bool> selectedButtonsRois = {0: false, 1: false, 2: false, 3: false};

class _ScreenWithDeeparCamera extends State<ScreenWithDeeparCamera> {
  int i = 0;
  List<Face> faces = [];
  late FaceDetector faceDetector;
  Timer? _screenshotTimer;

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

    if (widget.isAfterAnalysis) {
      // Starte regelmäßige Screenshots zur Erkennung der Features
      startScreenshotTimer();
    }
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
        key: widget.deepArPreviewKey,
        child: Scaffold(
          backgroundColor: Colors.green,
          body: Stack(
            children: [
              // Hintergrund: CameraWidget
              Transform.scale(
                scale: scale, //scale,
                child: Center(
                    // TODO: iOS-Sonderfall einfügen!
                    child: deepArController.isInitialized || Platform.isIOS
                        ? DeepArPreview(deepArController)
                        : //deepArController.hasPermission ?
                        CircularProgressIndicator()
                    //: TODO Error Widget wegen Kamera/Mikrofon-Berechtigung
                    ),
              ),
              // CustomPaint für das Malen von Kästchen um ROIs auf das Bild
              if (showRecommendations)
                CustomPaint(
                  foregroundPainter: FacePainter(null, faces),
                ),
              // Vordergrund-Inhalt: UI-Features
              widget.child,
              if (showRecommendations && roiRectangles.isNotEmpty)
                // Dynamisch platzierte Buttons
                for (int i = 0; i < roiRectangles.length; i++)
                  Positioned(
                    left: roiRectangles[i].left,
                    top: roiRectangles[i].top,
                    width: roiRectangles[i].width,
                    height: roiRectangles[i].height,
                    child: TransparentButton(
                      onPressed: () {
                        print("Button $i clicked!");
                        selectedButtonsRois[i] = !selectedButtonsRois[i]!;
                        String tabToSelect = "eyes"; 
                        switch(i){
                          case 1:
                           tabToSelect = "blush";
                          case 2: 
                          tabToSelect = "lips";
                          case 3: 
                          tabToSelect = "brows";
                        }
                        // Diese Methode wird verwendet, um auf den Zustand der übergeordneten StatefulWidget-Klasse (FeatureOne) zuzugreifen, da FeatureOne die Methode updateSelectedTab enthält.
                        final featureOneState =
                            context.findAncestorStateOfType<FeatureOneState>();
                        if (featureOneState != null) {
                          featureOneState.updateSelectedTab(tabToSelect);
                        }
                      },
                      buttonId: i,
                    ),
                  ),
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
    // TODO Error-Screen weil nur Front-Kamera erlaubt ist
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
      final boundary = widget.deepArPreviewKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
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

      final nv21Bytes =
          convertPngToNv21(pngBytes, image.width.toInt(), image.height.toInt());

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

// TransparentButton: ein Button, der aussieht wie ein Rechteck
class TransparentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int buttonId;

  TransparentButton({required this.onPressed, required this.buttonId});

  Color getBorderColor() {
    bool? isButtonSelected = selectedButtonsRois[buttonId];
    if (isButtonSelected == null || isButtonSelected == false) {
      return Colors.grey[600]!;
    } else {
      return Colors.pink[100]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(color: getBorderColor(), width: 2), // Rahmen
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Container(), // Kein Inhalt, da transparent
    );
  }
}
