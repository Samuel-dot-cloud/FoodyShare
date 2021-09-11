import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/routes/alt_profile_arguments.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/helpers/profile_helper.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AltProfile extends StatefulWidget {
  final AltProfileArguments arguments;

  const AltProfile({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  _AltProfileState createState() => _AltProfileState();
}

class _AltProfileState extends State<AltProfile> {
  late bool _isButtonDisabled;
  int itemsNumber = 10;
  double hPadding = 40.0;

  @override
  void initState() {
    checkIfFollowing();
    _isButtonDisabled = false;
    super.initState();
  }

  bool _isFollowing = false;

  checkIfFollowing() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(
          widget.arguments.userUID,
        )
        .collection('followers')
        .doc(
          Provider.of<FirebaseOperations>(context, listen: false).getUserId,
        )
        .get();
    setState(() {
      _isFollowing = doc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SlidingUpPanel(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        minHeight: size.height * 0.36,
        maxHeight: size.height * 0.75,
        parallaxEnabled: true,
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Hero(
                  tag: widget.arguments.authorImage,
                  child: Image(
                    height: (size.height / 2) + 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.arguments.authorImage),
                  ),
                ),
              ),
              Positioned(
                top: 40.0,
                left: 20.0,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        panel: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Provider.of<ProfileHelper>(context, listen: false)
                      .titleSection(
                          widget.arguments.authorDisplayName,
                          widget.arguments.authorUsername,
                          widget.arguments.authorBio),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Provider.of<ProfileHelper>(context, listen: false)
                      .infoSection(context, widget.arguments.userUID),
                  const SizedBox(
                    height: 12.0,
                  ),
                  _actionSection(hPadding: hPadding),
                ],
              ),
            ),

            ///Post Gridview
            Expanded(
              child: SingleChildScrollView(
                child: Provider.of<ProfileHelper>(context, listen: false)
                    .userRecipeGridViewPosts(
                        context, widget.arguments.userUID, itemsNumber),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Action section
  Container _actionSection({required double hPadding}) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: _isButtonDisabled
              ? null
              : () {
                  setState(() {
                    _isButtonDisabled = true;
                  });
                  _isFollowing
                      ? Provider.of<FirebaseOperations>(context, listen: false)
                          .unfollowUser(
                          widget.arguments.userUID,
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getUserId,
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .getUserId,
                          widget.arguments.userUID,
                        )
                          .whenComplete(() {
                          followNotification(context,
                              'Unfollowed @' + widget.arguments.authorUsername);
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .removeFollowFromActivityFeed(
                            widget.arguments.userUID,
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .getUserId,
                          );
                          setState(() {
                            _isFollowing = false;
                            _isButtonDisabled = false;
                          });
                        })
                      : Provider.of<FirebaseOperations>(context, listen: false)
                          .followUser(
                              widget.arguments.userUID,
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .getUserId,
                              {
                                'userUID': Provider.of<FirebaseOperations>(
                                        context,
                                        listen: false)
                                    .getUserId,
                                'timestamp': Timestamp.now(),
                              },
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .getUserId,
                              widget.arguments.userUID,
                              {
                                'userUID': widget.arguments.userUID,
                                'timestamp': Timestamp.now(),
                              })
                          .whenComplete(() {
                          followNotification(context,
                              'Followed @' + widget.arguments.authorUsername);
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .addFollowToActivityFeed(
                            widget.arguments.userUID,
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .getUserId,
                            {
                              'profileId': widget.arguments.userUID,
                              'userUID': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getUserId,
                              'timestamp': Timestamp.now(),
                            },
                          );
                          setState(() {
                            _isFollowing = true;
                            _isButtonDisabled = false;
                          });
                        });
                },
          child: Text(
            _isFollowing ? 'UNFOLLOW' : 'FOLLOW',
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(
                _isFollowing ? Colors.red : kBlue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(color: _isFollowing ? Colors.red : kBlue),
              ),
            ),
          ),
        ),
      ),
    );
  }

  followNotification(BuildContext context, String text) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
          );
        });
  }
}
