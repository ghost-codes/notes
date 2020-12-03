import 'package:cloud_firestore/cloud_firestore.dart';

final notesRef = FirebaseFirestore.instance.collection('notes');
final userRef = FirebaseFirestore.instance.collection('users');
final friendsRef = FirebaseFirestore.instance.collection("friends");
final labelsRef = FirebaseFirestore.instance.collection("labels");
