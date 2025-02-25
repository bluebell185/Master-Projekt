import 'package:flutter/material.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Buttons: 
                                  - PrimaryButton: darkplum background + white text
                                  - SecondaryButtonLight: white border + white text
                                  - SecondaryButtonDark: darkplum border + darkplum text
------------------------------------------------------------------------------------------------------------------------------------------------*/

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback
      onPressed; // Funktion zur Navigation oder um eine Action auszuführen

  const PrimaryButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextButton(
        onPressed: onPressed, // Aktion, wenn der Button gepressed wird
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFF342C32),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Sans Serif Collection',
            fontWeight: FontWeight.w400,
            letterSpacing: 0.32,
          ),
        ),
      ),
    );
  }
}

class SecondaryButtonLight extends StatelessWidget {
  final String buttonText;
  final VoidCallback
      onPressed; // Funktion zur Navigation oder um eine Action auszuführen

  const SecondaryButtonLight({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextButton(
        onPressed: onPressed, // Aktion, wenn der Button gepressed wird
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Colors.white, // Farbe des Rahmens
              width: 2, // Breite des Rahmens
            ),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Sans Serif Collection',
            fontWeight: FontWeight.w400,
            letterSpacing: 0.32,
          ),
        ),
      ),
    );
  }
}

class SecondaryButtonDark extends StatelessWidget {
  final String buttonText;
  final VoidCallback
      onPressed; // Funktion zur Navigation oder um eine Action auszuführen

  const SecondaryButtonDark({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextButton(
        onPressed: onPressed, // Aktion, wenn der Button gepressed wird
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: Color(0xFF342C32), // Farbe des Rahmens
              width: 2, // Breite des Rahmens
            ),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            color: Color(0xFF342C32),
            fontSize: 16,
            fontFamily: 'Sans Serif Collection',
            fontWeight: FontWeight.w400,
            letterSpacing: 0.32,
          ),
        ),
      ),
    );
  }
}
