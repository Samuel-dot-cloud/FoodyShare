class FormValues {
  String? name;
  String? description;
  String? cookingTime;
  String? servings;

  List<Map<String, String>>? ingredients;
  List<Map<String, String>>? preparation;
  List<String>? hashtagId;

  @override
  String toString() => '$name, $description, $cookingTime, $servings, $ingredients, $preparation, $hashtagId';
}
