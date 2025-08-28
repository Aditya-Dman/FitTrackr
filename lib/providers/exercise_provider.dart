import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/exercise_model.dart';

class ExerciseProvider with ChangeNotifier {
  final List<ExerciseModel> _exercises = [
    // Chest Exercises
    ExerciseModel(
      name: 'Push-ups',
      muscleGroup: 'Chest',
      description: 'Classic bodyweight chest exercise',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Bench Press',
      muscleGroup: 'Chest',
      description: 'Barbell chest press',
      difficulty: 'Intermediate',
    ),
    ExerciseModel(
      name: 'Incline Dumbbell Press',
      muscleGroup: 'Chest',
      description: 'Upper chest focused exercise',
      difficulty: 'Intermediate',
    ),
    ExerciseModel(
      name: 'Chest Dips',
      muscleGroup: 'Chest',
      description: 'Bodyweight chest and tricep exercise',
      difficulty: 'Intermediate',
    ),
    ExerciseModel(
      name: 'Chest Flyes',
      muscleGroup: 'Chest',
      description: 'Isolation exercise for chest',
      difficulty: 'Beginner',
    ),

    // Back Exercises
    ExerciseModel(
      name: 'Pull-ups',
      muscleGroup: 'Back',
      description: 'Upper body pulling exercise',
      difficulty: 'Intermediate',
    ),
    ExerciseModel(
      name: 'Deadlift',
      muscleGroup: 'Back',
      description: 'Full body compound movement',
      difficulty: 'Advanced',
    ),
    ExerciseModel(
      name: 'Bent Over Row',
      muscleGroup: 'Back',
      description: 'Horizontal pulling movement',
      difficulty: 'Intermediate',
    ),
    ExerciseModel(
      name: 'Lat Pulldown',
      muscleGroup: 'Back',
      description: 'Machine-based pulling exercise',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'T-Bar Row',
      muscleGroup: 'Back',
      description: 'Thick grip rowing exercise',
      difficulty: 'Intermediate',
    ),

    // Arms Exercises
    ExerciseModel(
      name: 'Bicep Curls',
      muscleGroup: 'Arms',
      description: 'Isolation exercise for biceps',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Tricep Dips',
      muscleGroup: 'Arms',
      description: 'Bodyweight tricep exercise',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Close Grip Bench Press',
      muscleGroup: 'Arms',
      description: 'Tricep focused bench press',
      difficulty: 'Intermediate',
    ),
    ExerciseModel(
      name: 'Hammer Curls',
      muscleGroup: 'Arms',
      description: 'Neutral grip bicep exercise',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Overhead Tricep Extension',
      muscleGroup: 'Arms',
      description: 'Isolation tricep exercise',
      difficulty: 'Beginner',
    ),

    // Legs Exercises
    ExerciseModel(
      name: 'Squats',
      muscleGroup: 'Legs',
      description: 'Compound lower body exercise',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Lunges',
      muscleGroup: 'Legs',
      description: 'Single leg strength exercise',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Leg Press',
      muscleGroup: 'Legs',
      description: 'Machine-based leg exercise',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Bulgarian Split Squats',
      muscleGroup: 'Legs',
      description: 'Single leg squat variation',
      difficulty: 'Intermediate',
    ),
    ExerciseModel(
      name: 'Calf Raises',
      muscleGroup: 'Legs',
      description: 'Isolation exercise for calves',
      difficulty: 'Beginner',
    ),

    // Shoulders Exercises
    ExerciseModel(
      name: 'Shoulder Press',
      muscleGroup: 'Shoulders',
      description: 'Overhead pressing movement',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Lateral Raises',
      muscleGroup: 'Shoulders',
      description: 'Side deltoid isolation',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Front Raises',
      muscleGroup: 'Shoulders',
      description: 'Front deltoid isolation',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Rear Delt Flyes',
      muscleGroup: 'Shoulders',
      description: 'Rear deltoid isolation',
      difficulty: 'Beginner',
    ),

    // Cardio Exercises
    ExerciseModel(
      name: 'Running',
      muscleGroup: 'Cardio',
      description: 'Cardiovascular endurance exercise',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Walking',
      muscleGroup: 'Cardio',
      description: 'Low impact cardio exercise',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Cycling',
      muscleGroup: 'Cardio',
      description: 'Low impact leg cardio',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Jump Rope',
      muscleGroup: 'Cardio',
      description: 'High intensity cardio',
      difficulty: 'Intermediate',
    ),

    // Core Exercises
    ExerciseModel(
      name: 'Plank',
      muscleGroup: 'Core',
      description: 'Isometric core exercise',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Crunches',
      muscleGroup: 'Core',
      description: 'Basic abdominal exercise',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Russian Twists',
      muscleGroup: 'Core',
      description: 'Rotational core exercise',
      difficulty: 'Beginner',
    ),
    ExerciseModel(
      name: 'Mountain Climbers',
      muscleGroup: 'Core',
      description: 'Dynamic core and cardio exercise',
      difficulty: 'Intermediate',
    ),
  ];

  final List<WorkoutLog> _workoutLogs = [];

  List<ExerciseModel> get exercises => _exercises;
  List<WorkoutLog> get workoutLogs => _workoutLogs;

  ExerciseProvider() {
    _loadWorkoutLogs();
  }

  // Load workout logs from SharedPreferences
  Future<void> _loadWorkoutLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? workoutData = prefs.getString('workout_logs');

      if (workoutData != null) {
        final List<dynamic> decodedData = json.decode(workoutData);
        _workoutLogs.clear();
        _workoutLogs.addAll(
          decodedData.map((item) => WorkoutLog.fromJson(item)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error loading workout logs: $e');
    }
  }

  // Save workout logs to SharedPreferences
  Future<void> _saveWorkoutLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = json.encode(
        _workoutLogs.map((log) => log.toJson()).toList(),
      );
      await prefs.setString('workout_logs', encodedData);
    } catch (e) {
      print('Error saving workout logs: $e');
    }
  }

  List<String> get muscleGroups => [
    'Chest',
    'Back',
    'Arms',
    'Legs',
    'Shoulders',
    'Core',
    'Cardio',
  ];

  List<ExerciseModel> getExercisesByMuscleGroup(String muscleGroup) {
    return _exercises
        .where((exercise) => exercise.muscleGroup == muscleGroup)
        .toList();
  }

  List<ExerciseModel> searchExercises(String query) {
    return _exercises
        .where(
          (exercise) =>
              exercise.name.toLowerCase().contains(query.toLowerCase()) ||
              exercise.muscleGroup.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  void addWorkoutLog(WorkoutLog log) {
    _workoutLogs.add(log);
    _saveWorkoutLogs();
    notifyListeners();
  }

  List<WorkoutLog> getWorkoutLogsByDate(DateTime date) {
    return _workoutLogs
        .where(
          (log) =>
              log.date.year == date.year &&
              log.date.month == date.month &&
              log.date.day == date.day,
        )
        .toList();
  }

  List<WorkoutLog> getTodaysWorkouts() {
    return getWorkoutLogsByDate(DateTime.now());
  }

  void removeWorkoutLog(WorkoutLog log) {
    _workoutLogs.remove(log);
    _saveWorkoutLogs();
    notifyListeners();
  }

  // Clear all workout logs (for refresh functionality)
  void clearAllWorkoutLogs() {
    _workoutLogs.clear();
    _saveWorkoutLogs();
    notifyListeners();
  }
}
