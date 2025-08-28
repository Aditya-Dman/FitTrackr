class UserModel {
  String name;
  double height; // in cm
  double weight; // in kg
  int calorieGoal;
  String fitnessGoal; // e.g. 'Weight Loss', 'Weight Gain', 'Muscle Build'
  String gender; // 'Male' or 'Female'

  UserModel({
    required this.name,
    required this.height,
    required this.weight,
    required this.calorieGoal,
    required this.fitnessGoal,
    this.gender = 'Male',
  });
}
