import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  ui.Image? image;
  List<Face> faces;
  List<Rect> boundingBoxes = [];
  List<Map<FaceContourType, FaceContour?>> contours = [];
  double scale = 1.0;
  double imageWidth = 1.0;
  double imageHeight = 1.0;
  Size screenSize = Size.zero;

  FacePainter(this.image, this.faces, double pointScale, double inputImageWidth,
      double inputImageHeight, Size screenSize) {
    for (var face in faces) {
      boundingBoxes.add(face.boundingBox);
      contours.add(face.contours);
    }

    scale = pointScale;
    imageWidth = inputImageWidth;
    imageHeight = inputImageHeight;
    screenSize = screenSize;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint contourPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    // Zeichne die Konturen
    for (var i = 0; i < faces.length; i++) {
      final faceContour = faces[i].contours;

      for (var contourType in faceContour.keys) {
        final contour = faceContour[contourType];
        if (contour != null) {
          List<Offset> adjustedContourPoints =
              adjustFaceContourPoints(contour.points);
          canvas.drawPoints(
            ui.PointMode.points,
            adjustedContourPoints.toList(),
            contourPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return faces != oldDelegate.faces;
  }

  List<Offset> adjustFaceContourPoints(List<Point> points) {
    List<Offset> adjustedPoints = [];

    // Skalierung dieses Bildes, da das Kamerabild für eine unverzerrte Darstellung auch skaliert wurde
    double scaledImageWidth = imageWidth * scale;
    double scaledImageHeight = imageHeight * scale;

    // Berechne die Offset-Verschiebung, da das Bild zentriert sein muss
    double offsetX = (scaledImageWidth - imageWidth) / 2 + 50;
    double offsetY = (scaledImageHeight - imageHeight) / 2 - 110;

    for (var point in points) {
      // Skalierung der einzelnen Konturpunkte
      double adjustedX = point.x.toDouble() * scale * 0.95;
      double adjustedY = point.y.toDouble() * scale * 0.9;

      // Da es sich um die Selfie-Kamera handelt, die X-Koordinaten spiegeln
      adjustedX = scaledImageWidth - adjustedX;

      // Zentrierung
      adjustedX -= offsetX;
      adjustedY -= offsetY;

      adjustedPoints.add(Offset(adjustedX, adjustedY));
    }

    return adjustedPoints;
  }
}
