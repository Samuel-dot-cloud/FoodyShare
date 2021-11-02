
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/activity_feed/follow_feed_section.dart';
import 'package:food_share/widgets/activity_feed/like_and_comment_feed_section.dart';
import 'package:lottie/lottie.dart';
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
    return SafeArea(
        child: DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            'Activity Feed',
            style: kBodyText.copyWith(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TabBar(
                tabs: [
                  Tab(
                    text: 'Likes & Comments'.toUpperCase(),
                  ),
                  Tab(
                    text: 'Follows'.toUpperCase(),
                  ),
                ],
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
            const Expanded(
              child: TabBarView(
                children: [
                  ///Likes and comments activity feed

                  LikeAndCommentFeedSection(),

                  ///Followers activity feed
                  FollowFeedSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  defaultNoNotification(String text) {
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
