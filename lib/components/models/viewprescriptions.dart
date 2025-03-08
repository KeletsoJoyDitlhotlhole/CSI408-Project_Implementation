// lib/components/models/viewprescriptions.dart

class ViewPrescriptions {
  final String medicationName;
  final String refillDate;

  ViewPrescriptions({required this.medicationName, required this.refillDate});

  // Factory method to create ViewPrescriptions from a map (DB query)
  factory ViewPrescriptions.fromMap(Map<String, dynamic> map) {
    return ViewPrescriptions(
      medicationName: map['Med_Name'] ?? 'Unknown', // Medication Name
      refillDate: map['Refill_Date'] ?? 'No refill date',
    );
  }
}
