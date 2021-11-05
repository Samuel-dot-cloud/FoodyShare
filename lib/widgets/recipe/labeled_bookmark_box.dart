import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class LabeledBookmarkBox extends StatefulWidget {
  const LabeledBookmarkBox(
      {Key? key, required this.postID, required this.listDoc})
      : super(key: key);

  final DocumentSnapshot listDoc;
  final String postID;

  @override
  State<LabeledBookmarkBox> createState() => _LabeledBookmarkBoxState();
}

class _LabeledBookmarkBoxState extends State<LabeledBookmarkBox> {
  @override
  void initState() {
    checkIfAddedToList();
    super.initState();
  }

  bool _isBookmarked = false;

  ///Checking if post is already added to favorites
  checkIfAddedToList() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<FirebaseOperations>(context, listen: false).getUserId)
        .collection('favorites')
        .doc(widget.listDoc['id'])
        .collection('bookmarked')
        .doc(widget.postID)
        .get();
    setState(() {
      _isBookmarked = doc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentUserID =
        Provider.of<FirebaseOperations>(context, listen: false).getUserId;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(widget.listDoc['name']),
          ),
          LikeButton(
            size: 25.0,
            isLiked: _isBookmarked,
            circleColor: const CircleColor(
                start: Color(0xff717879), end: Color(0xff010a0c)),
            bubblesColor: const BubblesColor(
              dotPrimaryColor: Color(0xff33393b),
              dotSecondaryColor: Color(0xff00080a),
            ),
            likeBuilder: (bool isLiked) {
              return Icon(
                isLiked
                    ? Icons.bookmark_added_rounded
                    : Icons.bookmark_add_rounded,
                color: isLiked ? Colors.black : Colors.grey,
                size: 20.0,
              );
            },
            onTap: (isSaved) async {
              _isBookmarked
                  ? Provider.of<FirebaseOperations>(context, listen: false)
                      .removeFromFavorites(
                          currentUserID, widget.listDoc['id'], widget.postID)
                      .whenComplete(() {
                      _isBookmarked = false;
                      Fluttertoast.showToast(
                          msg: 'Removed from list',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: kBlue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    })
                  : Provider.of<FirebaseOperations>(context, listen: false)
                      .addToFavorites(
                          currentUserID, widget.listDoc['id'], widget.postID, {
                      'postId': widget.postID,
                      'timestamp': Timestamp.now(),
                    }).whenComplete(() {
                      _isBookmarked = true;
                      Fluttertoast.showToast(
                          msg: 'Added to list.',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: kBlue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    });
              _isBookmarked = !isSaved;
              return !isSaved;
            },
          ),
        ],
      ),
    );
  }
}
