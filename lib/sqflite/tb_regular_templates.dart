import 'package:my_manege/sqflite/db_helper_my_manege.dart';
import 'package:sqflite/sqflite.dart';

class RegularTemplatesDao {
  final dbHelper = MyManageDBHelper.instance;

  Future<void> _createTableIfNotExists(Database db) async {
    final List<Map<String, dynamic>> tableInfo = await db.rawQuery(
      'PRAGMA table_info(regular_templates)',
    );
    if (tableInfo.isEmpty) {
      await db.execute('''
      CREATE TABLE regular_templates (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        description TEXT DEFAULT "",
        how_long INTEGER NOT NULL,
        start_at TEXT NOT NULL,
        end_at INTEGER NOT NULL,
        user_id INT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id)
      );
      ''');
    }
  }

  //これではrowというデータを挿入し、挿入後のidを受け取ることができる。
  Future<int> insert(Map<String, dynamic> row) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.insert('regular_templates', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.query('regular_templates');
  }

  //更新したら更新をしたカラムの数を返し、更新を失敗したら0を返す。
  Future<int> update(Map<String, dynamic> row) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.update('regular_templates', row,
        where: 'id = ?', whereArgs: [row['id']]);
  }

  //削除したカラムの数を返し、失敗したら0を返す。
  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db
        .delete('regular_templates', where: 'id = ?', whereArgs: [id]);
  }
}
