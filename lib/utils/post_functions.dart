import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:provider/provider.dart';

class PostFunctions with ChangeNotifier {
  final TextEditingController _commentController = TextEditingController();

  Future addLike(BuildContext context, String postId, subDocId) async {
    final String currentUserId = Provider.of<FirebaseOperations>(context, listen: false).getUserId;
    return FirebaseFirestore.instance
        .collection('recipes')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username':
          Provider.of<FirebaseOperations>(context, listen: false).getUsername,
      'userUID':
          Provider.of<FirebaseOperations>(context, listen: false).getUserId,
      'time': Timestamp.now()
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('recipes')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username':
          Provider.of<FirebaseOperations>(context, listen: false).getUsername,
      'userUID':
          Provider.of<FirebaseOperations>(context, listen: false).getUserId,
      'time': Timestamp.now()
    });
  }

  showCommentsSection(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.70,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 150.0),
            //   child: Divider(
            //     thickness: 4.0,
            //     color: Colors.grey,
            //   ),
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey),
            //     borderRadius: BorderRadius.circular(5.0),
            //   ),
            //   child: const Center(
            //     child: Text(
            //       'Comments',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 16.0,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              height: MediaQuery.of(context).size.height * 0.43,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('recipes')
                    .doc(docId)
                    .collection('comments')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.cyanAccent,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.yellow),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error...');
                  } else {
                    return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot documentSnapshot) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.11,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  child: CircleAvatar(
                                    backgroundColor: kBlue,
                                    radius: 15.0,
                                    backgroundImage: NetworkImage(
                                        documentSnapshot['userUID']),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            documentSnapshot['comment'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          FontAwesomeIcons.arrowUp,
                                          color: kBlue,
                                        ),
                                        onPressed: () {},
                                      ),
                                      const Text(
                                        '0',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          FontAwesomeIcons.reply,
                                          color: Colors.yellow,
                                        ),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          FontAwesomeIcons.trashAlt,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: kBlue,
                                      size: 12.0,
                                    ),
                                    onPressed: () {},
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      documentSnapshot['comment'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                      );
                    }).toList());
                  }
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.70,
                    height: 20.0,
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Add comment...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      controller: _commentController,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: kBlue,
                    child: const Icon(
                      FontAwesomeIcons.comment,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      addComment(
                          context, snapshot['postId'], _commentController.text);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }
}
