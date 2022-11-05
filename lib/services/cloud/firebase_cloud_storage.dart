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
    required String workoutNameData,
    required String workoutAreasData,
    required String workoutSettingsData,
  }) async {
    try {
      await workouts.doc(documentId).update({
        workoutName: workoutNameData,
        workoutAreas: workoutAreasData,
        workoutSettings: workoutSettingsData,
      });
    } catch (e) {
      throw CouldNotUpdateWorkoutException();
    }
  }

  // Stream<Iterable<CloudWorkout>> allWorkouts(
  //     {required String ownerUserId,
  //     Map? listPaginationData,
  //     DocumentSnapshot? lastDocumentSnapshot}) {
  //   Map pagination = listPaginationData ??
  //       {
  //         'page': 1,
  //         'perPage': 5,
  //       };
  //
  //   var query = workouts
  //       .limit(pagination['perPage'])
  //       .where('user_id', isEqualTo: ownerUserId);
  //   if (pagination['page'] > 1 && lastDocumentSnapshot != null) {
  //     query = query.startAfterDocument(lastDocumentSnapshot);
  //   }
  //
  //   return query.snapshots().map(
  //       (event) => event.docs.map((doc) => CloudWorkout.fromSnapshot(doc)));
  //   // return query.snapshots().map((event) => event.docs
  //   //     .map((doc) => CloudWorkout.fromSnapshot(doc))
  //   //     .where((workout) => workout.ownerUserId == ownerUserId));
  // }

  Future<QuerySnapshot> getWorkouts(
      {required String ownerUserId,
      required int documentLimit,
      DocumentSnapshot? startAfter}) async {
    try {
      final refWorkouts = workouts
          .where(
            workoutOwnerUserId,
            isEqualTo: ownerUserId,
          )
          .limit(documentLimit);

      if (startAfter == null) {
        return refWorkouts.get();
      } else {
        return refWorkouts.startAfterDocument(startAfter).get();
      }
    } catch (e) {
      throw CouldNotGetAllWorkoutException();
    }
  }

  Future<CloudWorkout> createNewWorkout({required String ownerUserId}) async {
    final document = await workouts.add({
      workoutOwnerUserId: ownerUserId,
      workoutCreatedByUserId: ownerUserId,
      workoutName: '',
      workoutAreas: '',
      workoutSettings: ''
    });
    final fetchedWorkout = await document.get();
    return CloudWorkout(
      documentId: fetchedWorkout.id,
      ownerUserId: ownerUserId,
      createdByUserId: ownerUserId,
      name: '',
      areas: '',
      settings: '',
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

  Future<CloudWorkout?> fetchWorkoutByDocumentId({
    required String workoutId,
  }) async {
    final fetchedWorkout = await workouts.doc(workoutId).get();
    if (fetchedWorkout.exists) {
      return CloudWorkout(
        documentId: fetchedWorkout.id,
        ownerUserId: fetchedWorkout.data()![workoutOwnerUserId],
        createdByUserId: fetchedWorkout.data()![workoutCreatedByUserId],
        name: fetchedWorkout.data()![workoutName] as String,
        areas: fetchedWorkout.data()![workoutAreas] as String,
        settings: fetchedWorkout.data()![workoutSettings] as String,
      );
    } else {
      throw CouldNotGetWorkoutException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
