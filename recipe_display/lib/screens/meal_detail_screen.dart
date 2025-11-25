import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/meal_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final MealDetail? preloadedMeal;
  const MealDetailScreen({super.key, required this.mealId, this.preloadedMeal});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  MealDetail? meal;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedMeal != null) {
      meal = widget.preloadedMeal;
      loading = false;
    } else {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final api = Provider.of<ApiService>(context, listen: false);
      final m = await api.getMealById(widget.mealId);
      setState(() => meal = m);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _openYoutube(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open URL')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meal?.name ?? 'Recipe')),
      body: loading ? const Center(child: CircularProgressIndicator())
        : meal == null ? const Center(child: Text('Meal not found'))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.network(meal!.thumb, height: 220, fit: BoxFit.cover)),
                const SizedBox(height: 12),
                Text(meal!.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: [
                  if (meal!.category.isNotEmpty) Chip(label: Text(meal!.category)),
                  if (meal!.area.isNotEmpty) Chip(label: Text(meal!.area)),
                ]),
                const SizedBox(height: 12),
                Text('Ingredients', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                ...meal!.ingredients.map((ing) => Text('• ${ing.name} — ${ing.measure}')),
                const SizedBox(height: 16),
                Text('Instructions', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(meal!.instructions),
                const SizedBox(height: 16),
                if (meal!.youtube != null) ElevatedButton.icon(
                  onPressed: () => _openYoutube(meal!.youtube!),
                  icon: const Icon(Icons.video_library),
                  label: const Text('Watch on YouTube'),
                ),
              ],
            ),
          ),
    );
  }
}
