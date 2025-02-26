import 'package:flutter/material.dart';
import 'package:master_projekt/main.dart';
import 'package:master_projekt/screen_with_deepar_camera.dart';
import 'package:master_projekt/ui/recomm_tiles.dart';
import 'package:master_projekt/ui/tabs.dart';
import 'analysis_results.dart';

// UI-Elemente
import 'package:master_projekt/ui/text.dart';
import 'package:master_projekt/ui/toolbar.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Feature One: 
                                  - Verantwortlich für die Anzeige der Recommendations am unteren Bildschirmrand
                                  - Recommendations sind über ein DraggableScrollableSheet nach oben erweiterbar
                                      - Box_1: Anzeige der ROI-Tabs zum Auswählen, welche Recommendations angezeigt werden sollen, dann erst:
                                      - Box_2: Anzeige Make-up-Empfehlungen für ROI und Typ
                                      - Box_3: Anzeige spezieller Looks und Anwendung darauf basierender Filter
------------------------------------------------------------------------------------------------------------------------------------------------*/

final String featureOneWidgetName = 'FeatureOne';

// GlobalKey für FeatureOne
final GlobalKey<FeatureOneState> featureOneKey = GlobalKey<FeatureOneState>();

class FeatureOne extends StatefulWidget {
  FeatureOne({Key? key}) : super(key: featureOneKey);

  @override
  State<FeatureOne> createState() => FeatureOneState();
}

final GlobalKey<AnalysisResultsState> analysisResultsKey =
    GlobalKey<AnalysisResultsState>();

bool setRebuild = false;

bool showRecommendations =
    true; // boolean zum Anzeigen von Frame mit Box 2 und 3
bool hideWidgets =
    false; // boolean, der vom Auge-Icon in der Toolbar angesprochen wird und die Sichtbarkeit der Komponenten bestimmt

final DraggableScrollableController draggableController =
    DraggableScrollableController();

class FeatureOneState extends State<FeatureOne> {
  bool isBox2Or3Visible = false; // Zustandsabfrage: ist Box 2 oder 3 sichtbar?
  String? newSelectedTab;
  bool isBoxThreeOpen = false; // zur Navigation zwischen Box 2 und 3

  void navigateToBoxThree() {
    setState(() {
      isBoxThreeOpen = true;
    });
  }

  void navigateToBoxTwo() {
    setState(() {
      isBoxThreeOpen = false;
    });
  }

  void toggleWidgetHiding() {
    setState(() {
      hideWidgets = !hideWidgets;
    });
  }

  void updateSelectedTab(String? tab) {
    setState(() {
      // Update den Parent state
      if (newSelectedTab == tab) {
        // Wenn der Tab bereits ausgewählt ist, deselektiere ihn
        newSelectedTab = null;
        selectedIndex = null;
        isBox2Or3Visible = false;
        showRecommendationList = false;
        print('Deselected Tab');
      } else {
        // Andernfalls wähle den neuen Tab aus
        newSelectedTab = tab;
        showRecommendationList = false;
        print('Selected Tab: $newSelectedTab');
      }
      if (tab == null) {
        // Box 2/3 ist nicht (mehr) sichtbar, sobald ein Tab deselected wurde
        isBox2Or3Visible = false;
        showRecommendationList = false;
      } else {
        // Box 2/3 ist sichtbar, sobald ein Tab ausgewählt wurde
        isBox2Or3Visible = true;
      }
    });
  }

  void updateSelectedTabFromButtons(String? tab) {
    setState(() {
      // Update den Parent state
      if (newSelectedTab == tab) {
        // Wenn der Tab bereits ausgewählt ist, deselektiere ihn
        newSelectedTab = null;
        selectedIndex = null;
        isBox2Or3Visible = false;
        showRecommendationList = false;
        print('Deselected Tab');
      } else {
        // Andernfalls wähle den neuen Tab aus
        newSelectedTab = tab;
        showRecommendationList = true;
        print('Selected Tab: $newSelectedTab');
      }
      if (tab == null) {
        // Box 2/3 ist nicht (mehr) sichtbar, sobald ein Tab deselected wurde
        isBox2Or3Visible = false;
        showRecommendationList = false;
      } else if (newSelectedTab != null) {
        // Box 2/3 ist sichtbar, sobald ein Tab ausgewählt wurde
        isBox2Or3Visible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    currentFeature = 1;

    return PopScope(
        canPop: false, // Verhindert das Zurücknavigieren
        child: ScreenWithDeeparCamera(
          deepArPreviewKey: GlobalKey(),
          isAfterAnalysis: true,
          isFeatureOne: true,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ScreenTitle(
                        titleText: 'Analysis',
                        titleColor:
                            hideWidgets ? Colors.transparent : Colors.white,
                      ),
                    ],
                  ),
                ),
                Toolbar(
                  widgetCallingToolbar: featureOneWidgetName,
                ),
                if (showRecommendations && !hideWidgets)
                  DraggableScrollableSheet(
                    key: const GlobalObjectKey(
                        'DraggableScrollableSheet'), // https://github.com/flutter/flutter/issues/140603#issuecomment-1871077425
                    controller: draggableController,
                    initialChildSize: 0.25,
                    minChildSize: 0.25,
                    maxChildSize: isBox2Or3Visible ? 0.75 : 0.25,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: AnalysisResults(
                          key: analysisResultsKey,
                          selectedTab:
                              newSelectedTab, // weitergeben des geupdateten ausgewählten Tabs an AnalysisResults
                          isBoxThreeOpen: isBoxThreeOpen,
                          onNavigateToBoxThree: navigateToBoxThree,
                          onNavigateToBoxTwo: navigateToBoxTwo,
                          onTabSelected:
                              updateSelectedTab, // Update an widget.selectedTab in AnalysisResults, wenn sich Tab ändert
                          scrollController: scrollController,
                        ),
                      );
                    },
                  ),
                if (showRecommendationList &&
                    !hideWidgets &&
                    newSelectedTab != 'blush' &&
                    newSelectedTab != 'brows')
                  ImageRecommendationsList(
                    images: imageLinks, // Preview-Images
                    filters: filterPaths, // Filter-Pfade
                    initialActiveFilter: activeFilter, // Filter, der active ist
                    onTileTap: toggleFilter, // Callback für Tap-Event
                  ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  toggleFilter(String filterPath) {
    analysisResultsKey.currentState?.toggleFilter(filterPath);
  }
}
