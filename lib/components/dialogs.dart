import 'package:flutter/material.dart';

class DialogBoxes {
  final BuildContext context;
  final String title;
  final String body;
  final Function boolAction;

  DialogBoxes(
      {required this.context,
      required this.title,
      required this.body,
      required this.boolAction});

  dialogBox() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => boolAction(true),
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => boolAction(false),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }
}
