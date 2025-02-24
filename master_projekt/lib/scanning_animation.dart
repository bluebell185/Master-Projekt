import 'package:flutter/material.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Scanning Animation: 
                                  - eine grüne "Scanning-Linie", die über den Display travelled
                                  - optisches Feedback für den User, während im Hintergrund die Gesichtsanalyse läuft
------------------------------------------------------------------------------------------------------------------------------------------------*/

class ScannerWidget extends StatefulWidget {
  const ScannerWidget({super.key});

  @override
  State<ScannerWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    print("Initializing AnimationController");

    // AnimationController initialisieren
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Animation abspielen
    print("Starting animation sequence...");
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    try {
      print("Starting forward animation");
      await _animationController.forward(from: 0.0);
      print("Starting reverse animation");
      await _animationController.reverse(from: 1.0);
      print("Starting forward animation again");
      await _animationController.forward(from: 0.0);

      print("Animation sequence completed");
      if (mounted) {
        Navigator.of(context).pop(); // Schließt den Dialog
      }
    } catch (e) {
      print('Error during animation sequence: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Bildschirmgröße
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Scanning-Effekt
        ImageScannerAnimation(
          stopped: false,
          width: screenWidth, // gesamte Bildschirmbreite
          height: screenHeight, // gesamte Bildschirmhöhe
          animation: _animationController,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// Design Scanner Linie
class ImageScannerAnimation extends AnimatedWidget {
  final bool stopped;
  final double width;
  final double height;

  ImageScannerAnimation({
    super.key,
    required this.stopped,
    required this.width,
    required this.height,
    required Animation<double> animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    final double scorePosition =
        animation.value * height; // Bewegung über gesamte Display-Höhe

    Color color1 = const Color(0x5532CD32);
    Color color2 = const Color(0x0032CD32);

    // Status vom AnimationController
    if ((listenable as AnimationController).status == AnimationStatus.reverse) {
      color1 = const Color(0x0032CD32);
      color2 = const Color(0x5532CD32);
    }

    return Positioned(
      bottom: scorePosition,
      left: 0.0,
      right: 0.0,
      child: Opacity(
        opacity: stopped ? 0.0 : 1.0,
        child: Container(
          height: 60.0,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.9],
              colors: [color1, color2],
            ),
          ),
        ),
      ),
    );
  }
}
