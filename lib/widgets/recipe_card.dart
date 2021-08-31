import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/screens/profile/alt_profile.dart';
import 'package:food_share/screens/recipe_details.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({Key? key, required this.recipeDoc}) : super(key: key);

  final DocumentSnapshot recipeDoc;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool saved = false;

  int likeCount = 0;

  CollectionReference recipesRef =
      FirebaseFirestore.instance.collection('recipes');

  @override
  Widget build(BuildContext context) {
    bool _isNotPostOwner =
        Provider.of<FirebaseOperations>(context, listen: false).getUserId !=
            widget.recipeDoc['authorId'];

    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetails(
                      cookingTime: widget.recipeDoc['cookingTime'],
                      recipeName: widget.recipeDoc['name'],
                      description: widget.recipeDoc['description'],
                      recipeImage: widget.recipeDoc['mediaUrl'],
                      servings: widget.recipeDoc['servings'],
                      authorUserUID: widget.recipeDoc['authorId'],
                      preparation: widget.recipeDoc['preparation'],
                      recipeTimestamp: widget.recipeDoc['timestamp'],
                      postID: widget.recipeDoc['postId'],
                      ingredients: widget.recipeDoc['ingredients'],
                    ),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: Hero(
                    tag: widget.recipeDoc['mediaUrl'],
                    child: FadeInImage.memoryNetwork(
                      height: 320.0,
                      width: 320.0,
                      placeholder: kTransparentImage,
                      image: widget.recipeDoc['mediaUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.recipeDoc['authorId'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: CircleAvatar(
                        radius: 18.0,
                        backgroundColor: kBlue,
                        backgroundImage:
                            NetworkImage(snapshot.data!['photoUrl']),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.recipeDoc['name'],
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_isNotPostOwner) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AltProfile(
                                      userUID: widget.recipeDoc['authorId'],
                                      authorImage: snapshot.data!['photoUrl'],
                                      authorUsername:
                                          snapshot.data!['username'],
                                      authorDisplayName:
                                          snapshot.data!['displayName'],
                                      authorBio: snapshot.data!['bio'],
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              _isNotPostOwner
                                  ? '@' + snapshot.data!['username']
                                  : 'You',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20.0,
                          ),
                          const Icon(
                            Icons.timer,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            widget.recipeDoc['cookingTime'] + '\'',
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .addLike(
                                context,
                                widget.recipeDoc['postId'],
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .getUserId,
                              );
                              if (_isNotPostOwner) {
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .addToActivityFeed(
                                  widget.recipeDoc['authorId'],
                                  widget.recipeDoc['postId'],
                                  {
                                    'type': 'like',
                                    'userUID': Provider.of<FirebaseOperations>(
                                            context,
                                            listen: false)
                                        .getUserId,
                                    'postId': widget.recipeDoc['postId'],
                                    'timestamp': Timestamp.now(),
                                  },
                                );
                              }
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.heart,
                              color: Colors.red,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('recipes')
                                .doc(widget.recipeDoc['postId'])
                                .collection('likes')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }

  int getLikeCount() {
    dynamic likes = widget.recipeDoc['likes'];
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });

    return count;
  }
}
