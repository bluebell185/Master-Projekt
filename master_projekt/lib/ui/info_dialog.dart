import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;

  const InfoDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
}

/* Aufruf:
void showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const InfoDialog(
          title: 'Information',
          content: 'Dies ist eine informative Nachricht.',
          buttonText: 'Verstanden',
        );
      },
    );
  }
*/