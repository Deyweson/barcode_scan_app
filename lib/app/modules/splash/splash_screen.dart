import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:barcode_scan_app/app/modules/home/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Column(
          children: [
            Text(
              'Bem vindo ao \n Barcode Scan App',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Icon(Icons.barcode_reader, size: 100, color: Colors.red),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      splashIconSize: 250,
      duration: 5000,
      splashTransition: SplashTransition.scaleTransition,
      animationDuration: Duration(milliseconds: 800),
      nextScreen: HomeScreen(),
    );
  }
}
