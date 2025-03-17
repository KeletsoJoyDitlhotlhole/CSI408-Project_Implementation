import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import login screen for navigation

class ResetPasswordSuccessPage extends StatelessWidget {
  final String email;

  const ResetPasswordSuccessPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFC3DFE0),
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.05,
                      horizontal: screenWidth * 0.05,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.04),
                          child: Image.asset(
                            "assets/images/logo_with_name_white.png",
                            width: screenWidth * 0.6,
                            height: screenHeight * 0.2,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          'Password Reset Success',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A3A3A),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                          child: Text(
                            'A password reset link has been sent to your email: $email',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Color(0xFF5F6B6C),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.03,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate back to login screen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: Color(0xFF6FBF73),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Go to Login',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
