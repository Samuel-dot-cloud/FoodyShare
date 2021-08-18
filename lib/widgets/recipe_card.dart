import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/utils/post_functions.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({Key? key, required this.recipeDoc}) : super(key: key);

  // final RecipeModel recipeModel;
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
    Provider.of<FirebaseOperations>(context, listen: true)
        .getRecipeDetails(context, widget.recipeDoc['postId']);
    Provider.of<FirebaseOperations>(context, listen: false)
        .getAuthorData(context, widget.recipeDoc['authorId']);

    Map likes = widget.recipeDoc['likes'];
    final String currentUserId =
        Provider.of<FirebaseOperations>(context, listen: false).getUserId;
    bool liked = likes[currentUserId] == true;

    handleLikePost() {
      dynamic likes = widget.recipeDoc['likes'];
      bool _isLiked = likes[currentUserId] == true;

      if (_isLiked) {
        recipesRef
            .doc(widget.recipeDoc['postId'])
            .update({'likes.$currentUserId': false});
        setState(() {
          likeCount -= 1;
          liked = false;
          likes[currentUserId] == false;
        });
      } else if (!_isLiked) {
        recipesRef
            .doc(widget.recipeDoc['postId'])
            .update({'likes.$currentUserId': true});
        setState(() {
          likeCount += 1;
          liked = true;
          likes[currentUserId] == true;
        });
      }
    }

    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: Hero(
                  tag: widget.recipeDoc['mediaUrl'],
                  child: Image(
                    height: 320.0,
                    width: 320.0,
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.recipeDoc['mediaUrl']),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20.0,
              right: 40.0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    saved = !saved;
                  });
                },
                child: FaIcon(
                  !saved
                      ? FontAwesomeIcons.bookmark
                      : FontAwesomeIcons.solidBookmark,
                  color: Colors.white,
                  size: 28.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
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
                  backgroundImage: NetworkImage(
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .getUserImage),
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
                    Text(
                      '@' +
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getUsername,
                      style: Theme.of(context).textTheme.caption,
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
                        handleLikePost();
                        setState(() {
                          liked = !liked;
                        });
                        Provider.of<PostFunctions>(context, listen: false)
                            .addLike(
                                context,
                                widget.recipeDoc['postId'],
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .getUserId);
                      },
                      child: FaIcon(
                        FontAwesomeIcons.gratipay,
                        color: liked ? Colors.red : Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        getLikeCount().toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
