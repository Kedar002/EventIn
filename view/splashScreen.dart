import 'dart:async';
import 'package:eventin/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      // Navigate to the desired screen after the splash screen is displayed
      // For example, you can use Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Set the background color of the splash screen
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SizedBox(
            //     height: 80,
            //     width: 250,
            //     child: Image.asset('assets/bsky_logo_with_name.png')),
            // SizedBox(
            //   height: 30,
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Center(
                child: Image.asset(
                    'assets/eventin_splashscreen.jpg'), // Load and display the logo image
              ),
            ),
            SizedBox(
              height: 30,
            ),
            // Text(
            //   'Event Passport',
            //   style: GoogleFonts.manrope(
            //       fontSize: 32,
            //       fontWeight: FontWeight.w500,
            //       color: Color(0xff0C5CBA)),
            // ),
            // SizedBox(
            //   height: 30,
            // ),
            // Center(
            //   child: CircularProgressIndicator(
            //     valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            //   ),
            // ),
            // SizedBox(
            //   height: 60,
            // ),
            Row(
              children: [
                Spacer(),
                Icon(
                  Icons.copyright,
                  color: MyTheme.secondaryColor,
                  size: 12,
                ),
                Text(
                  'Fast Trade Technologies',
                  style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: MyTheme.secondaryColor),
                  // color: Color(0xff0C5CBA)),
                ),
                Spacer()
              ],
            ),
            // Text(
            //   'Version: 1.0.0',
            //   style: GoogleFonts.manrope(
            //       fontSize: 16,
            //       fontWeight: FontWeight.w700,
            //       color: Color(0xff0C5CBA)),
            // ),
          ],
        ),
      ),
    );
  }
}
