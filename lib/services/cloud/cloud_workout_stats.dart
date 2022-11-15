class WorkoutStat {
  final String workoutId;
  final String userId;
  final int trainTime;
  final int fullTrainTime;
  final String dateTrained;

  WorkoutStat({
    required this.workoutId,
    required this.userId,
    required this.trainTime,
    required this.fullTrainTime,
    required this.dateTrained,
  });

  WorkoutStat.fromJson(Map<String, Object?> json)
      : this(
          workoutId: json['workoutId']! as String,
          userId: json['userId']! as String,
          trainTime: json['trainTime']! as int,
          fullTrainTime: json['fullTrainTime']! as int,
          dateTrained: json['dateTrained']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'workoutId': workoutId,
      'userId': userId,
      'trainTime': trainTime,
      'fullTrainTime': fullTrainTime,
      'dateTrained': dateTrained,
    };
  }
}
