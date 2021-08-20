import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/screens/recipe_details.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:provider/provider.dart';

class ProfilePostImage extends StatefulWidget {
  const ProfilePostImage({Key? key, required this.recipeDoc, required this.authorUserName, required this.userUID}) : super(key: key);

  final DocumentSnapshot recipeDoc;
  final String authorUserName;
  final String userUID;

  @override
  _ProfilePostImageState createState() => _ProfilePostImageState();
}

class _ProfilePostImageState extends State<ProfilePostImage> {

  @override
  void initState() {
    getRecipeDetails(context, widget.recipeDoc['postId']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<FirebaseOperations>(context, listen: true)
        .initUserData(context);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetails(
            cookingTime: cookingTime,
            recipeName: title,
            authorUserName: widget.authorUserName,
            recipeImage: mediaUrl,
            servings: servings,
            likes: likes,
            authorUserUID: widget.userUID,
            preparation: preparation,
            recipeTimestamp: timestamp,
            postID: widget.recipeDoc['postId'],
            ingredients: ingredients,
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(mediaUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  /// Recipe variables
  String id = '',
      authorId = '',
      title = '',
      description = '',
      cookingTime = '',
      servings = '',
      mediaUrl = '';

  Map likes = {};

  List preparation = [],
  ingredients = [];

  Timestamp timestamp = Timestamp.now();


  /// Method for retrieving specific recipe details
  Future getRecipeDetails(BuildContext context, String recipeId) async {
    return FirebaseFirestore.instance
        .collection('recipes')
        .doc(recipeId)
        .get()
        .then((doc) {
      id = doc.data()!['postId'];
      authorId = doc.data()!['authorId'];
      title = doc.data()!['name'];
      description = doc.data()!['description'];
      cookingTime = doc.data()!['cookingTime'];
      servings = doc.data()!['servings'];
      mediaUrl = doc.data()!['mediaUrl'];
      likes = doc.data()!['likes'];
      preparation = doc.data()!['preparation'];
      timestamp = doc.data()!['timestamp'];
      ingredients = doc.data()!['ingredients'];
      // t = doc.data()!['timestamp'];
    });
  }
}
