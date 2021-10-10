import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/routes/alt_profile_arguments.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/helpers/profile_helper.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/profile/profile_post_image.dart';
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
  double hPadding = 40.0;

  ///Recipe grid view pagination logic
  final usersRef = FirebaseFirestore.instance.collection('users');

  final StreamController<List<DocumentSnapshot>> _recipeGridController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  final List<List<DocumentSnapshot>> _allPagedResults = [<DocumentSnapshot>[]];

  static const int recipeGridLimit = 5;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  Stream<List<DocumentSnapshot>> listenToRecipeGridRealTime() {
    getRecipeGrid();
    return _recipeGridController.stream;
  }

  getRecipeGrid() async {
    final CollectionReference _recipeCollectionReference =
        usersRef.doc(widget.arguments.userUID).collection('recipes');
    var pageRecipeQuery = _recipeCollectionReference
        .orderBy('timestamp', descending: true)
        .limit(recipeGridLimit);

    if (_lastDocument != null) {
      pageRecipeQuery = pageRecipeQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMoreData) {
      Fluttertoast.showToast(
          msg: 'No more recipes to display',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    var currentRequestIndex = _allPagedResults.length;
    pageRecipeQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var generalRecipes = snapshot.docs.toList();

          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = generalRecipes;
          } else {
            _allPagedResults.add(generalRecipes);
          }

          var allRecipes = _allPagedResults.fold<List<DocumentSnapshot>>(
              <DocumentSnapshot>[],
              (initialValue, pageItems) => initialValue..addAll(pageItems));

          _recipeGridController.add(allRecipes);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }

          _hasMoreData = generalRecipes.length == recipeGridLimit;
        }
      },
    );
  }

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
                    image: CachedNetworkImageProvider(
                        widget.arguments.authorImage),
                  ),
                ),
              ),
              Positioned(
                top: 40.0,
                left: 20.0,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: Column(
                      children: [
                        StreamBuilder<List<DocumentSnapshot>>(
                          stream: listenToRecipeGridRealTime(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Provider.of<ProfileHelper>(context,
                                      listen: false)
                                  .defaultNoRecipes(context);
                            } else {
                              return Column(
                                children: [
                                  GridView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: snapshot.data!.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16.0,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3.0),
                                      child: ProfilePostImage(
                                        recipeDoc: snapshot.data![index],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      getRecipeGrid();
                                    },
                                    child: const Text(
                                      'SEE MORE',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
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
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
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
