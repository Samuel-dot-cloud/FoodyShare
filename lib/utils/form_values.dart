class FormValues {
  String? name;
  String? description;
  String? cookingTime;
  String? servings;

  List<Map<String, String>>? ingredients;

  @override
  String toString() => '$name, $description, $cookingTime, $servings, $ingredients';
}
