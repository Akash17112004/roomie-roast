import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
  Navigator.pushReplacementNamed(context, '/login');
});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.home_work_rounded,
                size: 90, color: Color(0xff7b61ff)),
            SizedBox(height: 20),
            Text(
              "Roomie Roast",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Flatmate chaos, organized beautifully.",
              style: TextStyle(color: Colors.white70),
            )
          ],
        ),
      ),
    );
  }
}