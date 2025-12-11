import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favorites_service.dart';
import '../services/api_service.dart';
import '../widgets/meal_grid_tile.dart';
import '../models/meal_summary.dart';
import '../screens/meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool loading = true;
  List<MealSummary> meals = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favService = Provider.of<FavoritesService>(context, listen: false);
    final api = Provider.of<ApiService>(context, listen: false);

    final ids = await favService.getFavorites();
    final List<MealSummary> list = [];

    for (final id in ids) {
      final mealDetail = await api.getMealById(id);
      if (mealDetail != null) {
        // Convert MealDetail → MealSummary
        list.add(MealSummary(
          id: mealDetail.id,
          name: mealDetail.name,
          thumb: mealDetail.thumb,
        ));
      }
    }

    setState(() {
      meals = list;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Recipes")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : meals.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: meals.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final meal = meals[index];
          return MealGridTile(
            meal: meal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MealDetailScreen(mealId: meal.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
