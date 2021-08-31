import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  String id;
  String authorId;
  String title, description;
  String cookingTime;
  String servings;
  List<dynamic> ingredients;
  List<dynamic> preparation;
  String imgPath;
  Timestamp createdAt;

  RecipeModel({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.cookingTime,
    required this.servings,
    required this.ingredients,
    required this.preparation,
    required this.imgPath,
    required this.createdAt,
  });

  // RecipeModel.fromMap(Map<String, dynamic> data) {
  //   id = data['postId'];
  //   authorId = data['authorId'];
  //   title = data['title'];
  //   description = data['description'];
  //   cookingTime = data['cookingTime'];
  //   servings = data['servings'];
  //   imgPath = data['mediaUrl'];
  //   ingredients = data['ingredients'];
  //   preparation = data['preparation'];
  //   createdAt = data['timestamp'];
  // }

  factory RecipeModel.fromDocument(DocumentSnapshot doc) {
    return RecipeModel(
      id: doc['postId'],
      authorId: doc['authorId'],
      createdAt: doc['timestamp'],
      description: doc['description'],
      preparation: doc['preparation'],
      cookingTime: doc['cookingTime'],
      title: doc['name'],
      servings: doc['servings'],
      imgPath: doc['mediaUrl'],
      ingredients: doc['ingredients'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorId': authorId,
      'title': title,
      'description': description,
      'cookingTime': cookingTime,
      'servings': servings,
      'imgPath': imgPath,
      'ingredients': ingredients,
      'preparation': preparation,
      'createdAt': createdAt,
    };
  }
}
