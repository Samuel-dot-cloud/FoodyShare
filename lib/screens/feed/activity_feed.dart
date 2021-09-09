import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/widgets/activity_feed/activity_feed_item.dart';
import 'package:food_share/widgets/activity_feed/follow_feed_item.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

final activityFeedRef = FirebaseFirestore.instance.collection('feed');

class ActivityFeed extends StatefulWidget {
  const ActivityFeed({Key? key}) : super(key: key);

  @override
  State<ActivityFeed> createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Activity Feed',
          style: kBodyText.copyWith(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            children: [
              Material(
                child: TabBar(
                  tabs: [
                    Tab(
                      text: 'Likes & Comments'.toUpperCase(),
                    ),
                    Tab(
                      text: 'Follows'.toUpperCase(),
                    ),
                  ],
                  labelColor: Colors.black,
                  indicator: MaterialIndicator(
                    height: 5.0,
                    topLeftRadius: 8.0,
                    topRightRadius: 8.0,
                    color: Colors.black,
                    horizontalPadding: 50,
                    tabPosition: TabPosition.bottom,
                  ),
                  unselectedLabelColor: Colors.black.withOpacity(0.3),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0,
                  ),
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: 2.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ///Likes and comments activity feed
                    SizedBox(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: activityFeedRef
                            .doc(Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .getUserId)
                            .collection('feedItems')
                            .doc('userNotifications')
                            .collection('postActivity')
                            .orderBy('timestamp', descending: true)
                            .limit(10)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Error');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return loadingAnimation(
                                'Loading comments & likes...');
                          }
                          if (snapshot.hasData) {
                            return snapshot.data!.docs.isNotEmpty
                                ? ListView.builder(
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (BuildContext context,
                                            int index) =>
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 12.0,
                                          ),
                                          child: ActivityFeedItem(
                                            feedDoc: snapshot.data!.docs[index],
                                          ),
                                        ))
                                : _defaultNoNotification('Nothing happening here so far...');
                          }
                          return const Text('Error ...');
                        },
                      ),
                    ),

                    ///Followers activity feed
                    SizedBox(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: activityFeedRef
                            .doc(Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .getUserId)
                            .collection('feedItems')
                            .doc('userNotifications')
                            .collection('followActivity')
                            .orderBy('timestamp', descending: true)
                            .limit(10)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Error');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return loadingAnimation('Loading follows...');
                          }
                          if (snapshot.hasData) {
                            return snapshot.data!.docs.isNotEmpty
                                ? ListView.builder(
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (BuildContext context,
                                            int index) =>
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 12.0,
                                          ),
                                          child: FollowFeedItem(
                                            feedDoc: snapshot.data!.docs[index],
                                          ),
                                        ),)
                                : _defaultNoNotification('No follow notifications yet...');
                          }
                          return const Text('Error...');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _defaultNoNotification(String text) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width * 0.80,
              child: Lottie.asset('assets/lottie/no-feed.json'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 23.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
