import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/utils/sign_up_util.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class FirebaseOperations with ChangeNotifier {
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

  ///User post variables
  String authorEmail = '',
      authorUsername = '',
      authorDisplayName = '',
      authorUserImage = '',
      authorBio = '';

  String get getAuthorEmail => authorEmail;

  String get getAuthorUsername => authorUsername;

  String get getAuthorDisplayName => authorDisplayName;

  String get getAuthorUserImage => authorUserImage;

  String get getAuthorBio => authorBio;

  ///Recipe variables
  String id = '',
      authorId = '',
      title = '',
      description = '',
      cookingTime = '',
      servings = '',
      mediaUrl = '';

  String get recipeId => id;

  String get getAuthorId => authorId;

  String get getRecipeTitle => title;

  String get getRecipeDescription => description;

  String get getRecipeCookingTime => cookingTime;

  String get getServings => servings;

  String get getMediaUrl => mediaUrl;

  Future uploadUserAvatar(BuildContext context) async {
    Reference imageReference =
        FirebaseStorage.instance.ref().child('userAvatar/${TimeOfDay.now()}');
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

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<AuthService>(context, listen: false).getuserUID)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((doc) {
      userId = doc.data()!['id'];
      username = doc.data()!['username'];
      displayName = doc.data()!['displayName'];
      userEmail = doc.data()!['email'];
      userBio = doc.data()!['bio'];
      userImage = doc.data()!['photoUrl'];
      notifyListeners();
    });
  }

  Future getAuthorData(BuildContext context, String authorId) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authorId)
        .get()
        .then((doc) {
      authorUsername = doc.data()!['username'];
      authorDisplayName = doc.data()!['displayName'];
      authorEmail = doc.data()!['email'];
      authorBio = doc.data()!['bio'];
      authorUserImage = doc.data()!['photoUrl'];
      notifyListeners();
    });
  }

  Future getRecipeDetails(BuildContext context, String recipeId) async {
    return FirebaseFirestore.instance
        .collection('recipes')
        .doc(recipeId)
        .get()
        .then((doc) {
      id = doc.data()!['postId'];
      authorId = doc.data()!['authorId'];
      title = doc.data()!['name'];
      description = doc.data()!['description'];
      cookingTime = doc.data()!['cookingTime'];
      servings = doc.data()!['servings'];
      mediaUrl = doc.data()!['mediaUrl'];
      // t = doc.data()!['timestamp'];
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
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUID)
        .collection('followers')
        .doc(followingDocId)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUID)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }
}
