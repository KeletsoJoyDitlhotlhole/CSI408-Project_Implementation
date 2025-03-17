import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'signup_screen.dart';
import 'dashboard_screen.dart';
import 'package:medication_compliance_tool/services/token_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TokenService _tokenService = TokenService();

  LoginPage({super.key});

  Future<void> _login(BuildContext context) async {
    final response = await http.post(
      Uri.parse(
        'http://10.220.6.32:8080/realms/csi408-medication-compliance-tool/protocol/openid-connect/token',
      ),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'password',
        'client_id': 'flutter-app-csi408-mct',
        'username': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    if (kDebugMode) {
      print('Response Body: ${response.body}');
    } // Debugging

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      if (kDebugMode) {
        print('Access Token: $accessToken');
      } // Debugging
      await _tokenService.saveToken(accessToken);
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      if (!context.mounted) return;
      _showError(context);
    }
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Invalid Credentials!')));
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
                          'Login',
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
                            controller: _usernameController,
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
                            vertical: screenHeight * 0.02,
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Color(0xFF5F6B6C)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFF5F6B6C),
                                  width: 1.5,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
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
                            onPressed: () => _login(context),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: Color(0xFF6FBF73),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
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
                        Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'New here? ',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Color(0xFF5F6B6C),
                                ),
                              ),
                              GestureDetector(
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignUpPage(),
                                      ),
                                    ),
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(
                                    color: Color(0xFF800000),
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w300,
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
