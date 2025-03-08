// lib/models/refill_reminder.dart

class RefillReminder {
  final String medicationName;
  final String refillDate;

  RefillReminder({required this.medicationName, required this.refillDate});

  // Factory method to create a RefillReminder from a map (database result)
  factory RefillReminder.fromMap(Map<String, dynamic> map) {
    return RefillReminder(
      medicationName: map['Med_Name'] ?? 'Unknown',
      refillDate: map['Refill_Date'] ?? 'No date',
    );
  }
}
