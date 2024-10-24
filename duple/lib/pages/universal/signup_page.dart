// ignore_for_file: unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_local_variable, prefer_const_constructors_in_immutables, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duple/components/duple_button.dart';
import 'package:duple/components/duple_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../helper/helper_functions.dart';

final TextEditingController emailController = TextEditingController();

final TextEditingController userController = TextEditingController();

final TextEditingController pwdController = TextEditingController();

final TextEditingController zipController = TextEditingController();

final TextEditingController confPwd = TextEditingController();

class SignupPage extends StatefulWidget{
  final void Function()? onTap;

  SignupPage({super.key, required this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  
  final TextEditingController emailController = TextEditingController();

  final TextEditingController userController = TextEditingController();

  final TextEditingController pwdController = TextEditingController();

  final TextEditingController zipController = TextEditingController();

  final TextEditingController confPwd = TextEditingController();

  bool artist = false;
  bool venue = false;

  Future<GeoPoint> getCurrentLocation() async{
    // prompts the user to allow location services
    LocationPermission perms = await Geolocator.checkPermission();
    if (perms == LocationPermission.denied) {
      perms = await Geolocator.requestPermission();
    }
    // fetch user location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // returns latitude and longitude of user in list form
    GeoPoint userLoc = GeoPoint(position.latitude, position.longitude);
    return userLoc;
  }

  // Checks to make sure all fields have text in them, both password fields match, and then
  // creates an account with authorization keys stored in Firebase, accessed through Firebase Console
  // *note - Firebase Console is linked to chasemacmillancs@gmail.com
  void _signup() async {
    // loading circle
    showDialog(
      context: context, 
      builder: (context) => const Center(child: CircularProgressIndicator(),),
    );
    // checks for matching passwords
    if (pwdController.text != confPwd.text) {
      Navigator.pop(context);
      displayMessageToUser("Passwords Do Not Match", context);
    } else if(pwdController.text.length < 6){
      Navigator.pop(context);
      displayMessageToUser("Password Too Weak", context);
    } else { // if passwords match, attempts to create an account through Firebase
        try {
          UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: pwdController.text,);
          createUserDocument(userCredential);
          if(context.mounted) Navigator.pop(context);
        } catch (e) { // a catch all for any account acreation issues
          Navigator.pop(context);
          //displayMessageToUser(e, context);
        }  
    }
  }

  void artistAccount() {
    artist = true;
    venue = false;
  }

  void venueAccount() {
    artist = false;
    venue = true;
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    GeoPoint userLoc = await getCurrentLocation();
    if(userCredential != null && userCredential.user != null) {
      if(artist){
        await FirebaseFirestore.instance.collection("Artists").doc(userCredential.user!.email).set({
        'email': userCredential.user!.email,
        'username': userController.text,
        'latitude': userLoc.latitude,
        'longitude': userLoc.longitude
      });
      }
      else if(venue){
        await FirebaseFirestore.instance.collection("Venues").doc(userCredential.user!.email).set({
        'email': userCredential.user!.email,
        'username': userController.text,
      });
      }
      else{
        await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
        'email': userCredential.user!.email,
        'username': userController.text,
        'latitude': userLoc.latitude,
        'longitude': userLoc.longitude
      });
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white, // background color of signup page
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            // blank account picture + spacing on the bottom
            Icon(Icons.person, size: 80, color: Colors.grey),
            const SizedBox(height: 25),

            // DUPLE (app name) + spacing on the bottom
            Text("D U P L E", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 50),

            Row(
              children: [
                SizedBox(
                  width: 170,
                  child: ElevatedButton(
                    onPressed: artistAccount, 
                    child: Text('Artist Signup')
                  ),
                ),

                SizedBox(
                  width: 170,
                  child: ElevatedButton(
                    onPressed: venueAccount, 
                    child: Text('Venue Signup')
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // username textfield + spacing on the bottom
            DupleTextField(hintText: 'Username', obscureText: false, controller: userController),
            const SizedBox(height: 10),

            // email textfield + spacing on the bottom
            DupleTextField(hintText: 'Email', obscureText: false, controller: emailController),
            const SizedBox(height: 10),

            //password textfield + spacing on the bottom
            DupleTextField(hintText: 'Password', obscureText: true, controller: pwdController),
            const SizedBox(height: 10),

            // confirm password textfield + spacing on the bottom
            DupleTextField(hintText: 'Confirm Password', obscureText: true, controller: confPwd),
            const SizedBox(height: 10),

            // sign in + spacing on the bottom
            DupleButton(text: 'Register', onTap: _signup,),
            const SizedBox(height: 10),

            // Creates two text blocks in a row, one asking a question, the other serving as a navbutton to
            // the login page (GestureDetector screens for interaction with the button)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(" Login Here", style: TextStyle(fontWeight: FontWeight.bold)), // navbutton
                )
              ],
            )
            ]
          ),
        ),
      ),
    );
  }
}