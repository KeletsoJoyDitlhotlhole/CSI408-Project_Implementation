import 'package:medication_compliance_tool/components/models/refillreminder.dart';
import 'package:medication_compliance_tool/components/models/viewprescriptions.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show ByteData, kIsWeb;
import 'package:sqflite/sqflite.dart'; // For mobile (iOS/Android)
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    as sqflite_ffi; // For desktop (Windows, Linux, MacOS)
import 'package:flutter/services.dart' show rootBundle;
import 'package:logging/logging.dart'; // For logging

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  final Logger _logger = Logger('DatabaseHelper');

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'medication.db');
      _logger.info("Database path: $path");

      // If the database doesn't exist, copy it from the assets folder
      if (await databaseExists(path) == false) {
        await _copyDatabaseFromAssets(path);
      }

      if (Platform.isWindows ||
          Platform.isLinux ||
          Platform.isMacOS ||
          kIsWeb) {
        sqflite_ffi.sqfliteFfiInit();
        return await sqflite_ffi.databaseFactoryFfi.openDatabase(path);
      } else {
        return await openDatabase(
          path,
          onCreate: (db, version) async {
            _logger.info("Creating tables...");
            await _createTables(db);
          },
          version: 3, // Make sure to update the version number
        );
      }
    } catch (e) {
      _logger.severe("Database initialization error: $e");
      rethrow;
    }
  }

  // Check if the database already exists
  Future<bool> databaseExists(String path) async {
    final dbFile = File(path);
    return dbFile.exists();
  }

  // Copy the database from assets to the local storage
  Future<void> _copyDatabaseFromAssets(String path) async {
    try {
      // Load the database file from the assets folder
      final ByteData data = await rootBundle.load(
        'assets/medication_compliance_tool.db',
      );
      final List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      // Create the database file in the app's local storage
      final File file = File(path);
      await file.writeAsBytes(bytes);
      _logger.info('Database copied from assets to local storage');

      // Check if the file is now available
      if (await File(path).exists()) {
        _logger.info('Database file exists at $path');
      } else {
        _logger.warning('Database file does not exist at $path');
      }
    } catch (e) {
      _logger.severe("Error copying database: $e");
      rethrow;
    }
  }

  // Create necessary tables if the database is being created for the first time
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

    await db.execute(''' 
      CREATE TABLE IF NOT EXISTS Doctor (
        Doctor_ID TEXT PRIMARY KEY,
        Doctor_Name TEXT,
        Doctor_Surname TEXT
      )
    ''');

    await db.execute(''' 
      CREATE TABLE IF NOT EXISTS Pharmacist (
        Pharmacist_ID TEXT PRIMARY KEY,
        Pharmacist_Name TEXT,
        Pharmacist_Surname TEXT
      )
    ''');

    _logger.info('Database tables created successfully');

    // Log the tables in the database after creation
    await _logDatabaseTables(db);
  }

  // Log the tables in the database to verify if all required tables exist
  Future<void> _logDatabaseTables(Database db) async {
    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT name FROM sqlite_master WHERE type="table";',
    );
    _logger.info(
      'Tables in database: ${result.map((e) => e['name']).join(', ')}',
    );
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

  Future<int> updateMedicationLog(String scheduleID, bool isLogged) async {
    final db = await database;
    return await db.update(
      'MedicationSchedule',
      {'IsTaken': isLogged ? 'Yes' : 'No'},
      where: 'Schedule_ID = ?',
      whereArgs: [scheduleID],
    );
  }

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

  Future<List<ViewPrescriptions>> getPrescriptions(String patientID) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'Prescription',
      where: 'Patient_ID = ?',
      whereArgs: [patientID],
    );

    return result.map((row) => ViewPrescriptions.fromMap(row)).toList();
  }

  Future<List<Map<String, dynamic>>> getMedicationHistory(
    String patientID,
  ) async {
    final db = await database;
    return await db.rawQuery(
      '''
    SELECT 
      p.Pre_ID, 
      p.Start_Date, 
      p.End_Date, 
      p.Refill_Date, 
      p.Refill_Frequency, 
      p.Refill_Description, 
      p.Collection_Date, 
      p.Med_Instruction, 
      p.Med_SuggestedDosage, 
      m.Med_Name, 
      d.Doctor_Name || ' ' || d.Doctor_Surname AS Doctor_Name, 
      ph.Pharmacist_Name || ' ' || ph.Pharmacist_Surname AS Pharmacist_Name
    FROM Prescription p
    LEFT JOIN Doctor d ON p.Doctor_ID = d.Doctor_ID
    LEFT JOIN Pharmacist ph ON p.Pharmacist_ID = ph.Pharmacist_ID
    LEFT JOIN Medication m ON p.Med_ID = m.Med_ID
    WHERE p.Patient_ID = ? 
  ''',
      [patientID],
    );
  }
}
