import 'package:market/models/config.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
      version: 2,
      onCreate: _createDB,
      // onUpgrade: (db, oldVersion, newVersion) => 2,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE $tableConfigs (
  ${ConfigFields.pk} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${ConfigFields.key} TEXT NOT NULL,
  ${ConfigFields.value} TEXT NOT NULL
  )
''');
  }

  Future<Config> create(Config config) async {
    final db = await instance.database;

    // raw insert
    // final columns = '${ConfigFields.productPk}, ...';
    // final values = '${json[ConfigFields.productPk', ...]';
    // final pk =
    //     await db.rawInsert('insert into local($columns) values ($values)');
    // delete(config.key);
    final pk = await db.insert(tableConfigs, config.toJson());

    return config.copy(pk: pk);
  }

  Future<Config> fetchOne(String key) async {
    final db = await instance.database;

    final maps = await db.query(
      tableConfigs,
      columns: ConfigFields.values,
      where: '${ConfigFields.key} = ?',
      whereArgs: [key],
    );

    if (maps.isNotEmpty) {
      return Config.fromJson(maps.first);
    } else {
      throw Exception();
    }
  }

  Future<List<Config>> fetchAll() async {
    final db = await instance.database;

    final result = await db.rawQuery(
        'SELECT * FROM $tableConfigs ORDER BY ${ConfigFields.pk} DESC');

    // final result =
    //     await db.query(tableConfigs, orderBy: '${ConfigFields.pk} ASC');
    return result.map((json) => Config.fromJson(json)).toList();
  }

  Future<int> update(Config config) async {
    final db = await instance.database;

    return db.update(
      tableConfigs,
      config.toJson(),
      where: '${ConfigFields.pk} = ?',
      whereArgs: [config.pk],
    );
  }

  Future<int> delete(String key) async {
    final db = await instance.database;

    return await db.delete(
      tableConfigs,
      where: '${ConfigFields.key} = ?',
      whereArgs: [key],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
