import 'package:flutter/material.dart';

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
    return Positioned(
      left: 0,
      right: 0,
      bottom: 70,
      child: Center(
        child: SizedBox(
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
        ),
      ),
    );
  }
}
