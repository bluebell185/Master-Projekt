import 'package:flutter/material.dart';
import 'package:master_projekt/json_parse.dart';
import 'package:master_projekt/main.dart';
import 'package:master_projekt/start_analysis.dart';

// UI-Elemente
import 'package:master_projekt/ui/accordion.dart';
import 'package:master_projekt/ui/recomm_tiles.dart';
import 'package:master_projekt/ui/tabs.dart';
import 'package:master_projekt/ui/text.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Analysis Results: 
                                  - Regelwerk bzw. Festlegen der einzelnen ROI-Kategorien
                                  - beinhaltet die textlichen und bildichen Reommendations
                                    * Content-Box 1: ROI Auswahl
                                    * Content-Box 2a/b: ROI Color/Shape
                                    * Content-Box 3: Galerie der Looks
                                  - Content-Logik
                                  - Filter-Logik
------------------------------------------------------------------------------------------------------------------------------------------------*/

// ---------------- Definition der verschiedenen Kategorien --------------->
enum RoiColorTypes { eye, eyebrow, lip, face }

enum EyeColorCategory { blue, green, brown, grey }

enum EyeShapeCategory { almond, round, upturned, downturned, monolid }

enum BlushCategory { light, beige, olive, tanned, dark }

enum BlushShapeCategory { oval, round, square }

enum LipCategory { red, pink, nude, coral }

enum BrowCategory { black, blonde, brown }

enum BrowShapeCategory { thin, thick, arched, straight }

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
  State<AnalysisResults> createState() => AnalysisResultsState();
}

bool showRecommendationList = false;

EyeColorCategory?
    eyeColorCategory; // Tracked die Augenfarben-Kategorie für "eyes"
EyeShapeCategory? eyeShapeCategory;
BlushCategory? blushCategory;
BlushShapeCategory? blushShapeCategory;
LipCategory? lipCategory;
BrowCategory? browCategory;
BrowShapeCategory? browShapeCategory;

List<String> imageLinks = []; // Pfad der Preview-Bilder
List<String> filterPaths = []; // Pfad der DeepAR-Filter
String? activeFilter; // speichert den aktuell aktiven Filter

// ------------------------------- Augenfarbe-Kategorie ------------------------------->
void setEyeColorCategory(String colorValue) {
  switch (colorValue) {
    case 'blue':
      eyeColorCategory = EyeColorCategory.blue;
    case 'green':
      eyeColorCategory = EyeColorCategory.green;
    case 'brown':
      eyeColorCategory = EyeColorCategory.brown;
    case 'grey':
      eyeColorCategory = EyeColorCategory.grey;
  }
}

// ------------------------------- Augenform-Kategorie ------------------------------->
void setEyeShapeCategory(String shapeValue) {
  switch (shapeValue) {
    case 'almond':
      eyeShapeCategory = EyeShapeCategory.almond;
    case 'round':
      eyeShapeCategory = EyeShapeCategory.round;
    case 'upturned':
      eyeShapeCategory = EyeShapeCategory.upturned;
    case 'downturned':
      eyeShapeCategory = EyeShapeCategory.downturned;
    case 'monolid':
      eyeShapeCategory = EyeShapeCategory.monolid;
  }
}

// ------------------------------- Blush-Farbe-Kategorie ------------------------------->
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

// ------------------------------- Blush-Form-Kategorie ------------------------------->
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

// ------------------------------- Lippenfarbe-Kategorie ------------------------------->
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

// ------------------------------- Augenbrauenfarbe-Kategorie ------------------------------->
void setBrowCategory(String browValue) {
  switch (browValue) {
    case 'black':
      browCategory = BrowCategory.black;
    case 'blonde':
      browCategory = BrowCategory.blonde;
    case 'brown':
      browCategory = BrowCategory.brown;
  }
}

// ------------------------------- Augenbrauenform-Kategorie ------------------------------->
void setBrowShapeCategory(String browValue) {
  switch (browValue) {
    case 'thin':
      browShapeCategory = BrowShapeCategory.thin;
    case 'thick':
      browShapeCategory = BrowShapeCategory.thick;
    case 'arched':
      browShapeCategory = BrowShapeCategory.arched;
    case 'straight':
      browShapeCategory = BrowShapeCategory.straight;
  }
}

// ---------------------------------------------- LOGIK ------------------------------------------------>
class AnalysisResultsState extends State<AnalysisResults> {
  // Box 2b ist angezeigt für ROIs 'eyes' und 'blush'
  bool _shouldShowShape(String tab) {
    return tab == 'eyes' || tab == 'blush';
  }

  // ------------------------------- Eye Color Content ------------------------------->
  Widget _getEyeColorContent(EyeColorCategory category) {
    String textToDisplay = "Content missing!";
    for (ColorOrShapeDetail colorDetail in roiData.rois[0].eyeColors) {
      if (colorDetail.colorOrShape == category.name) {
        textToDisplay = colorDetail.contentDescription;
        break;
      }
    }

    return Text(
      textToDisplay,
      style: const TextStyle(fontSize: 14),
    );
  }

  // ------------------------------- Eye Shape Content ------------------------------->
  Widget _getEyeShapeContent(EyeShapeCategory category) {
    String textToDisplay = "Content missing!";
    for (ColorOrShapeDetail shapeDetail in roiData.rois[0].eyeShapes) {
      if (shapeDetail.colorOrShape == category.name) {
        textToDisplay = shapeDetail.contentDescription;
        break;
      }
    }

    return Text(
      textToDisplay,
      style: const TextStyle(fontSize: 14),
    );
  }

  // ----------------------------- Blush Color Content ------------------------------->
  Widget _getBlushContent(BlushCategory category) {
    String textToDisplay = "Content missing!";
    for (ColorOrShapeDetail colorDetail in roiData.rois[0].faceColors) {
      if (colorDetail.colorOrShape == category.name) {
        textToDisplay = colorDetail.contentDescription;
        break;
      }
    }

    return Text(
      textToDisplay,
      style: const TextStyle(fontSize: 14),
    );
  }

  // ------------------------------ Blush Shape Content ------------------------------>
  Widget _getBlushShapeContent(BlushShapeCategory category) {
    String textToDisplay = "Content missing!";
    for (ColorOrShapeDetail shapeDetail in roiData.rois[0].faceShapes) {
      if (shapeDetail.colorOrShape == category.name) {
        textToDisplay = shapeDetail.contentDescription;
        break;
      }
    }

    return Text(
      textToDisplay,
      style: const TextStyle(fontSize: 14),
    );
  }

  // ---------------------------------- Lip Content ---------------------------------->
  Widget _getLipContent(LipCategory category) {
    String textToDisplay = "Content missing!";
    for (ColorOrShapeDetail colorDetail in roiData.rois[0].lipColors) {
      if (colorDetail.colorOrShape == category.name) {
        textToDisplay = colorDetail.contentDescription;
        break;
      }
    }

    return Text(
      textToDisplay,
      style: const TextStyle(fontSize: 14),
    );
  }

  // -------------------------------- Brow Content ------------------------------------>
  Widget _getBrowContent(BrowCategory category) {
    String textToDisplay = "Content missing!";
    for (ColorOrShapeDetail colorDetail in roiData.rois[0].browColors) {
      if (colorDetail.colorOrShape == category.name) {
        textToDisplay = colorDetail.contentDescription;
        break;
      }
    }

    return Text(
      textToDisplay,
      style: const TextStyle(fontSize: 14),
    );
  }

  // ------------------- Main COLOR Content für jeden selected Tab -------------------->
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

  // ------------------- Main SHAPE Content für jeden selected Tab ------------------->
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

  // -------------------------------- FILTER ANZEIGEN -------------------------------->

  // Toggle-Logik für Filter bei Kachel-Tap
  void toggleFilter(String filterPath) {
    setState(() {
      final filterName =
          filterPath.split('.').first; // Filtername ohne Extension
      if (activeFilter == filterName) {
        // Filter ist bereits aktiv -> Filter entfernen
        activeFilter = null;
        _clearFilter();
      } else {
        // Neuen Filter anwenden
        activeFilter = filterName;
        _applyFilter(filterPath);
      }
    });
  }

  // Applikation eines DeepAR-Filters durch Aufrufen des Filterpfades in switchEffect()
  void _applyFilter(String filterPath) {
    print("Applying filter: $filterPath");
    deepArController.switchEffect(filterPath);
  }

  // Löschen eines DeepAR-Filters durch Aufrufen von "null" in switchEffect()
  void _clearFilter() {
    print("Removing filter");
    deepArController.switchEffect(null);
  }

// <------------------------------------ BUILD ------------------------------------>
  @override
  Widget build(BuildContext context) {
    imageLinks = getImageLinks(widget.selectedTab);
    filterPaths = getFilters(widget.selectedTab);

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

  // ------------------------------- Content Box 1 ------------------------------->
  // -------------- enthält auswählbare Tabs für ROIs 'eyes' etc. ---------------->

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
                'based on your facial analysis, I have created personalized recommendations for you. select a category to learn more about your facial features and discover tailored makeup tips.',
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

  // ------------------------------- Content Box 2 ------------------------------->
  // ---------------- enthält Box 2a) COLOR und Box 2b) SHAPE -------------------->

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
              fontFamily: 'Chicle',
              color: Colors.black,
              fontSize: 24,
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
                fontFamily: 'Chicle',
                color: Colors.black,
                fontSize: 24,
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

  // ------------------------------- Content Box 3 ------------------------------->
  // ------------------- enthält bildliche Recommendations ----------------------->

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
            style: const TextStyle(
              fontFamily: 'Chicle',
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 10),
          if (widget.selectedTab != 'blush' && widget.selectedTab != 'brows')
            const BodyText(
              bodyText:
                  'here are some recommended looks. tap on the look you desire to see it applied on your face.',
            ),

          if (!showRecommendationList &&
              widget.selectedTab != 'blush' &&
              widget.selectedTab != 'brows')
            ImageRecommendationsGrid(
              images: imageLinks, // Preview-Images
              filters: filterPaths, // Filter-Pfade
              activeFilter: activeFilter, // Filter, der active ist
              onTileTap: toggleFilter, // Callback für Tap-Event
            ),
          if (showRecommendationList &&
              widget.selectedTab != 'blush' &&
              widget.selectedTab != 'brows')
            const SizedBox(height: 24),
          if (showRecommendationList &&
              widget.selectedTab != 'blush' &&
              widget.selectedTab != 'brows')
            const BodyText(
              bodyText:
                  'the recommendations are shown in the recommendations list on the top. \nchoose a look there to explore!',
            ),
          if (widget.selectedTab == 'blush' || widget.selectedTab == 'brows')
            const BodyText(
              bodyText:
                  'here are some recommendations.\n\nthere are no looks yet for you to apply.',
            ),
          const SizedBox(height: 10),
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

// Extrahiert die Preview-Images
List<String> getImageLinks(String? selectedTab) {
  switch (selectedTab) {
    case 'lips':
      return roiData.rois[0].lipColors
          .firstWhere((item) => item.colorOrShape == lipCategory!.name,
              orElse: () =>
                  emptyColorOrShapeDetail()) // sonst wird leeres Objekt zurückgegeben
          .imageLinks; // greift auf imageLinks zu, nachdem das richtige Objekt gefunden wurde
    case 'eyes':
      return roiData.rois[0].eyeColors
          .firstWhere((item) => item.colorOrShape == eyeColorCategory!.name,
              orElse: () => emptyColorOrShapeDetail())
          .imageLinks;
    case 'blush':
      return roiData.rois[0].faceColors
          .firstWhere((item) => item.colorOrShape == blushCategory!.name,
              orElse: () => emptyColorOrShapeDetail())
          .imageLinks;
    case 'brows':
      return roiData.rois[0].browColors
          .firstWhere((item) => item.colorOrShape == browCategory!.name,
              orElse: () => emptyColorOrShapeDetail())
          .imageLinks;
    default:
      return [];
  }
}

// Extrahiert die Filter-Pfade
List<String> getFilters(String? selectedTab) {
  switch (selectedTab) {
    case 'lips':
      return roiData.rois[0].lipColors
          .firstWhere((item) => item.colorOrShape == lipCategory!.name,
              orElse: () => emptyColorOrShapeDetail())
          .filters;
    case 'eyes':
      return roiData.rois[0].eyeColors
          .firstWhere((item) => item.colorOrShape == eyeColorCategory!.name,
              orElse: () => emptyColorOrShapeDetail())
          .filters;
    case 'blush':
      return roiData.rois[0].faceColors
          .firstWhere((item) => item.colorOrShape == blushCategory!.name,
              orElse: () => emptyColorOrShapeDetail())
          .filters;
    case 'brows':
      return roiData.rois[0].browColors
          .firstWhere((item) => item.colorOrShape == browCategory!.name,
              orElse: () => emptyColorOrShapeDetail())
          .filters;
    default:
      return [];
  }
}

// leere Rückgabewerte, falls keine ROI-Results gefunden wurde
ColorOrShapeDetail emptyColorOrShapeDetail() {
  return ColorOrShapeDetail(
    colorOrShape: '',
    contentDescription: '',
    goal: '',
    recommendations: [],
    techniques: [],
    imageLinks: [],
    filters: [],
  );
}
