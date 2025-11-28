import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    print('AppDatabase: database is null, initializing...');
    _database = await _initDB('notes.db');
    print('AppDatabase: database initialized');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    print('AppDatabase: _initDB called with $filePath');
    final dbPath = await getDatabasesPath();
    print('AppDatabase: dbPath is $dbPath');
    final path = join(dbPath, filePath);
    print('AppDatabase: full path is $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onOpen: (db) {
        print('AppDatabase: DB opened');
      },
    );
  }

  Future _createDB(Database db, int version) async {
    print('AppDatabase: Creating DB tables...');
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE notes (
  id $idType,
  title $textType,
  content $textType
)
''');
    print('AppDatabase: DB tables created');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
