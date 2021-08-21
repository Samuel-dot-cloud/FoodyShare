import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_share/screens/profile/alt_profile.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:provider/provider.dart';

class UserTile extends StatefulWidget {
  const UserTile({Key? key, required this.userDoc}) : super(key: key);

  final DocumentSnapshot userDoc;

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  void initState() {
    getAuthorData(context, widget.userDoc['userUID']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<FirebaseOperations>(context, listen: true)
        .initUserData(context);
    return ListTile(
      onTap: () {
        if (widget.userDoc['userUID'] !=
            Provider.of<FirebaseOperations>(context, listen: false).getUserId) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AltProfile(
                authorUsername: authorUsername,
                authorImage: authorUserImage,
                authorBio: authorBio,
                userUID: widget.userDoc['userUID'],
                authorDisplayName: authorDisplayName,
              ),
            ),
          );
        }
      },
      leading: CircleAvatar(
        backgroundColor: kBlue,
        backgroundImage: NetworkImage(authorUserImage),
      ),
      title: Text(
        authorDisplayName,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      subtitle: Text(
        '@' + authorUsername,
        style: const TextStyle(
          color: Colors.yellow,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
      // trailing: widget.userDoc['userUID'] ==
      //         Provider.of<FirebaseOperations>(context, listen: false).getUserId
      //     ? const SizedBox(
      //         width: 0.0,
      //         height: 0.0,
      //       )
      //     : MaterialButton(
      //         color: kBlue,
      //         onPressed: () {},
      //         child: const Text(
      //           'Unfollow',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),
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
