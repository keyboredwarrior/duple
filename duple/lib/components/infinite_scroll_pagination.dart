// ignore_for_file: unused_field

import 'dart:async';
//import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duple/database/firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class InfiniteScrollPagination extends StatefulWidget {
  final ScrollController scrollController;
  final double radius;
  const InfiniteScrollPagination(
      {super.key,
      required this.scrollController,
      required this.radius});

  @override
  State<InfiniteScrollPagination> createState() =>
      _InfiniteScrollPaginationState();
}

class _InfiniteScrollPaginationState extends State<InfiniteScrollPagination> {
  GeoPoint userLoc = GeoPoint(0, 0);
  double latitude = 0, longitude = 0;
  double longShift = 0.7228, latShift = 0.726;
  double _currentSliderValue = 0;
  final FirestoreDatabase database = FirestoreDatabase();
  final int _pageSize = 60;
  late final ScrollController _scrollController;
  final bool _isFetchingData = false;
  int limit = 15;

  void initLocation() async {
    userLoc = await getCurrentLocation();
    latitude = userLoc.latitude;
    longitude = userLoc.longitude;
  }

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
    initLocation();
    _scrollController = widget.scrollController;
    if(_currentSliderValue != widget.radius){
      _currentSliderValue = widget.radius;
      setState(() {
      });
    }
    _scrollController.addListener(() {
      _scrollController.addListener(() {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;

        if (currentScroll == maxScroll) {
          // When the last item is fully visible, load the next page.
          setState(() {
            limit = 15 + limit;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: database.getArtistsStream(latitude, latShift*_currentSliderValue/5, longitude, longShift*_currentSliderValue/10, limit),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle errors
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          // Display a message when there is no data
          return const Center(child: Text('No data available.'));
        } else {
          // Display the paginated data
          final items = snapshot.data!.docs;
          return ListView(
            controller: _scrollController,
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context,index) {
                  final artist = items[index];
                  return ListTile(
                    title: Text(artist['username'], style: TextStyle(color: Colors.white),),
                    subtitle: Text(artist['genre1'] + ',' + artist['genre2'], style: TextStyle(color: Colors.white70),),
                  );
                }
              ),
              if (_isFetchingData)
                const Center(
                    child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )),
            ],
          );
        }
      },
    );
  }
}