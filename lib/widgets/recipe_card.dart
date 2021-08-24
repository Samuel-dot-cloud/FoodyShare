import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/screens/profile/alt_profile.dart';
import 'package:food_share/screens/recipe_details.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    getAuthorData(context, widget.recipeDoc['authorId']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<FirebaseOperations>(context, listen: true)
        .initUserData(context);

    /// Variables for dealing with liking posts
    Map likes = widget.recipeDoc['likes'];
    final String currentUserId =
        Provider.of<FirebaseOperations>(context, listen: false).getUserId;
    bool liked = likes[currentUserId] == true;

    ///Variables for dealing with favorites
    Map favorites = widget.recipeDoc['favorites'];
    bool addedToFavorites = favorites[currentUserId] == true;

    ///Method for handling liking of posts
    handleLikePost() {
      bool _isLiked = likes[currentUserId] == true;
      bool _isNotPostOwner =
          Provider.of<FirebaseOperations>(context, listen: false).getUserId !=
              widget.recipeDoc['authorId'];

      if (_isLiked) {
        recipesRef
            .doc(widget.recipeDoc['postId'])
            .update({'likes.$currentUserId': false});
        if (_isNotPostOwner) {
          Provider.of<FirebaseOperations>(context, listen: false)
              .removeFromActivityFeed(
            widget.recipeDoc['authorId'],
            widget.recipeDoc['postId'],
          );
        }
        setState(() {
          likeCount -= 1;
          liked = false;
          likes[currentUserId] == false;
        });
      } else if (!_isLiked) {
        recipesRef
            .doc(widget.recipeDoc['postId'])
            .update({'likes.$currentUserId': true});
        if (_isNotPostOwner) {
          Provider.of<FirebaseOperations>(context, listen: false)
              .addToActivityFeed(
            widget.recipeDoc['authorId'],
            widget.recipeDoc['postId'],
            {
              'type': 'like',
              'userUID': Provider.of<FirebaseOperations>(context, listen: false)
                  .getUserId,
              'postId': widget.recipeDoc['postId'],
              'timestamp': Timestamp.now(),
            },
          );
        }
        setState(() {
          likeCount += 1;
          liked = true;
          likes[currentUserId] == true;
        });
      }
    }

    ///Method for handling adding posts to favorites
    handleFavoritePost() {
      bool _isFavorite = favorites[currentUserId] == true;
      if (_isFavorite) {
        recipesRef
            .doc(widget.recipeDoc['postId'])
            .update({'favorites.$currentUserId': false});
        setState(() {
          addedToFavorites = false;
          favorites[currentUserId] == false;
        });
      } else if (!_isFavorite) {
        recipesRef
            .doc(widget.recipeDoc['postId'])
            .update({'favorites.$currentUserId': true});
        setState(() {
          addedToFavorites = true;
          favorites[currentUserId] == true;
        });
      }
    }

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
                      likes: widget.recipeDoc['likes'],
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
                    child: Image(
                      height: 320.0,
                      width: 320.0,
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.recipeDoc['mediaUrl']),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20.0,
              right: 40.0,
              child: InkWell(
                onTap: () {
                  handleFavoritePost();
                  setState(() {
                    addedToFavorites = !addedToFavorites;
                  });
                },
                child: FaIcon(
                  !addedToFavorites
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
                  backgroundImage: NetworkImage(authorUserImage),
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
                        if (widget.recipeDoc['authorId'] !=
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .getUserId) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AltProfile(
                                userUID: widget.recipeDoc['authorId'],
                                authorImage: authorUserImage,
                                authorUsername: authorUsername,
                                authorDisplayName: authorDisplayName,
                                authorBio: authorBio,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        '@' + authorUsername,
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

  String authorEmail = '',
      authorUsername = '',
      authorDisplayName = '',
      authorUserImage = '',
      authorBio = '';

  Future getAuthorData(BuildContext context, String authorId) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authorId)
        .get()
        .then((doc) {
      authorUsername = doc.data()!['username'];
      authorDisplayName = doc.data()!['displayName'];
      authorEmail = doc.data()!['email'];
      authorBio = doc.data()!['bio'];
      authorUserImage = doc.data()!['photoUrl'];
    });
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
