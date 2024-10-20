// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, empty_constructor_bodies, must_be_immutable, unused_field, prefer_final_fields, prefer_const_constructors_in_immutables

import 'package:duple/auth/profile_or_settings.dart';
import 'package:duple/pages/universal/discovery_page.dart';
import 'package:duple/pages/universal/events_page.dart';
import 'package:duple/pages/universal/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class RootPage extends StatefulWidget {
  
  RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;
  void _navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  final List _pages = [HomePage(), DiscoveryPage(), ProfileOrSettings(), EventsPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            onTabChange: (index){
             _navigateBottomBar(index);
            },
            gap: 8,
            backgroundColor: Colors.black,
            color: Colors.grey,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            padding: EdgeInsets.all(20),
            tabs: const [
              GButton(icon: Icons.home,                    text: 'Home'),
              GButton(icon: Icons.search,                  text: 'Discover'),
              GButton(icon: Icons.account_circle_outlined, text: 'Me'),
              GButton(icon: Icons.calendar_month_outlined, text: 'Events'),
            ],
          ),
        ),
      )
    );
  }
}