import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/widgets/user_tile.dart';

class ProfileHelper with ChangeNotifier {
  checkFollowingSheet(BuildContext context, String userId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.4,
            width: MediaQuery
                .of(context)
                .size
                .width,
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
                  return snapshot.data!.docs.isNotEmpty ? ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) =>
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: UserTile(
                              userDoc: snapshot.data!.docs[index],),
                          )) : _defaultNoAssociation();
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
            height: MediaQuery
                .of(context)
                .size
                .height * 0.4,
            width: MediaQuery
                .of(context)
                .size
                .width,
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
                  return snapshot.data!.docs.isNotEmpty ? ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) =>
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 10.0,
                            ),
                            child: UserTile(
                              userDoc: snapshot.data!.docs[index],),
                          )) : _defaultNoAssociation();
                }
              },
            ),
          );
        });
  }

  Center _defaultNoAssociation() {
    return const Center(
      child: Text(
        'No associates yet...',
        style: TextStyle(
          color: Colors.black,
          fontSize: 23.0,
          fontWeight: FontWeight.w600,
        ),
      )
    );
  }
}

