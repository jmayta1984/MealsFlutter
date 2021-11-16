class MealCategory {
  String id;
  String name;
  String poster;
  String description;

  MealCategory({
    required this.id,
    required this.name,
    required this.poster,
    required this.description,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      id: json['idCategory'],
      name: json['strCategory'],
      poster: json['strCategoryThumb'],
      description: json['strCategoryDescription'],
    );
  }
}
