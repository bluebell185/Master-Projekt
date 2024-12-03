import 'package:flutter/material.dart';

// UI-Elemente
import 'package:master_projekt/ui/accordion.dart';
import 'package:master_projekt/ui/recomm_tiles.dart';
import 'package:master_projekt/ui/tabs.dart';
import 'package:master_projekt/ui/text.dart';

// Definition der verschiedenen Kategorien für "eyes"-Tab
enum EyeColorCategory { blue, green, brown, grey } // anpassen!

enum EyeShapeCategory { almond, round, upturned, downturned, monolid }

enum BlushCategory { coral, peach, rose, berry }

enum BlushShapeCategory { oval, round, square }

enum LipCategory { red, pink, nude, plum }

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

class _AnalysisResultsState extends State<AnalysisResults> {
  EyeColorCategory?
      eyeColorCategory; // Tracked die Augenfarben-Kategorie für "eyes"
  EyeShapeCategory? eyeShapeCategory;
  BlushCategory? blushCategory;
  BlushShapeCategory? blushShapeCategory;
  LipCategory? lipCategory;
  BrowCategory? browCategory;

  // Box 2b ist angezeigt für ROIs 'eyes' und 'blush'
  bool _shouldShowShape(String tab) {
    return tab == 'eyes' || tab == 'blush';
  }

  // Beispielgerüst: Logik für die Augenfarbe-Kategorien?
  // 'colorValue' bestimmt die Farbkategorie
  // 'eyeColorCategory' -> TO DO: Range der Farbkategorien
  void setEyeColorCategory(String colorValue) {
    if (colorValue == 'blue') {
      eyeColorCategory = EyeColorCategory.blue;
    } else if (colorValue == 'green') {
      eyeColorCategory = EyeColorCategory.green;
    } else if (colorValue == 'brown') {
      eyeColorCategory = EyeColorCategory.brown;
    } else if (colorValue == 'hazel') {
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

  // Content für die jeweilige Augenfarben-Kategorie --> JSON?
  Widget _getEyeColorContent(EyeColorCategory category) {
    switch (category) {
      case EyeColorCategory.blue:
        return const Text(
          'Your eye color is blue. Here are some details about blue eyes...',
          style: TextStyle(fontSize: 14),
        );
      case EyeColorCategory.green:
        return const Text(
          'Your eye color is green. Here are some details about green eyes...',
          style: TextStyle(fontSize: 14),
        );
      case EyeColorCategory.brown:
        return const Text(
          'Your eye color is brown. Here are some details about brown eyes...',
          style: TextStyle(fontSize: 14),
        );
      case EyeColorCategory.grey:
        return const Text(
          'Your eye color is grey. Here are some details about hazel eyes...',
          style: TextStyle(fontSize: 14),
        );
      default:
        return Container();
    }
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

  // Beispielgerüst: Logik für die Blush-Kategorie?
  // Methode für Blush -> if else?
  void setBlushCategory(String blushValue) {
    switch (blushValue) {
      case 'coral':
        blushCategory = BlushCategory.coral;
      case 'peach':
        blushCategory = BlushCategory.peach;
      case 'rose':
        blushCategory = BlushCategory.rose;
      case 'berry':
        blushCategory = BlushCategory.berry;
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

  Widget _getBlushContent(BlushCategory category) {
    final textMap = {
      BlushCategory.coral:
          'Your blush color is coral. Details about coral blush...',
      BlushCategory.peach:
          'Your blush color is peach. Details about peach blush...',
      BlushCategory.rose:
          'Your blush color is rose. Details about rose blush...',
      BlushCategory.berry:
          'Your blush color is berry. Details about berry blush...',
    };
    return Text(
      textMap[category] ?? '',
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _getBlushShapeContent(BlushShapeCategory category) {
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

  // Beispielgerüst: Logik für die Lippen-Kategorie?
  void setLipCategory(String lipValue) {
    switch (lipValue) {
      case 'red':
        lipCategory = LipCategory.red;
      case 'pink':
        lipCategory = LipCategory.pink;
      case 'nude':
        lipCategory = LipCategory.nude;
      case 'plum':
        lipCategory = LipCategory.plum;
    }
  }

  // switch case? was ist besser für JSON?
  Widget _getLipContent(LipCategory category) {
    final textMap = {
      LipCategory.red: 'Your lip color is red. Details about red lips...',
      LipCategory.pink: 'Your lip color is pink. Details about pink lips...',
      LipCategory.nude: 'Your lip color is nude. Details about nude lips...',
      LipCategory.plum: 'Your lip color is plum. Details about plum lips...',
    };
    return Text(
      textMap[category] ?? '',
      style: const TextStyle(fontSize: 14),
    );
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

  Widget _getBrowContent(BrowCategory category) {
    final textMap = {
      BrowCategory.thin: 'Your brow style is thin. Details about thin brows...',
      BrowCategory.thick:
          'Your brow style is thick. Details about thick brows...',
      BrowCategory.arched:
          'Your brow style is arched. Details about arched brows...',
      BrowCategory.straight:
          'Your brow style is straight. Details about straight brows...',
    };
    return Text(
      textMap[category] ?? '',
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
          const AccordionWidget(),
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
            const AccordionWidget(),
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
