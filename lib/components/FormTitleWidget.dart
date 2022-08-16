import 'package:flutter/material.dart';

class FormTitleWidget extends StatelessWidget {
  const FormTitleWidget({
    Key? key,
    required this.registrationText,
  }) : super(key: key);

  final String registrationText;

  @override
  Widget build(BuildContext context) {
    return Text(
      registrationText,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
