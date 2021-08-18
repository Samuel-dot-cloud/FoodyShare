import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

final commentsRef = FirebaseFirestore.instance.collection('comments');

class CommentsSection extends StatefulWidget {
  const CommentsSection({Key? key, required this.commentsDoc})
      : super(key: key);

  final DocumentSnapshot commentsDoc;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();

  displayComments() {
    return StreamBuilder<QuerySnapshot>(
      stream: commentsRef
          .doc(widget.commentsDoc['postId'])
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        } else if(snapshot.data == null){
          return SizedBox(

          );
        }
        List<Comment> comments = [];
        snapshot.data!.docs.forEach((doc) {
          comments.add(Comment.fromDocument(doc));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  addComment() {
    commentsRef.doc(widget.commentsDoc['postId']).collection('comments').add({
      'userUID':
          Provider.of<FirebaseOperations>(context, listen: false).getUserId,
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
                filled: true, labelText: 'Write a comment...'),
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

class Comment extends StatelessWidget {
  final String userUID;
  final String comment;
  final Timestamp timestamp;

  const Comment(
      {Key? key,
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('@test'),
          leading: const CircleAvatar(
            radius: 15.0,
            backgroundColor: kBlue,
            backgroundImage: NetworkImage(
                'https://thumbor.forbes.com/thumbor/960x0/https%3A%2F%2Fblogs-images.forbes.com%2Finsertcoin%2Ffiles%2F2016%2F01%2Fhorizon-zero-dawn2.jpg'),
          ),
          subtitle: Text(comment),
          trailing: Text(timeago.format(timestamp.toDate())),
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
