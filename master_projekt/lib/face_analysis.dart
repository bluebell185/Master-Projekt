import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:master_projekt/analysis_results.dart';
import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/main.dart';
import 'package:path_provider/path_provider.dart';

class FaceAnalysis {
  static Future<void> analyseColorsInFace(Face face) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String pathToSave =
        '${tempDir.path}/captured_image_for_color_detection.jpg';
    File imageCacheFile = File(pathToSave);

    final img.Image? decodedImage =
        img.decodeImage(imageCacheFile.readAsBytesSync());
    if (decodedImage == null) throw 'Bild konnte nicht geladen werden.';

    getAverageEyeColor(decodedImage, face);
    getAverageLipColor(decodedImage, face);
    getAverageEyebrowColor(decodedImage, face);
    getAverageFaceColor(decodedImage, face);
  }

  static void getAverageEyeColor(img.Image? image, Face face) {
    Point<int> leftEyeMiddlePoint =
        face.landmarks[FaceLandmarkType.leftEye]!.position;

    // Berechne die durchschnittliche Farbe in der Nähe des Augenmittelpunkts
    setEyeColorCategory(calculateAverageColor(
        image!,
        Offset(
            leftEyeMiddlePoint.x.toDouble(), leftEyeMiddlePoint.y.toDouble()),
        5,
        RoiColorTypes.eye));
  }

  static void getAverageLipColor(img.Image image, Face face) {
    Point<int> lipUpperBorder =
        face.contours[FaceContourType.lowerLipTop]!.points[4];
    Point<int> lipLowerBorder =
        face.contours[FaceContourType.lowerLipBottom]!.points[4];
    int lipHeight = (lipLowerBorder.y - lipUpperBorder.y);
    Point<int> lipMiddlePoint =
        Point(lipUpperBorder.x, lipUpperBorder.y + (lipHeight / 2).round());
    setLipCategory(calculateAverageColor(
        image,
        Offset(lipMiddlePoint.x.toDouble(), lipMiddlePoint.y.toDouble()),
        (lipHeight / 2 - 1).round(),
        RoiColorTypes.lip));
  }

  static void getAverageEyebrowColor(img.Image image, Face face) {
    Point<int> eyebrowUpperLeftCorner =
        face.contours[FaceContourType.leftEyebrowTop]!.points[2];
    Point<int> eyebrowLowerLeftCorner =
        face.contours[FaceContourType.leftEyebrowBottom]!.points[2];
    Point<int> eyebrowUpperRightCorner =
        face.contours[FaceContourType.leftEyebrowTop]!.points[3];
    Point<int> eyebrowLowerRightCorner =
        face.contours[FaceContourType.leftEyebrowBottom]!.points[3];

    double middleXValue = eyebrowUpperLeftCorner.x +
        (((eyebrowUpperRightCorner.x - eyebrowUpperLeftCorner.x) / 2) +
            ((eyebrowLowerRightCorner.x - eyebrowLowerLeftCorner.x) / 2) / 4);
    double middleYValue = eyebrowUpperLeftCorner.y +
        (((eyebrowLowerRightCorner.x - eyebrowUpperRightCorner.x) / 2) +
            ((eyebrowLowerLeftCorner.x - eyebrowUpperLeftCorner.x) / 2) / 4);

    eyebrowColor = calculateAverageColor(
        image, Offset(middleXValue, middleYValue), 3, RoiColorTypes.eyebrow);
  }

  static void getAverageFaceColor(img.Image? image, Face face) {
    Point<int> cheekMiddlePoint =
        face.landmarks[FaceLandmarkType.leftCheek]!.position;

    // Berechne die durchschnittliche Farbe in der Nähe des Augenmittelpunkts
    setBlushCategory(calculateAverageColor(
        image!,
        Offset(cheekMiddlePoint.x.toDouble(), cheekMiddlePoint.y.toDouble()),
        5,
        RoiColorTypes.face));
  }

// Hilfsfunktion zur Berechnung der durchschnittlichen Farbe in einem Bereich
  static String calculateAverageColor(
      img.Image image, Offset position, int radius, RoiColorTypes roiType) {
    double totalRed = 0, totalGreen = 0, totalBlue = 0;
    int count = 0;

    // Beispiel: Sammle Pixelwerte in einem kleinen Bereich um das Auge
    for (int dx = -radius; dx <= radius; dx++) {
      for (int dy = -radius; dy <= radius; dy++) {
        final pixel = image.getPixelSafe(
            position.dx.toInt() + dx, position.dy.toInt() + dy);
        totalRed += pixel.r;
        totalGreen += pixel.g;
        totalBlue += pixel.b;
        count++;
      }
    }

    // Durchschnittliche Farbe berechnen
    Color rgbColorValue = Color.fromARGB(
        255, totalRed ~/ count, totalGreen ~/ count, totalBlue ~/ count);
    return getColorCategoryFromHSV(rgbColorValue, roiType);
  }

  static String getColorCategoryFromHSV(Color color, RoiColorTypes roiType) {
    // RGB-Werte in den Bereich 0.0 bis 1.0 umwandeln
    double r = color.red / 255.0;
    double g = color.green / 255.0;
    double b = color.blue / 255.0;

    // Maximal- und Minimalwerte der RGB-Komponenten
    double max = [r, g, b].reduce((a, b) => a > b ? a : b);
    double min = [r, g, b].reduce((a, b) => a < b ? a : b);

    // Hue (Farbton) berechnen
    double hue;
    if (max == min) {
      hue = 0.0; // Keine Farbe (Grau)
    } else if (max == r) {
      hue = (60 * ((g - b) / (max - min)) + 360) % 360;
    } else if (max == g) {
      hue = (60 * ((b - r) / (max - min)) + 120) % 360;
    } else {
      hue = (60 * ((r - g) / (max - min)) + 240) % 360;
    }

    // Sättigung (Saturation) berechnen
    double saturation = max == 0 ? 0 : (max - min) / max;

    // Helligkeit (Value) berechnen
    double value = max;

    // Farbe anhand des Farbtons (Hue) kategorisieren
    switch (roiType) {
      case RoiColorTypes.eye:
        if (saturation < 0.5 && value > 0.8) {
          return "grey"; // Helle Farben mit geringer Sättigung
        } else if (hue >= 60 && hue < 180) {
          return "green";
        } else if (hue >= 180 && hue < 300) {
          return "blue";
        } else if (hue >= 5 && hue < 60) {
          return "brown";
        }
      case RoiColorTypes.eyebrow:
        if (value < 0.2) {
          return "Schwarz"; // Sehr dunkle Augenbrauen
        } else if (hue >= 30 && hue < 60 && saturation < 0.5) {
          return "Blond"; // Helle Augenbrauen
        } else if (hue >= 20 && hue < 40 && saturation > 0.5) {
          return "Braun"; // Brauntöne
        } else if (hue >= 10 && hue < 20 && value < 0.6) {
          return "Dunkelbraun"; // Dunklere Brauntöne
        }
      case RoiColorTypes.lip:
        if (saturation < 0.3 && value > 0.7) {
          return "pink"; // Dezente, blasse Lippen
        } else if (hue >= 0 && hue < 30) {
          return "red"; // Rote Töne
        } else if (hue >= 30 && hue < 60) {
          return "coral"; // Warme Korall- und Orangetöne
        } else if (hue >= 60 && hue < 100 && saturation > 0.5) {
          return "nude"; // Dunklere Brauntöne
        }
      case RoiColorTypes.face:
        if (saturation < 0.3 && value > 0.8) {
          return "light"; // Sehr helle Haut
        } else if (hue >= 20 && hue < 50 && saturation < 0.7) {
          return "beige"; // Neutrale bis leicht gelbliche Haut
        } else if (hue >= 15 && hue < 30 && saturation > 0.4) {
          return "olive"; // Haut mit olivfarbenen Untertönen
        } else if (hue >= 9 && hue < 30 && saturation > 0.6) {
          return "tanned"; // Dunklere Haut
        } else if (saturation < 0.2 && value < 0.5) {
          return "dark"; // Sehr dunkle Haut mit geringer Helligkeit
        }
    }
    return "Farbe nicht eindeutig erkennbar";
  }

  
}

  
// static Future<void> doFaceAnalysis() async {
//   // Bild von Gesicht nehmen - wird als jpg-Datei im Cache gespeichert
//   File screenshot = await deepArController.takeScreenshot();
//   if (screenshot.existsSync()){
//     // Aus dem Cache einlesen
// final jpgBytes = await screenshot.readAsBytes();

// // Bild dekodieren
// final decodedImage = img.decodeImage(jpgBytes);
//     if (decodedImage == null) {
//       print("Bild konnte nicht dekodiert werden.");
//       return null;
//     }

// // In NV21-Format umwandeln, damit der FaceDetector damit arbeiten kann
// final nv21Bytes = convertToNV21(decodedImage);

//  InputImage inputImage = InputImage.fromBytes(
//         bytes: nv21Bytes,
//         metadata: InputImageMetadata(
//           size: Size(decodedImage.width.toDouble(), decodedImage.height.toDouble()),
//           rotation: InputImageRotation
//               .rotation0deg, // TODO Passe je nach Kameraposition an
//           format: InputImageFormat.nv21,
//           bytesPerRow: decodedImage.width *
//               4, // 4 Bytes pro Pixel bei RGBA/BGRA
//         ),
//       );

//       // Gesichtskonturen rausziehen
//       if (inputImage.bytes != null) {
//         print("erlofg");
//         final detectedFaces = await faceDetector.processImage(inputImage);
//         if (detectedFaces.isNotEmpty) {
//           Face face = detectedFaces[0];
//           face.contours;
//         }
//       }
//   }
  

//   //.jpg
// // TODO Bild löschen
// }

// static Uint8List convertToNV21(img.Image image) {
//   final width = image.width;
//   final height = image.height;
//   final ySize = width * height;
//   final uvSize = width * height ~/ 2;

//   final nv21 = Uint8List(ySize + uvSize);

//   int yIndex = 0;
//   int uvIndex = ySize;

//   for (int y = 0; y < height; y++) {
//     for (int x = 0; x < width; x++) {
//       final pixel = image.getPixel(x, y);

//       // Extrahiere RGB-Werte
//       final r = pixel.r;
//       final g = pixel.g;
//       final b = pixel.b;

//       // Konvertiere in YUV
//       final yValue = (0.299 * r + 0.587 * g + 0.114 * b).round();
//       final uValue = ((b - yValue) * 0.565 + 128).round();
//       final vValue = ((r - yValue) * 0.713 + 128).round();

//       // Clamp-Werte auf [0, 255]
//       nv21[yIndex++] = yValue.clamp(0, 255);

//       if (y % 2 == 0 && x % 2 == 0 && uvIndex < nv21.length - 2) {
//         nv21[uvIndex++] = vValue.clamp(0, 255);
//         nv21[uvIndex++] = uValue.clamp(0, 255);
//       }
//     }
//   }

//   return nv21;
// }