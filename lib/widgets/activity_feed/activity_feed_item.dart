import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/routes/alt_profile_arguments.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/screens/profile/alt_profile.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/activity_feed/media_preview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeedItem extends StatelessWidget {
  ActivityFeedItem({Key? key, required this.feedDoc}) : super(key: key);
  final DocumentSnapshot feedDoc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(feedDoc['userUID'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListTile(
                title: GestureDetector(
                  onTap: () {
                    final args = AltProfileArguments(
                      userUID: feedDoc['userUID'],
                      authorImage: snapshot.data!['photoUrl'],
                      authorUsername: snapshot.data!['username'],
                      authorDisplayName: snapshot.data!['displayName'],
                      authorBio: snapshot.data!['bio'],
                    );
                    Navigator.pushNamed(
                      context,
                      AppRoutes.altProfile,
                      arguments: args,
                    );
                  },
                  child: RichText(
                    overflow: TextOverflow.fade,
                    text: TextSpan(
                      style: GoogleFonts.josefinSans(
                        textStyle: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                      children: [
                        TextSpan(
                          text: '@' + snapshot.data!['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: feedDoc['type'] == 'like'
                              ? ' liked your post.'
                              : ' commented on your post.',
                        ),
                      ],
                    ),
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: kBlue,
                  backgroundImage: NetworkImage(snapshot.data!['photoUrl']),
                ),
                subtitle: Text(
                  timeago.format(
                    feedDoc['timestamp'].toDate(),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: FeedMediaPreview(feedDoc: feedDoc),
              );
            }
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            thickness: 0.5,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
