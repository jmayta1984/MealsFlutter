import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meals/models/meal.dart';
import 'package:meals/models/meal_category.dart';

class HttpHelper {
  Future<List> fetchCategories() async {
    String urlString = 'https://www.themealdb.com/api/json/v1/1/categories.php';

    Uri url = Uri.parse(urlString);
    http.Response response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final maps = jsonResponse['categories'];
      List categories = maps.map((map) => MealCategory.fromJson(map)).toList();
      return categories;
    }
    return [];
  }


  Future<List> fetchMealsByCategory(String categoryName) async {
    String urlString = 'https://www.themealdb.com/api/json/v1/1/filter.php?c=$categoryName';

    Uri url = Uri.parse(urlString);
    http.Response response = await http.get(url);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final maps = jsonResponse['meals'];
      List meals = maps.map((map) => Meal.fromJson(map)).toList();
      return meals;
    }
    return [];
  }

}
