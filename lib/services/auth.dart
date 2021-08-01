import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_share/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create user object based on FirebaseUser
  User _userFromFirebaseUser(User user) {
    return user != null ? CustomUser(
      id: user.uid,
      username: '',
      displayName: '',
      email: '',
      photoUrl: '',
      bio: '',
      timeStamp: DateTime.now(),
    ) : null;
  }

  //Sign up with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _use
    } catch () {

    }
  }
//Log in with email and password
}