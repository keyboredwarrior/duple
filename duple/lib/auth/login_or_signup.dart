import 'package:duple/pages/universal/login_page.dart';
import 'package:duple/pages/universal/signup_page.dart';
import 'package:flutter/material.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({super.key});

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  // show login page
  bool showLoginPage = true;

  // toggle between signup and login
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return SignupPage(onTap: togglePages);
    }
  }
}