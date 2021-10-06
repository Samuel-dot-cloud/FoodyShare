import 'package:flutter/material.dart';
import 'package:food_share/widgets/create/hashtag_field.dart';

class HashtagResult extends StatelessWidget {
  const HashtagResult({Key? key, required this.hashtag}) : super(key: key);

  final Hashtag hashtag;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white54,
      // child: Column(
      //   children: [
      //     GestureDetector(
      //       onTap: () {
      //       },
      //       child: ListTile(
      //         leading: CircleAvatar(
      //           backgroundImage: NetworkImage(customUser.photoUrl),
      //         ),
      //         title: Text(
      //           customUser.displayName,
      //           style: const TextStyle(
      //             color: Colors.black,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         subtitle: Text(
      //           _isNotCurrentUser ? '@' + customUser.username : 'You',
      //           style: const TextStyle(
      //             color: Colors.black,
      //           ),
      //         ),
      //       ),
      //     ),
      //     Divider(
      //       height: 2.0,
      //       color: Colors.grey[500],
      //     ),
      //   ],
      // ),
    );
  }
}
