import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/helpers/recipe_detail_helper.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/recipe_details_arguments.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/number_formatter.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/recipe/comments_section.dart';
import 'package:food_share/widgets/recipe/ingredients_section.dart';
import 'package:food_share/widgets/recipe/like_button.dart';
import 'package:food_share/widgets/recipe/preparation_section.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecipeDetails extends StatefulWidget {
  final RecipeDetailsArguments arguments;

  const RecipeDetails({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  @override
  void initState() {
    checkIfLiked();
    super.initState();
  }

  bool _isLiked = false;
  bool _isDeleting = false;

  checkIfLiked() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.arguments.postID)
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
            widget.arguments.authorUserUID;

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
        color: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Hero(
                  tag: widget.arguments.recipeImage,
                  child: !_isDeleting
                      ? Image(
                          height: (size.height / 2) + 50,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              widget.arguments.recipeImage),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.cyanAccent,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.yellow),
                          ),
                        ),
                ),
              ),
              Positioned(
                top: 40.0,
                right: 40.0,
                child: InkWell(
                  onTap: () {
                    // if (_isNotPostOwner) {
                    //   _isAdded
                    //       ? Provider.of<FirebaseOperations>(context,
                    //               listen: false)
                    //           .removeFromFavorites(
                    //               currentUserId, widget.arguments.postID)
                    //           .whenComplete(() {
                    //           setState(() {
                    //             _isAdded = false;
                    //           });
                    //           Fluttertoast.showToast(
                    //               msg: 'Removed from favorites',
                    //               toastLength: Toast.LENGTH_SHORT,
                    //               gravity: ToastGravity.BOTTOM,
                    //               timeInSecForIosWeb: 1,
                    //               backgroundColor: kBlue,
                    //               textColor: Colors.white,
                    //               fontSize: 16.0);
                    //         })
                    //       : Provider.of<FirebaseOperations>(context,
                    //               listen: false)
                    //           .addToFavorites(
                    //           currentUserId,
                    //           widget.arguments.postID,
                    //           {
                    //             'postId': widget.arguments.postID,
                    //             'timestamp': Timestamp.now(),
                    //           },
                    //         ).whenComplete(() {
                    //           setState(() {
                    //             _isAdded = true;
                    //           });
                    //           Fluttertoast.showToast(
                    //               msg: 'Added to favorites',
                    //               toastLength: Toast.LENGTH_SHORT,
                    //               gravity: ToastGravity.BOTTOM,
                    //               timeInSecForIosWeb: 1,
                    //               backgroundColor: kBlue,
                    //               textColor: Colors.white,
                    //               fontSize: 16.0);
                    //         });
                    // } else {
                    _showOptionsBottomSheet(context);
                    // }
                  },
                  child: const Icon(
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
                  onTap: () {
                    Navigator.pop(context);
                  },
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
                widget.arguments.recipeName,
                style: _textTheme.headline6,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                widget.arguments.description,
                maxLines: 3,
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
                        CustomLikeButton(
                          isPostLiked: _isLiked,
                          authorID: widget.arguments.authorUserUID,
                          likeCount: 0,
                          postID: widget.arguments.postID,
                          isNotPostOwner: _isNotPostOwner,
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
                        Text(widget.arguments.cookingTime + '\''),
                        const SizedBox(
                          width: 10.0,
                        ),
                        const FaIcon(
                          FontAwesomeIcons.commentDots,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('comments')
                              .doc(widget.arguments.postID)
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
                                    ? NumberFormatter.formatter(
                                        snapshot.data!['count'].toString())
                                    : '0',
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Container(
                          color: Colors.black,
                          height: 30.0,
                          width: 2.0,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(timeago.format(
                            widget.arguments.recipeTimestamp.toDate(),
                            locale: 'en_short')),
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
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(widget.arguments.servings + ' servings'),
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
                        indicator: DotIndicator(
                          color: Colors.red,
                          distanceFromCenter: 16.0,
                          radius: 3,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        unselectedLabelColor: Colors.black.withOpacity(0.3),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          color: Theme.of(context).iconTheme.color,
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
                              ingredients: widget.arguments.ingredients,
                            ),
                            PreparationSection(
                              preparations: widget.arguments.preparation,
                            ),
                            CommentsSection(
                              postId: widget.arguments.postID,
                              authorId: widget.arguments.authorUserUID,
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

  _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (context) {
        bool _isNotPostOwner =
            Provider.of<FirebaseOperations>(context, listen: false).getUserId !=
                widget.arguments.authorUserUID;
        return Wrap(
          children: [
            Column(
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
                _isNotPostOwner
                    ? const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      )
                    : _buildOptionListTile(
                        () {
                          showDeleteAlertDialog();
                        },
                        Icons.delete_forever,
                        'Delete recipe',
                      ),
                _isNotPostOwner
                    ? _buildOptionListTile(
                        () async {
                          Provider.of<RecipeDetailHelper>(context,
                                  listen: false)
                              .showFavoriteListsBottomSheet(context, widget.arguments.postID);
                        },
                        Icons.bookmark_border_outlined,
                        'Add to favorites',
                      )
                    : const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                _isNotPostOwner
                    ? _buildOptionListTile(
                        () {},
                        Icons.info_outline_rounded,
                        'Report this recipe',
                      )
                    : const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
              ],
            ),
          ],
        );
      },
    );
  }

  ListTile _buildOptionListTile(
      GestureTapCallback onTap, IconData icon, String text) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }

  Future<void> showDeleteAlertDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            title: const Text(
              'Delete recipe?',
              style: TextStyle(
                fontSize: 23.0,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            content: const Text(
              'This is an irreversible action!!',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20.0,
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                  ),
                ),
              ),
              MaterialButton(
                color: kBlue,
                onPressed: () {
                  setState(() {
                    _isDeleting = true;
                  });
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .deleteRecipe(widget.arguments.postID)
                      .whenComplete(() {
                    setState(() {
                      _isDeleting = false;
                    });
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                        msg: 'Recipe successfully deleted.',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: kBlue,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.bottomNav);
                  });
                },
                child: const Text(
                  'Go Ahead',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
