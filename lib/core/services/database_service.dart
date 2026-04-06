import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('attendance.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sessionId TEXT NOT NULL,
        studentId TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<int> insertAttendance(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('attendance', row);
  }

  Future<List<Map<String, dynamic>>> getUnsyncedRecords() async {
    final db = await instance.database;
    return db.query('attendance', where: 'synced = ?', whereArgs: [0]);
  }

  Future<int> markAsSynced(int id) async {
    final db = await instance.database;
    return db.update(
      'attendance',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
