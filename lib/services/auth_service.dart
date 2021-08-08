import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_share/services/database_service.dart';
import 'package:food_share/services/recipe_notifier.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream<User> get authStateChanges => _auth.authStateChanges();

  //Create Account
  Future<String> createAccount(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      //Create a new document for user with the uid
      // await DatabaseService(uid: user!.uid).updateUserData(
      // )

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
    return 'Error occurred';
  }

  // Login user
  Future<String> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
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
    return 'Error occurred';
  }

  //Reset password
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

  //Log out
  void logOut() {
    _auth.signOut();
  }

// getRecipes(RecipeNotifier recipeNotifier){
//   FirebaseFirestore.instance.doc(_auth.currentUser!.uid).collection('')
// }
}
