// ignore_for_file: unused_field

import 'dart:async';
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
  TextEditingController searchController = TextEditingController();
  double latitude = 0, longitude = 0;
  double longShift = 0.7228, latShift = 0.726;
  List<QuerySnapshot> artistList = [];
  double _currentSliderValue = 0;

  final StreamController<List<dynamic>> _dataStreamController =
      StreamController<List<dynamic>>();
  Stream<List<dynamic>> get dataStream => _dataStreamController.stream;
  final FirestoreDatabase database = FirestoreDatabase();
  final List<dynamic> _currentItems = [];
  int _currentPage = 1;
  final int _pageSize = 60;
  late final ScrollController _scrollController;
  bool _isFetchingData = false;

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

  Future<void> _fetchPaginatedData() async {
    if (_isFetchingData) {
      // Avoid fetching new data while already fetching
      return;
    }
    try {
      _isFetchingData = true;
      setState(() {});

      final startTime = DateTime.now();

      // Add the updated list to the stream without overwriting the previous data
      final endTime = DateTime.now();
      final timeDifference =
          endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch;
      _dataStreamController.add(_currentItems);
      _currentPage++;
    } catch (e) {
      _dataStreamController.addError(e);
    } finally {
      // Set to false when data fetching is complete
      _isFetchingData = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.radius;
    initLocation();
    _scrollController = widget.scrollController;
    _fetchPaginatedData();
    _scrollController.addListener(() {
      _scrollController.addListener(() {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;

        if (currentScroll == maxScroll) {
          // When the last item is fully visible, load the next page.
          _fetchPaginatedData();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: database.getArtistsStream(latitude, latShift*_currentSliderValue/50, longitude, longShift),
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
                    title: Text(artist['username']),
                    subtitle: Text(artist['genre1'] + ',' + artist['genre2']),
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

  @override
  void dispose() {
    _dataStreamController.close();
    //we do not have control cover the _scrollController so it should not be disposed here
    // _scrollController.dispose();
    super.dispose();
  }
}