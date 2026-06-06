import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  final String databaseName;
  Database? _instance;

  AppDatabase({this.databaseName = 'orchom.db'});

  Future<Database> get database async {
    if (_instance != null) return _instance!;
    _instance = await _initDatabase();
    return _instance!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE active_session (
        id TEXT PRIMARY KEY,
        session_json TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE game_history (
        id TEXT PRIMARY KEY,
        session_json TEXT NOT NULL,
        created_at TEXT NOT NULL,
        finished_at TEXT,
        saved_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE app_settings (
        key TEXT PRIMARY KEY,
        value_json TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS app_settings (
          key TEXT PRIMARY KEY,
          value_json TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
    }
  }

  Future<void> close() async {
    final db = _instance;
    if (db != null) {
      await db.close();
      _instance = null;
    }
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('active_session');
    await db.delete('game_history');
    await db.delete('app_settings');
  }
}
