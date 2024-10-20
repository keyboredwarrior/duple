// ignore_for_file: unused_element, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SettingsPage extends StatelessWidget{
  final void Function()? onTap;
  SettingsPage({super.key, required this.onTap});

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String,dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).get();
  }

  void _logout() {
    FirebaseAuth.instance.signOut();
  }

  Future<List<double>> getCurrentLocation() async{
    // prompts the user to allow location services
    LocationPermission perms = await Geolocator.checkPermission();
    if (perms == LocationPermission.denied) {
      perms = await Geolocator.requestPermission();
    }
    // fetch user location
    // ignore: deprecated_member_use
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // returns latitude and longitude of user in list form
    List<double> latLong = [position.latitude, position.longitude];
    
    return latLong;
  }

  void _setLocation() {
    
  }

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
                  const SizedBox(height: 60,),
                  Row(
                    children: [
                      const SizedBox(width: 15,),
                      GestureDetector(
                        onTap: onTap,
                        child: Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),
                      const SizedBox(width: 130,),

                      Text(user!['username'], style: TextStyle(color: Colors.white)),
                    ]
                  ),
                  const SizedBox(height: 200,),
                  ElevatedButton(onPressed: _logout, child: Text("logout"))
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