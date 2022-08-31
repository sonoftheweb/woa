import 'package:flutter/material.dart';

class BuildRoutinePageFinalPage extends StatefulWidget {
  final Map<String, int> workoutSettings;

  const BuildRoutinePageFinalPage({Key? key, required this.workoutSettings})
      : super(key: key);

  @override
  State<BuildRoutinePageFinalPage> createState() =>
      _BuildRoutinePageFinalPageState();
}

class _BuildRoutinePageFinalPageState extends State<BuildRoutinePageFinalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        title: const Text('Save routine'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 30.0, right: 30.0),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
