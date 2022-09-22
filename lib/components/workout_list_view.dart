import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:woa/components/utilities/dialogs/delete_dialog.dart';

import '../services/cloud/cloud_workout.dart';

typedef WorkoutCallback = void Function(CloudWorkout workout);

class WorkoutListView extends StatelessWidget {
  final Iterable<CloudWorkout> workouts;
  final WorkoutCallback onDelete;
  final WorkoutCallback onTap;

  const WorkoutListView({
    Key? key,
    required this.workouts,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      const Padding(
        padding: EdgeInsets.only(
          top: 30.0,
          left: 40.0,
          right: 40.0,
          bottom: 60.0,
        ),
        child: Text(
          'Below is a list of your workout library. Select one to schedule a workout, build a new workout plan or add to your library from the marketplace.',
          textAlign: TextAlign.center,
        ),
      ),
    ];

    if (workouts.isEmpty) {
      widgets.add(
        const Center(
          child: Text(
            'You have no workouts saved. Please create one.',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    for (final workout in workouts) {
      if (workout.settings == '' || workout.areas == '') {
        continue;
      }
      var build = Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: GestureDetector(
          onTap: () {
            onTap(workout);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: Colors.white,
                width: 3.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${workout.name!} - ${json.decode(workout.settings!)['trainTime']} Mins',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final shouldDelete = await showDeleteDialog(context);
                    if (shouldDelete) {
                      onDelete(workout);
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      widgets.add(build);
    }

    return SingleChildScrollView(
      child: Column(
        children: widgets,
      ),
    );
  }
}
