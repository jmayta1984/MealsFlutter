import 'package:meals/models/meal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DbHelper {
  final int version = 1;
  final String name = 'meals.db';
  final String tableName = 'meals';
  Database? db;

  static final DbHelper _dbHelper = DbHelper._interal();

  DbHelper._interal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    db ??= await openDatabase(
      join(await getDatabasesPath(), name),
      onCreate: (database, version) {
        database.execute(
            'CREATE TABLE $tableName(id TEXT PRIMARY KEY, name TEXT, poster TEXT)');
      },
      version: version,
    );
    return db as Database;
  }

  insert(Meal meal) async {
    await db?.insert(tableName, meal.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  delete(Meal meal) async {
    await db?.delete(
      tableName,
      where: 'id=?',
      whereArgs: [meal.id],
    );
  }

  Future<bool> isFavorite(Meal meal) async {
    final maps = await db?.query(
      tableName,
      where: 'id=?',
      whereArgs: [meal.id],
    );
    return maps!.isNotEmpty;
  }
}
