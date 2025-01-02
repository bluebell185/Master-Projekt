import 'package:flutter/material.dart';

giveLoginFeedback(String feedbackText, BuildContext context){
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(feedbackText),
    duration: const Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.green,
  ),
);
}