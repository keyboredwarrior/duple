import 'package:duple/auth/login_or_signup.dart';
import 'package:duple/pages/universal/root_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return RootPage();
          } else {
            return LoginOrSignup();
          }
        }
      ),
    );
  }
}