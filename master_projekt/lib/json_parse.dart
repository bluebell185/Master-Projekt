import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

Future<RoisData> loadRoisData() async {
  final String response = await rootBundle.loadString('assets/data/rois.json');
  final Map<String, dynamic> jsonData = json.decode(response);
  return RoisData.fromJson(jsonData);
}

class RoisData {
  final List<Roi> rois;

  RoisData({required this.rois});

  factory RoisData.fromJson(Map<String, dynamic> json) {
    return RoisData(
      rois: (json['rois'] as List).map((roi) => Roi.fromJson(roi)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rois': rois.map((roi) => roi.toJson()).toList(),
    };
  }
}

class Roi {
  final List<ColorOrShapeDetail> eyeColors;
  final List<ColorOrShapeDetail> faceColors;
  final List<ColorOrShapeDetail> lipColors;
  final List<ColorOrShapeDetail> browColors;
  final List<ColorOrShapeDetail> eyeShapes;
  final List<ColorOrShapeDetail> faceShapes;

  Roi({
    required this.eyeColors,
    required this.faceColors,
    required this.lipColors,
    required this.browColors,
    required this.eyeShapes,
    required this.faceShapes,
  });

  factory Roi.fromJson(Map<String, dynamic> json) {
    return Roi(
      eyeColors: (json['eyeColors'] as List)
          .map((item) => ColorOrShapeDetail.fromJson(item))
          .toList(),
      faceColors: (json['faceColors'] as List)
          .map((item) => ColorOrShapeDetail.fromJson(item))
          .toList(),
      lipColors: (json['lipColors'] as List)
          .map((item) => ColorOrShapeDetail.fromJson(item))
          .toList(),
      browColors: (json['browColors'] as List)
          .map((item) => ColorOrShapeDetail.fromJson(item))
          .toList(),
      eyeShapes: (json['eyeShapes'] as List)
          .map((item) => ColorOrShapeDetail.fromJson(item))
          .toList(),
      faceShapes: (json['faceShapes'] as List)
          .map((item) => ColorOrShapeDetail.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eyeColors': eyeColors.map((color) => color.toJson()).toList(),
      'faceColors': faceColors.map((color) => color.toJson()).toList(),
      'lipColors': lipColors.map((color) => color.toJson()).toList(),
      'browColors': browColors.map((color) => color.toJson()).toList(),
      'eyeShapes': eyeShapes.map((shape) => shape.toJson()).toList(),
      'faceShapes': faceShapes.map((shape) => shape.toJson()).toList(),
    };
  }
}

class ColorOrShapeDetail {
  final String colorOrShape;
  final String contentDescription;
  final String goal;
  final List<RecommendedColor> recommendations;
  final List<String> techniques;
  final List<String> imageLinks;
  final List<String> filters;

  ColorOrShapeDetail({
    required this.colorOrShape,
    required this.contentDescription,
    required this.goal,
    required this.recommendations,
    required this.techniques,
    required this.imageLinks,
    required this.filters,
  });

  factory ColorOrShapeDetail.fromJson(Map<String, dynamic> json) {
    return ColorOrShapeDetail(
      colorOrShape: json['colorOrShape'] as String,
      contentDescription: json['contentDescription'] as String,
      goal: json['goal'] as String,
      recommendations: (json['recommendations'] as List)
          .map((item) => RecommendedColor.fromJson(item))
          .toList(),
      techniques: List<String>.from(json['techniques']),
      imageLinks: List<String>.from(json['imageLinks']),
      filters: List<String>.from(json['filters']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'colorOrShape': colorOrShape,
      'contentDescription': contentDescription,
      'goal': goal,
      'recommendations':
          recommendations.map((color) => color.toJson()).toList(),
      'techniques': techniques,
      'imageLinks': imageLinks,
      'filters': filters,
    };
  }
}

class RecommendedColor {
  final String title;
  final String description;

  RecommendedColor({required this.title, required this.description});

  factory RecommendedColor.fromJson(Map<String, dynamic> json) {
    return RecommendedColor(
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}
