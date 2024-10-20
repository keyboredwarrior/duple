// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// error msg
void displayMessageToUser(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message),
    )
  );
}