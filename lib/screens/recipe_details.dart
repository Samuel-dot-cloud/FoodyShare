import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/widgets/comments_section.dart';
import 'package:food_share/widgets/ingredients_section.dart';
import 'package:food_share/widgets/preparation_section.dart';
import 'package:google_fonts/google_fonts.dart';
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
  }) : super(key: key);

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  @override
  void initState() {
    checkIfLiked();
    _isButtonDisabled = false;
    checkIfAddedToFavorites();
    super.initState();
  }

  bool _isAdded = false;
  bool _isLiked = false;
  bool _isDeleting = false;
  late bool _isButtonDisabled;

  checkIfLiked() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.postID)
        .collection('likes')
        .doc(
          Provider.of<FirebaseOperations>(context, listen: false).getUserId,
        )
        .get();
    setState(() {
      _isLiked = doc.exists;
    });
  }

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
                child: !_isDeleting ? Hero(
                  tag: widget.recipeImage,
                  child: Image(
                    height: (size.height / 2) + 50,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.recipeImage),
                  ),
                ) : const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.cyanAccent,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.yellow),
                  ),
                ),
              ),
              Positioned(
                top: 40.0,
                right: 40.0,
                child: InkWell(
                  onTap: () {
                    if (_isNotPostOwner) {
                      _isAdded
                          ? Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .removeFromFavorites(currentUserId, widget.postID)
                              .whenComplete(() {
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
                    } else {
                      _showOptionsBottomSheet(context);
                    }
                  },
                  child: _isNotPostOwner
                      ? FaIcon(
                          !_isAdded
                              ? FontAwesomeIcons.bookmark
                              : FontAwesomeIcons.solidBookmark,
                          color: Colors.white,
                          size: 28.0,
                        )
                      : const Icon(
                          Icons.more_vert,
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
                widget.description,
                style: GoogleFonts.inconsolata(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.0,
                    color: Colors.grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: _isButtonDisabled
                              ? null
                              : () {
                                  setState(() {
                                    _isButtonDisabled = true;
                                  });
                                  _isLiked
                                      ? Provider.of<FirebaseOperations>(context,
                                              listen: false)
                                          .removeLike(
                                          context,
                                          widget.postID,
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getUserId,
                                        )
                                          .whenComplete(() {
                                          setState(() {
                                            _isLiked = false;
                                            _isButtonDisabled = false;
                                          });
                                        })
                                      : Provider.of<FirebaseOperations>(context,
                                              listen: false)
                                          .addLike(
                                          context,
                                          widget.postID,
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getUserId,
                                        )
                                          .whenComplete(() {
                                          setState(() {
                                            _isLiked = true;
                                            _isButtonDisabled = false;
                                          });
                                          if (_isNotPostOwner) {
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .addLikeToActivityFeed(
                                              widget.authorUserUID,
                                              widget.postID,
                                              {
                                                'type': 'like',
                                                'userUID': Provider.of<
                                                            FirebaseOperations>(
                                                        context,
                                                        listen: false)
                                                    .getUserId,
                                                'postId': widget.postID,
                                                'timestamp': Timestamp.now(),
                                              },
                                            );
                                          }
                                        });
                                },
                          child: FaIcon(
                            FontAwesomeIcons.heart,
                            color: _isLiked ? Colors.red : Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('recipes')
                              .doc(widget.postID)
                              .collection('likes')
                              .doc('like_count')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Text(''),
                              );
                            } else {
                              return Text(
                                snapshot.data!.exists
                                    ? snapshot.data!['count'].toString()
                                    : '0',
                                style: const TextStyle(
                                  // color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15.0,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const Icon(
                          Icons.timer,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(widget.cookingTime + '\''),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const FaIcon(
                          FontAwesomeIcons.commentDots,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('comments')
                              .doc(widget.postID)
                              .collection('count')
                              .doc('commentCount')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Text(''),
                              );
                            } else {
                              return Text(
                                snapshot.data!.exists
                                    ? snapshot.data!['count'].toString()
                                    : '0',
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const Icon(
                          Icons.mail_outline,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(timeago.format(widget.recipeTimestamp.toDate())),
                        const SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0, left: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.pizzaSlice,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(widget.servings + ' servings'),
                      ],
                    ),
                  ),
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

  _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Options',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Divider(
                      height: 2.0,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        _isDeleting = true;
                      });
                      Provider.of<FirebaseOperations>(context, listen: false).deleteRecipe(widget.postID).whenComplete(() {
                        setState(() {
                          _isDeleting = false;
                          Navigator.pop(context);
                        });
                      });
                    },
                    leading: const Icon(
                      Icons.delete_forever,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Delete recipe',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
