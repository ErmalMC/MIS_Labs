import 'package:flutter/material.dart';
import '../models/meal_summary.dart';

class MealGridTile extends StatelessWidget {
  final MealSummary meal;
  final VoidCallback? onTap;
  const MealGridTile({super.key, required this.meal, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Image.network(meal.thumb, fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(meal.name, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
