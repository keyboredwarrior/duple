// ignore_for_file: unused_element, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duple/database/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  HomePage({super.key});
  final FirestoreDatabase database = FirestoreDatabase();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          StreamBuilder(
            stream: database.getPostsStream(), 
            builder: (context,snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final posts = snapshot.data!.docs;

              if(snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text('No Posts'),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    String message = post['PostMessage'];
                    String userEmail = post['UserEmail'];
                    Timestamp timestamp = post['TimeStamp'];

                    return ListTile(
                      title: Text(message),
                      subtitle: Text(userEmail),
                    );
                  },
                )
              );
            }
          )
        ],
      ),

    );
  }
}