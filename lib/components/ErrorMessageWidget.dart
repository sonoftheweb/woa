import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FailureWidget extends StatelessWidget {
  final String? consoleMessage;

  const FailureWidget({Key? key, this.consoleMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Something went wrong $consoleMessage');
    }

    return const Scaffold(
      body: Center(
        child: Text('Something went wrong!'),
      ),
    );
  }
}
