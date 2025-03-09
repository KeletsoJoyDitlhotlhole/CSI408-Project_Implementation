import 'package:flutter/material.dart';

class RefillReminder {
  final String medicationName;
  final String refillDate;

  RefillReminder({required this.medicationName, required this.refillDate});
}

class RefillDatesScreen extends StatelessWidget {
  const RefillDatesScreen({super.key, required String patientID});

  // Simulating refill reminders for now
  Future<List<RefillReminder>> fetchRefillReminders() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate a delay
    return [
      RefillReminder(medicationName: 'Aspirin', refillDate: '2025-03-15'),
      RefillReminder(medicationName: 'Paracetamol', refillDate: '2025-03-20'),
      RefillReminder(medicationName: 'Vitamin D', refillDate: '2025-04-01'),
    ];
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

              // Container for Refill Fields with white background
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // White background behind fields
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
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
                                0.04, // Space between logo and refill reminders
                          ),
                          child: Image.asset(
                            "assets/images/logo_without_name_white.png", // Path to the logo
                            width: screenWidth * 0.6, // Adjust the logo size
                            height:
                                screenHeight * 0.15, // Adjust the logo height
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Header for refill reminder screen
                        Text(
                          'Refill Dates',
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
                        // Refill List View
                        FutureBuilder<List<RefillReminder>>(
                          future:
                              fetchRefillReminders(), // Simulate fetching data
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
                              return Center(child: Text('No refill dates.'));
                            } else {
                              var refills = snapshot.data!;
                              return ListView.builder(
                                itemCount: refills.length,
                                shrinkWrap:
                                    true, // Make the ListView fit inside the scrollable area
                                physics:
                                    NeverScrollableScrollPhysics(), // Disable scrolling in ListView
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.01,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(
                                          0xFFF0F0F0,
                                        ), // Light background for each list item
                                        borderRadius: BorderRadius.circular(
                                          12,
                                        ), // Rounded corners
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.05,
                                          vertical: screenHeight * 0.02,
                                        ),
                                        title: Text(
                                          'Medication: ${refills[index].medicationName}',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.05,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF3A3A3A),
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Refill Date: ${refills[index].refillDate}',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.04,
                                            color: Color(0xFF5F6B6C),
                                          ),
                                        ),
                                        leading: Icon(
                                          Icons
                                              .medical_services, // Icon for medications
                                          color: Color(0xFF6FBF73),
                                          size: screenWidth * 0.08,
                                        ),
                                        onTap: () {
                                          // Handle refill reminder action (if needed)
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
                    Navigator.pop(context); // Navigate back to the Dashboard
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
