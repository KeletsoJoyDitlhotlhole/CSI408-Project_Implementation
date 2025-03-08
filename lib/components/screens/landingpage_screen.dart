import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import the LoginScreen

class LandingPageScreen extends StatefulWidget {
  const LandingPageScreen({super.key});

  @override
  LandingPageScreenState createState() => LandingPageScreenState();
}

class LandingPageScreenState extends State<LandingPageScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Set up the animation controller for logo scaling
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Define the scale animation
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start the animation
    _animationController.forward();

    // Delay navigation to the login screen for 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      // Ensure the widget is still mounted before trying to navigate
      if (mounted) {
        // Navigate to the LoginScreen after 4 seconds
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation, // Apply the scale animation to the widget
          child: Image.asset(
            'assets/images/logo_with_name_blue.png',
          ), // Your logo here
        ),
      ),
    );
  }
}
