// import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:market/models/order.dart';

class MarketDatabase {
  static final MarketDatabase instance = MarketDatabase._init();

  static Database? _database;

  MarketDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('market.db');
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
CREATE TABLE $tableOrders (
  ${OrderFields.pk} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${OrderFields.productPk} INTEGER NOT NULL,
  ${OrderFields.uuid} TEXT NOT NULL,
  ${OrderFields.paid} BOOLEAN DEFAULT FALSE,
  ${OrderFields.notes} TEXT,
  ${OrderFields.dateCreated} TEXT NOT NULL,
  ${OrderFields.synced} BOOLEAN DEFAULT FALSE
  )
''');
  }

  Future<Order> create(Order order) async {
    final db = await instance.database;

    // raw insert
    // final columns = '${OrderFields.productPk}, ...';
    // final values = '${json[OrderFields.productPk', ...]';
    // final pk =
    //     await db.rawInsert('insert into orders($columns) values ($values)');

    final pk = await db.insert(tableOrders, order.toJson());
    return order.copy(pk: pk);
  }

  Future<Order?> getOrder(int pk) async {
    final db = await instance.database;
    final maps = await db.query(
      tableOrders,
      columns: OrderFields.values,
      where: '${OrderFields.pk} = ?',
      whereArgs: [pk],
    );

    if (maps.isNotEmpty) {
      return Order.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Order>> getAllOrders() async {
    final db = await instance.database;
    final result =
        await db.query(tableOrders, orderBy: '${OrderFields.pk} DESC');
    return result.map((json) => Order.fromJson(json)).toList();
  }

  Future<int> update(Order order) async {
    final db = await instance.database;

    return db.update(
      tableOrders,
      order.toJson(),
      where: '${OrderFields.pk} = ?',
      whereArgs: [order.pk],
    );
  }

  Future<int> delete(int pk) async {
    final db = await instance.database;

    return await db.delete(
      tableOrders,
      where: '${OrderFields.pk} = ?',
      whereArgs: [pk],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
