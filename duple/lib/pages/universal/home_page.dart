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
      body:
      Column(
        children: [
          SizedBox(height: 100,),
          Row(
            children: [SizedBox(width: 150,)],
          ),
          Text('HOME PAGE', style: TextStyle(color: Colors.white),)
        ],
      )
    );
  }
}