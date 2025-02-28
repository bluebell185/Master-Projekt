import 'dart:io';

import 'package:deepar_flutter_lib/deepar_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:master_projekt/analysis_results.dart';
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

import 'package:master_projekt/ui/tabs.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Screen with DeepAR Camera: 
                                  - Beinhaltet die Anzeige der DeepAR-Preview
                                  - child-Elemente von FeatureOne sind als "child" eingebunden, um die build-Prozesse zu entkoppeln
                                  - Regelmäßig Aufnahme von Screenshots für Anzeige der ROI-Buttons (-> Konvertierung)
                                  - Anzeige ROI-Buttons
------------------------------------------------------------------------------------------------------------------------------------------------*/

class ScreenWithDeeparCamera extends StatefulWidget {
  const ScreenWithDeeparCamera(
      {super.key,
      required this.child,
      required this.deepArPreviewKey,
      required this.isAfterAnalysis,
      required this.isFeatureOne});
  final Widget child;
  final GlobalKey deepArPreviewKey;
  final bool isAfterAnalysis;
  final bool isFeatureOne;

  @override
  State<ScreenWithDeeparCamera> createState() => ScreenWithDeeparCameraState();
}

Map<int, bool> selectedButtonsRois = {0: false, 1: false, 2: false, 3: false};
bool shouldCalcRoiButtons = true;

Timer? screenshotTimer;

class ScreenWithDeeparCameraState extends State<ScreenWithDeeparCamera>
    with WidgetsBindingObserver {
  int i = 0;
  List<Face> faces = [];
  late FaceDetector faceDetector;
  bool runDeeparCamera = true;

  void rebuildDeepArKamera() {
    setState(() {
      runDeeparCamera = true;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final detectorOptions = FaceDetectorOptions(
        enableClassification: false,
        enableLandmarks: true,
        enableContours: true,
        enableTracking: true,
        minFaceSize: 0.3,
        performanceMode: FaceDetectorMode.accurate);
    faceDetector = FaceDetector(options: detectorOptions);

    if ( //widget.isAfterAnalysis &&
        shouldCalcRoiButtons &&
            (screenshotTimer == null ||
                (screenshotTimer != null && !screenshotTimer!.isActive)) &&
            currentFeature != 2 &&
            currentFeature != 0) {
      // Starte regelmäßige Screenshots zur Erkennung der Features
      if (!Platform.isIOS) {
        startScreenshotTimer();

      // Falls Widget nicht neu gebaut wurde
        Future.delayed(Duration(seconds: 2), () {
          if ((screenshotTimer == null ||
                  (screenshotTimer != null && !screenshotTimer!.isActive)) &&
              currentFeature != 2 &&
              currentFeature != 0) {
            startScreenshotTimer();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    faceDetector.close();
    screenshotTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lösung für ein verzerrtes Kamerabild von: https://stackoverflow.com/a/61487358
    final screenSize = MediaQuery.of(context).size;

    double scale = screenSize.aspectRatio * deepArController.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    if ((screenshotTimer == null ||
            (screenshotTimer != null && !screenshotTimer!.isActive)) &&
        currentFeature != 2 &&
        currentFeature != 0) {
      startScreenshotTimer();
    }

    return RepaintBoundary(
        key: widget.deepArPreviewKey,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Hintergrund: CameraWidget
              Offstage(
                offstage: false,
                child: Transform.scale(
                  scale: scale, //scale,
                  child: Center(
                      child:
                          (deepArController.isInitialized || Platform.isIOS) &&
                                  runDeeparCamera
                              ? DeepArPreview(
                                  key: ValueKey('DeepArPreview$currentFeature'),
                                  deepArController)
                              : CircularProgressIndicator()),
                ),
              ),
              // CustomPaint für das Malen von Kästchen um ROIs auf das Bild
              if (showRecommendations && widget.isFeatureOne)
                CustomPaint(
                  foregroundPainter: FacePainter(null, faces),
                ),
              // Vordergrund-Inhalt: UI-Features
              widget.child,
              if (showRecommendations && widget.isFeatureOne)
                Offstage(
                  offstage: roiRectangles
                      .isEmpty, // Buttons nicht erstellen, wenn die Liste mit Rectangles leer ist
                  child: Stack(
                    children: [
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
                              for (int k = 0; k < 4; k++) {
                                if (k == i) {
                                  selectedButtonsRois[i] =
                                      !selectedButtonsRois[i]!;
                                } else {
                                  selectedButtonsRois[k] = false;
                                }
                              }
                              String tabToSelect = "eyes";
                              switch (i) {
                                case 1:
                                  tabToSelect = "blush";
                                case 2:
                                  tabToSelect = "lips";
                                case 3:
                                  tabToSelect = "brows";
                              }
                              // Auf den Zustand der übergeordneten StatefulWidget-Klasse FeatureOne zugreifen, um State dort zu abzuändern
                              final featureOneState = context
                                  .findAncestorStateOfType<FeatureOneState>();
                              if (featureOneState != null) {
                                selectedIndex = i;
                                featureOneState
                                    .updateSelectedTabFromButtons(tabToSelect);
                                imageLinks = getImageLinks(tabToSelect);
                                filterPaths = getFilters(tabToSelect);
                              }
                            },
                            buttonId: i,
                          ),
                        ),
                    ],
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
    print("Nur Frontkamera erlaubt, aber keine gefunden");
    return camerasOfPhone[0];
  }

  void startScreenshotTimer() {
    screenshotTimer?.cancel();
    screenshotTimer =
        Timer.periodic(const Duration(milliseconds: 850), (timer) {
      try {
        takeScreenshot();
      } catch (e) {
        print("Screenshot fehlgeschlagen: $e");
      }
    });
  }

  Future<void> takeScreenshot() async {
    try {
      final boundary = widget.deepArPreviewKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null || boundary.debugNeedsPaint) {
        print("RepaintBoundary nicht gefunden oder noch nicht fertig");
        return;
      }

      // Nimm das Bild als ui.Image
      final ui.Image image = await boundary.toImage(pixelRatio: 1);

      // Wandle ui.Image in Byte-Daten um (PNG-Format)
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final nv21Bytes =
          convertPngToNv21(pngBytes, image.width.toInt(), image.height.toInt());

      // Hier wäre Konvertierung für iOS angedacht -> convertPngToBgra8888

      InputImage inputImage = InputImage.fromBytes(
        bytes: nv21Bytes,
        metadata: InputImageMetadata(
          size: Size(boundary.size.width, boundary.size.height),
          rotation: InputImageRotation
              .rotation0deg, // Passe je nach Kameraposition an
          format: InputImageFormat.nv21,
          bytesPerRow: boundary.size.width.toInt() * 
              4, // 4 Bytes pro Pixel bei RGBA/BGRA (https://stackoverflow.com/a/52740776)
        ),
      );

      // Gesichtskonturen rausziehen
      if (inputImage.bytes != null && shouldCalcRoiButtons) {
        final detectedFaces = await faceDetector.processImage(inputImage);
        setState(() {
          faces = detectedFaces;
        });
      }
    } catch (e) {
      print("Error bei der Aufnahme von Screenshot: $e");
    }
  }

  Uint8List convertPngToNv21(Uint8List pngBytes, int width, int height) {
    // PNG in RGBA umwandeln
    final decodedImage = img.decodePng(pngBytes);
    if (decodedImage == null) {
      throw Exception("Failed to decode PNG");
    }

    // RGBA-Daten extrahieren
    final rgbaBytes = decodedImage.getBytes();

    // NV21 initialisieren
    final yuvSize = width * height + (width * height / 2).round();
    final nv21Bytes = Uint8List(yuvSize);

    // Konvertierung RGBA zu YUV (Y, U, V) -> https://answers.opencv.org/question/207593/how-to-convert-rgb-to-yuvnv21/
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

        // https://stackoverflow.com/a/52740776
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // App geht in den Hintergrund
      runDeeparCamera = false; // Pausieren des Kamera-Feeds
      print("Pause");
    } else if (state == AppLifecycleState.resumed) {
      // App kehrt zurück in den Vordergrund
      runDeeparCamera = true; // Wiederaufnahme des Kamera-Feeds
      if (screenshotTimer != null && !screenshotTimer!.isActive) {
        startScreenshotTimer();
      }
      print("Weiter");
    }
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
      return Color(0xFFFFDCE8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(
            color: getBorderColor(),
            width: 2), // Rahmen, der abgerundete Ecken hat
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Container(), // Kein Inhalt, da transparent
    );
  }
}
