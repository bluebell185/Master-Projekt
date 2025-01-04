import 'package:flutter/material.dart';
import 'package:master_projekt/feature_one.dart';
import 'package:master_projekt/screen_with_deepar_camera.dart';
import 'analysis_results.dart';

class TestDeepArCamera extends StatefulWidget {
  const TestDeepArCamera({super.key});

  @override
  State<TestDeepArCamera> createState() => TestDeepArCameraState();
}

final GlobalKey<AnalysisResultsState> analysisResultsKey = GlobalKey<AnalysisResultsState>();


class TestDeepArCameraState extends State<TestDeepArCamera> {
  @override
  Widget build(BuildContext context) {
    return ScreenWithDeeparCamera(
      deepArPreviewKey: GlobalKey(),
      isAfterAnalysis: true,
      child: FeatureOne());
  }

  @override
  void dispose() {
    super.dispose();
  }
}
