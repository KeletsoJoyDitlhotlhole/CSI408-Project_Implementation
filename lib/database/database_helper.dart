import 'package:medication_compliance_tool/components/models/refillreminder.dart';
import 'package:medication_compliance_tool/components/models/viewprescriptions.dart';
import 'package:path/path.dart';
import 'dart:io';

// Conditionally import sqflite_common_ffi for non-mobile platforms
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    if (dart.library.io) 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton pattern to ensure one instance of DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  // Open the database
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'medication.db');

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Initialize FFI for desktop platforms
      sqfliteFfiInit();
      return await databaseFactoryFfi.openDatabase(path);
    } else {
      // Use default database for mobile (Android/iOS)
      return await openDatabase(
        path,
        onCreate: (db, version) async {
          await _createTables(db);
        },
        version: 1,
      );
    }
  }

  // Create necessary tables
  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS MedicationSchedule (
        Schedule_ID TEXT PRIMARY KEY,
        Patient_ID TEXT,
        IsTaken TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Prescription (
        Prescription_ID TEXT PRIMARY KEY,
        Patient_ID TEXT,
        Med_ID TEXT,
        Refill_Date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Medication (
        Med_ID TEXT PRIMARY KEY,
        Med_Name TEXT
      )
    ''');
  }

  // Get medication schedules for a patient
  Future<List<Map<String, dynamic>>> getMedicationSchedules(
    String patientID,
  ) async {
    final db = await database;
    return await db.query(
      'MedicationSchedule',
      where: 'Patient_ID = ?',
      whereArgs: [patientID],
    );
  }

  // Update medication log (e.g., when the patient logs their intake)
  Future<int> updateMedicationLog(String scheduleID, bool isLogged) async {
    final db = await database;
    return await db.update(
      'MedicationSchedule',
      {'IsTaken': isLogged ? 'Yes' : 'No'},
      where: 'Schedule_ID = ?',
      whereArgs: [scheduleID],
    );
  }

  // Fetch refill reminders from Prescription and Medication tables
  Future<List<RefillReminder>> getRefillReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT p.Refill_Date, m.Med_Name
      FROM Prescription p
      JOIN Medication m ON p.Med_ID = m.Med_ID
      WHERE p.Refill_Date IS NOT NULL
    ''');

    return result.map((row) => RefillReminder.fromMap(row)).toList();
  }

  // Fetch prescriptions for a specific patient
  Future<List<ViewPrescriptions>> getPrescriptions(String patientID) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'Prescription',
      where: 'Patient_ID = ?',
      whereArgs: [patientID],
    );

    return result.map((row) => ViewPrescriptions.fromMap(row)).toList();
  }
}
