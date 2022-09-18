import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:woa/services/cloud/cloud_storage_exceptions.dart';

import 'cloud_storage_constants.dart';
import 'cloud_workout.dart';

class FirebaseCloudStorage {
  final workouts = FirebaseFirestore.instance.collection('workouts');

  Future<void> deleteWorkout({required String documentId}) async {
    try {
      await workouts.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteWorkoutException();
    }
  }

  Future<void> updateWorkout({
    required String documentId,
    required String workoutName,
    required String workoutAreas,
    required String workoutSettings,
  }) async {
    try {
      await workouts.doc(documentId).update({
        workoutName: workoutName,
        workoutAreas: workoutAreas,
        workoutSettings: workoutSettings,
      });
    } catch (e) {
      throw CouldNotUpdateWorkoutException();
    }
  }

  Stream<Iterable<CloudWorkout>> allWorkouts({required String ownerUserId}) =>
      workouts.snapshots().map((event) => event.docs
          .map((doc) => CloudWorkout.fromSnapshot(doc))
          .where((workout) => workout.ownerUserId == ownerUserId));

  Future<Iterable<CloudWorkout>> getWorkouts({
    required String ownerUserId,
  }) async {
    try {
      return await workouts
          .where(
            workoutOwnerUserId,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudWorkout.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllWorkoutException();
    }
  }

  Future<CloudWorkout> createNewWorkout({required String ownerUserId}) async {
    final document = await workouts.add({
      workoutOwnerUserId: ownerUserId,
      workoutName: '',
    });
    final fetchedWorkout = await document.get();
    return CloudWorkout(
      documentId: fetchedWorkout.id,
      ownerUserId: ownerUserId,
      createdByUserId: ownerUserId,
      name: '',
    );
  }

  Future<CloudWorkout> fetchWorkout({
    required String ownerUserId,
    required String workoutId,
  }) async {
    final fetchedWorkout = await workouts.doc(workoutId).get();
    return CloudWorkout(
      documentId: fetchedWorkout.id,
      ownerUserId: ownerUserId,
      createdByUserId: fetchedWorkout.data()![workoutCreatedByUserId] as String,
      name: fetchedWorkout.data()![workoutName] as String,
      areas: fetchedWorkout.data()![workoutAreas] as String,
      settings: fetchedWorkout.data()![workoutSettings] as String,
    );
  }

  // Future<CloudWorkout> fetchPreCreatedWorkout(
  //     {required String ownerUserId}) async {
  //   final fetchedWorkout = await workouts.doc().get();
  //   return CloudWorkout(
  //     documentId: fetchedWorkout.id,
  //     ownerUserId: ownerUserId,
  //     createdByUserId: fetchedWorkout.data()![workoutCreatedByUserId] as String,
  //     name: fetchedWorkout.data()![workoutName] as String,
  //     areas: fetchedWorkout.data()![workoutAreas] as String,
  //     settings: fetchedWorkout.data()![workoutSettings] as String,
  //   );
  // }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
