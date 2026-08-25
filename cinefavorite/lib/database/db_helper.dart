import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'cinefavorite.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER NOT NULL,
            title TEXT NOT NULL,
            posterPath TEXT,
            rating REAL,
            userName TEXT NOT NULL,
            PRIMARY KEY (id, userName)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE favorites_new (
              id INTEGER NOT NULL,
              title TEXT NOT NULL,
              posterPath TEXT,
              rating REAL,
              userName TEXT NOT NULL,
              PRIMARY KEY (id, userName)
            )
          ''');
          await db.execute(
            "INSERT INTO favorites_new (id, title, posterPath, rating, userName) "
            "SELECT id, title, posterPath, rating, '' FROM favorites",
          );
          await db.execute('DROP TABLE favorites');
          await db.execute('ALTER TABLE favorites_new RENAME TO favorites');
        }
      },
    );
  }

  static Future<int> addFavorite(Movie movie, String userName) async {
    final db = await database;
    final values = movie.toMap()..['userName'] = userName;
    return await db.insert(
      'favorites',
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Movie>> getFavorites(String userName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      where: 'userName = ?',
      whereArgs: [userName],
    );
    return maps.map((map) => Movie.fromMap(map)).toList();
  }

  static Future<int> removeFavorite(int id, String userName) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'id = ? AND userName = ?',
      whereArgs: [id, userName],
    );
  }

  static Future<int> updateRating(int id, String userName, double rating) async {
    final db = await database;
    return await db.update(
      'favorites',
      {'rating': rating},
      where: 'id = ? AND userName = ?',
      whereArgs: [id, userName],
    );
  }
}