import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/recipe_details_arguments.dart';
import 'package:lottie/lottie.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipePostImage extends StatelessWidget {
  const RecipePostImage({Key? key, required this.recipeDoc}) : super(key: key);

  final DocumentSnapshot recipeDoc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeDoc['post_id'])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return snapshot.data!.exists
              ? GestureDetector(
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
                postID: recipeDoc['postId'],
                ingredients: snapshot.data!['ingredients'],
              );
              Navigator.pushNamed(
                context,
                AppRoutes.recipeDetails,
                arguments: args,
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data!['mediaUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
              : GestureDetector(
            onTap: () => Fluttertoast.showToast(
                msg:
                'Recipe cannot be found. \n It may have been deleted by the author.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Lottie.asset('assets/lottie/error.json'),
              ),
            ),
          );
        }
      },
    );
  }
}
