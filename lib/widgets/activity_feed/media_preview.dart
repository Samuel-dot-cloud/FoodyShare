import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/recipe_details_arguments.dart';
import 'package:food_share/screens/recipe_details.dart';
import 'package:lottie/lottie.dart';

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
                        postID: feedDoc['postId'],
                        ingredients: snapshot.data!['ingredients'],
                      );
                      Navigator.pushNamed(
                        context,
                        AppRoutes.recipeDetails,
                        arguments: args,
                      );
                    },
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
                  )
                : GestureDetector(
                    onTap: () => Fluttertoast.showToast(
                        msg: 'Recipe cannot be found.',
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
                      child: SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                              child: Lottie.asset('assets/lottie/error.json'),
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
