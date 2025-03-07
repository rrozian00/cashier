import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseInstance {
  static Database? _database;
  static const int _databaseVersion = 2;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cashier.db');
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE menu (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            image TEXT,
            price TEXT,
            createdAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE orders (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            quantity TEXT,
            price TEXT,
            image TEXT,
            total TEXT,
            payment TEXT,
            refund TEXT,
            createdAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE expense (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            pay TEXT,
            createdAt TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              'ALTER TABLE expense ADD COLUMN isSynced INTEGER DEFAULT 0');
          await db.execute(
              'ALTER TABLE orders ADD COLUMN isSynced INTEGER DEFAULT 0');
          await db.execute(
              'ALTER TABLE menu ADD COLUMN isSynced INTEGER DEFAULT 0');
        }
      },
    );
  }

  // Create
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  // Read
  Future<List<Map<String, dynamic>>> read(
      String table, String? orderBy, String? where) async {
    final db = await database;
    return await db.query(table, orderBy: orderBy, where: where);
  }

  Future<int> update(String table, int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(table, data, where: 'id=?', whereArgs: [id]);
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(table, where: 'id=?', whereArgs: [id]);
  }
}
