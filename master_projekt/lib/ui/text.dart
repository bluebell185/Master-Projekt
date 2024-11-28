import 'package:flutter/material.dart';

class ScreenTitle extends StatelessWidget {
  final String titleText;
  final Color titleColor;

  const ScreenTitle({
    super.key,
    required this.titleText,
    this.titleColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Text(
          titleText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: titleColor,
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

class Heading extends StatelessWidget {
  final String headingText;
  final Color headingColor;

  const Heading({
    super.key,
    required this.headingText,
    this.headingColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(
        headingText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: headingColor,
          fontSize: 24,
          fontFamily: 'Chicle', // TO DO: installieren
          fontWeight: FontWeight.w400,
          letterSpacing: 0.48,
        ),
      ),
    );
  }
}

class BodyText extends StatelessWidget {
  final String bodyText;
  final Color bodyTextColor;

  const BodyText({
    super.key,
    required this.bodyText,
    this.bodyTextColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(
        bodyText,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: bodyTextColor,
          fontSize: 14,
          //fontFamily: 'Sans Serif', // TO DO: installieren
          fontWeight: FontWeight.w400,
          letterSpacing: 0.48,
        ),
      ),
    );
  }
}
