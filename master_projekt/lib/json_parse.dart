import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Future<List<RoiInformation>> fetchPhotos(http.Client client) async {
//   final response = await client
//       .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

//   // Use the compute function to run parsePhotos in a separate isolate.
//   return compute(parsePhotos, response.body);
// }

// // A function that converts a response body into a List<Photo>.
// List<RoiInformation> parsePhotos(String responseBody) {
//   final parsed =
//       (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

//   return parsed.map<RoiInformation>((json) => RoiInformation.fromJson(json)).toList();
// }

Future<EyeColorData> loadEyeColorData() async {
  final String response = await rootBundle.loadString('assets/data/roi_eyes.json');
  final Map<String, dynamic> data = json.decode(response);
  return EyeColorData.fromJson(data);
}

class EyeColorData {
  final List<EyeColor> eyeColors;

  EyeColorData({required this.eyeColors});

  factory EyeColorData.fromJson(Map<String, dynamic> json) {
    return EyeColorData(
      eyeColors: (json['eyeColors'] as List)
          .map((item) => EyeColor.fromJson(item))
          .toList(),
    );
  }
}

class EyeColor {
  final String color;
  final String eyeColorContent;
  final String goal;
  final List<RecommendedColor> recommendedColors;
  final List<String> techniques;
  final List<String> imageLinks;

  EyeColor({
    required this.color,
    required this.eyeColorContent,
    required this.goal,
    required this.recommendedColors,
    required this.techniques,
    required this.imageLinks,
  });

  factory EyeColor.fromJson(Map<String, dynamic> json) {
    return EyeColor(
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
}


// TODO
class ROIs {
  final List<EyeColor> eyes;
  final List<dynamic> lips;
  final List<dynamic> brows;
  final List<dynamic> blush;

  ROIs({
    required this.eyes,
    required this.lips,
    required this.brows,
    required this.blush,
  });

  factory ROIs.fromJson(Map<String, dynamic> json) {
    return ROIs(
      eyes: (json['eyes']['colors'] as List<dynamic>)
          .map((e) => EyeColor.fromJson(e as Map<String, dynamic>))
          .toList(),
      lips: json['lips'] as List<dynamic>,
      brows: json['brows'] as List<dynamic>,
      blush: json['blush'] as List<dynamic>,
    );
  }
}

// class EyeColor {
//   final String color;
//   final String description;
//   final Map<String, String> imagePaths;

//   EyeColor({
//     required this.color,
//     required this.description,
//     required this.imagePaths,
//   });

//   factory EyeColor.fromJson(Map<String, dynamic> json) {
//     return EyeColor(
//       color: json['color'] as String,
//       description: json['description'] as String,
//       imagePaths: Map<String, String>.from(json['image_paths'] as Map),
//     );
//   }
// }


// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const appTitle = 'Isolate Demo';

//     return const MaterialApp(
//       title: appTitle,
//       home: MyHomePage(title: appTitle),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late Future<List<Photo>> futurePhotos;

//   @override
//   void initState() {
//     super.initState();
//     futurePhotos = fetchPhotos(http.Client());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: FutureBuilder<List<Photo>>(
//         future: futurePhotos,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Center(
//               child: Text('An error has occurred!'),
//             );
//           } else if (snapshot.hasData) {
//             return const Center(
//               child: Text('Test!'),
//             );
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class PhotosList extends StatelessWidget {
//   const PhotosList({super.key, required this.photos});

//   final List<Photo> photos;

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//       ),
//       itemCount: photos.length,
//       itemBuilder: (context, index) {
//         return Image.network(photos[index].thumbnailUrl);
//       },
//     );
//   }
// }