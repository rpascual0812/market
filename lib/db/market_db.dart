// import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:market/models/local.dart';

class MarketDatabase {
  static final MarketDatabase instance = MarketDatabase._init();

  static Database? _database;

  MarketDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('samdhana_market.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      // onUpgrade: (db, oldVersion, newVersion) => 2,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE $tableLocal (
  ${LocalFields.pk} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${LocalFields.uuid} TEXT NOT NULL,
  ${LocalFields.name} TEXT NOT NULL,
  ${LocalFields.notes} TEXT,
  ${LocalFields.dateCreated} TEXT NOT NULL,
  )
''');
  }

  Future<Local> create(Local local) async {
    final db = await instance.database;

    // raw insert
    // final columns = '${LocalFields.productPk}, ...';
    // final values = '${json[LocalFields.productPk', ...]';
    // final pk =
    //     await db.rawInsert('insert into local($columns) values ($values)');

    final pk = await db.insert(tableLocal, local.toJson());
    return local.copy(pk: pk);
  }

  Future<Local?> getLocal(String name) async {
    final db = await instance.database;
    final maps = await db.query(
      tableLocal,
      columns: LocalFields.values,
      where: '${LocalFields.pk} = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return Local.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Local>> getAllLocals() async {
    final db = await instance.database;
    final result =
        await db.query(tableLocal, orderBy: '${LocalFields.pk} DESC');
    return result.map((json) => Local.fromJson(json)).toList();
  }

  Future<int> update(Local local) async {
    final db = await instance.database;

    return db.update(
      tableLocal,
      local.toJson(),
      where: '${LocalFields.pk} = ?',
      whereArgs: [local.pk],
    );
  }

  Future<int> delete(int pk) async {
    final db = await instance.database;

    return await db.delete(
      tableLocal,
      where: '${LocalFields.pk} = ?',
      whereArgs: [pk],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
