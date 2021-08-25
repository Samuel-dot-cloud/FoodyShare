import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? userUID;

  String? get getuserUID => userUID;

  ///Create Account
  Future<String> createAccount(String email, String password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      userUID = user?.uid;
      notifyListeners();

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
  Future<String> loginUser(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      userUID = user?.uid;
      notifyListeners();

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
      await auth.sendPasswordResetEmail(
        email: email,
      );
      return 'Reset email sent';
    } catch (e) {
      return 'Error occurred';
    }
  }

  ///Log out
  void logOut() {
    auth.signOut();
  }
}
