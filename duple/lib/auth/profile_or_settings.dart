import 'package:duple/pages/universal/profile_page.dart';
import 'package:duple/pages/universal/settings_page.dart';
import 'package:flutter/material.dart';

class ProfileOrSettings extends StatefulWidget {
  const ProfileOrSettings({super.key});

  @override
  State<ProfileOrSettings> createState() => _ProfileOrSettingsState();
}

class _ProfileOrSettingsState extends State<ProfileOrSettings> {
  bool showProfilePage = true;

  void togglePages() {
    setState(() {
      showProfilePage = !showProfilePage;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (showProfilePage) {
      return ProfilePage(onTap: togglePages);
    } else {
      return SettingsPage(onTap: togglePages);
    }
  }
}