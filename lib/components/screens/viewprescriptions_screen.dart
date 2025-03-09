import 'package:flutter/material.dart';
import 'package:medication_compliance_tool/database/database_helper.dart';
import 'package:medication_compliance_tool/components/models/viewprescriptions.dart'; // Import ViewPrescriptions model
import 'dashboard_screen.dart'; // Import the Dashboard screen for navigation

class ViewPrescriptionsScreen extends StatefulWidget {
  final String patientID; // Pass the patient ID to fetch their prescriptions

  const ViewPrescriptionsScreen({super.key, required this.patientID});

  @override
  ViewPrescriptionsScreenState createState() => ViewPrescriptionsScreenState();
}

class ViewPrescriptionsScreenState extends State<ViewPrescriptionsScreen> {
  late Future<List<ViewPrescriptions>>
  prescriptions; // Store the fetched prescriptions

  @override
  void initState() {
    super.initState();
    prescriptions =
        fetchPrescriptions(); // Fetch prescriptions when the screen is initialized
  }

  // Fetch prescriptions from the database
  Future<List<ViewPrescriptions>> fetchPrescriptions() async {
    var prescs = await DatabaseHelper.instance.getPrescriptions(
      widget.patientID,
    );
    return prescs
        .map((pres) => ViewPrescriptions.fromMap(pres as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFC3DFE0), // Set background color (C3DFE0)
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center the entire content
            children: [
              SizedBox(
                height: screenHeight * 0.1, // Space at the top
              ),

              // Container for Prescriptions Fields with white background
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // White background behind fields
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey, // Light shadow for a clean look
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // Changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical:
                          screenHeight * 0.05, // Padding for the top and bottom
                      horizontal: screenWidth * 0.05,
                    ),
                    child: Column(
                      children: [
                        // Logo at the top of the white container
                        Container(
                          padding: EdgeInsets.only(
                            bottom:
                                screenHeight *
                                0.04, // Space between logo and medication log
                          ),
                          child: Image.asset(
                            "assets/images/logo_without_name_white.png", // Path to the logo
                            width: screenWidth * 0.6, // Adjust the logo size
                            height:
                                screenHeight * 0.15, // Adjust the logo height
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Header for the View Prescriptions screen
                        Text(
                          'View Prescriptions',
                          style: TextStyle(
                            fontSize:
                                screenWidth *
                                0.08, // Larger font size for header
                            fontWeight: FontWeight.bold,
                            color: Color(
                              0xFF3A3A3A,
                            ), // Dark gray for readability
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ), // Space between heading and the list
                        // Medication Log List View
                        FutureBuilder<List<ViewPrescriptions>>(
                          future: prescriptions, // Simulate fetching data
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                child: Text('No prescriptions found.'),
                              );
                            } else {
                              var prescs = snapshot.data!;
                              return ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 15.0,
                                ), // Add padding for better layout
                                itemCount: prescs.length,
                                shrinkWrap:
                                    true, // Make the ListView fit inside the scrollable area
                                physics:
                                    NeverScrollableScrollPhysics(), // Disable scrolling in ListView
                                itemBuilder: (context, index) {
                                  var prescription = prescs[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    elevation:
                                        2.0, // Add some shadow for elevation
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.05,
                                        vertical: screenHeight * 0.02,
                                      ),
                                      title: Text(
                                        'Medication: ${prescription.medicationName}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF3A3A3A),
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Refill Date: ${prescription.refillDate}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color: Color(0xFF5F6B6C),
                                        ),
                                      ),
                                      trailing: Checkbox(
                                        value:
                                            prescription.isRefilled ==
                                            'Yes', // Assuming "Yes" means refilled
                                        onChanged: (bool? value) {
                                          // Handle checkbox toggle if needed
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Back to Dashboard Button at the bottom
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(),
                      ), // Navigate back to Dashboard
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Color(
                      0xFF6FBF73,
                    ), // Soft greenish-blue color for button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Rounded corners for button
                    ),
                  ),
                  child: Text(
                    'Back to Dashboard',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
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
