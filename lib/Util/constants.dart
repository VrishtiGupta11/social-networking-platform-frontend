library social_networking_platform;
import 'package:flutter/material.dart';
import 'package:social_networking/Model/user.dart';

class ShowSnackBar{
  String? message;
  ShowSnackBar({required BuildContext context, @required this.message}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message!)));
  }
}

bool isLoggedIn = false;
User? user;