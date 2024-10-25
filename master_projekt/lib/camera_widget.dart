import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
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
      //  controller.startImageStream(_processCameraImage).then((value) {
      //   if (widget.onCameraFeedReady != null) {
      //     widget.onCameraFeedReady!();
      //   }
      //   if (widget.onCameraLensDirectionChanged != null) {
      //     widget.onCameraLensDirectionChanged!(camera.lensDirection);
      //   }
      // });
      setState(() {});

      await controller.startImageStream((CameraImage image) async {
        // Das aktuelle Kamerabild muss nun in ein InputImage umgewandelt werden
        // CameraDescription description = controller.description;
        final visionImage =
            inputImageFromCameraImage(image, selfieCam, controller);
        // InputImage visionImage = InputImage.fromBytes(
        //     concatenatePlanes(image.planes),
        //     buildMetaData(image,
        //         rotationIntToImageRotation(description.sensorOrientation)));
        final List<Face> faces = await faceDetector.processImage(visionImage!);
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

  // void _processCameraImage(CameraImage image) {
  //   final inputImage = inputImageFromCameraImage(image, camera, controller);
  //   if (inputImage == null) return;
  //   widget.onImage(inputImage);
  // }

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
    // faceDetector.close();
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
  // get image rotation
  // it is used in android to convert the InputImage from Dart to Java
  // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
  // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
  final sensorOrientation = camera.sensorOrientation;
  InputImageRotation? rotation;
  if (Platform.isIOS) {
    rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
  } else if (Platform.isAndroid) {
    var rotationCompensation =
        _orientations[controller!.value.deviceOrientation];
    if (rotationCompensation == null) return null;
    if (camera.lensDirection == CameraLensDirection.front) {
      // front-facing
      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    } else {
      // back-facing
      rotationCompensation =
          (sensorOrientation - rotationCompensation + 360) % 360;
    }
    rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
  }
  if (rotation == null) return null;

  // get image format
  final format = InputImageFormatValue.fromRawValue(image.format.raw);
  // validate format depending on platform
  // only supported formats:
  // * nv21 for Android
  // * bgra8888 for iOS
  if (format == null ||
      (Platform.isAndroid && format != InputImageFormat.nv21) ||
      (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

  // since format is constraint to nv21 or bgra8888, both only have one plane
  if (image.planes.length != 1) return null;
  final plane = image.planes.first;

  // compose InputImage using bytes
  return InputImage.fromBytes(
    bytes: plane.bytes,
    metadata: InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation, // used only in Android
      format: format, // used only in iOS
      bytesPerRow: plane.bytesPerRow, // used only in iOS
    ),
  );
}

// InputImageMetadata buildMetaData(
//   CameraImage image,
//   InvalidType rotation,
// ) {
//   return GoogleVisionImageMetadata(
//     rawFormat: image.format.raw,
//     size: Size(image.width.toDouble(), image.height.toDouble()),
//     rotation: rotation,
//     planeData: image.planes.map(
//       (Plane plane) {
//         return GoogleVisionImagePlaneMetadata(
//           bytesPerRow: plane.bytesPerRow,
//           height: plane.height,
//           width: plane.width,
//         );
//       },
//     ).toList(),
//   );
// }

// ImageRotation rotationIntToImageRotation(int rotation) {
//   switch (rotation) {
//     case 0:
//       return ImageRotation.rotation0;
//     case 90:
//       return ImageRotation.rotation90;
//     case 180:
//       return ImageRotation.rotation180;
//     default:
//       assert(rotation == 270);
//       return ImageRotation.rotation270;
//   }
// }

void getFaceData(List<Face> faces) {
  for (Face face in faces) {
    final Rect boundingBox = face.boundingBox;

    final double? rotX =
        face.headEulerAngleX; // Head is tilted up and down rotX degrees
    final double? rotY =
        face.headEulerAngleY; // Head is rotated to the right rotY degrees
    final double? rotZ =
        face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

    // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
    // eyes, cheeks, and nose available):
    final FaceLandmark? leftEar = face.landmarks[FaceLandmarkType.leftEar];
    if (leftEar != null) {
      final Point<int> leftEarPos = leftEar.position;
    }

    // If classification was enabled with FaceDetectorOptions:
    // if (face.smilingProbability != null) {
    //   final double? smileProb = face.smilingProbability;
    // }

    // If face tracking was enabled with FaceDetectorOptions:
    if (face.trackingId != null) {
      final int? id = face.trackingId;
    }
  }
}
