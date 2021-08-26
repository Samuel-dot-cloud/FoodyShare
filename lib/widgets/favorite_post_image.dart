import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/screens/recipe_details.dart';
import 'package:transparent_image/transparent_image.dart';

class FavoritePostImage extends StatelessWidget {
  const FavoritePostImage({Key? key, required this.recipeDoc}) : super(key: key);

  final DocumentSnapshot recipeDoc;

  @override
  Widget build(BuildContext context) {
    return
      StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('recipes')
            .doc(recipeDoc['postId'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetails(
                    cookingTime: snapshot.data!['cookingTime'],
                    recipeName: snapshot.data!['name'],
                    description: snapshot.data!['description'],
                    recipeImage: snapshot.data!['mediaUrl'],
                    servings: snapshot.data!['servings'],
                    likes: snapshot.data!['likes'],
                    authorUserUID: snapshot.data!['authorId'],
                    preparation: snapshot.data!['preparation'],
                    recipeTimestamp: snapshot.data!['timestamp'],
                    postID: recipeDoc['postId'],
                    ingredients: snapshot.data!['ingredients'],
                  ),
                ),
              ),
              child:  Container(
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(
                        Radius.circular(15))
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(15)),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: snapshot.data!['mediaUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }
        },
      );
  }
}
