import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/bag_item.dart';
import 'default_items.dart';

/// Tüm veri yerelde (cihaz üzerinde) tutulur — sunucu, senkronizasyon
/// veya internet bağlantısı YOKTUR. Bkz. README -> "Neden sqflite?".
class DbHelper {
  DbHelper._internal();
  static final DbHelper instance = DbHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dogum_cantasi.db');

    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bag_items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            quantity INTEGER NOT NULL DEFAULT 1,
            note TEXT NOT NULL DEFAULT '',
            is_checked INTEGER NOT NULL DEFAULT 0,
            why_needed TEXT,
            source_note TEXT,
            is_preset INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );

    // İlk kurulumda hazır listeyi tek seferlik doldur.
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM bag_items'),
    );
    if (count == 0) {
      final batch = db.batch();
      for (final item in seedDefaultItems()) {
        batch.insert('bag_items', item.toMap()..remove('id'));
      }
      await batch.commit(noResult: true);
    }

    return db;
  }

  Future<List<BagItem>> getAllItems() async {
    final db = await database;
    final rows = await db.query('bag_items', orderBy: 'category ASC, id ASC');
    return rows.map(BagItem.fromMap).toList();
  }

  Future<int> insertItem(BagItem item) async {
    final db = await database;
    return db.insert('bag_items', item.toMap()..remove('id'));
  }

  Future<int> updateItem(BagItem item) async {
    final db = await database;
    return db.update(
      'bag_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return db.delete('bag_items', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> setChecked(int id, bool value) async {
    final db = await database;
    return db.update(
      'bag_items',
      {'is_checked': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
