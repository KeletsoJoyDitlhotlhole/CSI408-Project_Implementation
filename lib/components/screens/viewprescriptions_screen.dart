import 'package:flutter/material.dart';
import 'package:medication_compliance_tool/database/database_helper.dart'; // Import DatabaseHelper
import 'package:medication_compliance_tool/components/models/viewprescriptions.dart'; // Import ViewPrescriptions model

class ViewPrescriptionsScreen extends StatelessWidget {
  final String patientID; // Add patientID as a required parameter

  // Constructor to receive the patientID
  const ViewPrescriptionsScreen({super.key, required this.patientID});

  // Method to fetch prescriptions from the database
  Future<List<ViewPrescriptions>> fetchPrescriptions() async {
    // Pass the patientID to getPrescriptions
    var prescriptions = await DatabaseHelper.instance.getPrescriptions(
      patientID,
    );
    return prescriptions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Prescriptions')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Check if the screen width is large or small for responsiveness
          if (constraints.maxWidth > 600) {
            // For larger screens (e.g. tablets or large phones), use a grid or more sophisticated layout
            return _buildPrescriptionsList(context);
          } else {
            // For smaller screens (e.g. regular mobile), use a simple ListView
            return _buildPrescriptionsList(context);
          }
        },
      ),
    );
  }

  // Method to build the list of prescriptions
  Widget _buildPrescriptionsList(BuildContext context) {
    return FutureBuilder<List<ViewPrescriptions>>(
      future: fetchPrescriptions(), // Fetch prescriptions from DB
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No prescriptions found.'));
        } else {
          var prescriptions = snapshot.data!;
          return ListView.builder(
            itemCount: prescriptions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  'Medication: ${prescriptions[index].medicationName}',
                ),
                subtitle: Text(
                  'Refill Date: ${prescriptions[index].refillDate}',
                ),
                onTap: () {
                  // Handle tap if necessary (e.g., to view more details)
                },
              );
            },
          );
        }
      },
    );
  }
}
