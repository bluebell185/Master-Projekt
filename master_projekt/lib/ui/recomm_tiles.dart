import 'package:flutter/material.dart';

class RecommendationTile extends StatelessWidget {
  final String imagePath;
  final String label;

  const RecommendationTile({
    super.key,
    required this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 5.0),
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageRecommendationsGrid extends StatelessWidget {
  final List<String> images; // Liste der Bild-Pfade
  final int crossAxisCount; // Anzahl Kacheln pro Reihe
  final double childAspectRatio; // Seitenverhältnis

  const ImageRecommendationsGrid({
    super.key,
    required this.images,
    this.crossAxisCount = 2, // zwei Kacheln pro Zeile als Default
    this.childAspectRatio = 4 / 3, // Default Seitenverhältnis
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10, // Vertikaler Abstand zwischen Kacheln
        crossAxisSpacing: 10, // Horizontaler Abstand zwischen Kacheln
        childAspectRatio: childAspectRatio,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return RecommendationTile(
          imagePath: images[index],
          label: 'Look ${index + 1}',
        );
      },
    );
  }
}

class ImageRecommendationsList extends StatelessWidget {
  final List<String> images;

  const ImageRecommendationsList({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: images.map((image) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: SizedBox(
              width: 150, // Fixed width for horizontal tiles
              child: RecommendationTile(
                imagePath: image,
                label: 'Look ${images.indexOf(image) + 1}',
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
