// lib/services/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        supabase_id TEXT,
        is_synced INTEGER DEFAULT 0,
        user_id TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  // Modified to get tasks for specific user
  Future<List<Task>> getUnsynced(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'is_synced = ? AND user_id = ?',
      whereArgs: [0, userId],
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  // Modified to get tasks for specific user
  Future<List<Task>> getAllTasks(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<void> markAsSynced(int id, String supabaseId) async {
    final db = await database;
    await db.update(
      'tasks',
      {
        'is_synced': 1,
        'supabase_id': supabaseId,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}