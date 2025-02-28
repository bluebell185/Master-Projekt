import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:master_projekt/analysis_results.dart';
import 'package:path_provider/path_provider.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Face Analysis: 
                                  - Farbe bestimmen von Auge, Lippen, Augenbraue und Haut
                                  - Form bestimmen von Auge und Gesicht
                                  - Speichern der Ergebnisse in Datenbank
------------------------------------------------------------------------------------------------------------------------------------------------*/

class FaceAnalysis {
  static Future<bool> analyseColorsInFace(Face face) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String pathToSave =
        '${tempDir.path}/captured_image_for_color_detection.jpg';
    File imageCacheFile = File(pathToSave);

    try {
      final img.Image? decodedImage =
          img.decodeImage(imageCacheFile.readAsBytesSync());
      if (decodedImage == null) return false;

      getAverageEyeColor(decodedImage, face);
      getAverageLipColor(decodedImage, face);
      getAverageEyebrowColor(decodedImage, face);
      getAverageFaceColor(decodedImage, face);
    } catch (e) {
      return false;
    }

    getEyeShape(face);
    getFaceShape(face);

// Form der Brauen wird (noch) nicht ermittelt/angezeigt - wird der Vollständigkeit halber aber trotzdem gefüllt
    browShapeCategory = BrowShapeCategory.straight;

    putDataIntoDb();

    return true;
  }

  static void getEyeShape(Face face) {
    List<Point> eyeContour = face.contours[FaceContourType.leftEye]!.points;

    // Wichtige Punkte holen
    final innerCorner = eyeContour[0]; // Innerer Augenwinkel
    final outerCorner = eyeContour[8]; // Äußerer Augenwinkel
    final maxPoint = eyeContour[4]; // oberster Punkt des Auges
    final minPoint = eyeContour[12]; // niedrigster Punkt des Auges

    // Berechnung Höhe und Breite Auge
    final width = (outerCorner.x - innerCorner.x).abs();
    final height = minPoint.y - maxPoint.y;

    // Augenwinkel berechnen
    final angleCorners =
        (outerCorner.y - innerCorner.y) / (outerCorner.x - innerCorner.x).abs();

    // Klassifikation
     setEyeShapeCategory(
        "almond"); // im Zweifelsfall häufigste Augenform zurückgeben

    if (height / width > 0.5) setEyeShapeCategory("round");

    if (angleCorners < -0.05) setEyeShapeCategory("downturned");

    if (angleCorners > 0.05) setEyeShapeCategory("upturned");

    // Zukunft: setEyeShapeCategory("monolid";
  }

  static void getFaceShape(Face face) {
    List<Point> faceContour = face.contours[FaceContourType.face]!.points;

    // Wichtige Punkte holen
    final top = faceContour[0]; // Punkt ganz oben (Stirnmitte)
    final bottom = faceContour[18]; // Punkt ganz unten (Kinnspitze)
    final left = faceContour[9]; // Linke Kieferkante
    final right = faceContour[27]; // Rechte Kieferkante

    // Berechnung Gesichtslänge und -breite
    double faceHeight = bottom.y.toDouble() - top.y.toDouble();
    double faceWidth = left.x.toDouble() - right.x.toDouble();

    double lengthToWidthRatio = faceHeight / faceWidth;

    // Krümmung der Kieferlinie
    double jawCurve = calculateJawCurve(faceContour);

    // Klassifikation basierend auf Kriterien
    if (lengthToWidthRatio > 1.4 && jawCurve < 0.1) {
      setBlushShapeCategory("oval");
    } else if (lengthToWidthRatio <= 1.4 &&
        lengthToWidthRatio >= 1.0 &&
        jawCurve >= 0.1) {
      setBlushShapeCategory("round");
    } else {
      setBlushShapeCategory("square");
    }
  }

  static double calculateJawCurve(List<Point> faceContour) {
    // Berechnet die Krümmung der Kieferlinie (Punkte unterer Teil der Gesichtskontur)
    List<Point> jawPoints = faceContour.sublist(7, 29);

    double totalCurve = 0.0;
    for (int i = 1; i < jawPoints.length - 1; i++) {
      // 3 Punkte: Aktueller, der davor und der danach
      Point previous = jawPoints[i - 1];
      Point current = jawPoints[i];
      Point next = jawPoints[i + 1];

      // Winkel zwischen aufeinanderfolgenden Segmenten
      double angle = _angleBetween(previous, current, next);
      totalCurve += angle;
    }

    // Normalisierter Wert
    return totalCurve / jawPoints.length;
  }

  static double _angleBetween(Point a, Point b, Point c) {
    // Berechne den Winkel zwischen drei Punkten 
    // Zuerst Vektoren ausrechnen
    double ab = sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2));
    double bc = sqrt(pow(c.x - b.x, 2) + pow(c.y - b.y, 2));
    double ac = sqrt(pow(c.x - a.x, 2) + pow(c.y - a.y, 2));

    // Winkel zwischen Vektoren
    return acos((pow(ab, 2) + pow(bc, 2) - pow(ac, 2)) / (2 * ab * bc));
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
        face.contours[FaceContourType.lowerLipTop]!.points[4]; // Höchster Punkt Unterlippe
    Point<int> lipLowerBorder =
        face.contours[FaceContourType.lowerLipBottom]!.points[4]; // Niedrigster Punkt Unterlippe
    int lipHeight = (lipLowerBorder.y - lipUpperBorder.y);
    Point<int> lipMiddlePoint =
        Point(lipUpperBorder.x, lipUpperBorder.y + (lipHeight / 2).round()); // Mittelpunkt der Unterlippe
    setLipCategory(calculateAverageColor(
        image,
        Offset(lipMiddlePoint.x.toDouble(), lipMiddlePoint.y.toDouble()),
        (lipHeight / 2 - 1).round(), // Rechteck für die Analyse variabel je nach Lippenhöhe
        RoiColorTypes.lip));
  }

  static void getAverageEyebrowColor(img.Image image, Face face) {
    // Auswahl von Punkten, die ungefähr mittig sein sollen auf Länge der Braue hin gesehen
    Point<int> eyebrowUpperLeftCorner =
        face.contours[FaceContourType.leftEyebrowTop]!.points[2];  
    Point<int> eyebrowLowerLeftCorner =
        face.contours[FaceContourType.leftEyebrowBottom]!.points[2]; 
    Point<int> eyebrowUpperRightCorner =
        face.contours[FaceContourType.leftEyebrowTop]!.points[3];
    Point<int> eyebrowLowerRightCorner =
        face.contours[FaceContourType.leftEyebrowBottom]!.points[3];

    // Mittelpunkt bei Treffpunkt der Diagonalen
    double middleXValue = eyebrowUpperLeftCorner.x +
        (((eyebrowUpperRightCorner.x - eyebrowUpperLeftCorner.x) / 2) +
            ((eyebrowLowerRightCorner.x - eyebrowLowerLeftCorner.x) / 2) / 4);
    double middleYValue = eyebrowUpperLeftCorner.y +
        (((eyebrowLowerRightCorner.x - eyebrowUpperRightCorner.x) / 2) +
            ((eyebrowLowerLeftCorner.x - eyebrowUpperLeftCorner.x) / 2) / 4);

    setBrowCategory(calculateAverageColor(
        image, Offset(middleXValue, middleYValue), 3, RoiColorTypes.eyebrow));
  }

  static void getAverageFaceColor(img.Image? image, Face face) {
    Point<int> cheekMiddlePoint =
        face.landmarks[FaceLandmarkType.leftCheek]!.position; // Landmark auf Wange als Mittelpunkt

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

    // Beispiel: Sammle Pixel-Farb-Werte in einem kleinen Bereich um den definierten Mittelpunkt
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
        } else if (hue >= 60 && hue < 175) {
          return "green";
        } else if (hue >= 175 && hue < 270) {
          return "blue";
        } // else if (hue >= 5 && hue < 60) {
        return "brown"; // Im Zweifelsfall die häufigste Augenfarbe zurückgeben

      case RoiColorTypes.eyebrow:
        if (value < 0.2) {
          return "black"; // Sehr dunkle Augenbrauen
        } else if (hue >= 30 && hue < 60 && saturation < 0.5) {
          return "blonde"; // Helle Augenbrauen
        } else if (hue >= 20 && hue < 40 && saturation > 0.5) {
          return "brown"; // Brauntöne
        } // else if (hue >= 10 && hue < 20 && value < 0.6) {
        return "brown"; // Dunklere Brauntöne // Im Zweifelsfall die häufigste Augenbrauenfarbe zurückgeben

      case RoiColorTypes.lip:
        if (saturation < 0.3 && value > 0.7) {
          return "pink"; // Dezente, blasse Lippen
        } else if (hue >= 0 && hue < 21) {
          return "red"; // Rote Töne
        } else if (hue >= 21 && hue < 41) {
          return "coral"; // Warme Korall- und Orangetöne
        } else if (hue >= 41 && hue < 100 && saturation > 0.5) {
          return "nude"; // Dunklere Brauntöne
        }
        return "red"; // Im Zweifelsfall zurückgeben

      case RoiColorTypes.face:
        if (saturation < 0.3 && value > 0.8) {
          return "light"; // Sehr helle Haut
        } else if (hue >= 20 && hue < 45 && saturation < 0.7) {
          return "beige"; // Neutrale bis leicht gelbliche Haut
        } else if (hue >= 45 && hue < 56 && saturation > 0.4) {
          return "olive"; // Haut mit olivfarbenen Untertönen
        } else if (hue >= 9 && hue < 30 && saturation > 0.6) {
          return "tanned"; // Dunklere Haut
        } else if (saturation > 0.4 && value < 0.5) {
          return "dark"; // Sehr dunkle Haut mit geringer Helligkeit
        }
        return "beige"; // Im Zweifelsfall zurückgeben
    }
  }

  static void putDataIntoDb() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String useruid = user.uid;
      final roiData = {
        'blushCategory': blushCategory!.name,
        'blushShapeCategory': blushShapeCategory!.name,
        'browCategory': browCategory!.name,
        'browShapeCategory': browShapeCategory!.name,
        'eyeColorCategory': eyeColorCategory!.name,
        'eyeShapeCategory': eyeShapeCategory!.name,
        'lipCategory': lipCategory!.name,
        'userId': useruid,
      };
      final userTable = FirebaseFirestore.instance.collection('roiData');
      userTable.doc(useruid).set(roiData);
    }
  }
}