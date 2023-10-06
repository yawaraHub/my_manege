import 'package:my_manege/sqflite/db_helper_my_manege.dart';
import 'package:sqflite/sqflite.dart';

class RegularSchedulesDao {
  final dbHelper = MyManageDBHelper.instance;

  Future<void> _createTableIfNotExists(Database db) async {
    final List<Map<String, dynamic>> tableInfo = await db.rawQuery(
      'PRAGMA table_info(regular_schedules)',
    );
    if (tableInfo.isEmpty) {
      await db.execute('''
      CREATE TABLE regular_schedules (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        day INTEGER NOT NULL,
        start_at TEXT NOT NULL,
        end_at TEXT NOT NULL,
        description TEXT DEFAULT "",
        category_id INTEGER NOT NULL,
        regular_template_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT,
        FOREIGN KEY(category_id) REFERENCES categories(id),
        FOREIGN KEY(regular_template_id) REFERENCES regular_templates(id)
      );
      ''');
    }
  }

  //これではrowというデータを挿入し、挿入後のidを受け取ることができる。
  Future<int> insert(Map<String, dynamic> row) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.insert('regular_schedules', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.query('regular_schedules');
  }

  //更新したら更新をしたカラムの数を返し、更新を失敗したら0を返す。
  Future<int> update(Map<String, dynamic> row) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.update('regular_schedules', row,
        where: 'id = ?', whereArgs: [row['id']]);
  }

  //削除したカラムの数を返し、失敗したら0を返す。
  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db
        .delete('regular_schedules', where: 'id = ?', whereArgs: [id]);
  }

  //regular_schedulesのidを渡すことでその日毎のスケジュールを返す[[1日目][2日目]]
  Future<List<List<Map<String, dynamic>>>> getSameRegularId(
      int parentId) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    List<List<Map<String, dynamic>>> result = [];
    List<Map<String, dynamic>> parentData = await db
        .rawQuery('SELECT * FROM regular_templates WHERE id =?', [parentId]);

    for (int i = 1; i <= parentData[0]['day']; i++) {
      result.add(await db
          .rawQuery('SELECT * FROM regular_schedules WHERE day = ?', [i]));
    }
    return result;
  }
}
