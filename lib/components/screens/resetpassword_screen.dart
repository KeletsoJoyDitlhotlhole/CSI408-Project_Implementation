import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For json.encode()
import 'resettedpassword_screen.dart'; // Import the success page

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool isLoading = false; // To show a loading spinner

  // Send password reset request
  Future<void> _resetPassword(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String username = _usernameController.text.trim();

    // Validate that at least one field is filled (either email or username)
    if (email.isEmpty && username.isEmpty) {
      _showError(context, 'Please enter either an email or a username.');
      return;
    }

    // Set loading state to true
    setState(() {
      isLoading = true;
    });

    // Build request body
    final Map<String, String> body = {};
    if (email.isNotEmpty) {
      body['email'] = email;
    }
    if (username.isNotEmpty) {
      body['username'] = username;
    }

    try {
      final response = await http.post(
        Uri.parse(
          'http://10.220.6.32:3000/reset-password-request', // Corrected URL for password reset request
        ),
        headers: {
          'Content-Type': 'application/json',
        }, // Ensure correct Content-Type for JSON
        body: json.encode(body), // Encode the body as JSON
      );

      // Reset loading state
      setState(() {
        isLoading = false;
      });

      // Debugging: Log the response status code and body
      if (kDebugMode) {
        print("Response status code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("Response body: ${response.body}");
      }

      if (response.statusCode == 200) {
        // If successful, navigate to the success page
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder:
                (context) => ResetPasswordSuccessPage(
                  email: email.isNotEmpty ? email : username,
                ),
          ),
        );
      } else {
        // Show error message if password reset fails
        // ignore: use_build_context_synchronously
        _showError(context, 'Error resetting password. ${response.body}');
      }
    } catch (e) {
      // Reset loading state if request fails
      setState(() {
        isLoading = false;
      });
      _showError(
        // ignore: use_build_context_synchronously
        context,
        'Failed to send password reset request. Please try again. Error: $e',
      );
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

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
                          'Reset Password',
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
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Color(0xFF5F6B6C)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFF5F6B6C),
                                  width: 1.5,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Color(0xFF5F6B6C),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                          child: TextFormField(
                            controller:
                                _usernameController, // Added username input field
                            decoration: InputDecoration(
                              labelText: 'Username',
                              labelStyle: TextStyle(color: Color(0xFF5F6B6C)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFF5F6B6C),
                                  width: 1.5,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Color(0xFF5F6B6C),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.03,
                          ),
                          child: ElevatedButton(
                            onPressed:
                                isLoading
                                    ? null
                                    : () => _resetPassword(
                                      context,
                                    ), // Disable button when loading
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: Color(0xFF6FBF73),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child:
                                isLoading
                                    ? CircularProgressIndicator() // Show loading spinner
                                    : Text(
                                      'Reset Password',
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
