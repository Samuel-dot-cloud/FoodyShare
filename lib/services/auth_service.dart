import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'analytics_service.dart';
import 'firebase_operations.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ///Create Account
  Future<String> createAccount(BuildContext context, String email,
      String password, String username, String displayName) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        Provider.of<FirebaseOperations>(context, listen: false)
            .createUserCollection(
          context,
          value.user!.uid,
          {
            'id': value.user!.uid,
            'username': username,
            'email': email,
            'photoUrl':
                'https://cdn.icon-icons.com/icons2/2506/PNG/512/user_icon_150670.png',
            'displayName': displayName,
            'bio': 'I\'m new here',
            'timestamp': Timestamp.now(),
            'isVerified': false,
          },
          username,
        );
        Provider.of<AnalyticsService>(context, listen: false).setUserProperties(
            userID: value.user!.uid, userRole: 'normal_user');
      });

      return 'Account created';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return 'Error occurred';
    }
    return 'Error occurred';
  }

  /// Login user
  Future<String> loginUser(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      Provider.of<AnalyticsService>(context, listen: false).setUserProperties(
          userID: _auth.currentUser!.uid, userRole: 'normal_user');

      return 'Welcome';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return 'Error occurred';
  }

  ///Reset password
  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
      return 'Reset email sent';
    } catch (e) {
      return 'Error occurred';
    }
  }

  ///Log out
  void logOut() {
    _auth.signOut();
  }
}
