import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:master_projekt/face_painter.dart';
import 'package:master_projekt/main.dart';
import 'package:master_projekt/screen_with_deepar_camera.dart';
import 'package:master_projekt/test.dart';
import 'package:master_projekt/ui/recomm_tiles.dart';
import 'package:master_projekt/ui/tabs.dart';
import 'results_check.dart';
import 'analysis_results.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;

// UI-Elemente
import 'package:master_projekt/ui/text.dart';
import 'package:master_projekt/ui/toolbar.dart';

class FeatureOne extends StatefulWidget {
  final GlobalKey featureOneKey;

  const FeatureOne({
    super.key,
    required this.featureOneKey,
  });

  @override
  State<FeatureOne> createState() => FeatureOneState();
}

final GlobalKey<AnalysisResultsState> analysisResultsKey =
    GlobalKey<AnalysisResultsState>();

bool showRecommendations =
    true; // boolean zum Anzeigen von Frame mit Box 2 und 3

final DraggableScrollableController draggableController =
    DraggableScrollableController();

class FeatureOneState extends State<FeatureOne> {
  List<Face> faces = [];
  late FaceDetector faceDetector;
  Timer? _screenshotTimer;

  bool isBox2Or3Visible = false; // Zustandsabfrage: ist Box 2 oder 3 sichtbar?
  String? newSelectedTab;
  bool isBoxThreeOpen = false; // zur Navigation zwischen Box 2 und 3

  void navigateToBoxThree() {
    setState(() {
      isBoxThreeOpen = true;
    });
  }

  void navigateToBoxTwo() {
    setState(() {
      isBoxThreeOpen = false;
    });
  }

  void updateSelectedTab(String? tab) {
    setState(() {
      //newSelectedTab = tab; // Update den Parent state
      if (newSelectedTab == tab) {
        // Wenn der Tab bereits ausgewählt ist, deselektiere ihn
        newSelectedTab = null;
        selectedIndex = null;
        isBox2Or3Visible = false;
        showRecommendationList = false;
        print('Deselected Tab');
      } else {
        // Andernfalls wähle den neuen Tab aus
        newSelectedTab = tab;
        showRecommendationList = false;
        print('Selected Tab: $newSelectedTab');
      }
      if (tab == null) {
        // Box 2/3 ist nicht (mehr) sichtbar, sobald ein Tab deselected wurde
        isBox2Or3Visible = false;
        showRecommendationList = false;
      } else {
        // Box 2/3 ist sichtbar, sobald ein Tab ausgewählt wurde
        isBox2Or3Visible = true;
      }
    });
  }

  void updateSelectedTabFromButtons(String? tab) {
    setState(() {
      //newSelectedTab = tab; // Update den Parent state
      if (newSelectedTab == tab) {
        // Wenn der Tab bereits ausgewählt ist, deselektiere ihn
        newSelectedTab = null;
        selectedIndex = null;
        isBox2Or3Visible = false;
        showRecommendationList = false;
        print('Deselected Tab');
      } else {
        // Andernfalls wähle den neuen Tab aus
        newSelectedTab = tab;
        showRecommendationList = true;
        print('Selected Tab: $newSelectedTab');
      }
      if (tab == null) {
        // Box 2/3 ist nicht (mehr) sichtbar, sobald ein Tab deselected wurde
        isBox2Or3Visible = false;
        showRecommendationList = false;
      } else {
        // Box 2/3 ist sichtbar, sobald ein Tab ausgewählt wurde
        isBox2Or3Visible = true;
      }
    });
  }

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

    startScreenshotTimer();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        key: widget.featureOneKey,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ScreenTitle(
                      titleText: 'Analysis',
                      titleColor: Colors.white,
                    ),
                  ],
                ),
              ),
              Toolbar(),
              if (showRecommendations)
                CustomPaint(
                  foregroundPainter: FacePainter(null, faces),
                ),
              if (showRecommendations)
                DraggableScrollableSheet(
                  key: const GlobalObjectKey(
                      'DraggableScrollableSheet'), // https://github.com/flutter/flutter/issues/140603#issuecomment-1871077425
                  controller: draggableController,
                  initialChildSize: 0.25,
                  minChildSize: 0.25,
                  maxChildSize: isBox2Or3Visible ? 0.75 : 0.25,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: AnalysisResults(
                        key: analysisResultsKey,
                        selectedTab:
                            newSelectedTab, // weitergeben des geupdateten ausgewählten Tabs an AnalysisResults
                        isBoxThreeOpen: isBoxThreeOpen,
                        onNavigateToBoxThree: navigateToBoxThree,
                        onNavigateToBoxTwo: navigateToBoxTwo,
                        onTabSelected:
                            updateSelectedTab, // Update an widget.selectedTab in AnalysisResults, wenn sich Tab ändert
                        scrollController: scrollController,
                      ),
                    );
                  },
                ),
              if (showRecommendationList)
                ImageRecommendationsList(
                  images: imageLinks, // Preview-Images
                  filters: filterPaths, // Filter-Pfade
                  activeFilter: activeFilter, // Filter, der active ist
                  onTileTap: toggleFilter, // Callback für Tap-Event
                ),
              if (showRecommendations)
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
                              // Diese Methode wird verwendet, um auf den Zustand der übergeordneten StatefulWidget-Klasse (FeatureOne) zuzugreifen, da FeatureOne die Methode updateSelectedTab enthält.
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

  @override
  void dispose() {
    faceDetector.close();
    _screenshotTimer?.cancel();
    draggableController.dispose();
    super.dispose();
  }

  toggleFilter(String filterPath) {
    analysisResultsKey.currentState?.toggleFilter(filterPath);
  }

  void startScreenshotTimer() {
    _screenshotTimer =
        Timer.periodic(const Duration(milliseconds: 800), (timer) {
      takeScreenshot();
    });
  }

  Future<void> takeScreenshot() async {
    InputImage inputImage = InputImage.fromBytes(
        bytes: Uint8List(0),
        metadata: InputImageMetadata(
            size: Size(0, 0),
            rotation: InputImageRotation.rotation0deg,
            format: InputImageFormat.nv21,
            bytesPerRow: 0));

    try {
      final boundary = deepArRepaintBoundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        print("RepaintBoundary nicht gefunden");
        return;
      }

      // Nimm das Bild als ui.Image
      final ui.Image image = await boundary.toImage(pixelRatio: 1.0);

      if (Platform.isAndroid) {
        // Wandle ui.Image in Byte-Daten um (PNG-Format)
        final ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) return;

        final Uint8List pngBytes = byteData.buffer.asUint8List();

        final nv21Bytes = convertPngToNv21(
            pngBytes, image.width.toInt(), image.height.toInt());

        inputImage = InputImage.fromBytes(
          bytes: nv21Bytes,
          metadata: InputImageMetadata(
            size: Size(boundary.size.width, boundary.size.height),
            rotation: InputImageRotation.rotation0deg,
            format: InputImageFormat.nv21,
            bytesPerRow: boundary.size.width.toInt() *
                4, // 4 Bytes pro Pixel bei RGBA/BGRA
          ),
        );
      } else if (Platform.isIOS) {
        // Extrahiere die Pixeldaten im RGBA8888-Format
        final ByteData? rgbaByteData =
            await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        if (rgbaByteData == null) {
          print("RGBA-Daten konnten nicht extrahiert werden.");
        }
        final bgra8888Bytes = convertPngToBgra8888(image, rgbaByteData);

        inputImage = InputImage.fromBytes(
          bytes: bgra8888Bytes,
          metadata: InputImageMetadata(
            size: Size(boundary.size.width, boundary.size.height),
            rotation: InputImageRotation.rotation0deg, // TODO Anpassen
            format: InputImageFormat.bgra8888,
            bytesPerRow: boundary.size.width.toInt() *
                4, // 4 Bytes pro Pixel bei RGBA/BGRA
          ),
        );
      }

      // Gesichtskonturen rausziehen
      if (inputImage.bytes != null) {
        final detectedFaces = await faceDetector.processImage(inputImage);
        //if (detectedFaces.isNotEmpty) {
        setState(() {
          faces = detectedFaces;
        });
        //}
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

  Uint8List convertPngToBgra8888(ui.Image image, ByteData? rgbaByteData) {
    try {
      final Uint8List rgbaBytes = rgbaByteData!.buffer.asUint8List();
      final int pixelCount = image.width * image.height;

      // Erstelle einen Puffer für die BGRA-Daten
      final Uint8List bgraBytes = Uint8List(pixelCount * 4);

      // Konvertiere RGBA zu BGRA
      for (int i = 0; i < pixelCount; i++) {
        final int r = rgbaBytes[i * 4]; // Rot
        final int g = rgbaBytes[i * 4 + 1]; // Grün
        final int b = rgbaBytes[i * 4 + 2]; // Blau
        final int a = rgbaBytes[i * 4 + 3]; // Alpha

        // Schreibe in BGRA-Reihenfolge
        bgraBytes[i * 4] = b; // Blau
        bgraBytes[i * 4 + 1] = g; // Grün
        bgraBytes[i * 4 + 2] = r; // Rot
        bgraBytes[i * 4 + 3] = a; // Alpha
      }

      return bgraBytes;
    } catch (e) {
      print("Fehler bei der Konvertierung zu BGRA8888: $e");
      return Uint8List(0);
    }
  }
}
