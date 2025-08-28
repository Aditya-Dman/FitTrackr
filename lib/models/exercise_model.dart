class ExerciseModel {
  final String name;
  final String muscleGroup;
  final String description;
  final String difficulty; // 'Beginner', 'Intermediate', 'Advanced'

  ExerciseModel({
    required this.name,
    required this.muscleGroup,
    required this.description,
    this.difficulty = 'Beginner',
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'muscleGroup': muscleGroup,
      'description': description,
      'difficulty': difficulty,
    };
  }

  // Create from JSON
  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      name: json['name'],
      muscleGroup: json['muscleGroup'],
      description: json['description'],
      difficulty: json['difficulty'] ?? 'Beginner',
    );
  }
}

class WorkoutLog {
  final String exerciseName;
  final String muscleGroup;
  final List<ExerciseSet> sets;
  final DateTime date;

  WorkoutLog({
    required this.exerciseName,
    required this.muscleGroup,
    required this.sets,
    required this.date,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'exerciseName': exerciseName,
      'muscleGroup': muscleGroup,
      'sets': sets.map((set) => set.toJson()).toList(),
      'date': date.toIso8601String(),
    };
  }

  // Create from JSON
  factory WorkoutLog.fromJson(Map<String, dynamic> json) {
    return WorkoutLog(
      exerciseName: json['exerciseName'],
      muscleGroup: json['muscleGroup'],
      sets: (json['sets'] as List)
          .map((setJson) => ExerciseSet.fromJson(setJson))
          .toList(),
      date: DateTime.parse(json['date']),
    );
  }
}

class ExerciseSet {
  final int reps;
  final double weight; // in kg
  final int? duration; // in seconds for cardio
  final double? distance; // in km for running/walking

  ExerciseSet({
    required this.reps,
    this.weight = 0.0,
    this.duration,
    this.distance,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'weight': weight,
      'duration': duration,
      'distance': distance,
    };
  }

  // Create from JSON
  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      reps: json['reps'],
      weight: json['weight']?.toDouble() ?? 0.0,
      duration: json['duration'],
      distance: json['distance']?.toDouble(),
    );
  }
}
