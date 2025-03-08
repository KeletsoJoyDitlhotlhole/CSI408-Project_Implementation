import 'package:flutter/material.dart';
import 'package:medication_compliance_tool/database/database_helper.dart';
import 'package:medication_compliance_tool/components/models/medicationschedule.dart';

class LogIntakeScreen extends StatefulWidget {
  final String
  patientID; // Pass the patient ID to fetch their medication schedule

  const LogIntakeScreen({super.key, required this.patientID});

  @override
  LogIntakeScreenState createState() => LogIntakeScreenState(); // Updated here
}

class LogIntakeScreenState extends State<LogIntakeScreen> {
  // Updated here
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
    await DatabaseHelper.instance.updateMedicationLog(scheduleID, isLogged);
    setState(() {}); // Rebuild the UI to reflect the changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Medication Intake'),
        // Make the app bar adaptable to different screen sizes
      ),
      body: FutureBuilder<List<MedicationSchedule>>(
        future: medicationSchedules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No medication schedule found.'));
          } else {
            var schedules = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 15.0,
              ), // Add padding for better layout
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                var schedule = schedules[index];
                return Card(
                  // Wrap ListTile in a Card for better appearance
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 2.0, // Add some shadow for elevation
                  child: ListTile(
                    title: Text(
                      'Medication: ${schedule.medicationName}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    subtitle: Text(
                      'Time: ${schedule.scheduleTime}',
                      style: TextStyle(fontSize: 14.0),
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
    );
  }
}
