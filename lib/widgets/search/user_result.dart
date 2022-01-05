import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/models/user_model.dart';
import 'package:food_share/routes/alt_profile_arguments.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/screens/profile/alt_profile.dart';
import 'package:food_share/services/analytics_service.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/palette.dart';
import 'package:provider/provider.dart';

class UserResult extends StatelessWidget {
  final DocumentSnapshot userDoc;

  const UserResult({Key? key, required this.userDoc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isNotCurrentUser = userDoc['id'] !=
        Provider.of<FirebaseOperations>(context, listen: false).getUserId;
    return Container(
      color: Colors.white54,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (_isNotCurrentUser) {
                Provider.of<AnalyticsService>(context, listen: false)
                    .logViewSearchResults(userDoc['username']);
                final args = AltProfileArguments(
                  userUID: userDoc['id'],
                  authorImage: userDoc['photoUrl'],
                  authorUsername: userDoc['username'],
                  authorDisplayName: userDoc['displayName'],
                  authorBio: userDoc['bio'],
                );
                Navigator.pushNamed(
                  context,
                  AppRoutes.altProfile,
                  arguments: args,
                );
              }
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(userDoc['photoUrl']),
              ),
              title: Text(
                userDoc['displayName'],
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                _isNotCurrentUser ? '@' + userDoc['username'] : 'You',
                style: TextStyle(
                  color: _isNotCurrentUser ? Colors.black : kBlue,
                ),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.grey[500],
          ),
        ],
      ),
    );
  }
}
