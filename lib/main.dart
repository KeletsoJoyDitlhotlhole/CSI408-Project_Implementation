import 'package:flutter/material.dart';
import 'package:medication_compliance_tool/components/screens/landingpage_screen.dart'; // Ensure this path is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes debug banner
      title: 'Medication Compliance Tool',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LandingPageScreen(), // Load Landing Page first
    );
  }
}
