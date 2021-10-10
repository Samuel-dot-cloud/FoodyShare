import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_share/routes/alt_profile_arguments.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:provider/provider.dart';

class UserTile extends StatelessWidget {
  const UserTile({Key? key, required this.userDoc}) : super(key: key);

  final DocumentSnapshot userDoc;

  @override
  Widget build(BuildContext context) {
    bool _isNotProfileOwner = userDoc['userUID'] !=
        Provider.of<FirebaseOperations>(context, listen: false).getUserId;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc['userUID'])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListTile(
            onTap: () {
              if (_isNotProfileOwner) {
                final args = AltProfileArguments(
                  userUID: userDoc['userUID'],
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
            leading: CircleAvatar(
              backgroundColor: kBlue,
              backgroundImage: CachedNetworkImageProvider(snapshot.data!['photoUrl']),
            ),
            title: Text(
              snapshot.data!['displayName'],
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            subtitle: Text(
              _isNotProfileOwner ? '@' + snapshot.data!['username'] : 'You',
              style: TextStyle(
                color: _isNotProfileOwner ? Colors.yellow : kBlue,
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
              ),
            ),
          );
        }
      },
    );
  }
}
