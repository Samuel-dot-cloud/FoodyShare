import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/viewmodel/loading_animation.dart';
import 'package:food_share/widgets/activity_feed/activity_feed_item.dart';
import 'package:provider/provider.dart';

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
      body: SizedBox(
        child: StreamBuilder<QuerySnapshot>(
          stream: activityFeedRef
              .doc(Provider.of<FirebaseOperations>(context, listen: false)
                  .getUserId)
              .collection('feedItems')
              .orderBy('timestamp', descending: true)
              .limit(50)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingAnimation('Loading activity feed notifications...');
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 12.0,
                        ),
                        child: ActivityFeedItem(
                          feedDoc: snapshot.data!.docs[index],
                        ),
                      ));
            }
            return const Text('Loading ...');
          },
        ),
      ),
    );
  }
}
