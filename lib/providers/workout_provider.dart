import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:woa/services/cloud/cloud_workout.dart';
import 'package:woa/services/cloud/firebase_cloud_storage.dart';

import '../services/auth/auth_service.dart';
import '../services/cloud/cloud_storage_constants.dart';

class WorkoutProvider extends ChangeNotifier {
  final FirebaseCloudStorage _firebaseCloudStorage = FirebaseCloudStorage();
  final _workoutSnapshot = <DocumentSnapshot>[];
  final int _documentLimit = 5;
  String _errorMessage = '';
  bool _hasNext = true;
  bool _isFetchingWorkouts = false;

  final user = AuthService.firebase().currentUser!;

  String get errorMessage => _errorMessage;
  bool get hasNext => _hasNext;

  List<CloudWorkout> get workouts => _workoutSnapshot.map((snap) {
        final workout = snap.data()! as Map<String, dynamic>;
        return CloudWorkout(
            documentId: snap.id,
            ownerUserId: workout[workoutOwnerUserId],
            createdByUserId: workout[workoutCreatedByUserId],
            name: workout[workoutName],
            areas: workout[workoutAreas],
            settings: workout[workoutSettings]);
      }).toList();

  Future fetchNextWorkouts() async {
    if (_isFetchingWorkouts) return;

    _errorMessage = '';
    _isFetchingWorkouts = true;

    try {
      final snap = await _firebaseCloudStorage.getWorkouts(
        ownerUserId: user.id,
        documentLimit: _documentLimit,
        startAfter: _workoutSnapshot.isNotEmpty ? _workoutSnapshot.last : null,
      );

      _workoutSnapshot.addAll(snap.docs);

      if (snap.docs.length < _documentLimit) _hasNext = false;

      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
    _isFetchingWorkouts = false;
  }
}
