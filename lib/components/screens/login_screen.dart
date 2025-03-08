import 'package:flutter/material.dart';
import 'signup_screen.dart'; // Ensure you have the correct path to your signup screen
import 'dashboard_screen.dart'; // Ensure you have the correct path to your dashboard screen

/// A login page widget that displays an image with specific styling.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the height of the status bar (top padding) using MediaQuery
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: statusBarHeight,
        ), // Adjust based on the status bar height
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
          children: [
            // Logo with reduced space to the top-left corner
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                top: 10,
              ), // Further reduce space to the top and left
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Adjust aspect ratio based on screen width
                  double aspectRatio = constraints.maxWidth > 600 ? 0.45 : 0.65;
                  return AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        "logo_without_name_blue.png", // Use your logo image here
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Username Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            // Password Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                obscureText: true, // Hide the text for password input
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ),
            // Login Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the Dashboard when the login button is pressed
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
                  backgroundColor:
                      Colors.blue, // Customize button color as needed
                ),
                child: Text('Login'),
              ),
            ),
            // Spacer to push the content down if needed
            Expanded(child: Container()),
            // Row with "New here?" and "Create Account"
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Align the texts at the center
                children: [
                  Text(
                    'New here? ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black, // Customize the color as needed
                    ),
                  ),
                  // Create Account TextButton
                  GestureDetector(
                    onTap: () {
                      // Navigate to the Signup page when clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.red, // Change the color to red
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
