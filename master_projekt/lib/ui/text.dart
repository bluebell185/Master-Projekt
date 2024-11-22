import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  final String titleText;
  final Color textColor;

  const ScreenTitle({
    super.key,
    required this.titleText,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Text(
          titleText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontFamily: 'Chicle', // TO DO: installieren
            fontWeight: FontWeight.w400,
            letterSpacing: 0.48,
          ),
        ),
      ),
    );
  }
}
