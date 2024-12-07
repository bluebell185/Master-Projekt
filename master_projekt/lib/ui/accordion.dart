import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:master_projekt/analysis_results.dart';
import 'package:master_projekt/json_parse.dart';
import 'package:master_projekt/start_analysis.dart';

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
  static String roi = "";
  static List<String> category = [];

  AccordionWidget(String? selectedTab, String accordionCategory, {super.key}) {
    roi = selectedTab!;
    category.add(accordionCategory);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> colorShades = getColorShadesForRoi();

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
          headerText:
              colorShades.entries.elementAt(0).key, // Name der Recommendation
          contentText: colorShades.entries.elementAt(0).value,
        ),
        AccordionElement(
          leftIcon:
              Icon(Icons.circle, color: Color.fromARGB(124, 255, 223, 116)),
          headerBackgroundColorOpened: Color.fromARGB(123, 255, 235, 171),
          headerText: colorShades.entries.elementAt(1).key,
          contentText: colorShades.entries.elementAt(1).value,
        ),
        AccordionElement(
          leftIcon:
              Icon(Icons.circle, color: Color.fromARGB(124, 251, 189, 164)),
          headerBackgroundColorOpened: Color.fromARGB(123, 250, 207, 190),
          headerText: colorShades.entries.elementAt(2).key,
          contentText: colorShades.entries.elementAt(2).value,
        ),
        AccordionElement(
          leftIcon:
              Icon(Icons.circle, color: Color.fromARGB(124, 249, 164, 251)),
          headerBackgroundColorOpened: Color.fromARGB(123, 251, 191, 252),
          headerText: colorShades.entries.elementAt(3).key,
          contentText: colorShades.entries.elementAt(3).value,
        ),
      ],
    );
  }

  static Map<String, String> getColorShadesForRoi() {
    String colorOrShape = category[0];
    if (colorOrShape == "color") {
      category.removeAt(0);
      return getColorShadesForRoiColor();
    } else {
      category.removeAt(0);
      return getColorShadesForRoiShape();
    }
  }

  static Map<String, String> getColorShadesForRoiColor() {
    Map<String, String> colorText = {};
    ColorOrShapeDetail colorForContent = ColorOrShapeDetail(
        colorOrShape: "Oops",
        contentDescription: "Something went wrong!",
        goal: "",
        recommendations: [],
        techniques: [],
        imageLinks: []);

    if (roi == 'eyes') {
      for (ColorOrShapeDetail colorDetail in roiData.rois[0].eyeColors) {
        if (colorDetail.colorOrShape == eyeColorCategory!.name) {
          colorForContent = colorDetail;
          break;
        }
      }
    } else if (roi == 'brows') {
      for (ColorOrShapeDetail colorDetail in roiData.rois[0].browColors) {
        if (colorDetail.colorOrShape == browCategory!.name) {
          colorForContent = colorDetail;
          break;
        }
      }
    } else if (roi == 'lips') {
      for (ColorOrShapeDetail colorDetail in roiData.rois[0].lipColors) {
        if (colorDetail.colorOrShape == lipCategory!.name) {
          colorForContent = colorDetail;
          break;
        }
      }
    } else if (roi == 'blush') {
      for (ColorOrShapeDetail colorDetail in roiData.rois[0].faceColors) {
        if (colorDetail.colorOrShape == blushCategory!.name) {
          colorForContent = colorDetail;
          break;
        }
      }
    } else {
      colorText.putIfAbsent(
          "Color Shade 1",
          () =>
              "Hier ist ein Text, der erklärt, warum diese Farbe 1 geeignet für diese Augenfarbe ist.");
      colorText.putIfAbsent(
          "Color Shade 2",
          () =>
              "Hier ist ein Text, der erklärt, warum diese Farbe 2 geeignet für diese Augenfarbe ist.");
      colorText.putIfAbsent(
          "Color Shade 3",
          () =>
              "Hier ist ein Text, der erklärt, warum diese Farbe 3 geeignet für diese Augenfarbe ist.");
      colorText.putIfAbsent(
          "Color Shade 4",
          () =>
              "Hier ist ein Text, der erklärt, warum diese Farbe 4 geeignet für diese Augenfarbe ist.");
    }

    if (colorForContent.colorOrShape != "Oops") {
      for (int i = 0; i < 4; i++) {
        colorText.putIfAbsent(colorForContent.recommendations[i].title,
            () => colorForContent.recommendations[i].description);
      }
    }

    return colorText;
  }

  static Map<String, String> getColorShadesForRoiShape() {
    Map<String, String> colorText = {};
    ColorOrShapeDetail colorForContent = ColorOrShapeDetail(
        colorOrShape: "Oops",
        contentDescription: "Something went wrong!",
        goal: "",
        recommendations: [],
        techniques: [],
        imageLinks: []);

    if (roi == 'eyes') {
      for (ColorOrShapeDetail colorDetail in roiData.rois[0].eyeShapes) {
        if (colorDetail.colorOrShape == eyeShapeCategory!.name) {
          colorForContent = colorDetail;
          break;
        }
      }
    } else if (roi == 'blush') {
      for (ColorOrShapeDetail colorDetail in roiData.rois[0].faceShapes) {
        if (colorDetail.colorOrShape == blushShapeCategory!.name) {
          colorForContent = colorDetail;
          break;
        }
      }
    } else {
      colorText.putIfAbsent(
          "Color Shade 1",
          () =>
              "Hier ist ein Text, der erklärt, warum diese Farbe 1 geeignet für diese Augenform ist.");
      colorText.putIfAbsent(
          "Color Shade 2",
          () =>
              "Hier ist ein Text, der erklärt, warum diese Farbe 2 geeignet für diese Augenform ist.");
      colorText.putIfAbsent(
          "Color Shade 3",
          () =>
              "Hier ist ein Text, der erklärt, warum diese Farbe 3 geeignet für diese Augenform ist.");
      colorText.putIfAbsent(
          "Color Shade 4",
          () =>
              "Hier ist ein Text, der erklärt, warum diese Farbe 4 geeignet für diese Augenform ist.");
    }

    if (colorForContent.colorOrShape != "Oops") {
      for (int i = 0; i < 4; i++) {
        colorText.putIfAbsent(colorForContent.recommendations[i].title,
            () => colorForContent.recommendations[i].description);
      }
    }

    return colorText;
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