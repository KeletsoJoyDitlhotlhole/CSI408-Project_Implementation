import 'package:flutter/material.dart';
import 'viewprescriptions_screen.dart';
import 'logintake_screen.dart';
import 'refilldates_screen.dart'; // Make sure to import the correct screen
import 'login_screen.dart';

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
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  // Track hovered card index for desktop
  int _hoveredIndex = -1;

  String patientID = getLoggedInPatientID();

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back button
        backgroundColor: Colors.transparent, // Transparent background
        elevation: 0, // No shadow
        actions: [
          // Logout button with three dots (more_vert)
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
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
      body: Center(
        // Center the body content vertically and horizontally
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.05,
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the content vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center the content horizontally
            children: [
              // Dashboard Logo and Title Bar
              Column(
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      'assets/images/logo_with_name_white.png', // Path to your logo
                      height:
                          200, // Set the height to 4 times larger (200 instead of 50)
                    ),
                  ),
                  SizedBox(height: 20), // Space between logo and title
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize:
                          screenWidth > 600
                              ? 28
                              : 24, // Adjust title font size based on screen size
                      fontWeight: FontWeight.bold, // Make the title bold
                      color: Colors.black, // Light text color
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ), // Space between title and the cards
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
                      builder:
                          (context) => LogIntakeScreen(patientID: patientID),
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
                    MaterialPageRoute(
                      builder:
                          (context) => RefillDatesScreen(
                            patientID: patientID,
                          ), // Corrected navigation
                    ),
                  );
                },
                2, // Hover effect on third card
                screenWidth, // Pass screen width for responsiveness
              ),
            ],
          ),
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
                fontWeight: FontWeight.normal, // Unbold the card title
                color: Colors.black, // Black text by default
              ),
              textAlign: TextAlign.center, // Center the text
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
                  fontWeight: FontWeight.normal, // Unbold the card title
                  color:
                      isHovered
                          ? Colors.white
                          : Colors.black, // White text on hover
                ),
                textAlign: TextAlign.center, // Center the text
              ),
            ),
          ),
        ),
      );
    }
  }
}
