import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_share/utils/pallete.dart';

class ProfileHelper with ChangeNotifier {
  checkFollowingSheet(BuildContext context, String userId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('following')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                      scrollDirection: Axis.vertical,
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        getAuthorData(documentSnapshot['userUID']);
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListTile(
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
                          );
                        }
                      }).toList());
                }
              },
            ),
          );
        });
  }

  checkFollowerSheet(BuildContext context, String userId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('followers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 12.0,
                            ),
                            child: userTile(snapshot.data!.docs[index]['userUID']),
                          ));
                }
              },
            ),
          );
        });
  }

  Widget userTile(String doc) {
    getAuthorData(doc);
    return ListTile(
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
    );
  }

  String authorEmail = '',
      authorUsername = '',
      authorDisplayName = '',
      authorUserImage = '',
      authorBio = '';

  Future getAuthorData(String authorId) async {
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
