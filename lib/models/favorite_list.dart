import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteList {
  final String id;
  final String name;
  final String description;
  final Timestamp timestamp;
  final Timestamp lastEdited;
  final int recipeCount;

  FavoriteList( {
    required this.id,
    required this.name,
    required this.description,
    required this.timestamp,
    required this.lastEdited,
    required this.recipeCount,
  });

  factory FavoriteList.fromDocument(DocumentSnapshot doc) {
    return FavoriteList(
      id: doc['id'],
      name: doc['name'],
      description: doc['description'],
      timestamp: doc['timestamp'],
      lastEdited: doc['lastEdited'],
      recipeCount: doc['recipe_count'],
    );
  }
}