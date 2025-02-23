import 'package:flutter/material.dart';

class RecommendationTile extends StatefulWidget {
  final String imageLink;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const RecommendationTile({
    super.key,
    required this.imageLink,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  _RecommendationTileState createState() => _RecommendationTileState();
}

class _RecommendationTileState extends State<RecommendationTile> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive;
  }

  @override
  void didUpdateWidget(covariant RecommendationTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      setState(() {
        isActive = widget.isActive;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        setState(() {
          isActive = !isActive; // Toggle Status
        });
      },
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
                    image: AssetImage(widget.imageLink),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 5.0),
              child: Text(
                widget.label,
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
  final List<String> images; // Preview-Images
  final List<String> filters; // Filter-Pfade
  final String? activeFilter; // null = kein Filter
  final ValueChanged<String> onTileTap; // Callback für Tap-Event

  const ImageRecommendationsGrid({
    super.key,
    required this.images,
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
        final imagePath = images[index];
        final filterPath = filters[index];

        return RecommendationTile(
          imageLink: imagePath,
          label: 'Look ${index + 1}',
          isActive: activeFilter == filterPath.substring(0, filterPath.indexOf(".deep")),
          onTap: () => onTileTap(filterPath), // Filter-Logik auslösen
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

class ImageRecommendationsList extends StatefulWidget {
  final List<String> images; // Preview-Images
  final List<String> filters; // Filter-Pfade
  final String? initialActiveFilter; // null = kein Filter
  final ValueChanged<String> onTileTap; // Callback für Tap-Event

  const ImageRecommendationsList({
    super.key,
    required this.images,
    required this.filters,
    this.initialActiveFilter,
    required this.onTileTap,
  });

  @override
  _ImageRecommendationsListState createState() =>
      _ImageRecommendationsListState();
}

class _ImageRecommendationsListState extends State<ImageRecommendationsList> {
  String? activeFilter;

  @override
  void initState() {
    super.initState();
    activeFilter = widget.initialActiveFilter; // Startwert setzen
  }

  void handleTileTap(String filterPath) {
    setState(() {
      activeFilter =
          filterPath; // Neues aktives Tile setzen, andere deaktivieren
    });
    widget.onTileTap(filterPath); // Callback auslösen
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.only(top: 40),
        scrollDirection: Axis.horizontal, // Horizontal scrollen
        child: Container(
          height: 150,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.images.length, (index) {
              final imagePath = widget.images[index];
              final filterPath = widget.filters[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: SizedBox(
                  width: 150,
                  child: RecommendationTile(
                    imageLink: imagePath,
                    label: 'Look ${index + 1}',
                    isActive: activeFilter == filterPath.substring(0, filterPath.indexOf(".deep")), // Prüfen, ob aktiv
                    onTap: () => handleTileTap(filterPath),
                  ),
                ),
              );
            }),
          ),
        ));
  }
}

// gerade auskommentiert
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.only(top: 40),
//       scrollDirection: Axis.horizontal, // Horizontal scrollen
//       child: Container(
//       height: 150,
//        child:
//       Row(
//         mainAxisSize: MainAxisSize.min, // Row passt sich der Kindergröße an
//         children: List.generate(images.length, (index) {
//           final imagePath = images[index]; // aktuelles Preview-Image
//           final filterPath = filters[index]; // dazu passender Filter-Pfad

//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5.0),
//             child: SizedBox(
//               width: 150,
//               child: RecommendationTile(
//                 imageLink: imagePath,
//                 label: 'Look ${index + 1}',
//                 isActive: activeFilter == filterPath,
//                 onTap: () => onTileTap(filterPath),
//               ),
//             ),
//           );
//         }),
//       ),
//       ),
//     );
//   }
// }

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
