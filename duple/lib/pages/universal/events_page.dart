// ignore_for_file: unused_element, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget{
  EventsPage({super.key});

  TextEditingController searchController = TextEditingController();

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
                hintText: 'Search events...',
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