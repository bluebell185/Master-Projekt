import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/feature_one.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Face Painter: 
                                  - Berechnet aus Gesichtskoordinaten die Rechtecke um die ROIs rechtes Auge, linke Wange, linke Augenbraue und Mund
                                  - Fügt Rechteckdaten der Liste für die Buttons hinzu
                                  - Triggert Rebuild für jeden neuen Gesichtsdatensatz
                                  - Steuert das Verweinden der Buttons, wenn das DraggableSheet hoch gezogen wird
------------------------------------------------------------------------------------------------------------------------------------------------*/

List<Rect> roiRectangles = [];

class FacePainter extends CustomPainter {
  ui.Image? image;
  List<Face> faces;
  List<Rect> boundingBoxes = [];
  List<Map<FaceContourType, FaceContour?>> contours = [];

  FacePainter(this.image, this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    // Ermitteln der aktuellen Höhe des Draggable Sheet mit den Recommendations
    double draggedHeightOfDraggableSheet = draggableController.size;
    double draggableSheetHeightInPixels = draggableController.sizeToPixels(draggedHeightOfDraggableSheet);

    roiRectangles.clear();

    // Zeichnen der Kästen um ROIs herum
    if (!hideWidgets && faces.isNotEmpty &&
        faces[0].landmarks[FaceLandmarkType.leftEye] != null &&
         faces[0].contours.isNotEmpty
        && faces[0].landmarks[FaceLandmarkType.bottomMouth]!.position.y + 10 < (screenSize.height - draggableSheetHeightInPixels)) {

// --------- Kästchen um rechtes Auge -------------------------------------------------------
      // Position Auge
      final Point<int> rightEyePos =
          faces[0].landmarks[FaceLandmarkType.rightEye]!.position;
      // Maße Auge
      double eyeWidth = faces[0]
              .contours[FaceContourType.rightEye]!
              .points[8]
              .x
              .toDouble() -
          faces[0].contours[FaceContourType.rightEye]!.points[0].x.toDouble() +
          25;
      double eyeHeight = faces[0]
              .contours[FaceContourType.rightEye]!
              .points[12]
              .y
              .toDouble() -
          faces[0].contours[FaceContourType.rightEye]!.points[4].y.toDouble() +
          25;

      // Rechteck erstellen
      Rect eyeR = Rect.fromCenter(
          center: Offset(rightEyePos.x.toDouble(), rightEyePos.y.toDouble()),
          width: eyeWidth,
          height: eyeHeight);
      //canvas.drawRect(eyeR, contourPaint);
      roiRectangles.add(eyeR);

// --------- Kästchen um linke Wange -------------------------------------------------------
      // Position Wange
      final Point<int> leftCheekPos =
          faces[0].landmarks[FaceLandmarkType.leftCheek]!.position;

      // Rechteck erstellen
      Rect cheek = Rect.fromCircle(
          center: Offset(leftCheekPos.x.toDouble(), leftCheekPos.y.toDouble()),
          radius: 27);
      //canvas.drawRect(cheek, contourPaint);
      roiRectangles.add(cheek);

// --------- Kästchen um den Mund -------------------------------------------------------
      // Punkte zur Bestimmung der Kästchenposition- und größe, da mehrere Landmarks vorhanden sind
      final Point<int> mouthBottomPos =
          faces[0].landmarks[FaceLandmarkType.bottomMouth]!.position;
      final Point<int> mouthLeftPos =
          faces[0].landmarks[FaceLandmarkType.leftMouth]!.position;
      final Point<int> mouthRightPos =
          faces[0].landmarks[FaceLandmarkType.rightMouth]!.position;

      // Rechteck erstellen
      Rect mouthRect = Rect.fromLTRB(
          mouthLeftPos.x.toDouble() - 10,
          mouthBottomPos.y.toDouble() - 45,
          mouthRightPos.x.toDouble() + 10,
          mouthBottomPos.y.toDouble() + 10);
      //canvas.drawRect(mouthRect, contourPaint);
      roiRectangles.add(mouthRect);

// --------- Kästchen um die linke Augenbraue -------------------------------------------------------
      // Position Augenbraue
      final List<Point<int>> leftEyeBrowPosBottom =
          faces[0].contours[FaceContourType.leftEyebrowBottom]!.points;
      final List<Point<int>> leftEyeBrowPosTop =
          faces[0].contours[FaceContourType.leftEyebrowTop]!.points;

      // Die obere Augenbrauenlinie ist mehr links, die untere mehr rechts in den Punkten
      // (siehe Abbildung ml kit Mann in der Doku)
      Rect leftEyebrow = Rect.fromLTRB(
          leftEyeBrowPosTop[0].x.toDouble() - 10,
          leftEyeBrowPosTop[3].y.toDouble() - 8,
          leftEyeBrowPosBottom[4].x.toDouble() + 10,
          leftEyeBrowPosBottom[0].y.toDouble() + 8);
      //canvas.drawRect(leftEyebrow, contourPaint);
      roiRectangles.add(leftEyebrow);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return faces != oldDelegate.faces;
  }
}
