class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateWorkoutException extends CloudStorageException {}

class CouldNotGetAllWorkoutException extends CloudStorageException {}

class CouldNotUpdateWorkoutException extends CloudStorageException {}

class CouldNotDeleteWorkoutException extends CloudStorageException {}
