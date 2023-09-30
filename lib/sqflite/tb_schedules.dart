import 'package:my_manege/sqflite/db_helper_my_manege.dart';
import 'package:sqflite/sqflite.dart';

class SchedulesDao {
  final dbHelper = MyManageDBHelper.instance;

  Future<void> _createTableIfNotExists(Database db) async {
    final tableExists = await db.rawQuery("SELECT 1 FROM schedules LIMIT 1");
    if (tableExists.isEmpty) {
      await db.execute('''
      CREATE TABLE schedules (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        start_at TEXT NOT NULL,
        end_at TEXT NOT NULL,
        description TEXT DEFAULT "",
        category_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT,
        FOREIGN KEY(category_id) REFERENCES categories(id)
      );
      ''');
    }
  }

  //これではrowというデータを挿入し、挿入後のidを受け取ることができる。
  Future<int> insert(Map<String, dynamic> row) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.insert('schedules', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.query('schedules');
  }

  //更新したら更新をしたカラムの数を返し、更新を失敗したら0を返す。
  Future<int> update(Map<String, dynamic> row) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db
        .update('schedules', row, where: 'id = ?', whereArgs: [row['id']]);
  }

  //削除したカラムの数を返し、失敗したら0を返す。
  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.delete('schedules', where: 'id = ?', whereArgs: [id]);
  }

  //start_atがある日付('2002-06-19')の物を取り出す関数
  Future<List<Map<String, dynamic>>> getOneDaySchedule(
      String dateToSearch) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.rawQuery(
        "SELECT * FROM schedules WHERE start_at LIKE '$dateToSearch%'");
  }
}
