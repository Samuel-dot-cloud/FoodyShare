import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/utils/profile_util.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseOperations with ChangeNotifier {
  final activityFeedRef = FirebaseFirestore.instance.collection('feed');
  final usersRef = FirebaseFirestore.instance.collection('users');
  final recipesRef = FirebaseFirestore.instance.collection('recipes');
  final commentsRef = FirebaseFirestore.instance.collection('comments');
  final hashtagsRef = FirebaseFirestore.instance.collection('hashtags');
  firebase_storage.Reference reference =
      firebase_storage.FirebaseStorage.instance.ref();
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
        Provider.of<ProfileUtils>(context, listen: false).getUserAvatar);
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
        Provider.of<ProfileUtils>(context, listen: false).getUserAvatar);
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
          msg:
              'Image updated successfully. \nYou may need to restart the application to notice the changes made.',
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
      }).whenComplete(() {
        usersRef.doc(uid).collection('counts').doc('followerCount').set({
          'count': FieldValue.increment(0),
        }).whenComplete(() {
          return usersRef
              .doc(uid)
              .collection('counts')
              .doc('followingCount')
              .set({
            'count': FieldValue.increment(0),
          });
        });
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
    }).whenComplete(() async {
      addFollowCount(followerUID, followingUID);
    });
  }

  Future addFollowCount(String followerUID, String followingUID) async {
    return usersRef
        .doc(followingUID)
        .collection('counts')
        .doc('followerCount')
        .update({
      'count': FieldValue.increment(1),
    }).whenComplete(() async {
      return usersRef
          .doc(followerUID)
          .collection('counts')
          .doc('followingCount')
          .update({
        'count': FieldValue.increment(1),
      });
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
    }).whenComplete(() async {
      return usersRef
          .doc(followerUID)
          .collection('counts')
          .doc('followingCount')
          .update({
        'count': FieldValue.increment(-1),
      }).whenComplete(() async {
        return usersRef
            .doc(followingUID)
            .collection('counts')
            .doc('followerCount')
            .update({
          'count': FieldValue.increment(-1),
        });
      });
    });
  }

  Future addFollowToActivityFeed(
      String otherUserId, String currentUserId, dynamic data) async {
    activityFeedRef
        .doc(otherUserId)
        .collection('feedItems')
        .doc('userNotifications')
        .collection('followActivity')
        .doc(currentUserId)
        .set(data);
  }

  Future addLikeToActivityFeed(
      String authorId, String postId, dynamic data) async {
    activityFeedRef
        .doc(authorId)
        .collection('feedItems')
        .doc('userNotifications')
        .collection('postActivity')
        .doc(postId)
        .set(data);
  }

  Future removeFollowFromActivityFeed(
      String authorId, String currentUserId) async {
    activityFeedRef
        .doc(authorId)
        .collection('feedItems')
        .doc('userNotifications')
        .collection('followActivity')
        .doc(currentUserId)
        .delete();
  }

  Future addCommentToActivityFeed(String authorId, dynamic data) async {
    activityFeedRef
        .doc(authorId)
        .collection('feedItems')
        .doc('userNotifications')
        .collection('postActivity')
        .add(data);
  }

  Future addLike(BuildContext context, String postId, String userUID) async {
    return recipesRef.doc(postId).collection('likes').doc(userUID).set({
      'liked': true,
      'userUID': userUID,
      'timestamp': Timestamp.now(),
    }).whenComplete(() async {
      var doc = await recipesRef
          .doc(postId)
          .collection('likes')
          .doc('like_count')
          .get();
      if (doc.exists) {
        return recipesRef
            .doc(postId)
            .collection('likes')
            .doc('like_count')
            .update({
          'count': FieldValue.increment(1),
        });
      } else {
        return recipesRef
            .doc(postId)
            .collection('likes')
            .doc('like_count')
            .set({
          'count': FieldValue.increment(1),
        });
      }
    });
  }

  Future removeLike(BuildContext context, String postId, String userUID) async {
    return recipesRef
        .doc(postId)
        .collection('likes')
        .doc(userUID)
        .delete()
        .whenComplete(() {
      return recipesRef
          .doc(postId)
          .collection('likes')
          .doc('like_count')
          .update({
        'count': FieldValue.increment(-1),
      });
    });
  }

  Future createFavoriteList(
      String currentUserId, String listID, dynamic listData) {
    return usersRef
        .doc(currentUserId)
        .collection('favorites')
        .doc(listID)
        .set(listData);
  }

  Future editFavoriteList(
      String currentUserId, String listID, dynamic listData) {
    return usersRef
        .doc(currentUserId)
        .collection('favorites')
        .doc(listID)
        .update(listData);
  }

  Future deleteFavoriteList(
      String currentUserId, String listID, dynamic listData) {
    return usersRef
        .doc(currentUserId)
        .collection('favorites')
        .doc(listID)
        .delete();
  }

  Future addToFavorites(String currentUserId, String listID, String postId,
      dynamic recipeData) async {
    return usersRef
        .doc(currentUserId)
        .collection('favorites')
        .doc(listID)
        .collection('bookmarked')
        .doc(postId)
        .set(recipeData).whenComplete(() async {
      await usersRef
          .doc(currentUserId)
          .collection('favorites')
          .doc(listID)
          .update({
        'lastEdited': Timestamp.now(),
        'recipe_count': FieldValue.increment(1),
      });
      notifyListeners();
    });
  }

  Future removeFromFavorites(String currentUserId, String listID, String postId) async {
    return usersRef
        .doc(currentUserId)
        .collection('favorites')
        .doc(listID)
        .collection('bookmarked')
        .doc(postId)
        .delete().whenComplete(() async {
      await usersRef
          .doc(currentUserId)
          .collection('favorites')
          .doc(listID)
          .update({
        'lastEdited': Timestamp.now(),
        'recipe_count': FieldValue.increment(-1),
      });
      notifyListeners();
    });
  }

  Future deleteRecipe(String postId) async {
    return recipesRef.doc(postId).delete().whenComplete(() async {
      return commentsRef.doc(postId).delete().whenComplete(() async {
        return deleteRecipeImage(postId, reference);
      }).whenComplete(() async {
        return usersRef
            .doc(getUserId)
            .collection('recipes')
            .doc(postId)
            .delete()
            .whenComplete(() async {
          return usersRef
              .doc(getUserId)
              .collection('counts')
              .doc('recipeCount')
              .update({
            'count': FieldValue.increment(-1),
          });
        });
      });
    });
  }

  Future deleteRecipeImage(
      String postId, firebase_storage.Reference reference) async {
    await reference.child('recipe-images/$postId.jpg').delete();
  }
}
