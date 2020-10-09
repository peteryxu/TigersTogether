import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String email;
  final String id;
  final String photoUrl;
  final String username;
  final String displayName;
  final String bio;
  final Map followers;
  final Map following;

  const AppUser(
      {this.username,
      this.id,
      this.photoUrl,
      this.email,
      this.displayName,
      this.bio,
      this.followers,
      this.following});

  factory AppUser.fromDocument(Map document) {
    return AppUser(
      email: document['email'],
      username: document['username'],
      photoUrl: document['photoUrl'],
      id: document['id'],
      displayName: document['displayName'],
      bio: document['bio'],
      followers: document['followers'],
      following: document['following'],
    );
  }

   factory AppUser.fromFirebaseAuth(User user) {
    if (user == null) {
      return null;
    }
    return AppUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
