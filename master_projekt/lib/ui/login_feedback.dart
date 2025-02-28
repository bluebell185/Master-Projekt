import 'package:flutter/material.dart';

/*-----------------------------------------------------------------------------------------------------------------------------------------------
                    Login Feedback: 
                                  - Gibt eine Snackbar mit Infos über den erfolgreichen Login zurück
------------------------------------------------------------------------------------------------------------------------------------------------*/

giveLoginFeedback(String feedbackText, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(feedbackText, style: TextStyle(color: Colors.grey[800]!)),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color.fromARGB(255, 174, 214, 200),
    ),
  );
}
