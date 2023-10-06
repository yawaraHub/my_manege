import 'package:my_manege/sqflite/db_helper_my_manege.dart';
import 'package:sqflite/sqflite.dart';

class CategoriesDao {
  final dbHelper = MyManageDBHelper.instance;

  Future<void> _createTableIfNotExists(Database db) async {
    final List<Map<String, dynamic>> tableInfo = await db.rawQuery(
      'PRAGMA table_info(categories)',
    );
    if (tableInfo.isEmpty) {
      await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        color TEXT NOT NULL,
        description TEXT DEFAULT "",
        is_show INTEGER DEFAULT 1,
        parent_id INTEGER,
        category_order INTEGER NOT NULL,
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

  Future<Map<String, dynamic>> categoryData(int id) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    final List<Map<String, dynamic>> results = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.first;
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
    return await db
        .update('categories', row, where: 'id = ?', whereArgs: [row['id']]);
  }

  //削除したカラムの数を返し、失敗したら0を返す。
  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);

    //TODO:子の削除
  }

  //入れ子構造を作るための関数
  Future<List<Map<String, dynamic>>> _getCategoriesWithChildren(
      int parentId, Database db) async {
    final categories = await db
        .rawQuery('SELECT * FROM categories WHERE parent_id = ?', [parentId]);
    final result = <Map<String, dynamic>>[];

    for (var category in categories) {
      final int categoryId = category['id'] as int;
      final children = await _getCategoriesWithChildren(categoryId, db);

      // カテゴリとその子カテゴリをマップに追加&read-only回避
      Map<String, dynamic> categoryAvoidReadOnly = {
        'id': category['id'],
        'name': category['name'],
        'color': category['color'],
        'description': category['description'],
        'is_show': category['is_show'],
        'parent_id': category['parent_id'],
        'category_order': category['category_order'],
        'user_id': category['user_id'],
        'created_at': category['created_at'],
        'updated_at': category['updated_at'],
        'deleted_at': category['deleted_at'],
        'open': false,
        'children': children,
      };
      // category['children'] = children;
      result.add(categoryAvoidReadOnly);
    }

    return result;
  }

  //カテゴリーの入れ子構造を渡してくれる
  Future<List<Map<String, dynamic>>> getCategoryHierarchy() async {
    final db = await dbHelper.database;
    await _createTableIfNotExists(db);

    // 親カテゴリを取得
    final parentCategories =
        await db.rawQuery('SELECT * FROM categories WHERE parent_id = 0');
    final categoryHierarchy = <Map<String, dynamic>>[];

    for (var parentCategory in parentCategories) {
      final int parentId = parentCategory['id'] as int;
      final children = await _getCategoriesWithChildren(parentId, db);

      // 親カテゴリとその子カテゴリをマップに追加&read-onlyを回避
      Map<String, dynamic> parentCategoryAvoidReadOnly = {
        'id': parentCategory['id'],
        'name': parentCategory['name'],
        'color': parentCategory['color'],
        'description': parentCategory['description'],
        'is_show': parentCategory['is_show'],
        'parent_id': parentCategory['parent_id'],
        'category_order': parentCategory['category_order'],
        'user_id': parentCategory['user_id'],
        'created_at': parentCategory['created_at'],
        'updated_at': parentCategory['updated_at'],
        'deleted_at': parentCategory['deleted_at'],
        'open': false,
        'children': children,
      };
      // parentCategory['children'] = children;
      categoryHierarchy.add(parentCategoryAvoidReadOnly);
    }

    return categoryHierarchy;
  }
}
