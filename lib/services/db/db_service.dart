import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';

const dbName = 'workouts.db';
const workoutTable = 'workout';
const createWorkoutTable = '''
      CREATE TABLE IF NOT EXISTS "workout_routine" (
        "id"	INTEGER NOT NULL,
        "firebase_id"	TEXT,
        "created_locally"	INTEGER NOT NULL DEFAULT 1,
        "synced_with_cloud"	INTEGER DEFAULT 0,
        "name"	TEXT NOT NULL,
        "workout_areas"	TEXT NOT NULL,
        "workout_settings"	TEXT NOT NULL,
        "created_at"	TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
      );
      ''';

class DbService {
  Database? _db;

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createWorkoutTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Database getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }
}
