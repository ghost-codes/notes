import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Userr {
  final String displayName;
  // final String userName;
  final String uid;
  final String photoUrl;
  final String email;

  Userr({this.displayName, this.uid, this.photoUrl, this.email});

  factory Userr.fromAuthUser(User user) {
    return Userr(
        displayName: user.displayName,
        uid: user.uid,
        email: user.email,
        photoUrl: user.photoURL);
  }

  factory Userr.fromDocument(DocumentSnapshot doc) {
    return Userr(
      displayName: doc["displayName"],
      uid: doc["uid"],
      email: doc["email"],
      photoUrl: doc["photoUrl"],
    );
  }
}
