import 'package:flutter/material.dart';

class LogIntakeScreen extends StatefulWidget {
  final String patientID;

  const LogIntakeScreen({super.key, required this.patientID});

  @override
  LogIntakeScreenState createState() => LogIntakeScreenState();
}

class LogIntakeScreenState extends State<LogIntakeScreen> {
  // List of dummy medication schedules (for UI purposes)
  List<Map<String, String>> medicationSchedules = [
    {
      'medicationName': 'Medication 1',
      'scheduleTime': '8:00 AM',
      'isTaken': 'No',
      'date': '2025-03-09',
    },
    {
      'medicationName': 'Medication 2',
      'scheduleTime': '12:00 PM',
      'isTaken': 'No',
      'date': '2025-03-09',
    },
    {
      'medicationName': 'Medication 3',
      'scheduleTime': '6:00 PM',
      'isTaken': 'No',
      'date': '2025-03-09',
    },
    {
      'medicationName': 'Medication 4',
      'scheduleTime': '9:00 AM',
      'isTaken': 'No',
      'date': '2025-03-10',
    },
    {
      'medicationName': 'Medication 5',
      'scheduleTime': '10:00 PM',
      'isTaken': 'No',
      'date': '2025-03-10',
    },
    {
      'medicationName': 'Medication 6',
      'scheduleTime': '7:00 AM',
      'isTaken': 'No',
      'date': '2025-03-11',
    },
  ];

  // Method to handle checkbox toggle (UI only)
  void logMedicationIntake(int index, bool isLogged) {
    setState(() {
      medicationSchedules[index]['isTaken'] = isLogged ? 'Yes' : 'No';
    });
  }

  // Method to group by date and sort by time
  Map<String, List<Map<String, String>>> getGroupedSchedules() {
    Map<String, List<Map<String, String>>> groupedSchedules = {};

    // Group by date
    for (var schedule in medicationSchedules) {
      String date = schedule['date']!;
      if (groupedSchedules.containsKey(date)) {
        groupedSchedules[date]!.add(schedule);
      } else {
        groupedSchedules[date] = [schedule];
      }
    }

    // Sort each group by time
    groupedSchedules.forEach((key, value) {
      value.sort((a, b) {
        DateTime timeA = parseTime(a['scheduleTime']!);
        DateTime timeB = parseTime(b['scheduleTime']!);
        return timeA.compareTo(timeB);
      });
    });

    return groupedSchedules;
  }

  // Method to manually parse the time string into a DateTime object
  DateTime parseTime(String time) {
    // Extract hours and minutes from the time string
    final timeParts = time.split(' ');
    final hourMinute = timeParts[0].split(':');
    final hour = int.parse(hourMinute[0]);
    final minute = int.parse(hourMinute[1]);

    // Adjust for AM/PM
    int adjustedHour = hour;
    if (timeParts[1] == 'PM' && hour != 12) {
      adjustedHour = hour + 12;
    } else if (timeParts[1] == 'AM' && hour == 12) {
      adjustedHour = 0; // Midnight case
    }

    // Create a DateTime object from the parsed hour and minute
    return DateTime(0, 0, 0, adjustedHour, minute);
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Blue background color
    final backgroundColor = Color(0xFFC3DFE0);
    final cardColor = Color(0xFFF0F0F0); // Lighter gray for the card

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.1), // Space at the top
              // Container for Medication Fields
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02, // Reduced vertical padding
                      horizontal: screenWidth * 0.05,
                    ),
                    child: Column(
                      children: [
                        // Logo at the top of the white container
                        Container(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.04),
                          child: Image.asset(
                            "assets/images/logo_without_name_white.png", // Update path if needed
                            width: screenWidth * 0.6,
                            height: screenHeight * 0.15,
                            fit: BoxFit.contain,
                          ),
                        ),

                        // Header for the Log Medication Intake screen
                        Text(
                          'Log Medication Intake',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A3A3A),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03), // Space
                        // Group and sort the medication schedules by date and time
                        FutureBuilder(
                          future: Future.delayed(
                            Duration(milliseconds: 100),
                            () => getGroupedSchedules(),
                          ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            var groupedSchedules =
                                snapshot.data
                                    as Map<String, List<Map<String, String>>>;

                            // Create a list of widgets to display each group (date) and its corresponding schedules
                            return ListView.builder(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 15.0,
                              ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: groupedSchedules.keys.length,
                              itemBuilder: (context, dateIndex) {
                                String date = groupedSchedules.keys.elementAt(
                                  dateIndex,
                                );
                                var schedulesForDate = groupedSchedules[date]!;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Text(
                                        date, // Display the date
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.06,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF3A3A3A),
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: schedulesForDate.length,
                                      itemBuilder: (context, index) {
                                        var schedule = schedulesForDate[index];
                                        return Card(
                                          margin: EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          elevation: 2.0,
                                          color:
                                              cardColor, // Lighter gray card color
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8.0,
                                              horizontal: 10.0,
                                            ),
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value:
                                                      schedule['isTaken'] ==
                                                      'Yes',
                                                  onChanged: (bool? value) {
                                                    logMedicationIntake(
                                                      medicationSchedules
                                                          .indexOf(schedule),
                                                      value ?? false,
                                                    );
                                                  },
                                                  activeColor:
                                                      Colors
                                                          .white, // Checkbox color
                                                ),
                                                Expanded(
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    title: Text(
                                                      'Medication: ${schedule['medicationName']}',
                                                      style: TextStyle(
                                                        fontSize:
                                                            screenWidth * 0.05,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Colors
                                                                .black, // Black text color
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      'Time: ${schedule['scheduleTime']}',
                                                      style: TextStyle(
                                                        fontSize:
                                                            screenWidth * 0.04,
                                                        color:
                                                            Colors
                                                                .black54, // Darker gray for subtitle
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
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
                    Navigator.pop(
                      context,
                    ); // Navigate back to the previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Color(0xFF6FBF73),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
