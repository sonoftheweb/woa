import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woa/components/utilities/dialogs/delete_dialog.dart';

import '../services/cloud/cloud_workout.dart';

typedef WorkoutCallback = void Function(CloudWorkout workout);

class WorkoutListView extends StatefulWidget {
  final String userId;
  final WorkoutCallback onDelete;
  final WorkoutCallback onTap;

  const WorkoutListView({
    Key? key,
    required this.userId,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  State<WorkoutListView> createState() => _WorkoutListViewState();
}

class _WorkoutListViewState extends State<WorkoutListView> {
  late final Query<CloudWorkout> queryWorkout;

  @override
  void initState() {
    queryWorkout = FirebaseFirestore.instance
        .collection('workouts')
        .where('user_id', isEqualTo: widget.userId)
        .where('name', isNotEqualTo: '')
        .withConverter<CloudWorkout>(
          fromFirestore: (snapshot, _) =>
              CloudWorkout.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (workout, _) => workout.toJson(),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deleteIcon = Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      child: const Icon(Icons.delete),
    );

    return FirestoreListView<CloudWorkout>(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      query: queryWorkout,
      itemBuilder: (context, snapshot) {
        CloudWorkout workout = snapshot.data();
        Map<String, dynamic> areas = json.decode(workout.areas!);
        num areasTrainable =
            areas.entries.where((a) => a.value != 0).toList().length;
        Map<String, dynamic> settings = json.decode(workout.settings!);
        return GestureDetector(
          onTap: () {
            widget.onTap(workout);
          },
          child: Dismissible(
            key: ObjectKey(snapshot.id),
            background: deleteIcon,
            secondaryBackground: deleteIcon,
            confirmDismiss: (DismissDirection direction) async {
              final shouldDelete = await showDeleteDialog(context: context);
              if (shouldDelete) {
                widget.onDelete(workout);
              }
            },
            child: ListTile(
              title: Text(
                '${workout.name!} Min',
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: (workout.ownerUserId == workout.createdByUserId)
                  ? const Icon(Icons.verified_user)
                  : const Icon(Icons.supervised_user_circle),
              trailing: Text('${settings['trainTime']} mins'),
              subtitle: Text('$areasTrainable stimulated areas'),
              dense: true,
            ),
          ),
        );
      },
    );
  }
}
