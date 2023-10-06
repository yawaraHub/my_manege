import 'package:my_manege/sqflite/db_helper_my_manege.dart';
import 'package:sqflite/sqflite.dart';

class TasksDao {
  final dbHelper = MyManageDBHelper.instance;

  Future<void> _createTableIfNotExists(Database db) async {
    final List<Map<String, dynamic>> tableInfo = await db.rawQuery(
      'PRAGMA table_info(tasks)',
    );
    if (tableInfo.isEmpty) {
      await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        dead_line TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT DEFAULT "",
        completed_at TEXT,
        is_completed INTEGER NOT NULL,
        user_id INTEGER,
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
    return await db.insert('tasks', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.query('tasks');
  }

  //更新したら更新をしたカラムの数を返し、更新を失敗したら0を返す。
  Future<int> update(Map<String, dynamic> row) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db
        .update('tasks', row, where: 'id = ?', whereArgs: [row['id']]);
  }

  //削除したカラムの数を返し、失敗したら0を返す。
  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
