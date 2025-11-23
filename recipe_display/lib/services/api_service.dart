import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal_summary.dart';
import '../models/meal_detail.dart';

class ApiService {
  final String base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> getCategories() async {
    final res = await http.get(Uri.parse('$base/categories.php'));
    if (res.statusCode != 200) throw Exception('Failed to fetch categories');
    final data = json.decode(res.body);
    final list = (data['categories'] ?? []) as List;
    return list.map((e) => Category.fromJson(e)).toList();
  }

  Future<List<MealSummary>> getMealsByCategory(String category) async {
    final url = Uri.parse('$base/filter.php?c=${Uri.encodeComponent(category)}');
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('Failed to fetch meals');
    final data = json.decode(res.body);
    final list = (data['meals'] ?? []) as List;
    return list.map((e) => MealSummary.fromJson(e)).toList();
  }

  Future<List<MealDetail>> searchMeals(String query) async {
    final url = Uri.parse('$base/search.php?s=${Uri.encodeComponent(query)}');
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('Search failed');
    final data = json.decode(res.body);
    final list = data['meals'];
    if (list == null) return [];
    return (list as List).map((e) => MealDetail.fromJson(e)).toList();
  }

  Future<MealDetail> getMealById(String id) async {
    final url = Uri.parse('$base/lookup.php?i=${Uri.encodeComponent(id)}');
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('Fetch meal failed');
    final data = json.decode(res.body);
    final list = (data['meals'] ?? []) as List;
    if (list.isEmpty) throw Exception('Meal not found');
    return MealDetail.fromJson(list[0]);
  }

  Future<MealDetail> getRandomMeal() async {
    final url = Uri.parse('$base/random.php');
    final res = await http.get(url);
    if (res.statusCode != 200) throw Exception('Random failed');
    final data = json.decode(res.body);
    final list = (data['meals'] ?? []) as List;
    return MealDetail.fromJson(list[0]);
  }
}
