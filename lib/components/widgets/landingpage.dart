import 'package:flutter/material.dart';
import 'package:medication_compliance_tool/components/screens/login_screen.dart'; // Ensure this is the correct path to your login page

class LandingPageWidget extends StatefulWidget {
  const LandingPageWidget({super.key});

  @override
  LandingPageWidgetState createState() => LandingPageWidgetState();
}

class LandingPageWidgetState extends State<LandingPageWidget> {
  @override
  void initState() {
    super.initState();
    // Start the delay for navigation after 6 seconds
    Future.delayed(Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC3DFE0), // Set background color
      body: Center(
        child: Image.asset(
          'assets/images/logo_with_name_white.png',
          width: MediaQuery.of(context).size.width * 0.6,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
