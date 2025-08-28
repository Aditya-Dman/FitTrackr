import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exercise_provider.dart';
import '../models/exercise_model.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercise Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: const Color(0xFF1A237E), // Navy blue
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(
              text: 'Log Workout',
              icon: Icon(Icons.add_circle_outline, size: 24),
            ),
            Tab(
              text: 'Today\'s Workouts',
              icon: Icon(Icons.list_alt, size: 24),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [LogWorkoutTab(), TodaysWorkoutsTab()],
      ),
    );
  }
}

class LogWorkoutTab extends StatefulWidget {
  const LogWorkoutTab({super.key});

  @override
  State<LogWorkoutTab> createState() => _LogWorkoutTabState();
}

class _LogWorkoutTabState extends State<LogWorkoutTab> {
  String? selectedMuscleGroup;
  ExerciseModel? selectedExercise;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white, // White background
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Muscle Group',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E), // Navy blue text
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: exerciseProvider.muscleGroups.map((muscleGroup) {
                final isSelected = selectedMuscleGroup == muscleGroup;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMuscleGroup = muscleGroup;
                      selectedExercise = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1A237E)
                          : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1A237E)
                            : const Color(0xFF1A237E).withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      muscleGroup,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF1A237E),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            if (selectedMuscleGroup != null) ...[
              const SizedBox(height: 20),
              const Text(
                'Select Exercise',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E), // Navy blue text
                ),
              ),
              const SizedBox(height: 12),

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search exercises...',
                  hintStyle: TextStyle(
                    color: Color(0xFF1A237E).withOpacity(0.6),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF1A237E),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1A237E)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFF1A237E).withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF1A237E),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(color: Color(0xFF1A237E)),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 12),

              // Exercise list
              Expanded(
                child: ListView.builder(
                  itemCount: _getFilteredExercises(exerciseProvider).length,
                  itemBuilder: (context, index) {
                    final exercise = _getFilteredExercises(
                      exerciseProvider,
                    )[index];
                    final isSelected = selectedExercise == exercise;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF1A237E)
                              : const Color(0xFF1A237E).withOpacity(0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      color: isSelected
                          ? const Color(0xFF1A237E).withOpacity(0.1)
                          : Colors.white,
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A237E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getMuscleGroupIcon(exercise.muscleGroup),
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          exercise.name,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: const Color(0xFF1A237E),
                          ),
                        ),
                        subtitle: Text(
                          '${exercise.difficulty} • ${exercise.description}',
                          style: TextStyle(
                            color: const Color(0xFF1A237E).withOpacity(0.7),
                          ),
                        ),
                        trailing: isSelected
                            ? ElevatedButton(
                                onPressed: () => _showAddSetsDialog(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1A237E),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Log Sets'),
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            selectedExercise = exercise;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<ExerciseModel> _getFilteredExercises(ExerciseProvider provider) {
    var exercises = provider.getExercisesByMuscleGroup(selectedMuscleGroup!);
    if (searchQuery.isNotEmpty) {
      exercises = exercises
          .where(
            (exercise) =>
                exercise.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }
    return exercises;
  }

  IconData _getMuscleGroupIcon(String muscleGroup) {
    switch (muscleGroup) {
      case 'Chest':
        return Icons.favorite;
      case 'Back':
        return Icons.shield;
      case 'Arms':
        return Icons.fitness_center;
      case 'Legs':
        return Icons.directions_run;
      case 'Shoulders':
        return Icons.height;
      case 'Core':
        return Icons.center_focus_strong;
      case 'Cardio':
        return Icons.directions_run;
      default:
        return Icons.fitness_center;
    }
  }

  void _showAddSetsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddSetsDialog(exercise: selectedExercise!),
    );
  }
}

class AddSetsDialog extends StatefulWidget {
  final ExerciseModel exercise;

  const AddSetsDialog({super.key, required this.exercise});

  @override
  State<AddSetsDialog> createState() => _AddSetsDialogState();
}

class _AddSetsDialogState extends State<AddSetsDialog> {
  final List<ExerciseSet> sets = [];
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _durationController = TextEditingController();
  final _distanceController = TextEditingController();

  bool get isCardio => widget.exercise.muscleGroup == 'Cardio';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFF1A237E).withOpacity(0.3)),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log ${widget.exercise.name}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 16),

            if (sets.isNotEmpty) ...[
              const Text(
                'Sets:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF1A237E).withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: sets.length,
                  itemBuilder: (context, index) {
                    final set = sets[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor: const Color(
                          0xFF1A237E,
                        ).withOpacity(0.1),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(color: Color(0xFF1A237E)),
                        ),
                      ),
                      title: isCardio
                          ? Text(
                              '${set.duration ?? 0}s • ${set.distance ?? 0}km',
                              style: const TextStyle(color: Color(0xFF1A237E)),
                            )
                          : Text(
                              '${set.reps} reps × ${set.weight}kg',
                              style: const TextStyle(color: Color(0xFF1A237E)),
                            ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Color(0xFF1A237E),
                        ),
                        onPressed: () {
                          setState(() {
                            sets.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            const Text(
              'Add Set:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 8),

            if (isCardio) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _durationController,
                      decoration: InputDecoration(
                        labelText: 'Duration (seconds)',
                        labelStyle: const TextStyle(color: Color(0xFF1A237E)),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF1A237E),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF1A237E).withOpacity(0.3),
                          ),
                        ),
                      ),
                      style: const TextStyle(color: Color(0xFF1A237E)),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _distanceController,
                      decoration: InputDecoration(
                        labelText: 'Distance (km)',
                        labelStyle: const TextStyle(color: Color(0xFF1A237E)),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF1A237E),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF1A237E).withOpacity(0.3),
                          ),
                        ),
                      ),
                      style: const TextStyle(color: Color(0xFF1A237E)),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _repsController,
                      decoration: InputDecoration(
                        labelText: 'Reps',
                        labelStyle: const TextStyle(color: Color(0xFF1A237E)),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF1A237E),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF1A237E).withOpacity(0.3),
                          ),
                        ),
                      ),
                      style: const TextStyle(color: Color(0xFF1A237E)),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      decoration: InputDecoration(
                        labelText: 'Weight (kg)',
                        labelStyle: const TextStyle(color: Color(0xFF1A237E)),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF1A237E),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF1A237E).withOpacity(0.3),
                          ),
                        ),
                      ),
                      style: const TextStyle(color: Color(0xFF1A237E)),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addSet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add Set'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFF1A237E)),
                  ),
                ),
                ElevatedButton(
                  onPressed: sets.isNotEmpty ? _saveWorkout : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save Workout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addSet() {
    if (isCardio) {
      final duration = int.tryParse(_durationController.text);
      final distance = double.tryParse(_distanceController.text);
      if (duration != null || distance != null) {
        setState(() {
          sets.add(
            ExerciseSet(reps: 1, duration: duration, distance: distance),
          );
          _durationController.clear();
          _distanceController.clear();
        });
      }
    } else {
      final reps = int.tryParse(_repsController.text);
      final weight = double.tryParse(_weightController.text);
      if (reps != null && reps > 0) {
        setState(() {
          sets.add(ExerciseSet(reps: reps, weight: weight ?? 0.0));
          _repsController.clear();
          _weightController.clear();
        });
      }
    }
  }

  void _saveWorkout() {
    final exerciseProvider = Provider.of<ExerciseProvider>(
      context,
      listen: false,
    );
    final workoutLog = WorkoutLog(
      exerciseName: widget.exercise.name,
      muscleGroup: widget.exercise.muscleGroup,
      sets: sets,
      date: DateTime.now(),
    );

    exerciseProvider.addWorkoutLog(workoutLog);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.exercise.name} workout logged!'),
        backgroundColor: const Color(0xFF1A237E),
      ),
    );
  }
}

class TodaysWorkoutsTab extends StatelessWidget {
  const TodaysWorkoutsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final todaysWorkouts = exerciseProvider.getTodaysWorkouts();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white, // White background
      ),
      child: todaysWorkouts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 64,
                    color: Color(0xFF1A237E),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No workouts logged today',
                    style: TextStyle(fontSize: 18, color: Color(0xFF1A237E)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start by logging your first exercise!',
                    style: TextStyle(color: Color(0xFF1A237E)),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: todaysWorkouts.length,
              itemBuilder: (context, index) {
                final workout = todaysWorkouts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: const Color(0xFF1A237E).withOpacity(0.2),
                    ),
                  ),
                  color: Colors.white,
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A237E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getMuscleGroupIcon(workout.muscleGroup),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      workout.exerciseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    subtitle: Text(
                      '${workout.muscleGroup} • ${workout.sets.length} sets',
                      style: TextStyle(
                        color: const Color(0xFF1A237E).withOpacity(0.7),
                      ),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A237E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () => _showRemoveWorkoutDialog(
                          context,
                          workout,
                          exerciseProvider,
                        ),
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Color(0xFF1A237E),
                        ),
                        iconSize: 24,
                        tooltip: 'Remove workout',
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sets:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...workout.sets.asMap().entries.map((entry) {
                              final index = entry.key;
                              final set = entry.value;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue[100],
                                      radius: 12,
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: workout.muscleGroup == 'Cardio'
                                          ? Text(
                                              '${set.duration ?? 0}s • ${set.distance ?? 0}km',
                                            )
                                          : Text(
                                              '${set.reps} reps × ${set.weight}kg',
                                            ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _showRemoveWorkoutDialog(
    BuildContext context,
    WorkoutLog workout,
    ExerciseProvider exerciseProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: const Color(0xFF1A237E).withOpacity(0.3)),
        ),
        title: const Text(
          'Remove Workout',
          style: TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to remove "${workout.exerciseName}" workout from your log?',
          style: TextStyle(color: const Color(0xFF1A237E).withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF1A237E)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A237E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              exerciseProvider.removeWorkoutLog(workout);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${workout.exerciseName} workout removed from log',
                  ),
                  backgroundColor: const Color(0xFF1A237E),
                ),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  IconData _getMuscleGroupIcon(String muscleGroup) {
    switch (muscleGroup) {
      case 'Chest':
        return Icons.favorite;
      case 'Back':
        return Icons.shield;
      case 'Arms':
        return Icons.fitness_center;
      case 'Legs':
        return Icons.directions_run;
      case 'Shoulders':
        return Icons.height;
      case 'Core':
        return Icons.center_focus_strong;
      case 'Cardio':
        return Icons.directions_run;
      default:
        return Icons.fitness_center;
    }
  }
}
