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
      description,
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
    required this.description,
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
  @override
  void initState() {
    checkIfAddedToFavorites();
    super.initState();
  }

  bool _isAdded = false;

  CollectionReference recipesRef =
      FirebaseFirestore.instance.collection('recipes');

  @override
  Widget build(BuildContext context) {
    bool _isNotPostOwner =
        Provider.of<FirebaseOperations>(context, listen: false).getUserId !=
            widget.authorUserUID;

    final String currentUserId =
        Provider.of<FirebaseOperations>(context, listen: false).getUserId;

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
                    _isAdded
                        ? Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .removeFromFavorites(currentUserId, widget.postID).whenComplete(() {
                      setState(() {
                        _isAdded = false;
                      });
                    })
                        : Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .addToFavorites(
                            currentUserId,
                            widget.postID,
                            {
                              'postId': widget.postID,
                              'timestamp': Timestamp.now(),
                            },
                          ).whenComplete(() {
                      setState(() {
                        _isAdded = true;
                      });
                    });
                  },
                  child: _isNotPostOwner
                      ? FaIcon(
                          !_isAdded
                              ? FontAwesomeIcons.bookmark
                              : FontAwesomeIcons.solidBookmark,
                          color: Colors.white,
                          size: 28.0,
                        )
                      : const SizedBox(
                          height: 0.0,
                          width: 0.0,
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
                widget.description,
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
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .addLike(
                        context,
                        widget.postID,
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getUserId,
                      );
                      if (_isNotPostOwner) {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .addToActivityFeed(
                          widget.authorUserUID,
                          widget.postID,
                          {
                            'type': 'like',
                            'userUID': Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .getUserId,
                            'postId': widget.postID,
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
                  // const SizedBox(
                  //   width: 5.0,
                  // ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('recipes')
                        .doc(widget.postID)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Text(
                          snapshot.data!.docs.length.toString(),
                          style: const TextStyle(
                            // color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 15.0,
                          ),
                        );
                      }
                    },
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
                              authorId: widget.authorUserUID,
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

  ///Checking if post is already added to favorites
  checkIfAddedToFavorites() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<FirebaseOperations>(context, listen: false).getUserId)
        .collection('favorites')
        .doc(widget.postID)
        .get();
    setState(() {
      _isAdded = doc.exists;
    });
  }
}
