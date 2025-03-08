import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medication_compliance_tool/components/screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set status bar to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Medication Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use Color.fromRGBO() to define the color
        primarySwatch: MaterialColor(
          0xFFC3DFE0, // The color code in hex (C3DFE0)
          {
            50: Color(0xFFC3DFE0), // Lightest shade
            100: Color(0xFFC3DFE0),
            200: Color(0xFFC3DFE0),
            300: Color(0xFFC3DFE0),
            400: Color(0xFFC3DFE0),
            500: Color(0xFFC3DFE0),
            600: Color(0xFFC3DFE0),
            700: Color(0xFFC3DFE0),
            800: Color(0xFFC3DFE0),
            900: Color(0xFFC3DFE0), // Darkest shade
          },
        ),
        fontFamily: 'Manrope',
      ),
      home: const SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFF5F5F5),
          body: Center(child: Dashboard()),
        ),
      ),
    );
  }
}
