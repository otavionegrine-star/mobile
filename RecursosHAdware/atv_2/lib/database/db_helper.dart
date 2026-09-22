import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/checkin_model.dart';

class DBHelper {
  static Database? _db;

  // Garante que só exista uma conexão aberta com o banco (Singleton)
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  // Inicializa o arquivo do banco no dispositivo
  static Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'senai_checkin.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE checkins(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data_hora TEXT,
            latitude REAL,
            longitude REAL,
            observacao TEXT,
            caminho_foto TEXT
          )
        ''');
      },
    );
  }

  // INSERIR REGISTRO
  static Future<int> insertCheckIn(CheckIn checkin) async {
    final db = await database;
    return await db.insert('checkins', checkin.toMap());
  }

  // LISTAR TODOS OS REGISTROS (Do mais recente para o mais antigo)
  static Future<List<CheckIn>> getCheckIns() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'checkins', 
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => CheckIn.fromMap(maps[i]));
  }

  // EXCLUIR REGISTRO (Opcional)
  static Future<int> deleteCheckIn(int id) async {
    final db = await database;
    return await db.delete(
      'checkins',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}