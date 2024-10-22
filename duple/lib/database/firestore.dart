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
  Stream<QuerySnapshot> getArtistsStream(){
    final postsStream = FirebaseFirestore.instance.collection('Posts').orderBy('TimeStamp', descending: true).snapshots();
    return postsStream;
  }

  /*
    void postMessage() {
      String message = textcontroller.text;
      databse.addPost(message);
      textcontroller.clear();
    }
    in home page; final FirestoreDatabase firestore = FirestoreDatabase();

      // make a post
  Future<void> addPost(String message){
    return posts.add({
      'UserEmail': user!.email,
      'PostMessage': message,
      'TimeStamp': Timestamp.now(),
    });
  }

  */
}