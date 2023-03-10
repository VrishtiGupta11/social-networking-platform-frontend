import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_networking/Authentication/login-page.dart';
import 'package:social_networking/Authentication/register-page.dart';
import 'package:social_networking/Pages/events-page.dart';
import 'package:social_networking/Pages/explore-page.dart';
import 'package:social_networking/Pages/profile-page.dart';
import 'package:social_networking/Pages/splash-page.dart';
import 'package:social_networking/Pages/view-event-page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Networking Platform',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
      routes: {
        SplashPage.route : (context) => SplashPage(),
        LoginPage.route : (context) => LoginPage(),
        RegisterPage.route :(context) => RegisterPage(),
        EventsPage.route : (context) => EventsPage(),
        ProfilePage.route : (context) => ProfilePage(),
        ExplorePage.route : (context) => ExplorePage(),
        ViewEventPage.route : (context) => ViewEventPage(),
      },
    );
  }
}

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
  };
}
