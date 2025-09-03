import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:classtab_catalog/models/tablature.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static DatabaseService get instance => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize FFI for desktop platforms
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final String path = join(await getDatabasesPath(), 'classtab.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tablatures (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        composer TEXT NOT NULL,
        opus TEXT,
        key TEXT,
        difficulty TEXT,
        hasMidi INTEGER DEFAULT 0,
        hasLhf INTEGER DEFAULT 0,
        hasVideo INTEGER DEFAULT 0,
        videoUrl TEXT,
        tabUrl TEXT NOT NULL,
        midiUrl TEXT,
        content TEXT NOT NULL,
        lastUpdated INTEGER,
        isFavorite INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_composer ON tablatures(composer);
    ''');

    await db.execute('''
      CREATE INDEX idx_title ON tablatures(title);
    ''');

    await db.execute('''
      CREATE INDEX idx_favorite ON tablatures(isFavorite);
    ''');
  }

  Future<int> insertTablature(Tablature tablature) async {
    final db = await database;
    return await db.insert('tablatures', tablature.toMap());
  }

  Future<List<Tablature>> getAllTablatures() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tablatures',
      orderBy: 'composer, title',
    );

    return List.generate(maps.length, (i) {
      return Tablature.fromMap(maps[i]);
    });
  }

  Future<List<Tablature>> searchTablatures(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tablatures',
      where: 'title LIKE ? OR composer LIKE ? OR opus LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'composer, title',
    );

    return List.generate(maps.length, (i) {
      return Tablature.fromMap(maps[i]);
    });
  }

  Future<List<Tablature>> getTablaturesByComposer(String composer) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tablatures',
      where: 'composer = ?',
      whereArgs: [composer],
      orderBy: 'title',
    );

    return List.generate(maps.length, (i) {
      return Tablature.fromMap(maps[i]);
    });
  }

  Future<List<Tablature>> getFavoriteTablatures() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tablatures',
      where: 'isFavorite = 1',
      orderBy: 'composer, title',
    );

    return List.generate(maps.length, (i) {
      return Tablature.fromMap(maps[i]);
    });
  }

  Future<List<String>> getAllComposers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tablatures',
      columns: ['composer'],
      distinct: true,
      orderBy: 'composer',
    );

    return maps.map((map) => map['composer'] as String).toList();
  }

  Future<int> updateTablature(Tablature tablature) async {
    final db = await database;
    return await db.update(
      'tablatures',
      tablature.toMap(),
      where: 'id = ?',
      whereArgs: [tablature.id],
    );
  }

  Future<int> deleteTablature(int id) async {
    final db = await database;
    return await db.delete(
      'tablatures',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    return await db.update(
      'tablatures',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllTablatures() async {
    final db = await database;
    await db.delete('tablatures');
  }

  Future<int> getTablatureCount() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT COUNT(*) as count FROM tablatures');
    return result.first['count'] as int;
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
