import 'package:flutter/material.dart';
import 'login_screen.dart'; // Ensure you have the LoginPage imported

class LandingPageScreen extends StatefulWidget {
  const LandingPageScreen({super.key});

  @override
  LandingPageScreenState createState() => LandingPageScreenState();
}

class LandingPageScreenState extends State<LandingPageScreen> {
  @override
  void initState() {
    super.initState();

    // Delay navigation to the login screen for 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      // Ensure the widget is still mounted before trying to navigate
      if (mounted) {
        // Navigate to the LoginScreen after 5 seconds
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFC3DFE0,
      ), // Set background color to #C3DFE0
      body: Center(
        child: Image.asset(
          'assets/images/logo_with_name_blue.png',
        ), // Logo image
      ),
    );
  }
}
