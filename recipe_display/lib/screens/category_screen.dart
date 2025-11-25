import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/meal_summary.dart';
import '../widgets/meal_grid_tile.dart';
import '../screens/meal_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryName;
  const CategoryScreen({super.key, required this.categoryName});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<MealSummary> meals = [];
  List<MealSummary> filtered = [];
  bool loading = true;
  final TextEditingController ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() => loading = true);
    try {
      final api = Provider.of<ApiService>(context, listen: false);
      final list = await api.getMealsByCategory(widget.categoryName);
      setState(() {
        meals = list;
        filtered = list;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _search(String query) async {
    query = query.trim();
    if (query.isEmpty) {
      setState(() => filtered = meals);
      return;
    }

    setState(() => loading = true);

    try {
      final api = Provider.of<ApiService>(context, listen: false);
      final results = await api.searchMeals(query);

      final matched = results.where((meal) {
        final cat = meal.category?.toLowerCase() ?? "";
        return cat == widget.categoryName.toLowerCase();
      }).toList();

      setState(() {
        filtered = matched
            .map((m) => MealSummary(id: m.id, name: m.name, thumb: m.thumb))
            .toList();
      });
    } catch (e) {
      setState(() => filtered = []);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: ctrl,
              onChanged: _search,
              onSubmitted: _search,
              decoration: InputDecoration(
                hintText: 'Search dishes',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    ctrl.clear();
                    _search('');
                  },
                ),
              ),
            ),
          ),

          // Meal grid
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final meal = filtered[i];
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
          ),
        ],
      ),
    );
  }
}
