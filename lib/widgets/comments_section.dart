import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/routes/alt_profile_arguments.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/viewmodel/loading_animation.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

final commentsRef = FirebaseFirestore.instance.collection('comments');

class CommentsSection extends StatefulWidget {
  CommentsSection({Key? key, required this.postId, required this.authorId})
      : super(key: key);

  final String postId;
  final String authorId;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();

  Future addCommentCount() async {
    var doc = await commentsRef
        .doc(widget.postId)
        .collection('count')
        .doc('commentCount')
        .get();

    if (doc.exists) {
      commentsRef
          .doc(widget.postId)
          .collection('count')
          .doc('commentCount')
          .update({
        'count': FieldValue.increment(1),
      });
    } else {
      commentsRef
          .doc(widget.postId)
          .collection('count')
          .doc('commentCount')
          .set({
        'count': FieldValue.increment(1),
      });
    }
  }

  displayComments() {
    return StreamBuilder<QuerySnapshot>(
      stream: commentsRef
          .doc(widget.postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return loadingAnimation('Loading comments...');
        } else if (snapshot.data!.docs.isEmpty) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.30,
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: Lottie.asset('assets/lottie/cooking.json'),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Be the first to leave a comment...',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
          );
        } else {
          return ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) => Comment(
              commentDoc: snapshot.data!.docs[index],
              authorId: widget.authorId,
            ),
          );
        }
      },
    );
  }

  addComment() {
    bool _isNotPostOwner =
        Provider.of<FirebaseOperations>(context, listen: false).getUserId !=
            widget.authorId;
    commentsRef.doc(widget.postId).collection('comments').add({
      'userUID':
          Provider.of<FirebaseOperations>(context, listen: false).getUserId,
      'comment': _commentController.text,
      'timestamp': Timestamp.now(),
    }).whenComplete(() async {
      return addCommentCount();
    });
    if (_isNotPostOwner) {
      Provider.of<FirebaseOperations>(context, listen: false)
          .addCommentToActivityFeed(
        widget.authorId,
        {
          'type': 'comment',
          'postId': widget.postId,
          'userUID':
              Provider.of<FirebaseOperations>(context, listen: false).getUserId,
          'timestamp': Timestamp.now(),
        },
      );
    }
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: displayComments(),
        ),
        const Divider(),
        ListTile(
          title: TextFormField(
            controller: _commentController,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Leave a comment...',
            ),
          ),
          trailing: MaterialButton(
            color: kBlue,
            onPressed: () {
              if (_commentController.text.trim().isEmpty) {
                Fluttertoast.showToast(
                    msg: 'Please enter a valid comment!!',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                addComment();
              }
            },
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Comment extends StatelessWidget {
  final DocumentSnapshot commentDoc;
  final String authorId;

  const Comment({
    Key? key,
    required this.commentDoc,
    required this.authorId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isNotCurrentUser =
        Provider.of<FirebaseOperations>(context, listen: false).getUserId !=
            commentDoc['userUID'];
    bool _isNotAuthor = commentDoc['userUID'] != authorId;
    return Column(
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(commentDoc['userUID'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListTile(
                onTap: () {
                  if (_isNotCurrentUser) {
                    final args = AltProfileArguments(
                      userUID: commentDoc['userUID'],
                      authorImage: snapshot.data!['photoUrl'],
                      authorUsername: snapshot.data!['username'],
                      authorDisplayName: snapshot.data!['displayName'],
                      authorBio: snapshot.data!['bio'],
                    );
                    Navigator.pushNamed(
                      context,
                      AppRoutes.altProfile,
                      arguments: args,
                    );
                  }
                },
                title: _isNotAuthor
                    ? Text(
                        _isNotCurrentUser
                            ? '@' + snapshot.data!['username']
                            : 'You',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Text(
                        _isNotCurrentUser ? 'Author' : 'You(Author)',
                        style: const TextStyle(
                          color: kBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                leading: CircleAvatar(
                  radius: 18.0,
                  backgroundColor: kBlue,
                  backgroundImage: NetworkImage(snapshot.data!['photoUrl']),
                ),
                subtitle: Text(commentDoc['comment']),
                trailing:
                    Text(timeago.format(commentDoc['timestamp'].toDate())),
              );
            }
          },
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
}
