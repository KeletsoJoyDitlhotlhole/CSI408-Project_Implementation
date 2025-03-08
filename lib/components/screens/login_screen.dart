import 'package:flutter/material.dart';
import 'signup_screen.dart'; // Ensure you have the correct path to your signup screen
import 'dashboard_screen.dart'; // Ensure you have the correct path to your dashboard screen

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFC3DFE0), // Set background color (C3DFE0)
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center the entire content
            children: [
              SizedBox(
                height:
                    screenHeight * 0.1, // Space at the top (where the logo was)
              ),

              // Container for Login Fields with white background
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // White background behind fields
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey, // Light shadow for a clean look
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical:
                          screenHeight *
                          0.05, // Add padding to the top and bottom
                      horizontal: screenWidth * 0.05,
                    ),
                    child: Column(
                      children: [
                        // Logo at the top of the white container
                        Container(
                          padding: EdgeInsets.only(
                            bottom: screenHeight * 0.04,
                          ), // Space between logo and login fields
                          child: Image.asset(
                            "assets/images/logo_with_name_white.png", // Path to the logo
                            width: screenWidth * 0.6, // Adjust the logo size
                            height:
                                screenHeight * 0.2, // Adjust the logo height
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Login Heading
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize:
                                screenWidth *
                                0.08, // Larger font size for login text
                            fontWeight: FontWeight.bold,
                            color: Color(
                              0xFF3A3A3A,
                            ), // Dark gray for better readability
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ), // Space between heading and fields
                        // Username Field
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                color: Color(
                                  0xFF5F6B6C,
                                ), // Muted dark green color for labels
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(
                                    0xFF5F6B6C,
                                  ), // Muted border color
                                  width: 1.5,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color(
                                  0xFF5F6B6C,
                                ), // Matching color for icon
                              ),
                            ),
                          ),
                        ),

                        // Password Field
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Color(
                                  0xFF5F6B6C,
                                ), // Muted dark green color for labels
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(
                                    0xFF5F6B6C,
                                  ), // Muted border color
                                  width: 1.5,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Color(
                                  0xFF5F6B6C,
                                ), // Matching color for icon
                              ),
                            ),
                          ),
                        ),

                        // Login Button
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.03,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          Dashboard(), // Navigate to DashboardScreen
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: Color(
                                0xFF6FBF73,
                              ), // Soft greenish-blue color for button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ), // Rounded corners for button
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // Row with "New here?" and "Create Account"
                        Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'New here? ',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Color(
                                    0xFF5F6B6C,
                                  ), // Muted text color for better contrast
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignupScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(
                                    color: Color(
                                      0xFF800000,
                                    ), // Maroon for "Create Account"
                                    fontSize: screenWidth * 0.04,
                                    fontWeight:
                                        FontWeight
                                            .w300, // Lighter font weight for "Create Account"
                                  ),
                                ),
                              ),
                            ],
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
