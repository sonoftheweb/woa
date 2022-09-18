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

  CloudWorkout.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[workoutOwnerUserId],
        createdByUserId = snapshot.data()[workoutCreatedByUserId],
        name = snapshot.data()[workoutName] as String,
        areas = snapshot.data()[workoutAreas] as String,
        settings = snapshot.data()[workoutSettings] as String;
}
