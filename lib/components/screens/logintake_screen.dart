import 'package:flutter/material.dart';

class MedicationSchedule {
  final String medicationName;
  final String scheduleTime;
  final String scheduleID;
  String isTaken; // Make isTaken mutable to update the value dynamically

  MedicationSchedule({
    required this.medicationName,
    required this.scheduleTime,
    required this.scheduleID,
    required this.isTaken,
  });
}

class LogIntakeScreen extends StatefulWidget {
  final String
  patientID; // Pass the patient ID to fetch their medication schedule

  const LogIntakeScreen({super.key, required this.patientID});

  @override
  LogIntakeScreenState createState() => LogIntakeScreenState(); // Updated here
}

class LogIntakeScreenState extends State<LogIntakeScreen> {
  // Hardcoded list of medication schedules for UI preview
  final List<MedicationSchedule> medicationSchedules = [
    MedicationSchedule(
      medicationName: 'Aspirin',
      scheduleTime: '8:00 AM',
      scheduleID: '1',
      isTaken: 'No',
    ),
    MedicationSchedule(
      medicationName: 'Vitamin D',
      scheduleTime: '12:00 PM',
      scheduleID: '2',
      isTaken: 'Yes',
    ),
    MedicationSchedule(
      medicationName: 'Ibuprofen',
      scheduleTime: '6:00 PM',
      scheduleID: '3',
      isTaken: 'No',
    ),
  ];

  // Method to handle checkbox toggle and update the UI (hardcoded version)
  void logMedicationIntake(String scheduleID, bool isLogged) {
    setState(() {
      final index = medicationSchedules.indexWhere(
        (schedule) => schedule.scheduleID == scheduleID,
      );
      if (index != -1) {
        medicationSchedules[index].isTaken = isLogged ? 'Yes' : 'No';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Separate the medication schedules into taken and not taken lists
    List<MedicationSchedule> takenSchedules =
        medicationSchedules
            .where((schedule) => schedule.isTaken == 'Yes')
            .toList();
    List<MedicationSchedule> notTakenSchedules =
        medicationSchedules
            .where((schedule) => schedule.isTaken == 'No')
            .toList();

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
                        // Section for Not Taken Medications
                        Text(
                          'Not Taken',
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),

                        // List of Not Taken Medications
                        ListView.builder(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 15.0,
                          ), // Add padding for better layout
                          itemCount: notTakenSchedules.length,
                          shrinkWrap:
                              true, // Make the ListView fit inside the scrollable area
                          physics:
                              NeverScrollableScrollPhysics(), // Disable scrolling in ListView
                          itemBuilder: (context, index) {
                            var schedule = notTakenSchedules[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 2.0, // Add some shadow for elevation
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
                        ),

                        // Section for Taken Medications
                        SizedBox(height: 20),
                        Text(
                          'Taken',
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),

                        // List of Taken Medications
                        ListView.builder(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 15.0,
                          ), // Add padding for better layout
                          itemCount: takenSchedules.length,
                          shrinkWrap:
                              true, // Make the ListView fit inside the scrollable area
                          physics:
                              NeverScrollableScrollPhysics(), // Disable scrolling in ListView
                          itemBuilder: (context, index) {
                            var schedule = takenSchedules[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              elevation: 2.0, // Add some shadow for elevation
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
                    // You can replace this with a mock dashboard screen for now.
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
