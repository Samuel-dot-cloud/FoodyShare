import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/recipe/comment.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../refresh_widget.dart';

final commentsRef = FirebaseFirestore.instance.collection('comments');

class CommentsSection extends StatefulWidget {
  const CommentsSection(
      {Key? key, required this.postId, required this.authorId})
      : super(key: key);

  final String postId;
  final String authorId;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();

  ///Comments pagination logic

  final StreamController<List<DocumentSnapshot>> _commentsController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  final List<List<DocumentSnapshot>> _allPagedResults = [<DocumentSnapshot>[]];

  static const int commentLimit = 10;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  Stream<List<DocumentSnapshot>> listenToCommentsRealTime() {
    _getComments();
    return _commentsController.stream;
  }

  _getComments() async {
    final CollectionReference _commentCollectionReference =
        commentsRef.doc(widget.postId).collection('comments');
    var pageCommentQuery = _commentCollectionReference
        .orderBy('timestamp', descending: true)
        .limit(commentLimit);

    if (_lastDocument != null) {
      pageCommentQuery = pageCommentQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMoreData) {
      Fluttertoast.showToast(
          msg: 'No more comments to display',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    var currentRequestIndex = _allPagedResults.length;
    pageCommentQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var generalComments = snapshot.docs.toList();

          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = generalComments;
          } else {
            _allPagedResults.add(generalComments);
          }

          var allComments = _allPagedResults.fold<List<DocumentSnapshot>>(
              <DocumentSnapshot>[],
              (initialValue, pageItems) => initialValue..addAll(pageItems));

          _commentsController.add(allComments);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }

          _hasMoreData = generalComments.length == commentLimit;
        }
      },
    );
  }

  Future _addCommentCount() async {
    var doc = await commentsRef
        .doc(widget.postId)
        .collection('count')
        .doc('commentCount')
        .get();

    if (doc.exists) {
      commentsRef
          .doc(widget.postId)
          .collection('count')
          .doc('commentCount')
          .update({
        'count': FieldValue.increment(1),
      });
    } else {
      commentsRef
          .doc(widget.postId)
          .collection('count')
          .doc('commentCount')
          .set({
        'count': FieldValue.increment(1),
      });
    }
  }

  _displayComments() {
    return RefreshWidget(
      onRefresh: () async {
        _allPagedResults.clear();
        _lastDocument = null;
        await _getComments();
      },
      child: SingleChildScrollView(
        child: StreamBuilder<List<DocumentSnapshot>>(
          stream: listenToCommentsRealTime(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return _defaultNoComment();
            } else {
              return Column(
                children: [
                  ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) => Comment(
                      commentDoc: snapshot.data![index],
                      authorId: widget.authorId,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _getComments();
                    },
                    child: const Text(
                      'SEE MORE',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(color: kBlue),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  _addComment() {
    bool _isNotPostOwner =
        Provider.of<FirebaseOperations>(context, listen: false).getUserId !=
            widget.authorId;
    commentsRef.doc(widget.postId).collection('comments').add({
      'userUID':
          Provider.of<FirebaseOperations>(context, listen: false).getUserId,
      'comment': _commentController.text,
      'timestamp': Timestamp.now(),
    }).whenComplete(() async {
      return _addCommentCount();
    });
    if (_isNotPostOwner) {
      Provider.of<FirebaseOperations>(context, listen: false)
          .addCommentToActivityFeed(
        widget.authorId,
        {
          'type': 'comment',
          'postId': widget.postId,
          'userUID':
              Provider.of<FirebaseOperations>(context, listen: false).getUserId,
          'timestamp': Timestamp.now(),
        },
      );
    }
    _commentController.clear();
  }

  SingleChildScrollView _defaultNoComment() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width * 0.80,
            child: Lottie.asset('assets/lottie/no-comment.json'),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            'Be the first to leave a comment...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _displayComments(),
        ),
        const Divider(),
        ListTile(
          title: TextFormField(
            controller: _commentController,
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Leave a comment...',
            ),
          ),
          trailing: MaterialButton(
            color: kBlue,
            onPressed: () {
              if (_commentController.text.trim().isEmpty) {
                Fluttertoast.showToast(
                    msg: 'Please enter a valid comment!',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                _addComment();
              }
            },
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
