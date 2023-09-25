import 'package:my_manege/sqfl/db_helper_my_manege.dart';
import 'package:sqflite/sqflite.dart';

class DiariesDao {
  final dbHelper = MyManageDBHelper.instance;

  Future<void> _createTableIfNotExists(Database db) async {
    final tableExists = await db.rawQuery("SELECT 1 FROM diaries LIMIT 1");
    if (tableExists.isEmpty) {
      await db.execute('''
      CREATE TABLE diaries (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        day TEXT NOT NULL,
        diary TEXT DEFAULT "",
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
    return await db.insert('diaries', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.query('diaries');
  }

  //更新したら更新をしたカラムの数を返し、更新を失敗したら0を返す。
  Future<int> update(Map<String, dynamic> row) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.update('diaries', row, where: 'id = ?', whereArgs: [row['id']]);
  }

  //削除したカラムの数を返し、失敗したら0を返す。
  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.delete('diaries', where: 'id = ?', whereArgs: [id]);
  }

  //ある日にちの日記のデータを抽出
  Future<List<Map<String,dynamic>>> getSameDayData(String date)async{
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.rawQuery("SELECT * FROM diaries WHERE day LIKE '$date%'");
  }
}
