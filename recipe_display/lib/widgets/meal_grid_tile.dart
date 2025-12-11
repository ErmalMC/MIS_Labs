import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal_summary.dart';
import '../services/favorites_service.dart';

class MealGridTile extends StatefulWidget {
  final MealSummary meal;
  final VoidCallback? onTap;

  const MealGridTile({
    super.key,
    required this.meal,
    this.onTap,
  });

  @override
  State<MealGridTile> createState() => _MealGridTileState();
}

class _MealGridTileState extends State<MealGridTile> {
  bool isFav = false;

  @override
  void initState() {
    super.initState();

    // Load initial favorite state
    final favService = Provider.of<FavoritesService>(context, listen: false);
    favService.isFavorite(widget.meal.id).then((value) {
      if (mounted) {
        setState(() => isFav = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favService = Provider.of<FavoritesService>(context, listen: false);

    return Card(
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          children: [
            // Image + Name
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: Image.network(widget.meal.thumb,
                        fit: BoxFit.cover)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.meal.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // ❤️ Favorite Button
            Positioned(
              right: 8,
              top: 8,
              child: IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () async {
                  await favService.toggleFavorite(widget.meal.id);
                  final nowFavorite =
                  await favService.isFavorite(widget.meal.id);
                  setState(() => isFav = nowFavorite);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
