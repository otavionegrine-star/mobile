import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/morador_model.dart';
import '../models/encomenda_model.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('encomendas.db');
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

  Future _createDB(Database db, int version) async {
    // Tabela Moradores
    await db.execute('''
      CREATE TABLE moradores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        documento TEXT NOT NULL,
        idade INTEGER NOT NULL,
        endereco TEXT NOT NULL
      )
    ''');

    // Tabela Encomendas com Chave Estrangeira
    await db.execute('''
      CREATE TABLE encomendas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        morador_id INTEGER NOT NULL,
        data_entrega TEXT NOT NULL,
        data_saida TEXT NOT NULL,
        tipo_encomenda TEXT NOT NULL,
        status TEXT NOT NULL,
        FOREIGN KEY (morador_id) REFERENCES moradores (id) ON DELETE CASCADE
      )
    ''');
  }

  // --- Operações de Moradores ---
  Future<int> insertMorador(Morador morador) async {
    final db = await instance.database;
    return await db.insert('moradores', morador.toMap());
  }

  Future<List<Morador>> readAllMoradores() async {
    final db = await instance.database;
    final result = await db.query('moradores', orderBy: 'nome');
    return result.map((json) => Morador.fromMap(json)).toList();
  }

  // --- Operações de Encomendas ---
  Future<int> insertEncomenda(Encomenda encomenda) async {
    final db = await instance.database;
    return await db.insert('encomendas', encomenda.toMap());
  }

  Future<List<Encomenda>> readEncomendasPorMorador(int moradorId) async {
    final db = await instance.database;
    final result = await db.query(
      'encomendas',
      where: 'morador_id = ?',
      whereArgs: [moradorId],
      orderBy: 'data_entrega DESC',
    );
    return result.map((json) => Encomenda.fromMap(json)).toList();
  }

  Future<int> updateEncomenda(Encomenda encomenda) async {
    final db = await instance.database;
    return await db.update(
      'encomendas',
      encomenda.toMap(),
      where: 'id = ?',
      whereArgs: [encomenda.id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}