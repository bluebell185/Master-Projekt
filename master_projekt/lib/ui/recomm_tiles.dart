import 'package:flutter/material.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Recommendation Tile: 
                                  - Kacheln, über die man einen Filter auswählen kann
                                  - beinhalten Preview (ein Bild) des Looks/Filters
                                  - Kacheln genutzt in Form eines Grids für die Galerie in Content-Box 3
                                  - Kacheln genutzt in Form einer Liste, erscheint bei Tap auf ROI-Kästchen
------------------------------------------------------------------------------------------------------------------------------------------------*/

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
        final filterPathShortened =
            filterPath.substring(0, filterPath.indexOf(".deep"));

        return RecommendationTile(
          imageLink: imagePath,
          label: 'Look ${index + 1}',
          isActive: activeFilter == filterPathShortened,
          onTap: () => onTileTap(filterPath), // Filter-Logik auslösen
        );
      },
    );
  }
}

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
              String filterPath = widget.filters[index];
              if (filterPath.endsWith('.deepar') &&
                  (activeFilter != null &&
                      !activeFilter!.endsWith('.deepar'))) {
                filterPath =
                    filterPath.substring(0, filterPath.indexOf(".deep"));
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: SizedBox(
                  width: 150,
                  child: RecommendationTile(
                    imageLink: imagePath,
                    label: 'Look ${index + 1}',
                    isActive: activeFilter == filterPath, // Prüfen, ob aktiv
                    onTap: () => handleTileTap(filterPath),
                  ),
                ),
              );
            }),
          ),
        ));
  }
}
