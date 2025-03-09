class ViewPrescriptions {
  final String prescriptionID;
  final String medicationName;
  final String refillDate;
  final String isRefilled;

  ViewPrescriptions({
    required this.prescriptionID,
    required this.medicationName,
    required this.refillDate,
    required this.isRefilled,
  });

  // Convert a ViewPrescriptions object into a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'prescriptionID': prescriptionID,
      'medicationName': medicationName,
      'refillDate': refillDate,
      'isRefilled': isRefilled,
    };
  }

  // Convert a Map<String, dynamic> into a ViewPrescriptions object
  factory ViewPrescriptions.fromMap(Map<String, dynamic> map) {
    return ViewPrescriptions(
      prescriptionID: map['prescriptionID'],
      medicationName: map['medicationName'],
      refillDate: map['refillDate'],
      isRefilled: map['isRefilled'],
    );
  }
}
