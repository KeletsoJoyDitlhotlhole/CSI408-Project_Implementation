import 'package:flutter/material.dart';

class LandingPageWidget extends StatelessWidget {
  const LandingPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 640;

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        width: isSmallScreen ? screenSize.width : 360,
        height: isSmallScreen ? screenSize.height : 800,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            // Logo Image with cool effects
            Positioned(
              top: 180,
              left: isSmallScreen ? screenSize.width * 0.1 : 15,
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(seconds: 2),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Image.asset(
                    'assets/images/logo_with_name_blue.png',
                    width: isSmallScreen ? screenSize.width * 0.8 : 320,
                    height: isSmallScreen ? null : 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
