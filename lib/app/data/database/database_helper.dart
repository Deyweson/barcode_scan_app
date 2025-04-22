import 'package:barcode_scan_app/app/data/models/item_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'items.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE items (code TEXT PRIMARY KEY, title TEXT, quantity INTEGER)',
        );
      },
    );
  }

  Future<void> insertItem(Item item) async {
    final db = await database;
    await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Item>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');

    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  Future<void> deleteItem(String code) async {
    final db = await database;
    await db.delete('items', where: 'code = ?', whereArgs: [code]);
  }

  Future<void> updateQuantity(String code, int quantity) async {
    final db = await database;
    await db.update(
      'items',
      {'quantity': quantity},
      where: 'code = ?',
      whereArgs: [code],
    );
  }
}
