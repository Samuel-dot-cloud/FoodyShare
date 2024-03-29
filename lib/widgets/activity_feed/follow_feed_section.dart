import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/helpers/activity_feed_helper.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/utils/palette.dart';
import 'package:provider/provider.dart';

import '../refresh_widget.dart';
import 'follow_feed_item.dart';

class FollowFeedSection extends StatefulWidget {
  const FollowFeedSection({Key? key}) : super(key: key);

  static const int _feedLimit = 10;

  @override
  _FollowFeedSectionState createState() => _FollowFeedSectionState();
}

class _FollowFeedSectionState extends State<FollowFeedSection>
    with AutomaticKeepAliveClientMixin<FollowFeedSection> {
  final _activityFeedRef = FirebaseFirestore.instance.collection('feed');

  ///Follow Feed pagination logic

  final StreamController<List<DocumentSnapshot>> _feedController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  final List<List<DocumentSnapshot>> _allPagedResults = [<DocumentSnapshot>[]];

  DocumentSnapshot? _lastDocument;

  // bool _hasMoreData = true;

  Stream<List<DocumentSnapshot>> listenToFeedRealTime() {
    _getFeed();
    return _feedController.stream;
  }

  _getFeed() async {
    final CollectionReference _activityCollectionReference = _activityFeedRef
        .doc(Provider.of<FirebaseOperations>(context, listen: false).getUserId)
        .collection('feedItems')
        .doc('userNotifications')
        .collection('followActivity');
    var pageFeedQuery = _activityCollectionReference
        .orderBy('timestamp', descending: true)
        .limit(FollowFeedSection._feedLimit);

    if (_lastDocument != null) {
      pageFeedQuery = pageFeedQuery.startAfterDocument(_lastDocument!);
    }

    // if (!_hasMoreData) {
    //   Fluttertoast.showToast(
    //       msg: 'No more follow feed items to display',
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.blueAccent,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }

    var currentRequestIndex = _allPagedResults.length;
    pageFeedQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var generalFeeds = snapshot.docs.toList();

          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = generalFeeds;
          } else {
            _allPagedResults.add(generalFeeds);
          }

          var allFeed = _allPagedResults.fold<List<DocumentSnapshot>>(
              <DocumentSnapshot>[],
              (initialValue, pageItems) => initialValue..addAll(pageItems));

          _feedController.add(allFeed);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }

          // _hasMoreData = generalFeeds.length == FollowFeedSection._feedLimit;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshWidget(
      onRefresh: () async {
        _allPagedResults.clear();
        _lastDocument = null;
        await _getFeed();
      },
      child: SingleChildScrollView(
        child: SizedBox(
          child: StreamBuilder<List<DocumentSnapshot>>(
            stream: listenToFeedRealTime(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Provider.of<ActivityFeedHelper>(context, listen: false)
                    .defaultNoNotification(
                        context, 'No follow feed items to display..');
              }
              if (snapshot.hasData) {
                return Column(
                  children: [
                    ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 12.0,
                        ),
                        child: FollowFeedItem(
                          feedDoc: snapshot.data![index],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    OutlinedButton(
                      onPressed: () {
                        _getFeed();
                      },
                      child: const Text(
                        'SEE MORE',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
              return const Text('Error...');
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
