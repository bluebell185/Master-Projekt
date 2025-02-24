import 'dart:io';

import 'package:image/image.dart' as img;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:master_projekt/main.dart';
import 'package:master_projekt/ui/info_dialog.dart';
import 'package:path_provider/path_provider.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Camera Widget: 
                                  - TO DO
------------------------------------------------------------------------------------------------------------------------------------------------*/

String eyeColor = 'Augenfarbe noch nicht gefunden';
String lipColor = 'Lippenfarbe noch nicht gefunden';
String eyebrowColor = 'Augenbrauenfarbe noch nicht gefunden';
String faceColor = 'Gesichtsfarbe noch nicht gefunden';

double inputImageWidth = 1;
double inputImageHeight = 1;
Size screenSize = Size.zero;

bool isCameraDisposed = false;

FaceDetector faceDetector = FaceDetector(options: FaceDetectorOptions());
late CameraController cameraController;
late CameraDescription selfieCam;

Face faceForAnalysis =
    Face(boundingBox: Rect.zero, landmarks: {}, contours: {});

/*
In diesem Widget wird die Kamera für den Analyse-Screen eingerichtet und geöffnet
*/
class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  List<Face> faces = [];
  bool gotFaceForAnalysis = false;

  @override
  void initState() {
    super.initState();
    final detectorOptions = FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
        enableContours: true,
        enableTracking: true,
        minFaceSize: 0.3,
        performanceMode: FaceDetectorMode.accurate);
    faceDetector = FaceDetector(options: detectorOptions);

    // Auswahl der Selfie-Kamera
    selfieCam = chooseSelfieCamera();

    // Kamera initialisieren - Hier Audio auf false, da sonst auch nach Mikrofonberechtigung gefragt wird
    cameraController = CameraController(selfieCam, ResolutionPreset.high,
        enableAudio: false,
        fps: 15,
        imageFormatGroup: (Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888));
    cameraController.initialize().then((_) async {
      if (!mounted) {
        return;
      }

      await cameraController.startImageStream((CameraImage image) async {
        // Das aktuelle Kamerabild muss nun in ein InputImage umgewandelt werden
        final visionImage =
            inputImageFromCameraImage(image, selfieCam, cameraController);

        // Bildgröße für spätere Punktanpassungen
        inputImageHeight = visionImage!.metadata!.size.height;
        inputImageWidth = visionImage.metadata!.size.width;

        // Gesichter & Konturen finden
        final detectedFaces = await faceDetector.processImage(visionImage);

        if (!gotFaceForAnalysis &&
            detectedFaces.isNotEmpty &&
            detectedFaces.first.landmarks[FaceLandmarkType.leftEye] != null &&
            detectedFaces.first.contours[FaceContourType.face] != null &&
            detectedFaces.first.leftEyeOpenProbability! > 0.6 &&
            detectedFaces.first.rightEyeOpenProbability! > 0.6) {
          gotFaceForAnalysis = true;

          faceForAnalysis = detectedFaces.first;

          // Pfad zum Speichern
          // https://stackoverflow.com/a/50804807
          // https://pub.dev/packages/path_provider
          final Directory tempDir = await getTemporaryDirectory();
          final String pathToSave =
              '${tempDir.path}/captured_image_for_color_detection.jpg';

          // https://stackoverflow.com/a/58966922
          img.Image imgImage = img.Image(width: 12, height: 12);
          if (image.format.group == ImageFormatGroup.nv21) {
            imgImage = convertNV21(image);
          } else if (image.format.group == ImageFormatGroup.bgra8888) {
            imgImage = convertBGRA8888(image);
          }

          File(pathToSave).writeAsBytesSync(img.encodeJpg(imgImage));

          // if (cameraController.value.isInitialized) {
          //   cameraController.stopImageStream();
          // }
        }
      });
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("Access Camera Denied");
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const InfoDialog(
                  title: 'missing permissions',
                  content:
                      'you need to give permission for camera and microphone in order to use this app and its features. \n in order to give the permissions, close the app and open it again or open it in your settings and grant the permissions there.',
                  buttonText: 'ok',
                );
              },
            );
          default:
            print("Problem with permissions: $e");
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    faceDetector.close();
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized || isCameraDisposed) {
      return Container();
    }

    // Lösung für ein verzerrtes Kamerabild von: https://stackoverflow.com/a/61487358
    var camera = cameraController.value;
    // Bildschirmgröße ermitteln
    screenSize = MediaQuery.of(context).size;

    double scale = screenSize.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Hintergrund: CameraWidget
          Transform.scale(
            scale: scale,
            child: Center(
                child: cameraController.value.isInitialized
                    ? CameraPreview(cameraController)
                    : CircularProgressIndicator()),
          ),
          // Vordergrund-Inhalt: UI-Features
          widget.child,
        ],
      ),
    );
  }

  CameraDescription chooseSelfieCamera() {
    for (final camera in camerasOfPhone) {
      if (camera.lensDirection == CameraLensDirection.front) {
        return camera;
      }
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const InfoDialog(
          title: 'no front camera detected',
          content:
              'you need to use a device with a front camera in order to use the app with all its features!',
          buttonText: 'ok',
        );
      },
    );

    return camerasOfPhone[0];
  }

  Uint8List concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (var plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }
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

// https://stackoverflow.com/a/76379833
img.Image convertBGRA8888(CameraImage image) {
  return img.Image.fromBytes(
      height: image.height,
      width: image.width,
      bytes: (image.planes[0].bytes).buffer,
      format: img.Format.uint8,
      order: img.ChannelOrder.bgra);
}

// https://stackoverflow.com/a/77857241
img.Image convertNV21(CameraImage image) {
  final width = image.width.toInt();
  final height = image.height.toInt();
  Uint8List yuv420sp = image.planes[0].bytes;

  // Initial conversion from NV21 to RGB
  final outImg =
      img.Image(width: height, height: width); // Note the swapped dimensions
  final int frameSize = width * height;

  for (int j = 0, yp = 0; j < height; j++) {
    int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
    for (int i = 0; i < width; i++, yp++) {
      int y = (0xff & yuv420sp[yp]) - 16;
      if (y < 0) y = 0;
      if ((i & 1) == 0) {
        v = (0xff & yuv420sp[uvp++]) - 128;
        u = (0xff & yuv420sp[uvp++]) - 128;
      }
      int y1192 = 1192 * y;
      int r = (y1192 + 1634 * v);
      int g = (y1192 - 833 * v - 400 * u);
      int b = (y1192 + 2066 * u);

      if (r < 0) {
        r = 0;
      } else if (r > 262143) r = 262143;
      if (g < 0) {
        g = 0;
      } else if (g > 262143) g = 262143;
      if (b < 0) {
        b = 0;
      } else if (b > 262143) b = 262143;

      outImg.setPixelRgba(j, width - i - 1, ((r << 6) & 0xff0000) >> 16,
          ((g >> 2) & 0xff00) >> 8, (b >> 10) & 0xff, 100);
    }
  }
  return outImg;
  // Rotate the image by 90 degrees (or 270 degrees if needed)
  // return imglib.copyRotate(outImg, -90); // Use -90 for a 270 degrees rotation
}

void doFaceAnalysis() async {}
