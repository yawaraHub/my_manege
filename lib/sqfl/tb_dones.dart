import 'package:my_manege/sqfl/db_helper_my_manege.dart';
import 'package:sqflite/sqflite.dart';

class DonesDao {
  final dbHelper = MyManageDBHelper.instance;

  Future<void> _createTableIfNotExists(Database db) async {
    final tableExists = await db.rawQuery("SELECT 1 FROM dones LIMIT 1");
    if (tableExists.isEmpty) {
      await db.execute('''
      CREATE TABLE dones (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        start_at TEXT NOT NULL,
        end_at TEXT NOT NULL,
        review TEXT,
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
    return await db.insert('dones', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.query('dones');
  }

  //更新したら更新をしたカラムの数を返し、更新を失敗したら0を返す。
  Future<int> update(Map<String, dynamic> row) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.update('dones', row, where: 'id = ?', whereArgs: [row['id']]);
  }

  //削除したカラムの数を返し、失敗したら0を返す。
  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.delete('dones', where: 'id = ?', whereArgs: [id]);
  }

  //ある日にちのやったことのデータを抽出
  Future<List<Map<String,dynamic>>> getSameDayData(String date)async{
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.rawQuery("SELECT * FROM dones WHERE start_at LIKE '$date%'");
  }
}
