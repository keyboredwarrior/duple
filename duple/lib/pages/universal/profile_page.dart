// ignore_for_file: unused_element, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget{
  final void Function()? onTap;
  ProfilePage({super.key, required this.onTap});

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String,dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).get();
  }

  // actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout, color: Colors.white,),)]

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black87,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: getUserDetails(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } 
            else if (snapshot.hasError) {
              return Text("ERROR: ${snapshot.error}");
            }
            else if (snapshot.hasData) {
              Map<String, dynamic>? user = snapshot.data!.data();

              return Column(
                children: [
                  const SizedBox(height: 70),
                  Row(
                    children: [
                      const SizedBox(width: 25,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.grey, width: 2)
                          ),
                        padding: const EdgeInsets.all(25),
                        child: const Icon(Icons.person),
                      ),
                      const SizedBox(width: 20,),


                      Text(user!['username'], style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 140,),

                      GestureDetector(
                        onTap: onTap,
                        child: Icon(Icons.settings, color: Colors.white)
                      ),
                    ]
                  ),
                ],
              );
            }
            else {
              return Text("No data");
            }
          },
        ),
      );
  }
}