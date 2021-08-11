import 'package:flutter/material.dart';
import 'package:food_share/models/user_model.dart';
import 'package:food_share/utils/pallete.dart';

class UserResult extends StatelessWidget {
  final CustomUser customUser;

  const UserResult({Key? key, required this.customUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(customUser.photoUrl),
              ),
              title: Text(
                customUser.displayName,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '@' + customUser.username,
                style: const TextStyle(
                  color: Colors.black,
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
