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

  String userEmail = '', username = '', displayName = '', userImage = '', userBio = '';
  String get getUserEmail => userEmail;
  String get getUsername => username;
  String get getDisplayName => displayName;
  String get getUserImage => userImage;
  String get getUserBio => userBio;

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
      username = doc.data()!['username'];
      displayName = doc.data()!['displayName'];
      userEmail = doc.data()!['email'];
      userBio = doc.data()!['bio'];
      userImage = doc.data()!['photoUrl'];
      notifyListeners();
    });
  }
}
