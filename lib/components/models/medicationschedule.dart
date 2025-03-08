class MedicationSchedule {
  final String scheduleID;
  final String medicationName;
  final String scheduleTime;
  final String isTaken; // Either 'Yes' or 'No'

  MedicationSchedule({
    required this.scheduleID,
    required this.medicationName,
    required this.scheduleTime,
    required this.isTaken,
  });

  // Factory method to create MedicationSchedule from a map (database result)
  factory MedicationSchedule.fromMap(Map<String, dynamic> map) {
    return MedicationSchedule(
      scheduleID: map['Schedule_ID'],
      medicationName: map['Med_Name'],
      scheduleTime: map['Schedule_Time'],
      isTaken: map['IsTaken'] ?? 'No', // Default to 'No' if not available
    );
  }
}
