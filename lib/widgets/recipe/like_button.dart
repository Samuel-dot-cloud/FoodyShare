import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/number_formatter.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class CustomLikeButton extends StatelessWidget {
  CustomLikeButton(
      {Key? key,
      required this.postID,
      required this.isPostLiked,
      required this.isNotPostOwner,
      required this.authorID,
      required this.likeCount})
      : super(key: key);

  final String postID;
  final String authorID;
  bool isPostLiked;
  final bool isNotPostOwner;
  int likeCount;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('recipes')
          .doc(postID)
          .collection('likes')
          .doc('like_count')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return LikeButton(
            size: 20.0,
            isLiked: isPostLiked,
            likeCountPadding: const EdgeInsets.only(
              left: 3.0,
            ),
            onTap: (isLiked) async {
              isPostLiked
                  ? Provider.of<FirebaseOperations>(context, listen: false)
                      .removeLike(
                      context,
                      postID,
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .getUserId,
                    )
                      .whenComplete(() {
                      isPostLiked = false;
                    })
                  : Provider.of<FirebaseOperations>(context, listen: false)
                      .addLike(
                      context,
                      postID,
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .getUserId,
                    )
                      .whenComplete(() {
                      isPostLiked = true;
                      if (isNotPostOwner) {
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .addLikeToActivityFeed(
                          authorID,
                          postID,
                          {
                            'type': 'like',
                            'userUID': Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .getUserId,
                            'postId': postID,
                            'timestamp': Timestamp.now(),
                          },
                        );
                      }
                    });
              isPostLiked = !isLiked;
              likeCount += isPostLiked ? 1 : -1;
              return !isLiked;
            },
            circleColor: const CircleColor(
                start: Color(0xffe7218e), end: Color(0xffef0e0e)),
            bubblesColor: const BubblesColor(
              dotPrimaryColor: Color(0xffe7218e),
              dotSecondaryColor: Color(0xffef0e0e),
            ),
            likeBuilder: (isLiked) {
              return Icon(
                Icons.favorite,
                color: isLiked ? Colors.red : Colors.grey,
                size: 22.0,
              );
            },
            likeCount: snapshot.data!.exists ? snapshot.data!['count'] : 0,
            countBuilder: (int? count, bool isLiked, String text) {
              var color = isLiked ? Colors.red : Colors.grey;
              Widget result;
              if (count == 0) {
                result = Text(
                  "like",
                  style: TextStyle(color: color),
                );
              } else {
                result = Text(
                  NumberFormatter.formatter(text),
                  style: TextStyle(color: color),
                );
              }
              return result;
            },
          );
        }
      },
    );
  }
}
