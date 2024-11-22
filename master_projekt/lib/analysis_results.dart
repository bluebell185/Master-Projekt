import 'package:flutter/material.dart';

// UI-Elemente
import 'package:master_projekt/ui/accordion.dart';
import 'package:master_projekt/ui/tabs.dart';
import 'package:master_projekt/ui/toolbar.dart';

// TO DO: replace pixel padding with rem einheit?
// TO DO: Für jede ROI eine eigene File?

// Definition der verschiedenen Kategorien für "eyes"-Tab
enum EyeColorCategory { blue, green, brown, hazel } // anpassen!

enum LipCategory { red, pink, nude, plum }

enum BrowCategory { thin, thick, arched, straight }

enum BlushCategory { coral, peach, rose, berry }

class AnalysisResults extends StatefulWidget {
  const AnalysisResults({super.key, required this.title});

  final String title;

  @override
  State<AnalysisResults> createState() => _AnalysisResultsState();
}

class _AnalysisResultsState extends State<AnalysisResults> {
  String? selectedTab; // Tracked den ausgewählten Tab ('eyes', 'lips', etc.)
  EyeColorCategory?
      eyeColorCategory; // Tracked die Augenfarben-Kategorie für "eyes"
  LipCategory? lipCategory;
  BrowCategory? browCategory;
  BlushCategory? blushCategory;

  // Liste mit den verfügbaren Tabs
  final List<String> tabs = ['eyes', 'lips', 'brows', 'blush'];

  // Beispielgerüst: Logik für die Augenfarbe-Kategorien?
  void setEyeColorCategory(String colorValue) {
    // 'colorValue' bestimmt die Farbkategorie
    // 'eyeColorCategory' -> TO DO: Range der Farbkategorien
    if (colorValue == 'blue') {
      eyeColorCategory = EyeColorCategory.blue;
    } else if (colorValue == 'green') {
      eyeColorCategory = EyeColorCategory.green;
    } else if (colorValue == 'brown') {
      eyeColorCategory = EyeColorCategory.brown;
    } else if (colorValue == 'hazel') {
      eyeColorCategory = EyeColorCategory.hazel;
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
      case EyeColorCategory.hazel:
        return const Text(
          'Your eye color is hazel. Here are some details about hazel eyes...',
          style: TextStyle(fontSize: 14),
        );
      default:
        return Container();
    }
  }

  // Beispielgerüst: Logik für die Lippen-Kategorie?
  // Methode für Lippen -> if else?
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

  // Beispielgerüst: Logik für die Blush-Kategorie?
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

  // Main Content für jeden ausgewählten Tab
  Widget _getTabContent(String tab) {
    if (tab == 'eyes' && eyeColorCategory != null) {
      return _getEyeColorContent(eyeColorCategory!);
    } else if (tab == 'lips' && lipCategory != null) {
      return _getLipContent(lipCategory!);
    } else if (tab == 'brows' && browCategory != null) {
      return _getBrowContent(browCategory!);
    } else if (tab == 'blush' && blushCategory != null) {
      return _getBlushContent(blushCategory!);
    }

    return Text(
      'Content for $tab - Placeholder text for this category.',
      style: const TextStyle(fontSize: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hintergrund
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
            decoration: const BoxDecoration(
                color: Color.fromARGB(
                    255, 0, 119, 255)), // ersetzen durch Kamerabild

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title oben
                const Text(
                  'Analysis',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Chicle', // TO DO: installieren
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.48,
                  ),
                ),
              ],
            ),
          ),

          // ContentBox-Abschnitte 1+2
          // TO DO: Column Height + Verhalten (Scroll etc.), wenn zweiter Abschnitt kommt
          Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Column(
                  children: [
                    // erster ContentBox-Abschnitt
                    Container(
                      width: 393,
                      //height: 175,
                      padding: const EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 20),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // light-beige Content-Box
                          Container(
                            padding: const EdgeInsets.all(10),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: Color(0xFFF1EADD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // HEADING
                                Text(
                                  'your analysis results',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'Chicle',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                    letterSpacing: 0.48,
                                  ),
                                ),

                                // WHITESPACE
                                const SizedBox(height: 10),

                                // TEXT
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Hier steht Text - um mehr zu den Analyse Results zu erfahren, soll User eine Kategorie auswählen:',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Sans Serif Collection',
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                      letterSpacing: 0.28,
                                    ),
                                  ),
                                ),

                                // WHITESPACE
                                const SizedBox(height: 30),

                                // TABS
                                // - Swipe-Gesture -> gewährt durch class ScrollableTabs()
                                // - Interaktion mit den Tabs -> gewährt durch onTabSelected() und class Tab()
                                SingleChildScrollView(
                                  // A box in which a single widget can be scrolled.
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: tabs.map((tab) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: TabElement(
                                          label: tab,
                                          isSelected: selectedTab == tab,
                                          onTap: () {
                                            setState(() {
                                              selectedTab = (selectedTab == tab)
                                                  ? null
                                                  : tab;
                                              if (selectedTab == 'eyes') {
                                                setEyeColorCategory(
                                                    'blue'); // Set the eye color category here based on extracted color
                                              }
                                            });
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Zweiter ContentBox-Abschnitt je nach Tab & Kategorie
                    if (selectedTab != null) ...[
                      const SizedBox(height: 10),

                      // weiße Content-Box
                      Container(
                        width: 393,
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 20),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // light-beige Content-Box
                            Container(
                              padding: const EdgeInsets.all(10),
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                color: Color(0xFFF1EADD),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // hier: Icon?
                                      // const SizedBox(width: 8),
                                      Text(
                                        selectedTab!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  _getTabContent(
                                      selectedTab!), // Anzeigen des Contents je nach Tab & Kategorie
                                  const SizedBox(height: 10),

                                  Positioned(
                                    left: 0,
                                    child: AccordionWidget(),
                                  ),

                                  // TO DO: Navigation Arrows um von Text Recommendations zu Image Recommendations zu switchen
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          // Toolbar rechts oben
          Toolbar(),
        ],
      ),
    );
  }
}
