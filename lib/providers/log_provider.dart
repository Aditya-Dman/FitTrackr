import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/log_entry.dart';
import '../models/food_model.dart';

class LogProvider with ChangeNotifier {
  final List<LogEntry> _log = [];

  List<LogEntry> get log => _log;

  LogProvider() {
    _loadData();
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? logData = prefs.getString('food_log');

      if (logData != null) {
        final List<dynamic> decodedData = json.decode(logData);
        _log.clear();
        _log.addAll(
          decodedData.map((item) => LogEntry.fromJson(item)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error loading log data: $e');
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = json.encode(
        _log.map((entry) => entry.toJson()).toList(),
      );
      await prefs.setString('food_log', encodedData);
    } catch (e) {
      print('Error saving log data: $e');
    }
  }

  void addLog(FoodModel food, int quantity) {
    _log.add(LogEntry(food: food, date: DateTime.now(), quantity: quantity));
    _saveData();
    notifyListeners();
  }

  void removeLog(LogEntry entry) {
    _log.remove(entry);
    _saveData();
    notifyListeners();
  }

  // Clear all food logs (for refresh functionality)
  void clearAllLogs() {
    _log.clear();
    _saveData();
    notifyListeners();
  }

  int get totalCaloriesToday {
    final today = DateTime.now();
    return _log
        .where(
          (entry) =>
              entry.date.year == today.year &&
              entry.date.month == today.month &&
              entry.date.day == today.day,
        )
        .fold(0, (sum, entry) => sum + entry.food.calories * entry.quantity);
  }

  List<LogEntry> get todayLog {
    final today = DateTime.now();
    return _log
        .where(
          (entry) =>
              entry.date.year == today.year &&
              entry.date.month == today.month &&
              entry.date.day == today.day,
        )
        .toList();
  }
}
