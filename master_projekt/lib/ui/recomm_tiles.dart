import 'package:flutter/material.dart';
import 'package:master_projekt/filter.dart';

class RecommendationTile extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool isActive;
  final VoidCallback onTap; // Callback bei Tap

  const RecommendationTile({
    super.key,
    required this.imagePath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Tap-Event weitergeben
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: isActive
              ? Border.all(color: Colors.black, width: 2)
              : Border.all(color: Colors.transparent),
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
      ),
    );
  }
}

class ImageRecommendationsGrid extends StatelessWidget {
  final List<Filters> filters; // Liste der Filter-Datem
  final String? activeFilter; // null = kein Filter
  final ValueChanged<String> onTileTap; // Callback für Tap-Event

  const ImageRecommendationsGrid({
    super.key,
    required this.filters,
    this.activeFilter,
    required this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // zwei Kacheln pro Zeile als Default
        mainAxisSpacing: 10, // Vertikaler Abstand zwischen Kacheln
        crossAxisSpacing: 10, // Horizontaler Abstand zwischen Kacheln
        childAspectRatio: 4 / 3, // Seitenverhältnis
      ),
      itemCount: filters.length,
      itemBuilder: (context, index) {
        final filter = filters[index];
        // final effectFile = 'assets/filters/${filter.filterPath}';
        final filterName = filter.filterPath
            .split('.')
            .first; // aus Filterpfad den Filternamen extrahieren (ohne .deepar)
        return RecommendationTile(
          imagePath:
              'assets/previews/${filter.imagePath}', // Bildpfad des Preview-Bildes
          label: filterName.replaceAll('_', ' '), // Kachel-Name anzeigen
          isActive: activeFilter == filterName, // Prüfen, ob Filter active ist
          onTap: () => onTileTap(filterName), // Filter-Logik auslösen
        );
      },
    );
  }
}

  /*@override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // zwei Kacheln pro Zeile als Default
        mainAxisSpacing: 10, // Vertikaler Abstand zwischen Kacheln
        crossAxisSpacing: 10, // Horizontaler Abstand zwischen Kacheln
        childAspectRatio: 4 / 3, // Seitenverhältnis
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final filterName = images[index]
            .split('/')
            .last
            .split('_img')
            .first; // aus Filterpfad den Filternamen extrahieren
        return RecommendationTile(
          imagePath: images[index],
          label: filterName.replaceAll('_', ' '), // Kachel-Name
          isActive: activeFilter == filterName, // Prüfen, ob Filter active ist
          onTap: () => onTileTap(filterName), // Filter-Logik auslösen
        );
      },
    );
  }
}*/

/*
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
}*/
