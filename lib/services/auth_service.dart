import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  //Create Account
  Future<String> createAccount(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Account created';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak. '
            'Should be more than 6 characters long.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return 'Error occurred';
    }
    return 'default';
  }

  // Login user
  Future<String> loginUser(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Welcome';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return 'default';
  }

  //Reset password
  Future<String> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(
        email: email,
      );
      return 'Reset email sent';
    } catch (e) {
      return 'Error occurred';
    }

    return 'default';
  }

  //Log out
  void logOut() {
    auth.signOut();
  }
}
