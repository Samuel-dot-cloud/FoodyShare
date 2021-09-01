import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/services/screens/profile_helper.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/viewmodel/loading_animation.dart';
import 'package:food_share/widgets/profile_post_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AltProfile extends StatefulWidget {
  const AltProfile(
      {Key? key,
      required this.userUID,
      required this.authorDisplayName,
      required this.authorUsername,
      required this.authorBio,
      required this.authorImage})
      : super(key: key);

  final String userUID,
      authorDisplayName,
      authorUsername,
      authorBio,
      authorImage;

  @override
  _AltProfileState createState() => _AltProfileState();
}

class _AltProfileState extends State<AltProfile> {
  late bool _isButtonDisabled;

  @override
  void initState() {
    checkIfFollowing();
    _isButtonDisabled = false;
    super.initState();
  }

  bool _isOpen = false;
  bool _isFollowing = false;
  final PanelController _panelController = PanelController();

  checkIfFollowing() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(
          widget.userUID,
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.authorImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.3,
            child: Container(
              color: Colors.white,
            ),
          ),

          /// Sliding panel
          SlidingUpPanel(
            controller: _panelController,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
            minHeight: size.height * 0.35,
            maxHeight: size.height * 0.75,
            body: GestureDetector(
              onTap: () => _panelController.close(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            panelBuilder: (ScrollController controller) =>
                _panelBody(controller),
            onPanelSlide: (value) {
              if (value >= 0.2) {
                if (!_isOpen) {
                  setState(() {
                    _isOpen = true;
                  });
                }
              }
            },
            onPanelClosed: () {
              setState(() {
                _isOpen = false;
              });
            },
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
    );
  }

  ///Panel body
  SingleChildScrollView _panelBody(ScrollController controller) {
    double hPadding = 40.0;

    return SingleChildScrollView(
      controller: controller,
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _titleSection(),
                _infoSection(),
                _actionSection(hPadding: hPadding),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.userUID)
                    .collection('recipes')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loadingAnimation('Loading user posts');
                  } else {
                    return snapshot.data!.docs.isNotEmpty
                        ? GridView.builder(
                            primary: false,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: snapshot.data!.docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 16.0,
                            ),
                            itemBuilder: (BuildContext context, int index) =>
                                Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              child: ProfilePostImage(
                                recipeDoc: snapshot.data!.docs[index],
                              ),
                            ),
                          )
                        : _defaultNoRecipes();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Action section
  Row _actionSection({required double hPadding}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: !_isOpen,
          child: Expanded(
            child: OutlinedButton(
              onPressed: () => _panelController.open(),
              child: const Text(
                'VIEW PROFILE',
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
          ),
        ),
        Visibility(
          visible: !_isOpen,
          child: const SizedBox(
            width: 16.0,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: _isOpen
                  ? (MediaQuery.of(context).size.width - (2 * hPadding)) / 1.6
                  : double.infinity,
              child: TextButton(
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                        setState(() {
                          _isButtonDisabled = true;
                        });
                        _isFollowing
                            ? Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .unfollowUser(
                                widget.userUID,
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .getUserId,
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .getUserId,
                                widget.userUID,
                              )
                                .whenComplete(() {
                                followNotification(context,
                                    'Unfollowed @' + widget.authorUsername);
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .removeFollowFromActivityFeed(
                                  widget.userUID,
                                  Provider.of<FirebaseOperations>(context,
                                          listen: false)
                                      .getUserId,
                                );
                                setState(() {
                                  _isFollowing = false;
                                  _isButtonDisabled = false;
                                });
                              })
                            : Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .followUser(
                                    widget.userUID,
                                    Provider.of<FirebaseOperations>(context,
                                            listen: false)
                                        .getUserId,
                                    {
                                      'userUID':
                                          Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false)
                                              .getUserId,
                                      'timestamp': Timestamp.now(),
                                    },
                                    Provider.of<FirebaseOperations>(context,
                                            listen: false)
                                        .getUserId,
                                    widget.userUID,
                                    {
                                      'userUID': widget.userUID,
                                      'timestamp': Timestamp.now(),
                                    })
                                .whenComplete(() {
                                followNotification(context,
                                    'Followed @' + widget.authorUsername);
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .addFollowToActivityFeed(
                                  widget.userUID,
                                  Provider.of<FirebaseOperations>(context,
                                          listen: false)
                                      .getUserId,
                                  {
                                    'profileId': widget.userUID,
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
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      _isFollowing ? Colors.red : kBlue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side:
                          BorderSide(color: _isFollowing ? Colors.red : kBlue),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Info section
  Row _infoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.userUID)
                .collection('counts')
                .doc('recipeCount')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return _infoCell(
                  title: 'Posts',
                  value: snapshot.data!.exists
                      ? snapshot.data!['count'].toString()
                      : '0',
                );
              }
            },
          ),
        ),
        Container(
          width: 1.5,
          height: 40.0,
          color: Colors.grey,
        ),
        GestureDetector(
          onTap: () {
            Provider.of<ProfileHelper>(context, listen: false)
                .checkFollowerSheet(context, widget.userUID);
          },
          child: SizedBox(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userUID)
                  .collection('counts')
                  .doc('followerCount')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return _infoCell(
                    title: 'Followers',
                    value: snapshot.data!.exists
                        ? snapshot.data!['count'].toString()
                        : '0',
                  );
                }
              },
            ),
          ),
        ),
        Container(
          width: 1.5,
          height: 40.0,
          color: Colors.grey,
        ),
        GestureDetector(
          onTap: () {
            Provider.of<ProfileHelper>(context, listen: false)
                .checkFollowingSheet(context, widget.userUID);
          },
          child: SizedBox(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userUID)
                  .collection('counts')
                  .doc('followingCount')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return _infoCell(
                    title: 'Following',
                    value: snapshot.data!.exists
                        ? snapshot.data!['count'].toString()
                        : '0',
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Info cell
  Column _infoCell({required String title, required String value}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  ///Title section
  Column _titleSection() {
    return Column(
      children: [
        Text(
          widget.authorDisplayName,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 27.0,
          ),
        ),
        const SizedBox(
          height: 1.0,
        ),
        Text(
          '@' + widget.authorUsername,
          style: const TextStyle(
            fontStyle: FontStyle.normal,
            fontSize: 22.0,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 3.0,
        ),
        Text(
          "\"" + widget.authorBio + "\"",
          style: GoogleFonts.robotoMono(
            textStyle: const TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w300,
              fontSize: 15.0,
            ),
          ),
        ),
      ],
    );
  }

  Center _defaultNoRecipes() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width * 0.80,
            child: Lottie.asset('assets/lottie/no-post.json'),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            'No Recipes Here...',
            style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          )
        ],
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
