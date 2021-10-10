import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/routes/alt_profile_arguments.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

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
                  backgroundImage: CachedNetworkImageProvider(snapshot.data!['photoUrl']),
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