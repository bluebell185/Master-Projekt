import 'package:flutter/material.dart';
import 'package:master_projekt/base_screen_with_camera.dart';

// UI-Elemente
import 'package:master_projekt/ui/accordion.dart';
import 'package:master_projekt/ui/tabs.dart';
import 'package:master_projekt/ui/text.dart';
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
  bool _isBoxThreeOpen = false; // Tracked welche Box gerade offen ist
  EyeColorCategory?
      eyeColorCategory; // Tracked die Augenfarben-Kategorie für "eyes"
  LipCategory? lipCategory;
  BrowCategory? browCategory;
  BlushCategory? blushCategory;

  // Liste mit den verfügbaren Tabs
  final List<String> tabs = ['eyes', 'lips', 'brows', 'blush'];

// Navigation zwischen textlichen (Box2) und bildlichen (Box3) Recommendations
  void _navigateToBoxThree() {
    setState(() {
      _isBoxThreeOpen = true;
    });
  }

  void _navigateToBoxTwo() {
    setState(() {
      _isBoxThreeOpen = false;
    });
  }

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
    return BaseScreenWithCamera(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Hintergrund
            Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ScreenTitle(
                    titleText: 'Analysis',
                    titleColor: Colors.white,
                  ),
                ],
              ),
            ),

            Toolbar(),
            // Scrollable Frame A (Content Box Sections)
            DraggableScrollableSheet(
              initialChildSize: 0.25, // Box 1 in position 1
              minChildSize: 0.25, // Minimum size
              maxChildSize: 0.8, // Full screen
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          // Content Box 1
                          _buildBox1(),

                          // Insert Box 2 after selecting a tab
                          if (selectedTab != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child:
                                  _isBoxThreeOpen ? _buildBox3() : _buildBox2(),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
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
          // Tab buttons
          SingleChildScrollView(
            // A box in which a single widget can be scrolled.
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tabs.map((tab) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: TabElement(
                    label: tab,
                    isSelected: selectedTab == tab,
                    onTap: () {
                      setState(() {
                        selectedTab = (selectedTab == tab) ? null : tab;
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
        ],
      ),
    );
  }

  // Content Box 2
  Widget _buildBox2() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EADD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$selectedTab',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _getTabContent(
              selectedTab!), // Anzeigen des Contents je nach Tab & Kategorie
          const SizedBox(height: 10),
          const AccordionWidget(),
          const SizedBox(height: 10),

          // Navigation zu Box 3
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.black),
              onPressed: _navigateToBoxThree,
            ),
          ),
        ],
      ),
    );
  }

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

          imageRecommendations(),

          // Navigation zu Box 2
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: _navigateToBoxTwo,
            ),
          ),
        ],
      ),
    );
  }
}

Widget imageRecommendations() {
  return GridView.builder(
    // Grid aus Kacheln
    shrinkWrap:
        true, // shrinkt den Content, damit er in die Spalte passt -> anpassen mit Seitenverhältnis -- ???
    physics:
        NeverScrollableScrollPhysics(), // damit man in der GridView nicht scrollen kann
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // zwei Kacheln pro Zeile
      mainAxisSpacing: 10, // Vertikaler Abstand zwischen Kacheln
      crossAxisSpacing: 10, // Horizontaler Abstand zwischen Kacheln
      childAspectRatio: 4 / 3, // Seitenverhältnis der Kacheln -- ???
    ),
    itemCount: 6, // Anzahl Looks
    itemBuilder: (context, index) {
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
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/look1.png'), // austauschen
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 5.0),
              child: Text(
                'Look ${index + 1}',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      );
    },
  );
}
