import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/routes/alt_profile_arguments.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/recipe_details_arguments.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
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
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
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
                          postID: recipeDoc['post_id'],
                          ingredients: snapshot.data!['ingredients'],
                        );
                        Navigator.pushNamed(
                          context,
                          AppRoutes.recipeDetails,
                          arguments: args,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.9),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: snapshot.data!['mediaUrl'],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                              value: downloadProgress.progress,
                              backgroundColor: Colors.cyanAccent,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.yellow),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: _buildUserProfileStreamBuilder(
                          context, snapshot.data!['authorId']),
                    ),
                  ],
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

  StreamBuilder<DocumentSnapshot<Object?>> _buildUserProfileStreamBuilder(
      BuildContext context, String authorId) {
    bool _isNotProfileOwner = authorId !=
        Provider.of<FirebaseOperations>(context, listen: false).getUserId;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(authorId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return InputChip(
            backgroundColor: Colors.white,
            avatar: CircleAvatar(
              backgroundColor: kBlue,
              backgroundImage:
                  CachedNetworkImageProvider(snapshot.data!['photoUrl']),
            ),
            label: Text(
              _isNotProfileOwner ? '@' + snapshot.data!['username'] : 'You',
              style: TextStyle(
                color: _isNotProfileOwner ? Colors.black : kBlue,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            onPressed: () {
              if (_isNotProfileOwner) {
                final args = AltProfileArguments(
                  userUID: snapshot.data!['id'],
                  authorImage: snapshot.data!['photoUrl'],
                  authorUsername: snapshot.data!['username'],
                  authorDisplayName: snapshot.data!['displayName'],
                  authorBio: snapshot.data!['bio'],
                );
                Navigator.pushNamed(
                  context,
                  AppRoutes.altProfile,
                  arguments: args,
                );
              }
            },
          );
        }
      },
    );
  }
}
