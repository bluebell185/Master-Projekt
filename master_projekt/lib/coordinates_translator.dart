import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'dart:io';
import 'dart:ui';

// https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart

double translateX(int x, InputImageRotation rotation, Size canvasSize, Size absoluteImageSize, double scale){
  switch(rotation){
    case InputImageRotation.rotation90deg:
      return x * canvasSize.width / (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    case InputImageRotation.rotation270deg:
      return canvasSize.width - x * canvasSize.width * scale / (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    default: 
      //return x * canvasSize.width / absoluteImageSize.width;
      return canvasSize.width - x * canvasSize.width / absoluteImageSize.width;
  }
}

double translateY(int y, InputImageRotation rotation, Size canvasSize, Size absoluteImageSize, double scale){
  switch(rotation){
    case InputImageRotation.rotation90deg:
    case InputImageRotation.rotation270deg:
      return (y * canvasSize.height / (scale * 1.1))  / (Platform.isIOS ? absoluteImageSize.height : absoluteImageSize.width);
    default: 
      return y * canvasSize.height / absoluteImageSize.height;
  }
}