import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  static String route = '/';
  const SplashPage({Key? key}) : super(key: key);

  navigateToHome(BuildContext context) {
    Future.delayed(Duration(seconds: 4), () {
      // Navigator.pushReplacementNamed(context, '/events');
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Util.fetchUserDetails();
    navigateToHome(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "social-networking.png",
              fit: BoxFit.cover,
              height: 300,
              width: 300,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              },
            ),
            CupertinoActivityIndicator()
          ],
        ),
      ),
    );
  }
}