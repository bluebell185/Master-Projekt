import 'package:flutter/material.dart';
import 'package:master_projekt/start_look_generator.dart';

final String featureTwoWidgetName = 'FeatureTwo';

// GlobalKey für FeatureTwo
final GlobalKey<FeatureTwoState> featureTwoKey = GlobalKey<FeatureTwoState>();

class FeatureTwo extends StatefulWidget {
  FeatureTwo({Key? key}) : super(key: featureTwoKey);

  @override
  State<FeatureTwo> createState() => FeatureTwoState();
}

// needed?
final GlobalKey<StartLookGeneratorState> lookGeneratorKey =
    GlobalKey<StartLookGeneratorState>();

class FeatureTwoState extends State<FeatureTwo> {
  @override
  Widget build(BuildContext context) {
    // TO DO
    return Container();
  }
}
