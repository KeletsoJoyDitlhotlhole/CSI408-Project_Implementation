import 'package:flutter/material.dart';
import 'package:medication_compliance_tool/components/models/medicationlog.dart';
import 'package:medication_compliance_tool/database/database_helper.dart';
import 'dashboard_screen.dart'; // Import the Dashboard screen for navigation

class ViewMedicationHistoryScreen extends StatefulWidget {
  final String
  patientID; // Pass the patient ID to fetch their medication history

  const ViewMedicationHistoryScreen({super.key, required this.patientID});

  @override
  ViewMedicationHistoryScreenState createState() =>
      ViewMedicationHistoryScreenState();
}

class ViewMedicationHistoryScreenState
    extends State<ViewMedicationHistoryScreen> {
  late Future<List<MedicationLog>>
  medicationHistory; // Store the fetched medication history

  @override
  void initState() {
    super.initState();
    medicationHistory =
        fetchMedicationHistory(); // Fetch medication history when the screen is initialized
  }

  // Fetch medication history from the database
  Future<List<MedicationLog>> fetchMedicationHistory() async {
    var history = await DatabaseHelper.instance.getMedicationHistory(
      widget.patientID,
    );
    return history
        .map((historyItem) => MedicationLog.fromMap(historyItem))
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

              // Container for Medication History Fields with white background
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
                                0.04, // Space between logo and medication history log
                          ),
                          child: Image.asset(
                            "assets/images/logo_without_name_white.png", // Path to the logo
                            width: screenWidth * 0.6, // Adjust the logo size
                            height:
                                screenHeight * 0.15, // Adjust the logo height
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Header for the View Medication History screen
                        Text(
                          'View Medication History',
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
                        // Medication History Log List View
                        FutureBuilder<List<MedicationLog>>(
                          future:
                              medicationHistory, // Fetch data asynchronously
                          builder: (context, snapshot) {
                            // Loading state
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            // Error state
                            else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }
                            // No data available
                            else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                child: Text('No medication history found.'),
                              );
                            }
                            // Data available
                            else {
                              var history = snapshot.data!;
                              return ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 15.0,
                                ),
                                itemCount: history.length,
                                shrinkWrap:
                                    true, // Make the ListView fit inside the scrollable area
                                physics:
                                    NeverScrollableScrollPhysics(), // Disable scrolling in ListView
                                itemBuilder: (context, index) {
                                  var medHistory = history[index];
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
                                        'Medication: ${medHistory.medicationName}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF3A3A3A),
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Taken on: ${medHistory.logDate}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color: Color(0xFF5F6B6C),
                                        ),
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
