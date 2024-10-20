// ignore_for_file: unused_element, prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'package:duple/components/duple_button.dart';
import 'package:duple/components/duple_textfield.dart';
import 'package:duple/helper/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController pwdController = TextEditingController();

  final TextEditingController zipController = TextEditingController();

  void _login() async {
    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator(),));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: pwdController.text);
      if (context.mounted) {Navigator.pop(context);}
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            // logo
            Icon(Icons.person, size: 80, color: Colors.grey),
          
            const SizedBox(height: 25),
            // app name
            Text("D U P L E", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 50),
            // email textfield
            DupleTextField(hintText: 'Email', obscureText: false, controller: emailController),
            const SizedBox(height: 10),
            //password textfield
            DupleTextField(hintText: 'Password', obscureText: true, controller: pwdController),
            const SizedBox(height: 10),

            // forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Forgot Password?"),
              ],
            ),
            const SizedBox(height: 15),

            // sign in
            DupleButton(text: 'Login', onTap: _login,),
            const SizedBox(height: 10),

            // register account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(" Register Here", style: TextStyle(fontWeight: FontWeight.bold)),
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