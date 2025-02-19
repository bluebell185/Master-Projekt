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
      backgroundColor: Color.fromARGB(255, 249, 224, 233),
      title: Text(title,
        textAlign: TextAlign.center,),
      content: Text(content,
        textAlign: TextAlign.center,),
      actionsAlignment: MainAxisAlignment.center, // Aktionen zentrieren
      actions: <Widget>[
        ElevatedButton(
                      style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800]!,
                    foregroundColor: Colors.white),
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