import 'package:my_manege/sqfl/db_helper_my_manege.dart';
import 'package:sqflite/sqflite.dart';

class CategoriesDao {
  final dbHelper = MyManageDBHelper.instance;

  Future<void> _createTableIfNotExists(Database db) async {
    final tableExists = await db.rawQuery("SELECT 1 FROM categories LIMIT 1");
    if (tableExists.isEmpty) {
      await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        description TEXT DEFAULT "",
        is_show INTEGER DEFAULT 1,
        parent_id INTEGER,
        order INTEGER NOT NULL,
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
    return await db.insert('categories', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.query('categories');
  }

  //更新したら更新をしたカラムの数を返し、更新を失敗したら0を返す。
  Future<int> update(Map<String, dynamic> row) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.update('categories', row, where: 'id = ?', whereArgs: [row['id']]);
  }

  //削除したカラムの数を返し、失敗したら0を返す。
  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  //入れ子構造を作るための関数
  Future<List<Map<String, dynamic>>> _getCategoriesWithChildren(int parentId, Database db) async {
    final categories = await db.rawQuery('SELECT * FROM categories WHERE parent_id = ?', [parentId]);
    final result = <Map<String, dynamic>>[];

    for (var category in categories) {
      final int categoryId = category['id'] as int;
      final children = await _getCategoriesWithChildren(categoryId, db);

      // カテゴリとその子カテゴリをマップに追加
      category['children'] = children;
      result.add(category);
    }

    return result;
  }
  //カテゴリーの入れ子構造を渡してくれる
  Future<List<Map<String, dynamic>>> getCategoryHierarchy() async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);

    // 親カテゴリを取得
    final parentCategories = await db.rawQuery('SELECT * FROM categories WHERE parent_id IS NULL');
    final categoryHierarchy = <Map<String, dynamic>>[];

    for (var parentCategory in parentCategories) {
      final int parentId = parentCategory['id'] as int;
      final children = await _getCategoriesWithChildren(parentId, db);

      // 親カテゴリとその子カテゴリをマップに追加
      parentCategory['children'] = children;
      categoryHierarchy.add(parentCategory);
    }

    return categoryHierarchy;
  }

}
