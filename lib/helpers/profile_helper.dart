import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/helpers/recipe_detail_helper.dart';
import 'package:food_share/utils/number_formatter.dart';
import 'package:food_share/utils/palette.dart';
import 'package:food_share/utils/profile_util.dart';
import 'package:food_share/widgets/profile/user_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../services/firebase_operations.dart';

class ProfileHelper with ChangeNotifier {
  checkFollowingSheet(BuildContext context, String userId) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          ),
        ),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('following')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return snapshot.data!.docs.isNotEmpty
                      ? ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 10.0,
                                ),
                                child: UserTile(
                                  userDoc: snapshot.data!.docs[index],
                                ),
                              ))
                      : _defaultNoAssociation();
                }
              },
            ),
          );
        });
  }

  checkFollowerSheet(BuildContext context, String userId) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          ),
        ),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('followers')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return snapshot.data!.docs.isNotEmpty
                      ? ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 10.0,
                                ),
                                child: UserTile(
                                  userDoc: snapshot.data!.docs[index],
                                ),
                              ))
                      : _defaultNoAssociation();
                }
              },
            ),
          );
        });
  }

  showProfileUserAvatar(BuildContext context, String userUID) {
    return showModalBottomSheet(
      context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.30,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: Colors.black54,
                  ),
                ),
                CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(Provider.of<FirebaseOperations>(context, listen: false)
                      .getUserImage),
                ),
                SizedBox(
                  child: MaterialButton(
                    onPressed: () {
                      selectProfileAvatarOptionsSheet(context);
                    },
                    child: const Text(
                      'Select',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.zero,
          ),
        );
      },
    );
  }

  Future selectProfileAvatarOptionsSheet(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.white54,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        color: Colors.black,
                        child: const Text(
                          'Gallery',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<ProfileUtils>(context, listen: false)
                              .pickUserAvatar(context, ImageSource.gallery)
                              .whenComplete(() {
                            Navigator.pop(context);
                            showSelectedUserAvatar(
                                context,
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .getUserId);
                          });
                        },
                      ),
                      MaterialButton(
                        color: Colors.black,
                        child: const Text(
                          'Camera',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<ProfileUtils>(context, listen: false)
                              .pickUserAvatar(context, ImageSource.camera)
                              .whenComplete(() {
                            Navigator.pop(context);
                            showSelectedUserAvatar(
                                context,
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .getUserId);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: kBlue,
              borderRadius: BorderRadius.zero,
            ),
          );
        });
  }

  showSelectedUserAvatar(BuildContext context, String userUID) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.30,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: Colors.black54,
                  ),
                ),
                CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: FileImage(
                      Provider.of<ProfileUtils>(context, listen: false)
                          .userAvatar),
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          selectProfileAvatarOptionsSheet(context);
                        },
                        child: const Text(
                          'Select again',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black,
                          ),
                        ),
                      ),
                      MaterialButton(
                        color: kBlue,
                        onPressed: () {
                          Provider.of<FirebaseOperations>(context,
                                  listen: false)
                              .updateUserAvatar(context, userUID)
                              .whenComplete(() async {
                            Navigator.pop(context);
                          });
                        },
                        child: const Text(
                          'Update Image',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.zero,
          ),
        );
      },
    );
  }

  ///Profile title section
  Column titleSection(String displayName, String username, String bio) {
    return Column(
      children: [
        Text(
          displayName,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 27.0,
          ),
        ),
        const SizedBox(
          height: 1.0,
        ),
        Text(
          '@' + username,
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
          "\"" + bio + "\"",
          style: GoogleFonts.robotoMono(
            textStyle: const TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w300,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  /// Info section
  Row infoSection(BuildContext context, String userUID) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userUID)
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
                      ? NumberFormatter.formatter(snapshot.data!['count'].toString())
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
            checkFollowerSheet(context, userUID);
          },
          child: SizedBox(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userUID)
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
                        ? NumberFormatter.formatter(snapshot.data!['count'].toString())
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
            checkFollowingSheet(context, userUID);
          },
          child: SizedBox(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userUID)
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
                        ? NumberFormatter.formatter(snapshot.data!['count'].toString())
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

  Center defaultNoRecipes(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.40,
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

  Future<void> showReportDialog(BuildContext context, String userUID) async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            elevation: 15.0,
            child: SizedBox(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Center(
                    child: Text(
                      'What would you like to report?',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      thickness: 0.3,
                      height: 0.5,
                      color: Colors.grey[500],
                    ),
                  ),
                  Provider.of<RecipeDetailHelper>(context, listen: false).buildRow(context, Icons.photo_camera_outlined, 'Profile picture', 'user', userUID),
                  Provider.of<RecipeDetailHelper>(context, listen: false).buildRow(context, Icons.ballot_outlined, 'Nickname', 'user', userUID),
                  Provider.of<RecipeDetailHelper>(context, listen: false).buildRow(context, Icons.comment_outlined, 'Rudeness', 'user', userUID),
                  Provider.of<RecipeDetailHelper>(context, listen: false).buildRow(context, Icons.more_outlined, 'Other problem', 'user', userUID),
                ],
              ),
            ),
          );
        });
  }

  Center _defaultNoAssociation() {
    return const Center(
        child: Text(
      'No associates yet...',
      style: TextStyle(
        color: Colors.black,
        fontSize: 23.0,
        fontWeight: FontWeight.w600,
      ),
    ));
  }
}
