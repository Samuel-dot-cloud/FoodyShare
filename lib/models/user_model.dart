import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUser {
  final String id;
  final String username;
  final String displayName;
  final String email;
  final String photoUrl;
  final String bio;

  CustomUser( {
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.bio,
  });

  factory CustomUser.fromDocument(DocumentSnapshot doc) {
    return CustomUser(
      id: doc['id'],
      username: doc['username'],
      displayName: doc['displayName'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      bio: doc['bio'],
    );
  }
}
