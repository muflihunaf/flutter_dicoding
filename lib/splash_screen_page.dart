import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurant_app/home_page.dart';
import 'package:lottie/lottie.dart';

class SplashScreenPage extends StatefulWidget {
  static const routeName = '/splashScreen';
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
        () => Navigator.pushReplacementNamed(context, HomePage.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellowAccent,
      body: Center(
        child: Lottie.asset(
          'assets/delivery.json',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
