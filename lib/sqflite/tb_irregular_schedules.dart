import 'package:my_manege/sqflite/db_helper_my_manege.dart';
import 'package:sqflite/sqflite.dart';

class IrregularSchedulesDao {
  final dbHelper = MyManageDBHelper.instance;

  Future<void> _createTableIfNotExists(Database db) async {
    final List<Map<String, dynamic>> tableInfo = await db.rawQuery(
      'PRAGMA table_info(irregular_schedules)',
    );
    if (tableInfo.isEmpty) {
      await db.execute('''
      CREATE TABLE irregular_schedules (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        start_at TEXT NOT NULL,
        end_at TEXT NOT NULL,
        description TEXT DEFAULT "",
        category_id INTEGER NOT NULL,
        irregular_template_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT,
        FOREIGN KEY(category_id) REFERENCES categories(id),
        FOREIGN KEY(irregular_template_id) REFERENCES irregular_templates(id)
      );
      ''');
    }
  }

  //これではrowというデータを挿入し、挿入後のidを受け取ることができる。
  Future<int> insert(Map<String, dynamic> row) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.insert('irregular_schedules', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.query('irregular_schedules');
  }

  //更新したら更新をしたカラムの数を返し、更新を失敗したら0を返す。
  Future<int> update(Map<String, dynamic> row) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.update('irregular_schedules', row,
        where: 'id = ?', whereArgs: [row['id']]);
  }

  //削除したカラムの数を返し、失敗したら0を返す。
  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db
        .delete('irregular_schedules', where: 'id = ?', whereArgs: [id]);
  }

  //同じ親のidを持つスケジュールを抽出
  Future<List<Map<String, dynamic>>> getSameParentId(int parentId) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.rawQuery(
        'SELECT *FROM irregular_schedules WHERE irregular_template_id = ?',
        [parentId]);
  }
}
