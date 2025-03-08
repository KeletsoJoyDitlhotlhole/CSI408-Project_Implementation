import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite;

void initializeDatabase() {
  sqflite.databaseFactory = sqflite.databaseFactoryFfi;
}
