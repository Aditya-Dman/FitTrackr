import 'package:flutter/material.dart';
import '../models/food_model.dart';

class FoodProvider with ChangeNotifier {
  final List<FoodModel> _foods = [
    // Global foods
    FoodModel(name: 'Apple', calories: 95, region: 'Global'),
    FoodModel(name: 'Banana', calories: 105, region: 'Global'),
    FoodModel(name: 'Chicken Breast (100g)', calories: 165, region: 'Global'),
    FoodModel(name: 'Rice (1 cup)', calories: 200, region: 'Global'),
    FoodModel(name: 'Egg', calories: 78, region: 'Global'),
    FoodModel(name: 'Broccoli (100g)', calories: 34, region: 'Global'),
    FoodModel(name: 'Bread (1 slice)', calories: 80, region: 'Global'),
    FoodModel(name: 'Milk (1 cup)', calories: 150, region: 'Global'),
    // North India
    FoodModel(name: 'Chole Bhature', calories: 427, region: 'North India'),
    FoodModel(
      name: 'Paneer Butter Masala',
      calories: 350,
      region: 'North India',
    ),
    FoodModel(name: 'Rajma Chawal', calories: 350, region: 'North India'),
    FoodModel(name: 'Aloo Paratha', calories: 210, region: 'North India'),
    // South India
    FoodModel(name: 'Dosa', calories: 133, region: 'South India'),
    FoodModel(name: 'Idli', calories: 39, region: 'South India'),
    FoodModel(name: 'Sambar', calories: 50, region: 'South India'),
    FoodModel(name: 'Uttapam', calories: 180, region: 'South India'),
    // East India
    FoodModel(name: 'Macher Jhol', calories: 250, region: 'East India'),
    FoodModel(name: 'Litti Chokha', calories: 320, region: 'East India'),
    FoodModel(name: 'Rasgulla', calories: 186, region: 'East India'),
    // West India
    FoodModel(name: 'Dhokla', calories: 150, region: 'West India'),
    FoodModel(name: 'Vada Pav', calories: 290, region: 'West India'),
    FoodModel(name: 'Pav Bhaji', calories: 400, region: 'West India'),
    FoodModel(name: 'Shrikhand', calories: 200, region: 'West India'),
    // Common Indian routine foods
    FoodModel(name: 'Dal (1 bowl)', calories: 120, region: 'All'),
    FoodModel(name: 'Roti (1 piece)', calories: 70, region: 'All'),
    FoodModel(name: 'Sabzi (1 bowl)', calories: 100, region: 'All'),
    FoodModel(name: 'Curd (1 bowl)', calories: 98, region: 'All'),
    FoodModel(name: 'Plain Paratha (1 piece)', calories: 120, region: 'All'),
    FoodModel(name: 'Poha', calories: 180, region: 'All'),
    FoodModel(name: 'Upma', calories: 192, region: 'All'),
    FoodModel(name: 'Khichdi', calories: 210, region: 'All'),
    FoodModel(name: 'Paneer (50g)', calories: 130, region: 'All'),
    FoodModel(name: 'Bhindi Sabzi (1 bowl)', calories: 90, region: 'All'),
    FoodModel(name: 'Aloo Sabzi (1 bowl)', calories: 130, region: 'All'),
    FoodModel(name: 'Mixed Veg (1 bowl)', calories: 110, region: 'All'),
    FoodModel(name: 'Chana Masala (1 bowl)', calories: 180, region: 'All'),
    FoodModel(name: 'Palak Paneer (1 bowl)', calories: 220, region: 'All'),
    FoodModel(name: 'Gajar Halwa (1 bowl)', calories: 250, region: 'All'),
  ];

  List<FoodModel> get foods => _foods;

  List<FoodModel> searchFoods(String query) {
    return _foods
        .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<FoodModel> filterByRegion(String region) {
    if (region == 'All') return _foods;
    return _foods.where((food) => food.region == region).toList();
  }

  void addFood(FoodModel food) {
    _foods.add(food);
    notifyListeners();
  }
}
