import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  final UserModel _user = UserModel(
    name: 'User',
    height: 170,
    weight: 70,
    calorieGoal: 2000,
    fitnessGoal: 'Maintain',
    gender: 'Male',
  );

  UserModel get user => _user;

  UserProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _user.name = prefs.getString('name') ?? 'User';
    _user.height = prefs.getDouble('height') ?? 170;
    _user.weight = prefs.getDouble('weight') ?? 70;
    _user.calorieGoal = prefs.getInt('calorieGoal') ?? 2000;
    _user.fitnessGoal = prefs.getString('fitnessGoal') ?? 'Maintain';
    _user.gender = prefs.getString('gender') ?? 'Male';
    notifyListeners();
  }

  Future<void> _saveUserToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _user.name);
    await prefs.setDouble('height', _user.height);
    await prefs.setDouble('weight', _user.weight);
    await prefs.setInt('calorieGoal', _user.calorieGoal);
    await prefs.setString('fitnessGoal', _user.fitnessGoal);
    await prefs.setString('gender', _user.gender);
  }

  void updateUser({
    String? name,
    double? height,
    double? weight,
    int? calorieGoal,
    String? fitnessGoal,
    String? gender,
    bool recalculateCalories = true,
  }) {
    if (name != null) _user.name = name;
    if (height != null) _user.height = height;
    if (weight != null) _user.weight = weight;
    if (fitnessGoal != null) _user.fitnessGoal = fitnessGoal;
    if (gender != null) _user.gender = gender;
    // Calorie calculation logic
    if (recalculateCalories) {
      _user.calorieGoal = _calculateCalories(
        _user.height,
        _user.weight,
        _user.fitnessGoal,
        _user.gender,
      );
    } else if (calorieGoal != null) {
      _user.calorieGoal = calorieGoal;
    }
    notifyListeners();
  }

  int _calculateCalories(
    double height,
    double weight,
    String goal, [
    String gender = 'Male',
  ]) {
    // Mifflin-St Jeor Equation (simplified, assuming age 25)
    double bmr =
        10 * weight + 6.25 * height - 5 * 25 + (gender == 'Male' ? 5 : -161);
    double calories = bmr * 1.4; // Light activity
    if (goal == 'Weight Loss') {
      calories -= 500;
    } else if (goal == 'Weight Gain') {
      calories += 300;
    } else if (goal == 'Muscle Build') {
      calories += 150;
    }
    return max(1200, calories.round());
  }

  @override
  void notifyListeners() {
    _saveUserToPrefs();
    super.notifyListeners();
  }
}
