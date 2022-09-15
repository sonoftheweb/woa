import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:woa/services/db/db_service.dart';

import 'db_exceptions.dart';

class WorkoutService {
  List<DatabaseWorkout> _workouts = [];

  // make this service a singleton
  static final WorkoutService _shared = WorkoutService._sharedInstance();
  WorkoutService._sharedInstance();
  factory WorkoutService() => _shared;

  final _workoutStreamController =
      StreamController<List<DatabaseWorkout>>.broadcast();

  Stream<List<DatabaseWorkout>> get allWorkouts =>
      _workoutStreamController.stream;

  Future<void> cacheWorkouts() async {
    final allWorkouts = await getAllWorkouts();
    _workouts = allWorkouts.toList();
    _workoutStreamController.add(_workouts);
  }

  Future<void> deleteWorkout({required int id}) async {
    await DbService().ensureDbIsOpen();
    final db = DbService().getDatabaseOrThrow();
    final deletedCount = await db.delete(
      workoutTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount != 1) {
      throw CouldNotDelete();
    } else {
      _workouts.removeWhere((workout) => workout.id == id);
      _workoutStreamController.add(_workouts);
    }
  }

  Future<DatabaseWorkout> createWorkout({
    required String name,
    required Map<String, int> workoutAreas,
    required Map<String, dynamic> deviceSettings,
    bool? createdLocally = false,
    String? firebaseId,
  }) async {
    await DbService().ensureDbIsOpen();
    final db = DbService().getDatabaseOrThrow();
    final res = await db.query(
      workoutTable,
      limit: 1,
      where: 'name: ?',
      whereArgs: [name],
    );
    if (res.isNotEmpty) {
      throw CouldNotCreate();
    }
    DateTime date = DateTime.now();
    int id = await db.insert(workoutTable, {
      firebaseIdColumn: firebaseId,
      createdLocallyColumn: createdLocally,
      syncedWithCloudColumn: firebaseId != null ? true : false,
      nameColumn: name,
      workoutAreasColumn: json.encode(workoutAreas),
      workoutSettingsColumn: json.encode(deviceSettings),
      createdAtColumn: date.toString()
    });
    final workout = DatabaseWorkout(
        id: id,
        firebaseId: firebaseId,
        createdLocally: createdLocally != null && createdLocally ? true : false,
        syncedWithCloud: firebaseId != null ? true : false,
        name: name,
        workoutAreas: json.encode(workoutAreas),
        workoutSettings: json.encode(deviceSettings),
        createdAt: date.toString());

    _workouts.add(workout);
    _workoutStreamController.add(_workouts);
    return workout;
  }

  Future<DatabaseWorkout> getWorkout({required int id}) async {
    await DbService().ensureDbIsOpen();
    final db = DbService().getDatabaseOrThrow();
    final workout = await db.query(
      workoutTable,
      limit: 1,
      where: 'id: ?',
      whereArgs: [id],
    );
    if (workout.isEmpty) {
      throw CouldNotFind();
    } else {
      final singleWorkout = DatabaseWorkout.fromRow(workout.first);
      _workouts.removeWhere((workout) => workout.id == singleWorkout.id);
      _workouts.add(singleWorkout);
      _workoutStreamController.add(_workouts);
      return singleWorkout;
    }
  }

  Future<Iterable<DatabaseWorkout>> getAllWorkouts() async {
    await DbService().ensureDbIsOpen();
    final db = DbService().getDatabaseOrThrow();
    final workouts = await db.query(workoutTable);
    return workouts.map((w) => DatabaseWorkout.fromRow(w));
  }
}

@immutable
class DatabaseWorkout {
  final int id;
  final String? firebaseId;
  final bool createdLocally;
  final bool? syncedWithCloud;
  final String name;
  final String workoutAreas;
  final String workoutSettings;
  final String? createdAt;

  const DatabaseWorkout({
    required this.id,
    this.firebaseId,
    required this.createdLocally,
    this.syncedWithCloud,
    required this.name,
    required this.workoutAreas,
    required this.workoutSettings,
    this.createdAt,
  });

  DatabaseWorkout.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        firebaseId = map[firebaseIdColumn] as String,
        createdLocally = (map[createdLocallyColumn] as int) == 1 ? true : false,
        syncedWithCloud =
            (map[syncedWithCloudColumn] as int) == 1 ? true : false,
        name = map[nameColumn] as String,
        workoutAreas = map[workoutAreasColumn] as String,
        workoutSettings = map[workoutSettingsColumn] as String,
        createdAt = map[createdAtColumn] as String;

  @override
  String toString() =>
      'Workout, ID = $id, firebaseId = $firebaseId, createdLocally = $createdLocally, syncedWithCloud = $syncedWithCloud, name = $name, workoutAreas = $workoutAreas, workoutSettings = $workoutSettings, createdAt = $createdAt';
}

const dbName = 'workouts.db';
const workoutTable = 'workout';
const idColumn = 'id';
const firebaseIdColumn = 'firebase_d';
const createdLocallyColumn = 'created_locally';
const syncedWithCloudColumn = 'synced_with_cloud';
const nameColumn = 'name';
const workoutAreasColumn = 'workout_areas';
const workoutSettingsColumn = 'workout_settings';
const createdAtColumn = 'created_at';
