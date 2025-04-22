import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:barcode_scan_app/app/modules/home/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Image.asset('assets/icon.png', width: 200, height: 200),
      ),
      splashIconSize: 250,
      duration: 2500,
      splashTransition: SplashTransition.scaleTransition,
      animationDuration: Duration(milliseconds: 800),
      nextScreen: HomeScreen(),
    );
  }
}
