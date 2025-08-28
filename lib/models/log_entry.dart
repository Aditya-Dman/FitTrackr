import 'food_model.dart';

class LogEntry {
  final FoodModel food;
  final DateTime date;
  final int quantity;

  LogEntry({required this.food, required this.date, required this.quantity});

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'food': food.toJson(),
      'date': date.toIso8601String(),
      'quantity': quantity,
    };
  }

  // Create from JSON
  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      food: FoodModel.fromJson(json['food']),
      date: DateTime.parse(json['date']),
      quantity: json['quantity'],
    );
  }
}
