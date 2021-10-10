import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_share/models/user_model.dart';
import 'package:food_share/routes/alt_profile_arguments.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/screens/profile/alt_profile.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:provider/provider.dart';

class UserResult extends StatelessWidget {
  final CustomUser customUser;

  const UserResult({Key? key, required this.customUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isNotCurrentUser = customUser.id !=
        Provider.of<FirebaseOperations>(context, listen: false).getUserId;
    return Container(
      color: Colors.white54,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (_isNotCurrentUser) {
                final args = AltProfileArguments(
                  userUID: customUser.id,
                  authorImage: customUser.photoUrl,
                  authorUsername: customUser.username,
                  authorDisplayName: customUser.displayName,
                  authorBio: customUser.bio,
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
                    CachedNetworkImageProvider(customUser.photoUrl),
              ),
              title: Text(
                customUser.displayName,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                _isNotCurrentUser ? '@' + customUser.username : 'You',
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
