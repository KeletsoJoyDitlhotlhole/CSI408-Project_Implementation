import 'package:flutter/material.dart';
import 'viewprescriptions_screen.dart';
import 'logintake_screen.dart';
import 'refilldates_screen.dart';
import 'login_screen.dart';

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
      title: 'Medication Compliance Tool',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState(); // Use public state class here
}

class DashboardState extends State<Dashboard> {
  // Make this class public by removing underscore
  // Track hovered card index for desktop
  int _hoveredIndex = -1;

  String patientID = getLoggedInPatientID();

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Adjust the logo size based on screen width
    double logoSize = screenWidth > 600 ? 70.0 : 60.0; // Increase logo size

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back button
        title: Image.asset(
          'assets/images/logo_with_name_white.png', // Your logo path
          height: logoSize, // Adjust logo size for responsiveness
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Transparent background
        elevation: 0, // No shadow
        actions: [
          // Logout button
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // Set the background color to white
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dashboard Title (Centered and light color)
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize:
                    screenWidth > 600
                        ? 28
                        : 24, // Adjust title font size based on screen size
                fontWeight: FontWeight.w500,
                color: Colors.black54, // Light text color
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ), // Space between title and the cards

            Spacer(), // Push content to the bottom
            // View Prescriptions Card
            _buildDashboardCard(
              context,
              'View Prescriptions',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ViewPrescriptionsScreen(patientID: patientID),
                  ),
                );
              },
              0, // Hover effect on first card
              screenWidth, // Pass screen width for responsiveness
            ),

            SizedBox(height: screenHeight * 0.02), // Space between cards
            // Log Medication Intake Card
            _buildDashboardCard(
              context,
              'Log Medication Intake',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogIntakeScreen(patientID: patientID),
                  ),
                );
              },
              1, // Hover effect on second card
              screenWidth, // Pass screen width for responsiveness
            ),

            SizedBox(height: screenHeight * 0.02), // Space between cards
            // View Refill Dates Card
            _buildDashboardCard(
              context,
              'View Refill Dates',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RefillScreen()),
                );
              },
              2, // Hover effect on third card
              screenWidth, // Pass screen width for responsiveness
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  // Helper function to create a card with title and action
  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    VoidCallback onTap,
    int index, // Index of the card
    double screenWidth, // Pass screenWidth for responsiveness
  ) {
    bool isHovered = _hoveredIndex == index;
    // For mobile devices, no hover effect will work, only onTap.
    if (screenWidth <= 600) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), // Slightly rounded corners
            color: Color(0xFFADD8E6), // Light blue color for the card
            boxShadow: [
              BoxShadow(
                color: Colors.grey, // Subtle shadow color
                blurRadius: 8, // Softer blur
                spreadRadius: 2, // Slight spread
                offset: Offset(0, 4), // Slight offset for depth
              ),
            ],
          ),
          padding: EdgeInsets.all(12), // Thinner cards with less padding
          height: 100, // Slightly smaller card height
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16, // Smaller font size for modern look
                fontWeight: FontWeight.w600,
                color: Colors.black, // Black text by default
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _hoveredIndex = index;
            });
          },
          onExit: (_) {
            setState(() {
              _hoveredIndex = -1;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                12,
              ), // Slightly rounded corners
              color:
                  isHovered
                      ? Color(0xFF9E4A47) // Light maroon when hovered
                      : Color(0xFFADD8E6), // Light blue color for the card
              boxShadow: [
                BoxShadow(
                  color: Colors.grey, // Subtle shadow color
                  blurRadius: 8, // Softer blur
                  spreadRadius: 2, // Slight spread
                  offset: Offset(0, 4), // Slight offset for depth
                ),
              ],
            ),
            padding: EdgeInsets.all(12), // Thinner cards with less padding
            height: 100, // Slightly smaller card height
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16, // Smaller font size for modern look
                  fontWeight: FontWeight.w600,
                  color:
                      isHovered
                          ? Colors.white
                          : Colors.black, // White text on hover
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }
  }
}
