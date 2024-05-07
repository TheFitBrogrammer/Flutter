// ignore_for_file: prefer_const_declarations

import 'package:path/path.dart';
import 'package:simply_todo/model/object_models/item.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "simply_todo.db";
  static final _databaseVersion = 1;

  static final tableItems = 'items';

  static final columnId = 'id';
  static final columnIndexId = 'indexId';
  static final columnItemTitle = 'itemTitle';
  static final columnIsDone = 'isDone';
  static final columnCategory = 'category';
  static final columnDate = 'date';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableItems (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnIndexId INTEGER,
            $columnDate INTEGER,
            $columnItemTitle TEXT NOT NULL,
            $columnIsDone INTEGER NOT NULL,
            $columnCategory INTEGER NOT NULL
          )
          ''');
    return db;
  }

//*************** CRUD OPERATIONS ***************
// Query Items table
  Future<List<Map<String, dynamic>>> queryItems() async {
    Database db = await instance.database;
    return await db.query(tableItems);
  }

// Add item
  Future<int> insertItem(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableItems, row);
  }

// Update item
  Future<int> updateItem(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(tableItems, row, where: '$columnId = ?', whereArgs: [id]);
  }

// Update item list order
  Future<void> updateItemOrder(List<Item> itemsList) async {
    Database db = await instance.database;
    for (var item in itemsList) {
      Map<String, dynamic> row = {
        columnIndexId: item.indexId,
      };
      await db.update(tableItems, row,
          where: '$columnId = ?', whereArgs: [item.id]);
    }
  }

  // Delete item
  Future<int> deleteItem(int id) async {
    Database db = await instance.database;
    return await db.delete(tableItems, where: '$columnId = ?', whereArgs: [id]);
  }
}
