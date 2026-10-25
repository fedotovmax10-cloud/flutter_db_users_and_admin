import 'package:flutter_worker/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;

  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();

  final String _tableName = 'users';
  final String _columnId = 'id';
  final String _columnLogin = 'login';
  final String _columnPassword = 'password';
  final String _columnEmail = 'email';
  final String _columnBirthday = 'birthday';
  final String _columnPhoneNumber = 'phone_number';
  final String _columnDescription = 'description';
  final String _columnAdmin = 'isAdmin';

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await _getDatabase();
    return _db!;
  }

  Future<Database> _getDatabase() async {
    final dirPath = await getDatabasesPath();
    final dbPath = join(dirPath, 'users.db');

    return await openDatabase(
      dbPath,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_columnLogin TEXT NOT NULL,
            $_columnPassword TEXT NOT NULL,
            $_columnEmail TEXT NOT NULL,
            $_columnBirthday TEXT NOT NULL,
            $_columnPhoneNumber TEXT NOT NULL,
            $_columnDescription TEXT,
            $_columnAdmin INTEGER NOT NULL DEFAULT 0
          )
          ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE $_tableName ADD COLUMN $_columnDescription TEXT;',
          );
        }

        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE $_tableName ADD COLUMN $_columnAdmin INTEGER NOT NULL DEFAULT 0;',
          );
        }
      },
    );
  }

  Future<void> addUser(User user) async {
    final db = await database;

    await db.insert(
      _tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getUsers() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return maps.map((user) => User.fromMap(user)).toList();
  }

  Future<void> userUpdate(User user) async {
    final db = await database;

    await db.update(
      _tableName,
      user.toMap(),
      where: '$_columnId = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> userDelete(int id) async {
    final db = await database;

    await db.delete(_tableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  Future<User?> getUserByLogin(String login) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$_columnLogin = ?',
      whereArgs: [login],
    );

    if (maps.isEmpty) {
      return null;
    }

    return User.fromMap(maps.first);
  }
}
