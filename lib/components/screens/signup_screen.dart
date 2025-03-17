import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:medication_compliance_tool/components/screens/signedup_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      TextEditingController();
  final TextEditingController _idController = TextEditingController();

  // Fetch environment variables
  String get keycloakUrl => dotenv.get('KEYCLOAK_URL');
  String get keycloakRealm => dotenv.get('KEYCLOAK_REALM');
  String get keycloakClientId => dotenv.get('KEYCLOAK_CLIENT_ID');
  String get keycloakAdminUsername => dotenv.get('KEYCLOAK_ADMIN_USERNAME');
  String get keycloakAdminPassword => dotenv.get('KEYCLOAK_ADMIN_PASSWORD');

  Future<String> getAdminAccessToken() async {
    final response = await http.post(
      Uri.parse(
        '$keycloakUrl/realms/$keycloakRealm/protocol/openid-connect/token',
      ),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id':
            'admin-cli', // The admin-cli client is used for admin purposes
        'username': keycloakAdminUsername,
        'password': keycloakAdminPassword,
        'grant_type': 'password',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to get admin access token');
    }
  }

  Future<void> createUser(Map<String, String> userData) async {
    final adminAccessToken = await getAdminAccessToken();

    final response = await http.post(
      Uri.parse('$keycloakUrl/admin/realms/$keycloakRealm/users'),
      headers: {
        'Authorization': 'Bearer $adminAccessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': userData['Patient_ID'],
        'enabled': true,
        'firstName': userData['Patient_Name'],
        'lastName': userData['Patient_Surname'],
        'email': '',
        'credentials': [
          {
            'type': 'password',
            'value': userData['password'],
            'temporary': false,
          },
        ],
      }),
    );

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print('User created successfully');
      }
    } else {
      if (kDebugMode) {
        print('Failed to create user: ${response.body}');
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final userData = {
        'Patient_ID': _idController.text,
        'Patient_Name': _firstNameController.text,
        'Patient_Surname': _surnameController.text,
        'Patient_DoB': _dobController.text,
        'Patient_Gender': _genderController.text,
        'Patient_PhoneNumber': _phoneNumberController.text,
        'password': _passwordController.text,
      };

      createUser(userData)
          .then((_) {
            Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => SignedUp()),
            );
          })
          .catchError((error) {
            if (kDebugMode) {
              print('Error: $error');
            }
          });
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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFFC3DFE0),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    dotenv.load(); // Load environment variables
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Color(0xFFC3DFE0),
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
