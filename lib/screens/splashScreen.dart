import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kaza_app/screens/wrapper.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = "//Splash-Screen";

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, Wrapper.routeName);
    });
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.orange,
          Colors.deepOrange,
        ], begin: Alignment.topLeft),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: Image(
                color: Colors.white,
                height: 150.0,
                image: AssetImage('lib/assets/images/kaza-logo.png'),
              ),
            ),
            Text(
              'Enhancing one\'s experience of the world',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
      ),
    );
  }
}
