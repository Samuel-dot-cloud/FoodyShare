import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/recipe_details_arguments.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfilePostImage extends StatefulWidget {
  const ProfilePostImage({
    Key? key,
    required this.recipeDoc,
  }) : super(key: key);

  final DocumentSnapshot recipeDoc;

  @override
  _ProfilePostImageState createState() => _ProfilePostImageState();
}

class _ProfilePostImageState extends State<ProfilePostImage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.recipeDoc['postId'])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return GestureDetector(
            onTap: () {
              final args = RecipeDetailsArguments(
                cookingTime: snapshot.data!['cookingTime'],
                recipeName: snapshot.data!['name'],
                description: snapshot.data!['description'],
                recipeImage: snapshot.data!['mediaUrl'],
                servings: snapshot.data!['servings'],
                authorUserUID: snapshot.data!['authorId'],
                preparation: snapshot.data!['preparation'],
                recipeTimestamp: snapshot.data!['timestamp'],
                postID: widget.recipeDoc['postId'],
                ingredients: snapshot.data!['ingredients'],
              );
              Navigator.pushNamed(
                context,
                AppRoutes.recipeDetails,
                arguments: args,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data!['mediaUrl'],
                fit: BoxFit.cover,
              ),
            ),
          );
        }
      },
    );
  }
}
