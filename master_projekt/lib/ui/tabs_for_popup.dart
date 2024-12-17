import 'package:flutter/material.dart';
import 'package:master_projekt/screen_with_deepar_camera.dart';

// INTERACTIVE TABS
class ScrollableTabsPopup extends StatefulWidget {
  final List<String> labels; // Liste der Tab Labels
  final ValueChanged<String?>
      onTabSelected; // Callback um ausgewählten Tab zurückzugeben
  final String? selectedTab;

  const ScrollableTabsPopup({
    super.key,
    required this.labels,
    required this.onTabSelected,
    this.selectedTab, 
  });

  @override
  State<ScrollableTabsPopup> createState() => _ScrollableTabsPopupState();
}

class _ScrollableTabsPopupState extends State<ScrollableTabsPopup> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    // Initialisiere `selectedIndex` basierend auf dem bereits ausgewählten Tab
    // Bspl: widget.selectedTab = "brown"
    // widget.labels: Liste der Farben
    selectedIndex = widget.selectedTab != null
        ? widget.labels.indexOf(widget.selectedTab!)
        : null;
  }

  void onTabSelected(int index) {
    setState(() {
      // Auswahl und De-Selection
      selectedIndex = index;
      selectedButtonsRois[index] == true
          ? selectedButtonsRois[index] = false
          : selectedButtonsRois[index] = true;
      for (int k = 0; k < 4; k++) {
        if (k != index) {
          selectedButtonsRois[k] = false;
        }
      }
      // Ausgewählter Index wird geupdated oder auf null gesetzt
    });
    widget.onTabSelected(
      selectedIndex != null ? widget.labels[selectedIndex!] : null,
    ); // Parent ausgewählten Tab melden oder null
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          widget.labels.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TabElement(
              label: widget.labels[index],
              isSelected: selectedIndex == index,
              onTap: () => onTabSelected(index),
            ),
          ),
        ),
      ),
    );
  }
}

class TabElement extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TabElement({
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
