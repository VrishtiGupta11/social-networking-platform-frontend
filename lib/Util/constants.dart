import 'package:flutter/material.dart';
import 'package:social_networking/Model/user.dart';

class ShowSnackBar{
  String? message;
  ShowSnackBar({required BuildContext context, @required this.message}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message!)));
  }
}

class Util {
  static bool isLoggedIn = false;
  static User user = User();
}