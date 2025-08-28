class FoodModel {
  final String name;
  final int calories;
  final String
  region; // e.g. 'North India', 'South India', 'East India', 'West India', 'Global'

  FoodModel({
    required this.name,
    required this.calories,
    this.region = 'Global',
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'calories': calories, 'region': region};
  }

  // Create from JSON
  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      name: json['name'],
      calories: json['calories'],
      region: json['region'] ?? 'Global',
    );
  }
}
