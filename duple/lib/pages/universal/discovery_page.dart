// ignore_for_file: unused_element, prefer_const_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duple/database/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DiscoveryPage extends StatefulWidget{

  DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  final FirestoreDatabase database = FirestoreDatabase();

  TextEditingController searchController = TextEditingController();
  double _currentSliderValue = 50;

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

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Artists').snapshots(),
                builder: (context,snapshot){
                  List<Row> artistWidgets = [];

                  if(snapshot.hasData){
                    final artists = snapshot.data?.docs.reversed.toList();
                    for(var artist in artists!){
                      final artistWidget = Row(
                        children: [
                          Text(artist['username'])
                        ],
                      );
                      artistWidgets.add(artistWidget);
                    }

                  }

                  return Expanded(
                    child: ListView(
                      children: artistWidgets,
                    ),
                  );
                },

              ),
            ],
          )
        ),
      ),
    );
  }
}