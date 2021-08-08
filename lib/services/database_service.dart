import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_share/models/user_model.dart';

class DatabaseService{

  final String uid;
  DatabaseService( {required this.uid});

  // Collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(CustomUser customUser) async {
    return await userCollection.doc(uid).set({
      'bio': customUser.bio,
      'displayName': customUser.displayName,
      'email': customUser.email,
      'id': customUser.id,
      'photoUrl': customUser.photoUrl,
      'username': customUser.username,
    });
  }
}