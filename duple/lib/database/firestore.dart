/*
This database will store posts by
artists and businesses (images, text)
stored in 'Posts' collection in Firebase

Each post contains;
 - a caption/description
 - poster username
 - timestamp
 - image
*/


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  // current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  // get Posts collection from firebase
  final CollectionReference posts = FirebaseFirestore.instance.collection('Artists');

  // read posts from database
  Stream<QuerySnapshot> getArtistsStream(double latitude, double latShift, double longitude, double longShift, int limit){
    final postsStream = FirebaseFirestore.instance.collection('Artists')
    .where('latitude', isGreaterThanOrEqualTo: latitude - latShift, isLessThanOrEqualTo: latitude + latShift)
    .where('longitude', isLessThanOrEqualTo: longitude + longShift, isGreaterThanOrEqualTo: longitude -longShift)
    .snapshots();
    return postsStream;
  }
}