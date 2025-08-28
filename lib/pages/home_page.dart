import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/log_provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/user_provider.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  final void Function(int)? onNavigate;
  const HomePage({super.key, this.onNavigate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _tipController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _tipFadeAnimation;

  // Tips functionality
  final Map<String, List<String>> _tipsByGoal = {
    'Weight Loss': [
      'Eat more fiber-rich foods to feel full longer.',
      'Drink water before meals to reduce calorie intake.',
      'Avoid sugary drinks and processed snacks.',
      'Increase your daily step count.',
      'Plan your meals and track your calories.',
      'Prioritize sleep for better weight management.',
    ],
    'Weight Gain': [
      'Eat more frequently and add healthy snacks.',
      'Choose nutrient-dense foods like nuts and avocados.',
      'Increase your protein intake for muscle growth.',
      'Strength train regularly to build mass.',
      'Drink smoothies or shakes for extra calories.',
      'Track your progress and adjust as needed.',
    ],
    'Muscle Build': [
      'Focus on compound lifts for maximum muscle.',
      'Eat enough protein and healthy carbs.',
      'Progressively overload your workouts.',
      'Get enough rest and recovery.',
      'Stay hydrated for muscle function.',
      'Track your workouts and nutrition.',
    ],
    'Maintain': [
      'Balance your calorie intake with activity.',
      'Keep a consistent workout routine.',
      'Eat a variety of whole foods.',
      'Stay hydrated and get enough sleep.',
      'Monitor your weight and adjust as needed.',
      'Enjoy active hobbies to stay fit.',
    ],
  };
  int _tipIndex = 0;
  late List<String> _currentTips;
  late String _goal;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _tipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeIn));

    _tipFadeAnimation = CurvedAnimation(
      parent: _tipController,
      curve: Curves.easeInOut,
    );

    // Initialize tips
    final userGoal = Provider.of<UserProvider>(
      context,
      listen: false,
    ).user.fitnessGoal;
    _goal = _tipsByGoal.containsKey(userGoal) ? userGoal : 'Maintain';
    _currentTips = _tipsByGoal[_goal]!;
    _tipIndex = Random().nextInt(_currentTips.length);

    _slideController.forward();
    _tipController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _tipController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userGoal = Provider.of<UserProvider>(context).user.fitnessGoal;
    if (_goal != userGoal && _tipsByGoal.containsKey(userGoal)) {
      setState(() {
        _goal = userGoal;
        _currentTips = _tipsByGoal[_goal]!;
        _tipIndex = Random().nextInt(_currentTips.length);
      });
    }
  }

  void _refreshTip() async {
    await _tipController.reverse();
    setState(() {
      int newIndex;
      do {
        newIndex = Random().nextInt(_currentTips.length);
      } while (newIndex == _tipIndex && _currentTips.length > 1);
      _tipIndex = newIndex;
    });
    await _tipController.forward();
  }

  void _showRefreshDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A237E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          title: const Text(
            'Start Fresh Day',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'This will clear all your food logs and workout logs for a fresh start. Your profile settings (name, height, weight, goals) will remain unchanged.\n\nDo you want to continue?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                // Reset all daily logs
                final logProvider = Provider.of<LogProvider>(
                  context,
                  listen: false,
                );
                final exerciseProvider = Provider.of<ExerciseProvider>(
                  context,
                  listen: false,
                );

                logProvider.clearAllLogs();
                exerciseProvider.clearAllWorkoutLogs();

                Navigator.of(context).pop();

                // Show success feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🎉 Fresh day started! All logs cleared.'),
                    backgroundColor: Color(0xFF1A237E),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'Yes, Reset',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final logProvider = Provider.of<LogProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final totalCalories = logProvider.totalCaloriesToday;
    final goal = user.calorieGoal > 0 ? user.calorieGoal : 2000;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1A237E), // Navy blue
            Color(0xFF283593), // Lighter navy
            Color(0xFF3949AB), // Even lighter navy
            Color(0xFF5C6BC0), // Light navy blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 24,
                    ),
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ScaleTransition(
                                              scale: _pulseAnimation,
                                              child: Text(
                                                'Hello, ${user.name.isNotEmpty ? user.name : 'User'}!',
                                                style: const TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(2, 2),
                                                      blurRadius: 4,
                                                      color: Colors.black26,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              user.fitnessGoal.isNotEmpty
                                                  ? user.fitnessGoal
                                                  : 'Set your goal',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Refresh Button
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: IconButton(
                                          onPressed: () =>
                                              _showRefreshDialog(context),
                                          icon: const Icon(
                                            Icons.refresh,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                          tooltip: 'Start Fresh Day',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            _statCard(
                              'Calories',
                              '$totalCalories / $goal',
                              Icons.local_fire_department,
                            ),
                            const SizedBox(width: 12),
                            _statCard(
                              'Goal',
                              user.fitnessGoal.isNotEmpty
                                  ? user.fitnessGoal
                                  : 'Set Goal',
                              Icons.flag,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Progress',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.grey[200],
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1A237E),
                                      Color(0xFF3949AB),
                                    ],
                                  ),
                                ),
                                width:
                                    MediaQuery.of(context).size.width *
                                    (totalCalories / goal).clamp(0.0, 1.0) *
                                    0.8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${((totalCalories / goal) * 100).toInt()}% of daily goal',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1A237E).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Tips Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '💡 Tip of the Day',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A237E),
                              ),
                            ),
                            GestureDetector(
                              onTap: _refreshTip,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1A237E),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF1A237E,
                                      ).withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FadeTransition(
                          opacity: _tipFadeAnimation,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$_goal Tip',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _currentTips[_tipIndex],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
