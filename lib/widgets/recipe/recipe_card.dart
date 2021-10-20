import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/routes/alt_profile_arguments.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/recipe_details_arguments.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/number_formatter.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({Key? key, required this.recipeDoc}) : super(key: key);

  final DocumentSnapshot recipeDoc;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  void initState() {
    checkIfLiked();
    _isButtonDisabled = false;
    _isNotPostOwner =
        Provider.of<FirebaseOperations>(context, listen: false).getUserId !=
            widget.recipeDoc['authorId'];
    super.initState();
  }

  bool saved = false;
  bool _isLiked = false;
  late bool _isButtonDisabled;
  late bool _isNotPostOwner;
  int likeCount = 0;

  checkIfLiked() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipeDoc['postId'])
        .collection('likes')
        .doc(
          Provider.of<FirebaseOperations>(context, listen: false).getUserId,
        )
        .get();
    setState(() {
      _isLiked = doc.exists;
    });
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    _isButtonDisabled
        ? null
        : () {
            setState(() {
              _isButtonDisabled = true;
            });
            _isLiked
                ? Provider.of<FirebaseOperations>(context, listen: false)
                    .removeLike(
                    context,
                    widget.recipeDoc['postId'],
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .getUserId,
                  )
                    .whenComplete(() {
                    setState(() {
                      _isLiked = false;
                      _isButtonDisabled = false;
                    });
                  })
                : Provider.of<FirebaseOperations>(context, listen: false)
                    .addLike(
                    context,
                    widget.recipeDoc['postId'],
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .getUserId,
                  )
                    .whenComplete(() {
                    setState(() {
                      _isLiked = true;
                      _isButtonDisabled = false;
                    });
                    if (_isNotPostOwner) {
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .addLikeToActivityFeed(
                        widget.recipeDoc['authorId'],
                        widget.recipeDoc['postId'],
                        {
                          'type': 'like',
                          'userUID': Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getUserId,
                          'postId': widget.recipeDoc['postId'],
                          'timestamp': Timestamp.now(),
                        },
                      );
                    }
                  });
          };

    return isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () {
                  final args = RecipeDetailsArguments(
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
                  );
                  Navigator.pushNamed(
                    context,
                    AppRoutes.recipeDetails,
                    arguments: args,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: Hero(
                    tag: widget.recipeDoc['mediaUrl'],
                    child: CachedNetworkImage(
                      height: 320.0,
                      width: 320.0,
                      fit: BoxFit.cover,
                      imageUrl: widget.recipeDoc['mediaUrl'],
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                        value: downloadProgress.progress,
                        backgroundColor: Colors.cyanAccent,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.yellow),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: CircleAvatar(
                        radius: 18.0,
                        backgroundColor: kBlue,
                        backgroundImage: CachedNetworkImageProvider(
                            snapshot.data!['photoUrl']),
                      ),
                    ),
                    Flexible(
                      flex: 1,
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
                                final args = AltProfileArguments(
                                  userUID: widget.recipeDoc['authorId'],
                                  authorImage: snapshot.data!['photoUrl'],
                                  authorUsername: snapshot.data!['username'],
                                  authorDisplayName:
                                      snapshot.data!['displayName'],
                                  authorBio: snapshot.data!['bio'],
                                );
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.altProfile,
                                  arguments: args,
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
                          const SizedBox(
                            width: 20.0,
                          ),

                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('recipes')
                                .doc(widget.recipeDoc['postId'])
                                .collection('likes')
                                .doc('like_count')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: SizedBox(
                                    height: 0.0,
                                    width: 0.0,
                                  ),
                                );
                              } else if (snapshot.data!.exists){
                                likeCount = 100;
                                return LikeButton(
                                  size: 30.0,
                                  isLiked: _isLiked,
                                  onTap: (isLiked) async {
                                    _isLiked
                                        ? Provider.of<FirebaseOperations>(
                                                context,
                                                listen: false)
                                            .removeLike(
                                            context,
                                            widget.recipeDoc['postId'],
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .getUserId,
                                          )
                                            .whenComplete(() {
                                            _isLiked = false;
                                          })
                                        : Provider.of<FirebaseOperations>(
                                                context,
                                                listen: false)
                                            .addLike(
                                            context,
                                            widget.recipeDoc['postId'],
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .getUserId,
                                          )
                                            .whenComplete(() {
                                            _isLiked = true;
                                            if (_isNotPostOwner) {
                                              Provider.of<FirebaseOperations>(
                                                      context,
                                                      listen: false)
                                                  .addLikeToActivityFeed(
                                                widget.recipeDoc['authorId'],
                                                widget.recipeDoc['postId'],
                                                {
                                                  'type': 'like',
                                                  'userUID': Provider.of<
                                                              FirebaseOperations>(
                                                          context,
                                                          listen: false)
                                                      .getUserId,
                                                  'postId': widget
                                                      .recipeDoc['postId'],
                                                  'timestamp': Timestamp.now(),
                                                },
                                              );
                                            }
                                          });
                                    _isLiked = !isLiked;
                                    likeCount += _isLiked ? 1 : -1;
                                    return !isLiked;
                                  },
                                  circleColor: const CircleColor(
                                      start: Color(0xffe7218e),
                                      end: Color(0xffef0e0e)),
                                  bubblesColor: const BubblesColor(
                                    dotPrimaryColor: Color(0xffe7218e),
                                    dotSecondaryColor: Color(0xffef0e0e),
                                  ),
                                  likeBuilder: (isLiked) {
                                    return Icon(
                                      Icons.favorite,
                                      color:
                                          isLiked ? Colors.red : Colors.black,
                                      size: 25.0,
                                    );
                                  },
                                  likeCount: likeCount,
                                  countBuilder:
                                      (int? count, bool isLiked, String text) {
                                    var color =
                                        isLiked ? Colors.red : Colors.black;
                                    Widget result;
                                    if (count == 0 || count!.isNaN) {
                                      result = Text(
                                        "like",
                                        style: TextStyle(color: color),
                                      );
                                    } else {
                                      result = Text(
                                        text,
                                        style: TextStyle(color: color),
                                      );
                                    }
                                    return result;
                                  },
                                );
                              }
                              return const Text('Error');
                            },
                          ),

                          // InkWell(
                          //   onTap: _isButtonDisabled
                          //       ? null
                          //       : () {
                          //           setState(() {
                          //             _isButtonDisabled = true;
                          //           });
                          //           _isLiked
                          //               ? Provider.of<FirebaseOperations>(
                          //                       context,
                          //                       listen: false)
                          //                   .removeLike(
                          //                   context,
                          //                   widget.recipeDoc['postId'],
                          //                   Provider.of<FirebaseOperations>(
                          //                           context,
                          //                           listen: false)
                          //                       .getUserId,
                          //                 )
                          //                   .whenComplete(() {
                          //                   setState(() {
                          //                     _isLiked = false;
                          //                     _isButtonDisabled = false;
                          //                   });
                          //                 })
                          //               : Provider.of<FirebaseOperations>(
                          //                       context,
                          //                       listen: false)
                          //                   .addLike(
                          //                   context,
                          //                   widget.recipeDoc['postId'],
                          //                   Provider.of<FirebaseOperations>(
                          //                           context,
                          //                           listen: false)
                          //                       .getUserId,
                          //                 )
                          //                   .whenComplete(() {
                          //                   setState(() {
                          //                     _isLiked = true;
                          //                     _isButtonDisabled = false;
                          //                   });
                          //                   if (_isNotPostOwner) {
                          //                     Provider.of<FirebaseOperations>(
                          //                             context,
                          //                             listen: false)
                          //                         .addLikeToActivityFeed(
                          //                       widget.recipeDoc['authorId'],
                          //                       widget.recipeDoc['postId'],
                          //                       {
                          //                         'type': 'like',
                          //                         'userUID': Provider.of<
                          //                                     FirebaseOperations>(
                          //                                 context,
                          //                                 listen: false)
                          //                             .getUserId,
                          //                         'postId': widget
                          //                             .recipeDoc['postId'],
                          //                         'timestamp': Timestamp.now(),
                          //                       },
                          //                     );
                          //                   }
                          //                 });
                          //         },
                          //   child: FaIcon(
                          //     FontAwesomeIcons.heart,
                          //     color: _isLiked ? Colors.red : Colors.black,
                          //   ),
                          // ),
                          // StreamBuilder<DocumentSnapshot>(
                          //   stream: FirebaseFirestore.instance
                          //       .collection('recipes')
                          //       .doc(widget.recipeDoc['postId'])
                          //       .collection('likes')
                          //       .doc('like_count')
                          //       .snapshots(),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.connectionState ==
                          //         ConnectionState.waiting) {
                          //       return const Center(
                          //         child: Text(''),
                          //       );
                          //     } else {
                          //       return Padding(
                          //         padding: const EdgeInsets.only(left: 4.0),
                          //         child: Text(
                          //           snapshot.data!.exists
                          //               ? NumberFormatter.formatter(snapshot.data!['count'].toString())
                          //               : '0',
                          //           style: const TextStyle(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.normal,
                          //             fontSize: 15.0,
                          //           ),
                          //         ),
                          //       );
                          //     }
                          //   },
                          // ),
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
}
