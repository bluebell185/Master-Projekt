import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';

// Accordion Widget, das die verschiedenen textlichen Recommendations in Analysis-Results darstellt.

class AccordionElement extends AccordionSection {
  AccordionElement({
    required Icon
        leftIcon, // Der Kreis, der die Farbe in Vollfarbe 100% anzeigt
    required Color headerBackgroundColorOpened,
    required String headerText,
    required String contentText,
  }) : super(
          isOpen: false,
          leftIcon: leftIcon,
          rightIcon:
              Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
          headerBorderRadius: 30,
          headerBackgroundColor: Colors.white,
          headerBackgroundColorOpened: headerBackgroundColorOpened,
          contentBackgroundColor: Colors.transparent,
          contentBorderColor: Colors.white,
          contentVerticalPadding: 30,
          header: Text(headerText,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          content: Text(contentText,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal)),
        );
}

class AccordionWidget extends StatelessWidget {
  const AccordionWidget({super.key});

  // Statische Texte für die Inhalte -> in JSON speichern?
  static const colorshade1 =
      'Hier ist ein Text, der erklärt, warum diese Farbe 1 geeignet für diese Augenfarbe ist.';
  static const colorshade2 =
      'Hier ist ein Text, der erklärt, warum diese Farbe 2 geeignet für diese Augenfarbe ist.';
  static const colorshade3 =
      'Hier ist ein Text, der erklärt, warum diese Farbe 3 geeignet für diese Augenfarbe ist.';
  static const colorshade4 =
      'Hier ist ein Text, der erklärt, warum diese Farbe 4 geeignet für diese Augenfarbe ist.';

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
        // für jede Kategorie eine Gruppe anlegen und hier ganz aufrufen?
        AccordionElement(
          leftIcon: Icon(Icons.circle,
              color: Color.fromARGB(126, 251, 164,
                  193)), // Der Kreis, der die Farbe in Vollfarbe 100% anzeigt
          headerBackgroundColorOpened:
              const Color(0x7FFEB9D0), // Der Hintergrund in der Farbe in 50%
          headerText: 'Color Shade 1', // Name der Recommendation
          contentText: colorshade1,
        ),
        AccordionElement(
          leftIcon:
              Icon(Icons.circle, color: Color.fromARGB(124, 255, 223, 116)),
          headerBackgroundColorOpened: Color.fromARGB(123, 255, 235, 171),
          headerText: 'Color Shade 2',
          contentText: colorshade2,
        ),
        AccordionElement(
          leftIcon:
              Icon(Icons.circle, color: Color.fromARGB(124, 251, 189, 164)),
          headerBackgroundColorOpened: Color.fromARGB(123, 250, 207, 190),
          headerText: 'Color Shade 3',
          contentText: colorshade3,
        ),
        AccordionElement(
          leftIcon:
              Icon(Icons.circle, color: Color.fromARGB(124, 249, 164, 251)),
          headerBackgroundColorOpened: Color.fromARGB(123, 251, 191, 252),
          headerText: 'Color Shade 4',
          contentText: colorshade4,
        ),
      ],
    );
  }
}

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