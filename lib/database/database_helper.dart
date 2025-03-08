import 'package:medication_compliance_tool/components/models/refillreminder.dart';
import 'package:medication_compliance_tool/components/models/viewprescriptions.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:sqflite/sqflite.dart'; // For mobile (iOS/Android)
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    as sqflite_ffi; // For desktop (Windows, Linux, MacOS)

import 'package:logging/logging.dart'; // For logging

class DatabaseHelper {
  // Singleton pattern to ensure only one instance of DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  // Logger setup
  final Logger _logger = Logger('DatabaseHelper'); // Set up logger

  DatabaseHelper._privateConstructor();

  // Open the database
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'medication.db');
      _logger.info("Database path: $path"); // Log the database path

      if (Platform.isWindows ||
          Platform.isLinux ||
          Platform.isMacOS ||
          kIsWeb) {
        // Initialize FFI for desktop and web platforms
        sqflite_ffi.sqfliteFfiInit(); // Ensure that FFI is initialized
        return await sqflite_ffi.databaseFactoryFfi.openDatabase(path);
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
    } catch (e) {
      _logger.severe("Database initialization error: $e"); // Log error
      rethrow; // Re-throw the error after logging it
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

    _logger.info('Database tables created successfully');
  }

  // Fetch medication schedules for a patient
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
