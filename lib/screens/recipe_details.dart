import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/post_functions.dart';
import 'package:food_share/widgets/comments_section.dart';
import 'package:food_share/widgets/ingredients_section.dart';
import 'package:food_share/widgets/preparation_section.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class RecipeDetails extends StatefulWidget {
  final DocumentSnapshot recipeDoc;

  const RecipeDetails({Key? key, required this.recipeDoc}) : super(key: key);

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
    Provider.of<FirebaseOperations>(context, listen: true)
        .getRecipeDetails(context, widget.recipeDoc['postId']);
    Provider.of<FirebaseOperations>(context, listen: true)
        .getAuthorData(context, widget.recipeDoc['authorId']);

    Map likes = widget.recipeDoc['likes'];
    final String currentUserId =
        Provider.of<FirebaseOperations>(context, listen: false).getUserId;
    bool liked = likes[currentUserId] == true;

    handleLikePost() {
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
                  tag: widget.recipeDoc['mediaUrl'],
                  child: Image(
                    height: (size.height / 2) + 50,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.recipeDoc['mediaUrl']),
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
                widget.recipeDoc['name'],
                style: _textTheme.headline6,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                '@' +
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .getUsername,
                style: _textTheme.caption,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
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
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    getLikeCount().toString(),
                    style: const TextStyle(
                      // color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(
                    width: 7.0,
                  ),
                  const Icon(
                    Icons.timer,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(widget.recipeDoc['cookingTime'] + '\''),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Container(
                    color: Colors.black,
                    height: 30.0,
                    width: 2.0,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(widget.recipeDoc['servings'] + ' servings'),
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
                              ingredientsDoc: widget.recipeDoc,
                            ),
                            PreparationSection(
                              preparationDoc: widget.recipeDoc,
                            ),
                            CommentsSection(commentsDoc: widget.recipeDoc,)
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
