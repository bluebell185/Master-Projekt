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
  final List<ColorDetail> eyeColors;
  final List<ColorDetail> faceColors;
  final List<ColorDetail> lipColors;
  final List<ColorDetail> browColors;
  final List<dynamic>
      eyeShapes; // Assuming `eyeShapes` and `faceShapes` have no specific structure
  final List<dynamic> faceShapes;

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
          .map((item) => ColorDetail.fromJson(item))
          .toList(),
      faceColors: (json['faceColors'] as List)
          .map((item) => ColorDetail.fromJson(item))
          .toList(),
      lipColors: (json['lipColors'] as List)
          .map((item) => ColorDetail.fromJson(item))
          .toList(),
      browColors: (json['browColors'] as List)
          .map((item) => ColorDetail.fromJson(item))
          .toList(),
      eyeShapes: List<dynamic>.from(json['eyeShapes']),
      faceShapes: List<dynamic>.from(json['faceShapes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eyeColors': eyeColors.map((color) => color.toJson()).toList(),
      'faceColors': faceColors.map((color) => color.toJson()).toList(),
      'lipColors': lipColors.map((color) => color.toJson()).toList(),
      'browColors': browColors.map((color) => color.toJson()).toList(),
      'eyeShapes': eyeShapes,
      'faceShapes': faceShapes,
    };
  }
}

class ColorDetail {
  final String color;
  final String eyeColorContent;
  final String goal;
  final List<RecommendedColor> recommendedColors;
  final List<String> techniques;
  final List<String> imageLinks;

  ColorDetail({
    required this.color,
    required this.eyeColorContent,
    required this.goal,
    required this.recommendedColors,
    required this.techniques,
    required this.imageLinks,
  });

  factory ColorDetail.fromJson(Map<String, dynamic> json) {
    return ColorDetail(
      color: json['color'] as String,
      eyeColorContent: json['eyeColorContent'] as String,
      goal: json['goal'] as String,
      recommendedColors: (json['recommendedColors'] as List)
          .map((item) => RecommendedColor.fromJson(item))
          .toList(),
      techniques: List<String>.from(json['techniques']),
      imageLinks: List<String>.from(json['imageLinks']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'eyeColorContent': eyeColorContent,
      'goal': goal,
      'recommendedColors':
          recommendedColors.map((color) => color.toJson()).toList(),
      'techniques': techniques,
      'imageLinks': imageLinks,
    };
  }
}

class RecommendedColor {
  final String color;
  final String description;

  RecommendedColor({required this.color, required this.description});

  factory RecommendedColor.fromJson(Map<String, dynamic> json) {
    return RecommendedColor(
      color: json['color'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'description': description,
    };
  }
}
