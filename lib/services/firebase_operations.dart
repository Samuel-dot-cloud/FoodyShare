import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/utils/sign_up_util.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class FirebaseOperations with ChangeNotifier {
  final activityFeedRef = FirebaseFirestore.instance.collection('feed');
  final usersRef = FirebaseFirestore.instance.collection('users');
  late UploadTask imageUploadTask;

  late String userAvatarUrl;

  String get getUserAvatarUrl => userAvatarUrl;

  ///User variables
  String userEmail = '',
      username = '',
      displayName = '',
      userImage = '',
      userBio = '',
      userId = '';

  String get getUserEmail => userEmail;

  String get getUsername => username;

  String get getDisplayName => displayName;

  String get getUserImage => userImage;

  String get getUserBio => userBio;

  String get getUserId => userId;

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('user-avatars/${DateTime.now()}.jpg');
    imageUploadTask = imageReference.putFile(
        Provider.of<SignUpUtils>(context, listen: false).getUserAvatar);
    await imageUploadTask.whenComplete(() {
      Fluttertoast.showToast(
          msg: 'Image uploaded successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    });
    imageReference.getDownloadURL().then((url) {
      userAvatarUrl = url.toString();
      notifyListeners();
    });
  }

  Future updateUserAvatar(BuildContext context, String uid) async {
    Reference imageReference =
        FirebaseStorage.instance.ref().child('user-avatars/$uid.jpg');
    imageUploadTask = imageReference.putFile(
        Provider.of<SignUpUtils>(context, listen: false).getUserAvatar);
    await imageUploadTask.whenComplete(() {
      Fluttertoast.showToast(
          msg: 'Image uploaded successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    });
    imageReference.getDownloadURL().then((url) {
      updateUserRef(context, url.toString());
      notifyListeners();
    });
  }

  updateUserRef(BuildContext context, String url) {
    usersRef.doc(getUserId).update({
      'photoUrl': url,
    }).whenComplete(() {
      Fluttertoast.showToast(
          msg: 'Image updated successfully. \nYou may need to restart the application to notice the changes made.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kBlue,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  Future createUserCollection(
      BuildContext context, String uid, dynamic data, String username) async {
    return usersRef.doc(uid).set(data).whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('usernames')
          .doc(username)
          .set({
        'userUID': uid,
      });
    });
  }

  Future initUserData(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;

    return usersRef.doc(uid).get().then((doc) {
      userId = doc.data()!['id'];
      username = doc.data()!['username'];
      displayName = doc.data()!['displayName'];
      userEmail = doc.data()!['email'];
      userBio = doc.data()!['bio'];
      userImage = doc.data()!['photoUrl'];
      notifyListeners();
    });
  }

  Future followUser(
      String followingUID,
      String followingDocId,
      dynamic followingData,
      String followerUID,
      followerDocId,
      dynamic followerData) async {
    return usersRef
        .doc(followingUID)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return usersRef
          .doc(followerUID)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }

  Future unfollowUser(
    String followingUID,
    String followingDocId,
    String followerUID,
    followerDocId,
  ) async {
    return usersRef
        .doc(followingUID)
        .collection('followers')
        .doc(followingDocId)
        .delete()
        .whenComplete(() async {
      return usersRef
          .doc(followerUID)
          .collection('following')
          .doc(followerDocId)
          .delete();
    });
  }

  Future addToActivityFeed(String authorId, String postId, dynamic data) async {
    activityFeedRef.doc(authorId).collection('feedItems').doc(postId).set(data);
  }

  Future removeFromActivityFeed(String authorId, String postId) async {
    activityFeedRef.doc(authorId).collection('feedItems').doc(postId).delete();
  }

  Future addCommentToActivityFeed(String authorId, dynamic data) async {
    activityFeedRef.doc(authorId).collection('feedItems').add(data);
  }

  Future addLike(BuildContext context, String postId, String userUID) async {
    return FirebaseFirestore.instance
        .collection('recipes')
        .doc(postId)
        .collection('likes')
        .doc(userUID)
        .set({
      'liked': FieldValue.increment(1),
      'userUID': userUID,
      'timestamp': Timestamp.now(),
    });
  }

  Future addToFavorites(
      String currentUserId, String postId, dynamic recipeData) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('favorites')
        .doc(postId)
        .set(recipeData);
  }

  Future removeFromFavorites(String currentUserId, String postId) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('favorites')
        .doc(postId)
        .delete();
  }
}
