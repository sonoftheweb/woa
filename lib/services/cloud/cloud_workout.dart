import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'cloud_storage_constants.dart';

@immutable
class CloudWorkout {
  final String documentId;
  final String ownerUserId;
  final String createdByUserId;
  final String? name;
  final String? areas;
  final String? settings;

  const CloudWorkout({
    required this.documentId,
    required this.ownerUserId,
    required this.createdByUserId,
    this.name,
    this.areas,
    this.settings,
  });

  CloudWorkout.fromJson(String id, Map<String, Object?> json)
      : this(
          documentId: id,
          ownerUserId: json[workoutOwnerUserId]! as String,
          createdByUserId: json[workoutCreatedByUserId]! as String,
          name: json[workoutName]! as String,
          areas: json[workoutAreas]! as String,
          settings: json[workoutSettings]! as String,
        );

  Map<String, Object?> toJson() => {
        'user_id': ownerUserId,
        'created_by': createdByUserId,
        'name': name,
        'workout_areas': areas,
        'workout_settings': settings,
      };

  CloudWorkout.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[workoutOwnerUserId],
        createdByUserId = snapshot.data()[workoutCreatedByUserId],
        name = snapshot.data()[workoutName] as String,
        areas = snapshot.data()[workoutAreas] as String,
        settings = snapshot.data()[workoutSettings] as String;

  // factory CloudWorkout.fromFirestore();
}
