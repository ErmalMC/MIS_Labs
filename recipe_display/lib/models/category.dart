class Category {
  final String idCategory;
  final String name;
  final String thumb;
  final String description;

  Category({
    required this.idCategory,
    required this.name,
    required this.thumb,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      idCategory: json['idCategory'] ?? '',
      name: json['strCategory'] ?? '',
      thumb: json['strCategoryThumb'] ?? '',
      description: json['strCategoryDescription'] ?? '',
    );
  }
}
