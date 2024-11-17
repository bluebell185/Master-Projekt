import 'package:flutter/material.dart';

class FeatureOneResults extends StatelessWidget {
  const FeatureOneResults({super.key, required this.title});

  final String title;

/* HIER: Gesichtsanalyse!

- Loading Screen bzw. Scan-Effekt sollte laufen
- nach Analyse poppt Pop-Up auf, das die Analysis-Results anzeigt, die User modifizieren kann
- erst nach Tap auf CTA_Button "save" -> erster ContentBox-Abschnitt erscheint mit ROIs
- nach Auswahl einer ROI (Tab) -> zweiter ContentBox-Abschnitt mit Recommendations & Looks erscheint

*/

// TO DO: replace pixel padding with rem einheit?

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
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
                    fontFamily: 'Chicle',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.48,
                  ),
                ),
              ],
            ),
          ),

          // erster ContentBox-Abschnitt
          Positioned(
            bottom: 0,
            child: Container(
              width: 393,
              //height: 175,
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
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
                            'Hier steht Text - um  mehr zu den Analyse Results zu erfahren, soll User eine Kategorie auswählen:',
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
                        // TO DO:
                        // - "overflowing" bzw. Swipe-Gesture einbauen -> gewährt durch class ScrollableTabs()
                        // - Interaktion mit den Tabs -> gewährt durch onTabSelected() und class Tab()
                        SizedBox(
                          width: 373,
                          //height: 25,
                          child: ScrollableTabs(),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 75, // 75px Padding top
            right: 15, // 15px Padding right
            child: Column(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'assets/icons/user.png',
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'assets/icons/flash.png',
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'assets/icons/analysis.png',
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'assets/icons/create.png',
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'assets/icons/eye.png',
                  ),
                ),
              ],
            ),
          ),
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
