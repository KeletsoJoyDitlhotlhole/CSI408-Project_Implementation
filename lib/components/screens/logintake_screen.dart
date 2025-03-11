import 'package:flutter/material.dart';
import 'package:medication_compliance_tool/database/database_helper.dart';
import 'package:medication_compliance_tool/components/models/medicationschedule.dart';
import 'dashboard_screen.dart'; // Import the Dashboard screen for navigation

class LogIntakeScreen extends StatefulWidget {
  final String
  patientID; // Pass the patient ID to fetch their medication schedule

  const LogIntakeScreen({super.key, required this.patientID});

  @override
  LogIntakeScreenState createState() => LogIntakeScreenState(); // Updated here
}

class LogIntakeScreenState extends State<LogIntakeScreen> {
  late Future<List<MedicationSchedule>>
  medicationSchedules; // Store the fetched schedules

  @override
  void initState() {
    super.initState();
    medicationSchedules = fetchMedicationSchedules();
  }

  // Fetch medication schedules from the database
  Future<List<MedicationSchedule>> fetchMedicationSchedules() async {
    var schedules = await DatabaseHelper.instance.getMedicationSchedules(
      widget.patientID,
    );
    return schedules
        .map((schedule) => MedicationSchedule.fromMap(schedule))
        .toList();
  }

  // Method to handle checkbox toggle and update the database
  Future<void> logMedicationIntake(String scheduleID, bool isLogged) async {
    // Instead of 'Yes'/'No', directly store the bool value in the database
    await DatabaseHelper.instance.updateMedicationLog(scheduleID, isLogged);
    setState(() {}); // Rebuild the UI to reflect the changes
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

              // Container for Medication Fields with white background
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

                        // Header for the Log Medication Intake screen
                        Text(
                          'Log Medication Intake',
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
                        FutureBuilder<List<MedicationSchedule>>(
                          future: medicationSchedules, // Simulate fetching data
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
                                child: Text('No medication schedule found.'),
                              );
                            } else {
                              var schedules = snapshot.data!;
                              return ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 15.0,
                                ), // Add padding for better layout
                                itemCount: schedules.length,
                                shrinkWrap:
                                    true, // Make the ListView fit inside the scrollable area
                                physics:
                                    NeverScrollableScrollPhysics(), // Disable scrolling in ListView
                                itemBuilder: (context, index) {
                                  var schedule = schedules[index];
                                  return Card(
                                    // Wrap ListTile in a Card for better appearance
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    elevation:
                                        2.0, // Add some shadow for elevation
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.05,
                                        vertical: screenHeight * 0.02,
                                      ),
                                      title: Text(
                                        'Medication: ${schedule.medicationName}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.05,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF3A3A3A),
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Time: ${schedule.scheduleTime}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color: Color(0xFF5F6B6C),
                                        ),
                                      ),
                                      trailing: Checkbox(
                                        value:
                                            schedule.isTaken ==
                                            'Yes', // Assuming "Yes" means taken
                                        onChanged: (bool? value) {
                                          logMedicationIntake(
                                            schedule.scheduleID,
                                            value ?? false,
                                          );
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
