import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeDetailsArguments {
  final String recipeName;
  final String description;
  final String authorUserUID;
  final String recipeImage;
  final String servings;
  final String cookingTime;
  final String postID;
  final List ingredients;
  final List preparation;
  final Timestamp recipeTimestamp;

  const RecipeDetailsArguments(
      {required this.recipeName,
      required this.description,
      required this.authorUserUID,
      required this.recipeImage,
      required this.servings,
      required this.cookingTime,
      required this.postID,
      required this.ingredients,
      required this.preparation,
      required this.recipeTimestamp});
}
