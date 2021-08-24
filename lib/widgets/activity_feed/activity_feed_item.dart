import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/screens/profile/alt_profile.dart';
import 'package:food_share/screens/recipe_details.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget? mediaPreview;
String activityItemText = '';

class ActivityFeedItem extends StatelessWidget {
  ActivityFeedItem({Key? key, required this.feedDoc}) : super(key: key);
  final DocumentSnapshot feedDoc;

  configureMediaPreview(BuildContext context) {
    String type = feedDoc['type'];
    if (type == 'like' || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetails(
              preparation: preparation,
              recipeTimestamp: timestamp,
              ingredients: ingredients,
              description: description,
              cookingTime: cookingTime,
              authorUserUID: authorId,
              postID: feedDoc['postId'],
              recipeName: title,
              recipeImage: mediaUrl,
              servings: servings,
              likes: likes,
            ),
          ),
        ),
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(mediaUrl),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = const Text('');
    }
    if (type == 'like') {
      activityItemText = 'liked your post';
    } else if (type == 'follow') {
      activityItemText = 'started following you';
    } else if (type == 'comment') {
      activityItemText = 'commented on your post';
    } else {
      activityItemText = "Error: Unknown type '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    getAuthorData(context, feedDoc['userUID']);
    getRecipeDetails(context, feedDoc['postId']);
    Provider.of<FirebaseOperations>(context, listen: true)
        .initUserData(context);
    return Column(
      children: [
        ListTile(
          title: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AltProfile(
                  userUID: feedDoc['userUID'],
                  authorImage: authorUserImage,
                  authorUsername: authorUsername,
                  authorDisplayName: authorDisplayName,
                  authorBio: authorBio,
                ),
              ),
            ),
            child: RichText(
              overflow: TextOverflow.fade,
              text: TextSpan(
                style: GoogleFonts.josefinSans(
                  textStyle: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                children: [
                  TextSpan(
                    text: '@' + authorUsername,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' $activityItemText',
                  ),
                ],
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: kBlue,
            backgroundImage: NetworkImage(authorUserImage),
          ),
          subtitle: Text(
            timeago.format(
              feedDoc['timestamp'].toDate(),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            thickness: 0.5,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  ///User variables
  String authorEmail = '',
      authorUsername = '',
      authorDisplayName = '',
      authorUserImage = '',
      authorBio = '';

  /// Method for retrieving specific user details
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

  /// Recipe variables
  String id = '',
      authorId = '',
      title = '',
      description = '',
      cookingTime = '',
      servings = '',
      mediaUrl = '';

  Map likes = {};

  List preparation = [], ingredients = [];

  Timestamp timestamp = Timestamp.now();

  /// Method for retrieving specific recipe details
  Future getRecipeDetails(BuildContext context, String recipeId) async {
    return FirebaseFirestore.instance
        .collection('recipes')
        .doc(recipeId)
        .get()
        .then((doc) {
      id = doc.data()!['postId'];
      authorId = doc.data()!['authorId'];
      title = doc.data()!['name'];
      description = doc.data()!['description'];
      cookingTime = doc.data()!['cookingTime'];
      servings = doc.data()!['servings'];
      mediaUrl = doc.data()!['mediaUrl'];
      likes = doc.data()!['likes'];
      preparation = doc.data()!['preparation'];
      timestamp = doc.data()!['timestamp'];
      ingredients = doc.data()!['ingredients'];
      // t = doc.data()!['timestamp'];
    });
  }
}
