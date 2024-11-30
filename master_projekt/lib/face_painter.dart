import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'coordinates_translator.dart';

class FacePainter extends CustomPainter {
  ui.Image? image;
  List<Face> faces;
  List<Rect> boundingBoxes = [];
  List<Map<FaceContourType, FaceContour?>> contours = [];
  double scale = 1.0;
  double imageWidth = 1.0;
  double imageHeight = 1.0;
  Size screenSize = Size.zero;
  InputImageRotation imageRotation = InputImageRotation.rotation270deg;

  FacePainter(
      this.image,
      this.faces,
      double pointScale,
      double inputImageWidth,
      double inputImageHeight,
      Size scrSize,
      InputImageRotation inputImageRotation) {
    for (var face in faces) {
      boundingBoxes.add(face.boundingBox);
      contours.add(face.contours);
    }

    scale = pointScale;
    imageWidth = inputImageWidth;
    imageHeight = inputImageHeight;
    screenSize = scrSize;
    imageRotation = inputImageRotation;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint contourPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.grey[600]!;

    //   final Paint contourPaint2 = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 2.0
    //   ..color = Colors.red;

    //   Rect testRect = Rect.fromLTWH(
    //     20.0,
    //     20.0,
    //     75,
    //     35);
    // canvas.drawRect(testRect, contourPaint2);

    // Zeichne die Konturen
    if (faces.isNotEmpty){
      if (faces[0].landmarks[FaceLandmarkType.leftEye] != null){
    // Auge
    final Point<int> rightEyePos =
        faces[0].landmarks[FaceLandmarkType.rightEye]!.position;

        Rect eyeR = Rect.fromCircle(center: Offset(rightEyePos.x.toDouble(),
        rightEyePos.y.toDouble()), radius: 20);
    canvas.drawRect(eyeR, contourPaint);

    final Point<int> leftCheekPos =
        faces[0].landmarks[FaceLandmarkType.leftCheek]!.position;

        Rect cheek = Rect.fromCircle(center: Offset(leftCheekPos.x.toDouble(),
        leftCheekPos.y.toDouble()), radius: 30);
    canvas.drawRect(cheek, contourPaint);

    final Point<int> mouthPos1 =
        faces[0].landmarks[FaceLandmarkType.bottomMouth]!.position;

        Rect mouth = Rect.fromCircle(center: Offset(mouthPos1.x.toDouble(),
        mouthPos1.y.toDouble()), radius: 30);
    canvas.drawRect(mouth, contourPaint);

      }
    }
      // Size inputImageSize = Size(imageWidth, imageHeight);
      // translateCoordinatesAndPaintContours(canvas, faces[i], contourPaint,
      //     screenSize, inputImageSize, imageRotation);

      // final faceContour = faces[i].contours;

      // for (var contourType in faceContour.keys) {
      //   final contour = faceContour[contourType];
      //   if (contour != null) {
      //     List<Offset> adjustedContourPoints =
      //         adjustFaceContourPoints(contour.points);
      //     canvas.drawPoints(
      //       ui.PointMode.points,
      //       adjustedContourPoints.toList(),
      //       contourPaint,
      //     );
      //   }
      // }
    
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

  void translateCoordinatesAndPaintContours(
      Canvas canvas,
      Face face,
      ui.Paint contourPaint,
      Size size,
      Size imageSize,
      InputImageRotation rotation) {
// TODO Feste Werte nochmal anpassen, dass a) für iOS klappt und b) generell flexibler ist, auch in Kästchengröße!!

    // Auge
    final Point<int> leftEyePos =
        face.landmarks[FaceLandmarkType.leftEye]!.position;
    final Point<int> rightEyePos =
        face.landmarks[FaceLandmarkType.rightEye]!.position;

    Rect oldEye = Rect.fromCenter(
        center: Offset(
          translateX(leftEyePos.x, rotation, size, imageSize, scale),
          translateY(leftEyePos.y, rotation, size, imageSize, scale),
        ),
        width: 60,
        height: 30);

    Rect eyeL = Rect.fromLTWH(
        translateX(leftEyePos.x, rotation, size, imageSize, scale) - 22,
        translateY(leftEyePos.y, rotation, size, imageSize, scale) - 22,
        75,
        35);
    canvas.drawRect(eyeL, contourPaint);

    Rect eyeR = Rect.fromLTWH(
        translateX(rightEyePos.x, rotation, size, imageSize, scale) - 60,
        translateY(rightEyePos.y, rotation, size, imageSize, scale) - 22,
        75,
        35);
    canvas.drawRect(eyeR, contourPaint);

    // canvas.drawCircle(
    //     Offset(
    //       translateX(leftEyePos.x, rotation, size, imageSize, scale),
    //       translateY(leftEyePos.y, rotation, size, imageSize, scale),
    //     ),
    //     10,
    //     contourPaint);

// Augenbrauen
    final Paint contourPaint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.orange;

    final List<Point<int>> rightEyeBrowPosBottom =
        face.contours[FaceContourType.rightEyebrowBottom]!.points;
    final List<Point<int>> rightEyeBrowPosTop =
        face.contours[FaceContourType.rightEyebrowTop]!.points;

    final List<Point<int>> leftEyeBrowPosBottom =
        face.contours[FaceContourType.leftEyebrowBottom]!.points;
    final List<Point<int>> leftEyeBrowPosTop =
        face.contours[FaceContourType.leftEyebrowTop]!.points;

// Top Eyebrow is more left, bottom more right in points (see image ml kit Mann)
    Rect rightEyebrow = Rect.fromLTRB(
        translateX(rightEyeBrowPosTop[0].x, rotation, size, imageSize, scale) - 25,
        translateY(rightEyeBrowPosTop[3].y, rotation, size, imageSize, scale) - 5,
        translateX(
            rightEyeBrowPosBottom[4].x, rotation, size, imageSize, scale),
        translateY(
            rightEyeBrowPosBottom[0].y, rotation, size, imageSize, scale) );
    canvas.drawRect(rightEyebrow, contourPaint1);

    Rect leftEyebrow = Rect.fromLTRB(
        translateX(leftEyeBrowPosTop[0].x, rotation, size, imageSize, scale) + 25,
        translateY(leftEyeBrowPosTop[3].y, rotation, size, imageSize, scale) - 5,
        translateX(
            leftEyeBrowPosBottom[4].x, rotation, size, imageSize, scale) -5,
        translateY(
            leftEyeBrowPosBottom[0].y, rotation, size, imageSize, scale));
    canvas.drawRect(leftEyebrow, contourPaint1);
// Nase
    // final Point<int> nosePos =
    //     face.landmarks[FaceLandmarkType.noseBase]!.position;

    // canvas.drawRect(
    //     Rect.fromCenter(
    //         center: Offset(
    //       translateX(nosePos.x, rotation, size, imageSize, scale),
    //       translateY(nosePos.y, rotation, size, imageSize, scale),
    //     ),
    //         width: 30,
    //         height: 30),
    //     contourPaint1);

    // canvas.drawCircle(
    //     Offset(
    //       translateX(nosePos.x, rotation, size, imageSize, scale),
    //       translateY(nosePos.y, rotation, size, imageSize, scale),
    //     ),
    //     10,
    //     contourPaint1);

// Mund
    final Point<int> mouthBottomPos =
        face.landmarks[FaceLandmarkType.bottomMouth]!.position;
    final Point<int> mouthLeftPos =
        face.landmarks[FaceLandmarkType.leftMouth]!.position;
    final Point<int> mouthRightPos =
        face.landmarks[FaceLandmarkType.rightMouth]!.position;

    final Paint contourPaint2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.blue;

    Rect mouthRect = Rect.fromLTRB(
        translateX(mouthLeftPos.x, rotation, size, imageSize, scale) + 10,
        translateY(mouthBottomPos.y, rotation, size, imageSize, scale) - 30,
        translateX(mouthRightPos.x, rotation, size, imageSize, scale) - 15,
        translateY(mouthBottomPos.y, rotation, size, imageSize, scale) + 10);
    canvas.drawRect(mouthRect, contourPaint2);

    // canvas.drawCircle(
    //     Offset(
    //       translateX(mouthBottomPos.x, rotation, size, imageSize, scale),
    //       translateY(mouthBottomPos.y, rotation, size, imageSize, scale),
    //     ),
    //     10,
    //     contourPaint2);
    // canvas.drawCircle(
    //     Offset(
    //       translateX(mouthLeftPos.x, rotation, size, imageSize, scale),
    //       translateY(mouthLeftPos.y, rotation, size, imageSize, scale),
    //     ),
    //     10,
    //     contourPaint2);
    // canvas.drawCircle(
    //     Offset(
    //       translateX(mouthRightPos.x, rotation, size, imageSize, scale),
    //       translateY(mouthRightPos.y, rotation, size, imageSize, scale),
    //     ),
    //     10,
    //     contourPaint2);

    // Cheek
    final Paint contourPaint3 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.pink[200]!;

      final Point<int> cheekPosLeft =
        face.landmarks[FaceLandmarkType.leftCheek]!.position;
      final Point<int> cheekPosRight =
        face.landmarks[FaceLandmarkType.rightCheek]!.position;

    canvas.drawRect(Rect.fromCenter(center: Offset(translateX(cheekPosLeft.x, rotation, size, imageSize, scale) + 10, translateY(cheekPosLeft.y, rotation, size, imageSize, scale)), width: 20, height: 20), contourPaint3);
    canvas.drawRect(Rect.fromCenter(center: Offset(translateX(cheekPosRight.x, rotation, size, imageSize, scale) - 10, translateY(cheekPosRight.y, rotation, size, imageSize, scale)), width: 20, height: 20), contourPaint3);

    // List<Offset> adjustedContourPoints =
    //     adjustFaceContourPointsTest(contour.points);
    // canvas.drawPoints(
    //   ui.PointMode.points,
    //   //contour.points.map((e) => Offset(e.x.toDouble(), e.y.toDouble())).toList(),
    //   adjustedContourPoints.toList(),
    //   contourPaint,
    // );
  }
}