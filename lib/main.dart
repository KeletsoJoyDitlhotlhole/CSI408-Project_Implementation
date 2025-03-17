import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
import 'package:medication_compliance_tool/components/screens/landingpage_screen.dart'; // Ensure this path is correct

Future<void> main() async {
  // Load the .env file
  await dotenv.load(fileName: "config/.env");

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
