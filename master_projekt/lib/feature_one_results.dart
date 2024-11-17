import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:master_projekt/toolbar.dart';

/* HIER: Gesichtsanalyse!

- Loading Screen bzw. Scan-Effekt sollte laufen
- nach Analyse poppt Pop-Up auf, das die Analysis-Results anzeigt, die User modifizieren kann
- erst nach Tap auf CTA_Button "save" -> erster ContentBox-Abschnitt erscheint mit ROIs
- nach Auswahl einer ROI (Tab) -> zweiter ContentBox-Abschnitt mit Recommendations & Looks erscheint

*/

// TO DO: replace pixel padding with rem einheit?

// Definition der verschiedenen Kategorien für "eyes"-Tab
enum EyeColorCategory { blue, green, brown, hazel } // anpassen!

// TO DO: Für jede ROI eine eigene File?
// Definition der verschiedenen Kategorien für "lips"-Tab?
// Definition der verschiedenen Kategorien für "brows"-Tab?
// Definition der verschiedenen Kategorien für "blush"-Tab?

class FeatureOneResults extends StatefulWidget {
  const FeatureOneResults({super.key, required this.title});

  final String title;

  @override
  State<FeatureOneResults> createState() => _FeatureOneResultsState();
}

class _FeatureOneResultsState extends State<FeatureOneResults> {
  String? selectedTab; // Tracked den ausgewählten Tab ('eyes', 'lips', etc.)
  EyeColorCategory?
      eyeColorCategory; // Tracked die Augenfarben-Kategorie für "eyes"
  // TO DO: weitere Kategorien der anderen ROIs

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

  // Content für die jeweilige Augenfarben-Kategorie
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

  // Main Content für jeden ausgewählten Tab
  Widget _getTabContent(String tab) {
    if (tab == 'eyes' && eyeColorCategory != null) {
      return _getEyeColorContent(
          eyeColorCategory!); // Anzeige des Contents je nach Augenfarben-Kategorie
    }
    /* Placeholder Content für die anderen Tabs -> Umsetzen wie Widget _getEyeColorContent() für andere ROIs?
      else if (tab == 'lips' && lipCategory != null) {
      TO DO();
    } else if (tab == 'brows' && browCategory != null) {
      TO DO ();
    } else if (tab == 'blush' && blushCategory != null) {
      TO DO();
    }*/
    return Text(
      'Content for $tab - Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      style: TextStyle(fontSize: 14),
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
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
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
                            width:
                                373, // sollte das aber nicht bei Padding der weißen box schon festgelegt werden?
                            //height: 145,
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
                                        child: Tab(
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
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
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
                              width:
                                  373, // sollte das aber nicht bei Padding der weißen box schon festgelegt werden?
                              //height: 145,
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

          Toolbar(),
        ],
      ),
    );
  }
}

// INTERACTIVE TABS
class ScrollableTabs extends StatefulWidget {
  @override
  State<ScrollableTabs> createState() => _ScrollableTabsState();
}

class _ScrollableTabsState extends State<ScrollableTabs> {
  int selectedIndex = -1; // -1 = Initial ist kein Tab ausgewählt

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index; // Ausgewählter Index wird geupdated
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Tab(
            label: 'eyes',
            isSelected: selectedIndex == 0,
            onTap: () => onTabSelected(0),
          ),
          SizedBox(width: 10),
          Tab(
            label: 'lips',
            isSelected: selectedIndex == 1,
            onTap: () => onTabSelected(1),
          ),
          SizedBox(width: 10),
          Tab(
            label: 'brows',
            isSelected: selectedIndex == 2,
            onTap: () => onTabSelected(2),
          ),
          SizedBox(width: 10),
          Tab(
            label: 'blush',
            isSelected: selectedIndex == 3,
            onTap: () => onTabSelected(3),
          ),
        ],
      ),
    );
  }
}

class Tab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const Tab({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Triggert den onTap-Callback, wenn getapped wird
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFFFFDCE8)
              : Colors.white, // Lightpink wenn ausgewählt, sonst weiß
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? Colors.black
                  : Colors.black, // schwarze Textfarbe
              fontSize: 14,
              fontFamily: 'Sans Serif Collection',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.28,
            ),
          ),
        ),
      ),
    );
  }
}

// ACCORDIONS

/* ExpansionTile hat nicht das gewünschte Layout -> deswegen Accordion Package
class ExpansionTileExample extends StatefulWidget {
  const ExpansionTileExample({super.key});

  @override
  State<ExpansionTileExample> createState() => _ExpansionTileExampleState();
}

class _ExpansionTileExampleState extends State<ExpansionTileExample> {
  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const ExpansionTile(
          title: Text('Color shade'),
          collapsedBackgroundColor:
              Color(0xFF42A5F5), // hard coded für jede Farbe?
          collapsedShape: RoundedRectangleBorder(), // Form des Accordions
          collapsedTextColor: Color(0xFF000000), // Textfarbe collapsed
          textColor: Color(0xFF000000), // Textfarbe expanded
          controlAffinity:
              ListTileControlAffinity.platform, // eig wo das Icon platziert ist
          iconColor: Color(0xFF000000), // Farbe des Icons wenn expanded
          children: <Widget>[
            ListTile(
                title: Text(
                    'Hier ist ein Text, der erklärt, warum diese Farbe geeignet für diese Augenfarbe ist.'))
          ],
        ),
      ],
    );
  }
}*/

class AccordionWidget extends StatelessWidget {
  const AccordionWidget({super.key});

  // hier statisch die Farben definieren?
  static const headerStyle =
      TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);
  //static const contentStyleHeader = TextStyle(
  //color: Color(0xffffffff), fontSize: 14, fontWeight: FontWeight.w700);
  static const contentStyle = TextStyle(
      color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal);

  // hier statisch die Texte definieren?
  static const colorshade1 =
      'Hier ist ein Text, der erklärt, warum diese Farbe geeignet für diese Augenfarbe ist.';
  static const colorshade2 =
      'Hier ist ein Text, der erklärt, warum diese Farbe 2 geeignet für diese Augenfarbe ist.';

  @override
  Widget build(BuildContext context) {
    return Accordion(
      contentHorizontalPadding: 20,
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      sectionOpeningHapticFeedback: SectionHapticFeedback.light,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      children: [
        AccordionSection(
          isOpen: false,
          leftIcon: const Icon(Icons.circle,
              color: Color.fromARGB(126, 251, 164, 193)), // anpassen
          rightIcon:
              Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
          headerBorderRadius: 30,
          headerBackgroundColor: Colors.white,
          headerBackgroundColorOpened: Color(0x7FFEB9D0),
          contentBackgroundColor: Colors.transparent,
          contentBorderColor: Colors.white,
          contentVerticalPadding: 30,
          header: const Text('Color Shade 1', style: headerStyle),
          content: const Text(colorshade1, style: contentStyle),
        ),
        AccordionSection(
          isOpen: false,
          leftIcon: const Icon(Icons.circle,
              color: Color.fromARGB(126, 251, 164, 193)), // anpassen
          rightIcon:
              Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
          headerBorderRadius: 30,
          headerBackgroundColor: Colors.white,
          headerBackgroundColorOpened: Color(0x7FFEB9D0),
          contentBackgroundColor: Colors.transparent,
          contentBorderColor: Colors.white,
          contentVerticalPadding: 30,
          header: const Text('Color Shade 2', style: headerStyle),
          content: const Text(colorshade2, style: contentStyle),
        ),
      ],
    );
  }
}
