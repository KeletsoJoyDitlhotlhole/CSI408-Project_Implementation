import 'package:flutter/material.dart';
import 'viewprescriptions_screen.dart';
import 'logintake_screen.dart';
import 'refilldates_screen.dart';

// Mock method to get logged-in user's patientID (replace this with your actual logic)
String getLoggedInPatientID() {
  return 'Pat001'; // Example patientID for the logged-in user
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication Compliance Tool', // Set a default app title
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the logged-in user's patientID dynamically
    String patientID = getLoggedInPatientID();

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        // Use the logo image in the AppBar instead of a title
        title: Image.asset(
          'assets/images/logo_with_name_white.png', // Your logo path
          height: 40, // Adjust the logo height as needed
        ),
        centerTitle: true, // This will center the logo in the AppBar
        backgroundColor:
            Colors.white, // Optional: Set a background color for the AppBar
        elevation: 0, // Optional: Remove the elevation (shadow)
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $patientID!', // Display the patientID
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 70),

            // View Prescriptions Card
            Card(
              elevation: 8, // Add shadow for elevation
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Round the corners
              ),
              color: Color.fromRGBO(
                195,
                223,
                224,
                1,
              ), // Set card background color
              child: Container(
                height: 120, // Increase the card's height
                padding: EdgeInsets.all(30), // More padding inside the card
                child: ListTile(
                  title: Text(
                    'View Prescriptions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center, // Adjust text size
                  ),
                  onTap: () {
                    // Navigate to ViewPrescriptionsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ViewPrescriptionsScreen(patientID: patientID),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16), // Add space between cards
            // Log Medication Intake Card
            Card(
              elevation: 8, // Add shadow for elevation
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Round the corners
              ),
              color: Color.fromRGBO(
                195,
                223,
                224,
                1,
              ), // Set card background color
              child: Container(
                height: 120, // Increase the card's height
                padding: EdgeInsets.all(24), // More padding inside the card
                child: ListTile(
                  title: Text(
                    'Log Medication Intake',
                    style: TextStyle(fontSize: 18), // Adjust text size
                  ),
                  onTap: () {
                    // Pass the dynamic patientID to LogIntakeScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => LogIntakeScreen(patientID: patientID),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16), // Add space between cards
            // View Refill Dates Card
            Card(
              elevation: 8, // Add shadow for elevation
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Round the corners
              ),
              color: Color.fromRGBO(
                195,
                223,
                224,
                1,
              ), // Set card background color
              child: Container(
                height: 120, // Increase the card's height
                padding: EdgeInsets.all(24), // More padding inside the card
                child: ListTile(
                  title: Text(
                    'View Refill Dates',
                    style: TextStyle(fontSize: 18), // Adjust text size
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RefillScreen()),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
