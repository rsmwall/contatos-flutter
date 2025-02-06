import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contato.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contatos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    await db.execute('''
      CREATE TABLE contatos (
        id $idType,
        nome $textType,
        telefone $textType,
        email $textType,
        coordx $textType,
        coordy $textType
      )
    ''');
  }

  Future<int> create(Contato contato) async {
    final db = await instance.database;
    return await db.insert('contatos', contato.toMap());
  }

  Future<List<Contato>> readAll() async {
    final db = await instance.database;
    final result = await db.query('contatos');
    return result.map((json) => Contato.fromMap(json)).toList();
  }

  Future<int> update(Contato contato) async {
    final db = await instance.database;
    return await db.update(
      'contatos',
      contato.toMap(),
      where: 'id = ?',
      whereArgs: [contato.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'contatos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
