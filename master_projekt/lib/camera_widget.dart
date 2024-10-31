import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'face_painter.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:master_projekt/main.dart';

/*
In diesem Widget wird die Kamera eingerichtet und geöffnet
*/
class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key, required this.title});

  final String title;

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController controller;
  List<Face> faces = [];
  double inputImageWidth = 1;
  double inputImageHeight = 1;

  // Set true to see the contour points found by ML Kit
  bool isContourVisible = false;

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
    final faceDetector = FaceDetector(options: detectorOptions);

    // Auswahl der Selfie-Kamera
    final CameraDescription selfieCam = chooseSelfieCamera();

    // Kamera initialisieren - Hier Audio auf false, da sonst auch nach Mikrofonberechtigung gefragt wird
    controller = CameraController(selfieCam, ResolutionPreset.medium,
        enableAudio: false,
        fps: 2,
        imageFormatGroup: (Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888));
    controller.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      setState(() {});

      await controller.startImageStream((CameraImage image) async {
        // Das aktuelle Kamerabild muss nun in ein InputImage umgewandelt werden
        // CameraDescription description = controller.description;
        final visionImage =
            inputImageFromCameraImage(image, selfieCam, controller);

        // Bildgröße für spätere Punktanpassungen
        inputImageHeight = visionImage!.metadata!.size.height;
        inputImageWidth = visionImage.metadata!.size.width;

        // Gesichter & Konturen finden
        final detectedFaces = await faceDetector.processImage(visionImage);
        setState(() {
          faces = detectedFaces;
        });
        getFaceData(faces);
      });
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
    // TODO:
    // faceDetector.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }

    // Lösung für ein verzerrtes Kamerabild von: https://stackoverflow.com/a/61487358
    var camera = controller.value;
    // Bildschirmgröße ermitteln
    final screenSize = MediaQuery.of(context).size;

    var scale = screenSize.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Scaffold(
      body: Stack(
        children: [
          // Kameravorschau
          Transform.scale(
            scale: scale,
            child: Center(
              child: controller.value.isInitialized
                  ? CameraPreview(controller)
                  : CircularProgressIndicator(),
            ),
          ),
          // CustomPaint für das Malen auf das Bild
          if (isContourVisible)
            CustomPaint(
              foregroundPainter: FacePainter(null, faces, scale,
                  inputImageHeight, inputImageWidth, screenSize),
            ),
        ],
      ),
    );
  }
}

Uint8List concatenatePlanes(List<Plane> planes) {
  final WriteBuffer allBytes = WriteBuffer();
  for (var plane in planes) {
    allBytes.putUint8List(plane.bytes);
  }
  return allBytes.done().buffer.asUint8List();
}

// Code Großteils von https://github.com/flutter-ml/google_ml_kit_flutter/tree/master/packages/google_mlkit_commons#creating-an-inputimage
final _orientations = {
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
};

// Code Großteils von https://github.com/flutter-ml/google_ml_kit_flutter/tree/master/packages/google_mlkit_commons#creating-an-inputimage
InputImage? inputImageFromCameraImage(
    CameraImage image, CameraDescription camera, CameraController controller) {
  // Bildrotation
  final sensorOrientation = camera.sensorOrientation;
  InputImageRotation? rotation;
  if (Platform.isIOS) {
    rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
  } else if (Platform.isAndroid) {
    var rotationCompensation =
        _orientations[controller.value.deviceOrientation];
    if (rotationCompensation == null) return null;
    rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
  }
  if (rotation == null) return null;

  // Bild Format
  final format = InputImageFormatValue.fromRawValue(image.format.raw);
  // Funktioniert nur mit
  // * nv21 für Android
  // * bgra8888 für iOS
  if (format == null ||
      (Platform.isAndroid && format != InputImageFormat.nv21) ||
      (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

  // beide gültige Formate besitzen nur einen Bildkanal (Plane)
  if (image.planes.length != 1) return null;
  final plane = image.planes.first;

  // InputImage zusammenstellen
  return InputImage.fromBytes(
    bytes: plane.bytes,
    metadata: InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: format,
      bytesPerRow: plane.bytesPerRow,
    ),
  );
}

void getFaceData(List<Face> faces) {
  for (Face face in faces) {
    // TODO work with face data
    final Rect boundingBox = face.boundingBox;

    final contours = face.contours;
    FaceContour? faceContour = contours[FaceContourType.face];
    faceContour?.points;

    final double? rotX =
        face.headEulerAngleX; // Head is tilted up and down rotX degrees
    final double? rotY =
        face.headEulerAngleY; // Head is rotated to the right rotY degrees
    final double? rotZ =
        face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

    final FaceLandmark? leftEar = face.landmarks[FaceLandmarkType.leftEar];
    if (leftEar != null) {
      final Point<int> leftEarPos = leftEar.position;
    }

    // If face tracking was enabled with FaceDetectorOptions:
    if (face.trackingId != null) {
      final int? id = face.trackingId;
    }
  }
}
