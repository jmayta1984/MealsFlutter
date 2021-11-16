class Meal {
  String id;
  String name;
  String poster;

  Meal({
    required this.id,
    required this.name,
    required this.poster,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      poster: json['strMealThumb'],
    );
  }
}
