import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'resettedpassword_screen.dart'; // Import the success page

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> {
  // Changed from _ResetPasswordPageState to ResetPasswordPageState
  final TextEditingController _emailController = TextEditingController();

  // Send password reset request
  Future<void> _resetPassword(BuildContext context) async {
    final response = await http.post(
      Uri.parse(
        'http://10.220.6.32:8080/realms/csi408-medication-compliance-tool/protocol/openid-connect/reset-password',
      ), // Replace with actual reset endpoint
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'email': _emailController.text},
    );

    if (response.statusCode == 200) {
      // If successful, navigate to the success page
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  ResetPasswordSuccessPage(email: _emailController.text),
        ),
      );
    } else {
      // Show error message if password reset fails
      // ignore: use_build_context_synchronously
      _showError(context);
    }
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Error resetting password!')));
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
                            vertical: screenHeight * 0.03,
                          ),
                          child: ElevatedButton(
                            onPressed: () => _resetPassword(context),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: Color(0xFF6FBF73),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
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
