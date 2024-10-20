// ignore_for_file: unused_element, prefer_const_constructors, must_be_immutable

import 'package:duple/database/firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DiscoveryPage extends StatelessWidget{
  TextEditingController searchController = TextEditingController();
  final FirestoreDatabase database = FirestoreDatabase();
  DiscoveryPage({super.key});

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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 55, left: 12, right: 12),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Search artists...',
                hintStyle: TextStyle(color: Colors.grey,)
                ),
                style: TextStyle(color: Colors.white),
              ),
            ],
          )
        ),
      ),
    );
  }
}