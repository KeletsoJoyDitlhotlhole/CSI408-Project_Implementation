// lib/screens/refill_screen.dart

import 'package:flutter/material.dart';
import 'package:medication_compliance_tool/database/database_helper.dart'; // Import DatabaseHelper to access the database
import 'package:medication_compliance_tool/components/models/refillreminder.dart'; // Import RefillReminder model

class RefillScreen extends StatelessWidget {
  const RefillScreen({super.key});

  // Asynchronous method to fetch refill reminders from the database
  Future<List<RefillReminder>> fetchRefillReminders() async {
    return await DatabaseHelper.instance
        .getRefillReminders(); // Fetch from the database using the instance
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Refill Dates')),
      body: FutureBuilder<List<RefillReminder>>(
        future:
            fetchRefillReminders(), // Call the function to fetch data from DB
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No refill reminders.'));
          } else {
            var refills = snapshot.data!;
            return ListView.builder(
              itemCount: refills.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Medication: ${refills[index].medicationName}'),
                  subtitle: Text('Refill Date: ${refills[index].refillDate}'),
                  onTap: () {
                    // Handle refill reminder action (if needed)
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
