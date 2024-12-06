import 'package:flutter/material.dart';
import 'package:master_projekt/json_parse.dart';
import 'package:master_projekt/screen_with_deepar_camera.dart';
import 'package:master_projekt/camera_widget.dart';
import 'package:master_projekt/start_analysis.dart';

// UI-Elemente
import 'package:master_projekt/ui/accordion.dart';
import 'package:master_projekt/ui/recomm_tiles.dart';
import 'package:master_projekt/ui/tabs.dart';
import 'package:master_projekt/ui/text.dart';

// Definition der verschiedenen Kategorien für "eyes"-Tab
enum RoiColorTypes { eye, eyebrow, lip, face }

enum EyeColorCategory { blue, green, brown, grey } // anpassen!

enum EyeShapeCategory { almond, round, upturned, downturned, monolid }

enum BlushCategory { light, beige, olive, tanned, dark }

enum BlushShapeCategory { oval, round, square }

enum LipCategory { red, pink, nude, coral }

enum BrowCategory { thin, thick, arched, straight }

class AnalysisResults extends StatefulWidget {
  final String? selectedTab;
  final bool isBoxThreeOpen;
  final VoidCallback onNavigateToBoxThree;
  final VoidCallback onNavigateToBoxTwo;
  final ValueChanged<String?> onTabSelected;
  final ScrollController scrollController;

  const AnalysisResults({
    super.key,
    required this.selectedTab,
    required this.isBoxThreeOpen,
    required this.onNavigateToBoxThree,
    required this.onNavigateToBoxTwo,
    required this.onTabSelected,
    required this.scrollController,
  });

  @override
  State<AnalysisResults> createState() => _AnalysisResultsState();
}

EyeColorCategory?
    eyeColorCategory; // Tracked die Augenfarben-Kategorie für "eyes"
EyeShapeCategory? eyeShapeCategory;
BlushCategory? blushCategory;
BlushShapeCategory? blushShapeCategory;
LipCategory? lipCategory;
BrowCategory? browCategory;

// Beispielgerüst: Logik für die Augenfarbe-Kategorien?
// 'colorValue' bestimmt die Farbkategorie
// 'eyeColorCategory'
void setEyeColorCategory(String colorValue) {
  if (colorValue == 'blue') {
    eyeColorCategory = EyeColorCategory.blue;
  } else if (colorValue == 'green') {
    eyeColorCategory = EyeColorCategory.green;
  } else if (colorValue == 'brown') {
    eyeColorCategory = EyeColorCategory.brown;
  } else if (colorValue == 'grey') {
    eyeColorCategory = EyeColorCategory.grey;
  }
}

void setEyeShapeCategory(String shapeValue) {
  if (shapeValue == 'almond') {
    eyeShapeCategory = EyeShapeCategory.almond;
  } else if (shapeValue == 'round') {
    eyeShapeCategory = EyeShapeCategory.round;
  } else if (shapeValue == 'upturned') {
    eyeShapeCategory = EyeShapeCategory.upturned;
  } else if (shapeValue == 'downturned') {
    eyeShapeCategory = EyeShapeCategory.downturned;
  } else if (shapeValue == 'monolid') {
    eyeShapeCategory = EyeShapeCategory.monolid;
  }
}

// Beispielgerüst: Logik für die Blush-Kategorie?
// Methode für Blush -> if else?
void setBlushCategory(String blushValue) {
  switch (blushValue) {
    case 'beige':
      blushCategory = BlushCategory.beige;
    case 'dark':
      blushCategory = BlushCategory.dark;
    case 'light':
      blushCategory = BlushCategory.light;
    case 'olive':
      blushCategory = BlushCategory.olive;
    case 'tanned':
      blushCategory = BlushCategory.tanned;
  }
}

void setBlushShapeCategory(String blushShapeValue) {
  switch (blushShapeValue) {
    case 'oval':
      blushShapeCategory = BlushShapeCategory.oval;
    case 'round':
      blushShapeCategory = BlushShapeCategory.round;
    case 'square':
      blushShapeCategory = BlushShapeCategory.square;
  }
}

// Beispielgerüst: Logik für die Lippen-Kategorie?
void setLipCategory(String lipValue) {
  switch (lipValue) {
    case 'red':
      lipCategory = LipCategory.red;
    case 'pink':
      lipCategory = LipCategory.pink;
    case 'nude':
      lipCategory = LipCategory.nude;
    case 'coral':
      lipCategory = LipCategory.coral;
  }
}

// Beispielgerüst: Logik für die Augenbrauen-Kategorie?
void setBrowCategory(String browValue) {
  switch (browValue) {
    case 'thin':
      browCategory = BrowCategory.thin;
    case 'thick':
      browCategory = BrowCategory.thick;
    case 'arched':
      browCategory = BrowCategory.arched;
    case 'straight':
      browCategory = BrowCategory.straight;
  }
}

class _AnalysisResultsState extends State<AnalysisResults> {
  // Box 2b ist angezeigt für ROIs 'eyes' und 'blush'
  bool _shouldShowShape(String tab) {
    return tab == 'eyes' || tab == 'blush';
  }

  Widget _getEyeColorContent(EyeColorCategory category) {
    String textToDisplay = "Content missing!";
    for (ColorDetail colorDetail in roiData.rois[0].eyeColors) {
      if (colorDetail.color == category.name) {
        textToDisplay = colorDetail.eyeColorContent;
        break;
      }
    }

    return Text(
      textToDisplay,
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _getEyeShapeContent(EyeShapeCategory category) {
    switch (category) {
      case EyeShapeCategory.almond:
        return const Text(
          'Your eye shape is almond. Here are some details about almond shaped eyes...',
          style: TextStyle(fontSize: 14),
        );
      case EyeShapeCategory.round:
        return const Text(
          'Your eye color is round. Here are some details about round eyes...',
          style: TextStyle(fontSize: 14),
        );
      case EyeShapeCategory.upturned:
        return const Text(
          'Your eye color is upturned. Here are some details about upturned eyes...',
          style: TextStyle(fontSize: 14),
        );
      case EyeShapeCategory.downturned:
        return const Text(
          'Your eye color is downturned. Here are some details about downturned eyes...',
          style: TextStyle(fontSize: 14),
        );
      case EyeShapeCategory.monolid:
        return const Text(
          'Your eye color is monolid. Here are some details about monolid eyes...',
          style: TextStyle(fontSize: 14),
        );
      default:
        return Container();
    }
  }

  Widget _getBlushContent(BlushCategory category) {
    String textToDisplay = "Content missing!";
    for (ColorDetail colorDetail in roiData.rois[0].faceColors) {
      if (colorDetail.color == category.name) {
        textToDisplay = colorDetail.eyeColorContent;
        break;
      }
    }

    return Text(
      textToDisplay,
      style: const TextStyle(fontSize: 14),
    );

    // TODO was ist mit default: return Container(); überall?
  }

  Widget _getBlushShapeContent(BlushShapeCategory category) {
    // TODO durch JSON-Inhalt ersetzen
    final textMap = {
      BlushShapeCategory.oval:
          'Oval Face. Details about blush for oval faces...',
      BlushShapeCategory.round:
          'Round Face. Details about blush for round faces...',
      BlushShapeCategory.square:
          'Square Face. Details about blush for square faces...',
    };
    return Text(
      textMap[category] ?? '',
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _getLipContent(LipCategory category) {
    String textToDisplay = "Content missing!";
    for (ColorDetail colorDetail in roiData.rois[0].lipColors) {
      if (colorDetail.color == category.name) {
        textToDisplay = colorDetail.eyeColorContent;
        break;
      }
    }

    return Text(
      textToDisplay,
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _getBrowContent(BrowCategory category) {
    String textToDisplay = "Content missing!";
    for (ColorDetail colorDetail in roiData.rois[0].browColors) {
      if (colorDetail.color == category.name) {
        textToDisplay = colorDetail.eyeColorContent;
        break;
      }
    }

    return Text(
      textToDisplay,
      style: const TextStyle(fontSize: 14),
    );
  }

  // Main Content für jeden ausgewählten Tab - COLOR
  Widget _getTabContentColor(String tab) {
    if (tab == 'eyes' && eyeColorCategory != null) {
      return _getEyeColorContent(eyeColorCategory!);
    } else if (tab == 'blush' && blushCategory != null) {
      return _getBlushContent(blushCategory!);
    } else if (tab == 'lips' && lipCategory != null) {
      return _getLipContent(lipCategory!);
    } else if (tab == 'brows' && browCategory != null) {
      return _getBrowContent(browCategory!);
    }

    return Text(
      'Content for $tab COLOR - Placeholder text for this category.',
      style: const TextStyle(fontSize: 14),
    );
  }

  // Main Content für jeden ausgewählten Tab - SHAPE
  Widget _getTabContentShape(String tab) {
    if (tab == 'eyes' && eyeShapeCategory != null) {
      return _getEyeShapeContent(eyeShapeCategory!);
    } else if (tab == 'blush' && blushShapeCategory != null) {
      return _getBlushShapeContent(blushShapeCategory!);
    }
    // oder einfach: return Container();
    return Text(
      'Content for $tab SHAPE - Placeholder text for this category.',
      style: const TextStyle(fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          controller: widget.scrollController,
          child: Column(
            children: [
              // Content Box 1
              _buildBox1(),
              // Einfügen von Box 2 nach Tab-Auswahl
              if (widget.selectedTab != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: widget.isBoxThreeOpen ? _buildBox3() : _buildBox2(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Content Box 1
  Widget _buildBox1() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EADD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Heading(
            headingText: 'your analysis results',
            headingColor: Colors.black,
          ),
          const SizedBox(height: 10),
          const BodyText(
            bodyText:
                'Hier steht Text - um mehr zu den Analyse Results zu erfahren, soll User eine Kategorie auswählen:',
            bodyTextColor: Colors.black,
          ),
          const SizedBox(height: 20),
          // Tab Buttons
          ScrollableTabs(
            labels: ['eyes', 'blush', 'lips', 'brows'], // Tab Labels
            onTabSelected: (tab) {
              widget.onTabSelected(tab);
            },
          )
        ],
      ),
    );
  }

  // Content Box 2 - enthält Box 2a) COLOR und Box 2b) SHAPE
  Widget _buildBox2() {
    // Schauen, dass ein Tab ausgewählt ist bevor Box 2 gebuilded wird
    if (widget.selectedTab == null) {
      return const SizedBox(); // Returne leeres Widget, wenn kein Tab ausgewählt ist
    }

    print('Building Box 2 with Tab: ${widget.selectedTab}');

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EADD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Box 2a - COLOR
          Text(
            '${widget.selectedTab} - your color',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10), _getTabContentColor(widget.selectedTab!),
          const SizedBox(height: 10),
          AccordionWidget(widget.selectedTab, "color"),
          const SizedBox(height: 20),

          // Box 2b - SHAPE
          if (_shouldShowShape(widget.selectedTab!)) ...[
            Text(
              '${widget.selectedTab} - your shape',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _getTabContentShape(widget.selectedTab!),
            const SizedBox(height: 10),
            AccordionWidget(widget.selectedTab, "shape"),
          ],
          const SizedBox(height: 20),

          // Navigation zu Box 3
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.black),
              onPressed: widget.onNavigateToBoxThree,
            ),
          ),
        ],
      ),
    );
  }

  // Content Box 3 - enthält die bildlichen Recommendations
  Widget _buildBox3() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EADD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'recommendations',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const BodyText(
            bodyText:
                'Here is the content for Box 3...Tap on the look you desire to see it applied on your face.',
          ),

          ImageRecommendationsGrid(
            images: [
              // Kategorien-based Grids/Listen anlegen?
              'assets/images/look1.png',
              'assets/images/look1.png',
              'assets/images/look1.png',
              'assets/images/look1.png',
              'assets/images/look1.png',
              'assets/images/look1.png',
            ], // Liste der Bild-Pfade
          ),

          // Navigation zu Box 2
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: widget.onNavigateToBoxTwo,
            ),
          ),
        ],
      ),
    );
  }
}
