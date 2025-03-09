import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For modifying system UI overlays
import 'package:medication_compliance_tool/components/screens/signedup_screen.dart'; // Add the path to your success screen

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController(); // Confirm password
  final TextEditingController _idController =
      TextEditingController(); // Added ID controller

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Integrate Keycloak authentication for passwords and save other patient data to SQLite

      // Navigate to success screen after sign-up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignedUp(),
        ), // Redirect to success screen
      );
    }
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    // Set status bar color to #C3DFE0 (light greenish)
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFFC3DFE0), // Light greenish color
        statusBarIconBrightness: Brightness.dark, // To make icons visible
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Color(0xFFC3DFE0), // AppBar color
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/logo_with_name_white.png",
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.2,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                Container(
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
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Added ID field first
                        TextFormField(
                          controller: _idController,
                          decoration: InputDecoration(
                            labelText: 'ID (OMANG/Passport/Birth Certificate)',
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) => value!.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) => value!.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _surnameController,
                          decoration: InputDecoration(
                            labelText: 'Surname',
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) => value!.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _dobController,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.datetime,
                          validator:
                              (value) => value!.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _genderController,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) => value!.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator:
                              (value) => value!.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator:
                              (value) =>
                                  value!.length < 6 ? 'Min 6 chars' : null,
                        ),
                        SizedBox(height: 10),
                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: _validateConfirmPassword,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Color(0xFFC3DFE0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
