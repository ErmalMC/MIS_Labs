class Ingredient {
  final String name;
  final String measure;
  Ingredient({required this.name, required this.measure});
}

class MealDetail {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumb;
  final String? youtube;
  final List<Ingredient> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumb,
    required this.youtube,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    
    final List<Ingredient> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingKey = 'strIngredient$i';
      final measureKey = 'strMeasure$i';
      final ing = (json[ingKey] ?? '').toString().trim();
      final measure = (json[measureKey] ?? '').toString().trim();
      if (ing.isNotEmpty) {
        ingredients.add(Ingredient(name: ing, measure: measure));
      }
    }

    return MealDetail(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      thumb: json['strMealThumb'] ?? '',
      youtube: (json['strYoutube'] ?? '').toString().isEmpty ? null : json['strYoutube'],
      ingredients: ingredients,
    );
  }
}
