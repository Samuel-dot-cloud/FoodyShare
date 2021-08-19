import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/viewmodel/loading_animation.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

final commentsRef = FirebaseFirestore.instance.collection('comments');

class CommentsSection extends StatefulWidget {
  const CommentsSection({Key? key, required this.postId})
      : super(key: key);

  final String postId;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();

  displayComments() {
    return StreamBuilder<QuerySnapshot>(
      stream: commentsRef
          .doc(widget.postId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return loadingAnimation('Loading comments...');
        } else if (snapshot.data!.docs.isEmpty) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.30,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.80,
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
          List<Comment> comments = [];
          for (var doc in snapshot.data!.docs) {
            comments.add(Comment.fromDocument(doc));
          }
          return ListView(
            children: comments,
          );
        }
      },
    );
  }

  addComment() {
    commentsRef.doc(widget.postId).collection('comments').add({
      'userUID':
      Provider
          .of<FirebaseOperations>(context, listen: false)
          .getUserId,
      'comment': _commentController.text,
      'timestamp': Timestamp.now(),
    });
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
            onPressed: addComment,
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

class Comment extends StatefulWidget {
  final String userUID;
  final String comment;
  final Timestamp timestamp;

  const Comment({Key? key,
    required this.userUID,
    required this.comment,
    required this.timestamp})
      : super(key: key);

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      comment: doc['comment'],
      userUID: doc['userUID'],
      timestamp: doc['timestamp'],
    );
  }

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {

  @override
  void initState() {
    getAuthorData(context, widget.userUID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('@' + authorUsername),
          leading: CircleAvatar(
            radius: 18.0,
            backgroundColor: kBlue,
            backgroundImage: NetworkImage(authorUserImage),
          ),
          subtitle: Text(widget.comment),
          trailing: Text(timeago.format(widget.timestamp.toDate())),
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
}