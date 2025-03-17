class MedicationLog {
  final String logID;
  final String logDate;
  final String logTime;
  final bool isLogged;
  final String medicationName;
  final String suggestedDosage;

  MedicationLog({
    required this.logID,
    required this.logDate,
    required this.logTime,
    required this.isLogged,
    required this.medicationName,
    required this.suggestedDosage,
  });

  factory MedicationLog.fromMap(Map<String, dynamic> map) {
    return MedicationLog(
      logID: map['Log_ID'],
      logDate: map['LogDate'],
      logTime: map['LogTime'],
      isLogged: map['IsLogged'] == '1', // Assuming '1' represents true
      medicationName: map['Med_Name'],
      suggestedDosage: map['Med_SuggestedDosage'],
    );
  }
}
