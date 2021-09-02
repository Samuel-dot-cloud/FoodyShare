import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/screens/recipe_details.dart';

Widget? mediaPreview;
String activityItemText = '';

class FeedMediaPreview extends StatelessWidget {
  const FeedMediaPreview({Key? key, required this.feedDoc}) : super(key: key);
  final DocumentSnapshot feedDoc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: 50.0,
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('recipes')
            .doc(feedDoc['postId'])
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
                    authorUserUID: snapshot.data!['authorId'],
                    preparation: snapshot.data!['preparation'],
                    recipeTimestamp: snapshot.data!['timestamp'],
                    postID: feedDoc['postId'],
                    ingredients: snapshot.data!['ingredients'],
                  ),
                ),
              ),
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(snapshot.data!['mediaUrl']),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
