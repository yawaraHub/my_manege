import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyManageDBHelper {
  static Database? _database;
  static final MyManageDBHelper instance =
      MyManageDBHelper._privateConstructor();

  MyManageDBHelper._privateConstructor();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_database.db');

    return await openDatabase(path,
        version: 1, // データベースのバージョン
        onCreate: _createDatabase, // データベースが作成されるときに呼び出されるメソッド
        readOnly: false);
  }

  Future<void> _createDatabase(Database db, int version) async {
    // データベースのテーブルを作成するクエリを実行する
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        uid INTEGER UNIQUE,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      );
    ''');
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
    await db.execute('''
      CREATE TABLE schedules (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        day TEXT NOT NULL,
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
    await db.execute('''
      CREATE TABLE logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        day TEXT NOT NULL,
        start_at TEXT NOT NULL,
        end_at TEXT NOT NULL,
        review TEXT DEFAULT "",
        category_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT,
        FOREIGN KEY(category_id) REFERENCES categories(id)
      );
    ''');
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
    await db.execute('''
      CREATE TABLE irregular_templates (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT NOT NULL,
        description TEXT DEFAULT "",
        user_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id)
      );
    ''');
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
