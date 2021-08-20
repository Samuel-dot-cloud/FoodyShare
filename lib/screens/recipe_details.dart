import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/widgets/comments_section.dart';
import 'package:food_share/widgets/ingredients_section.dart';
import 'package:food_share/widgets/preparation_section.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecipeDetails extends StatefulWidget {
  final String recipeName,
      authorUserName,
      authorUserUID,
      recipeImage,
      servings,
      cookingTime,
      postID;
  final List ingredients, preparation;
  final Map likes;
  final Timestamp recipeTimestamp;

  const RecipeDetails({
    Key? key,
    required this.recipeName,
    required this.authorUserName,
    required this.authorUserUID,
    required this.recipeImage,
    required this.recipeTimestamp,
    required this.servings,
    required this.cookingTime,
    required this.postID,
    required this.ingredients,
    required this.preparation,
    required this.likes,
  }) : super(key: key);

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  bool saved = false;

  int likeCount = 0;

  CollectionReference recipesRef =
      FirebaseFirestore.instance.collection('recipes');

  @override
  Widget build(BuildContext context) {
    Map likes = widget.likes;
    final String currentUserId =
        Provider.of<FirebaseOperations>(context, listen: false).getUserId;
    bool liked = likes[currentUserId] == true;

    handleLikePost() {
      bool _isLiked = likes[currentUserId] == true;

      if (_isLiked) {
        recipesRef.doc(widget.postID).update({'likes.$currentUserId': false});
        setState(() {
          likeCount -= 1;
          liked = false;
          likes[currentUserId] == false;
        });
      } else if (!_isLiked) {
        recipesRef.doc(widget.postID).update({'likes.$currentUserId': true});
        setState(() {
          likeCount += 1;
          liked = true;
          likes[currentUserId] == true;
        });
      }
    }

    Size size = MediaQuery.of(context).size;
    final _textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SlidingUpPanel(
        minHeight: (size.height / 2),
        maxHeight: (size.height / 1.2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        parallaxEnabled: true,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Hero(
                  tag: widget.recipeImage,
                  child: Image(
                    height: (size.height / 2) + 50,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.recipeImage),
                  ),
                ),
              ),
              Positioned(
                top: 40.0,
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
                    size: 32.0,
                  ),
                ),
              ),
              Positioned(
                top: 40.0,
                left: 20.0,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        panel: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                widget.recipeName,
                style: _textTheme.headline6,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                '@' + widget.authorUserName,
                style: _textTheme.caption,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      handleLikePost();
                      setState(() {
                        liked = !liked;
                      });
                    },
                    child: FaIcon(
                      FontAwesomeIcons.gratipay,
                      color: liked ? Colors.red : Colors.black,
                    ),
                  ),
                  // const SizedBox(
                  //   width: 5.0,
                  // ),
                  Text(
                    getLikeCount().toString(),
                    style: const TextStyle(
                      // color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0,
                    ),
                  ),
                  // const SizedBox(
                  //   width: 5.0,
                  // ),
                  const Icon(
                    Icons.timer,
                  ),
                  // const SizedBox(
                  //   width: 5.0,
                  // ),
                  Text(widget.cookingTime + '\''),
                  // const SizedBox(
                  //   width: 5.0,
                  // ),
                  const Icon(
                    Icons.mail_outline,
                  ),
                  // const SizedBox(
                  //   width: 5.0,
                  // ),
                  Text(timeago.format(widget.recipeTimestamp.toDate())),
                  // const SizedBox(
                  //   width: 10.0,
                  // ),
                  Container(
                    color: Colors.black,
                    height: 30.0,
                    width: 2.0,
                  ),
                  // const SizedBox(
                  //   width: 10.0,
                  // ),
                  Text(widget.servings + ' servings'),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Divider(
                color: Colors.black.withOpacity(0.3),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  initialIndex: 0,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(
                            text: 'Ingredients'.toUpperCase(),
                          ),
                          Tab(
                            text: 'Preparation'.toUpperCase(),
                          ),
                          Tab(
                            text: 'Comments'.toUpperCase(),
                          ),
                        ],
                        labelColor: Colors.black,
                        indicator: DotIndicator(
                          color: Colors.red,
                          distanceFromCenter: 16.0,
                          radius: 3,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        unselectedLabelColor: Colors.black.withOpacity(0.3),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                        ),
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 2.0,
                        ),
                      ),
                      Divider(
                        color: Colors.black.withOpacity(0.3),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            IngredientsSection(
                              ingredients: widget.ingredients,
                            ),
                            PreparationSection(
                              preparations: widget.preparation,
                            ),
                            CommentsSection(
                              postId: widget.postID,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int getLikeCount() {
    dynamic likes = widget.likes;
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
