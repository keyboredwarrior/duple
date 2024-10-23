// ignore_for_file: unused_element, prefer_const_constructors, must_be_immutable, unused_local_variable

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duple/components/infinite_realtime_pagination.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class DiscoveryPage extends StatefulWidget{

  const DiscoveryPage({super.key, Object? dataModel});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final ScrollController scrollCtrl = ScrollController();
  GeoPoint userLoc = GeoPoint(0, 0);
  TextEditingController searchController = TextEditingController();
  double _currentSliderValue = 50;
  double longShift = 0, latShift = 0;
  List<QuerySnapshot> artistList = [];
  final List<String> genres = ['Pop', 'Rock', 'Rap', 'HipHop', 'Hyperpop', 'Indie', 'Metal', 'EDM', 'Country', 'Shoegaze'];

  Future<GeoPoint> getCurrentLocation() async{
    // fetch user location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // returns latitude and longitude of user in list form
    GeoPoint userLoc = GeoPoint(position.latitude, position.longitude);
    return userLoc;
  }

  @override
  void initState() {
    super.initState();
  }

  void _uploadRandom() async {
    final numbers = List.generate(50, (index) => index + 1);
    Random generator = Random();
    double latitude;
    double longitude;

    for (final number in numbers) {
      latitude = generator.nextDouble();
      longitude = generator.nextDouble();

      if(latitude < 0.5) {
        latitude *= -89;
      } else {latitude *= 89;}
      if(longitude < 0.5) {
        longitude *= -89;
      } else {longitude *= 89;}
      await FirebaseFirestore.instance.collection("Artists").doc('artist$number').set({
        'email': "test$number@gmail.com",
        'username': "artist$number",
        'latitude': latitude,
        'longitude': longitude,
        'genre1': genres[generator.nextInt(9)],
        'genre2': genres[generator.nextInt(9)],
      });
    }
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

              Slider(
                value: _currentSliderValue,
                min: 50,
                max: 300,
                divisions: 5,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),

              InfiniteRealtimePagination()              
            ],
          )
        ),
      ),
    );
  }
}
