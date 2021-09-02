import 'package:path/path.dart';
import 'package:restaurant_app/data/model/favorite.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static late Database _database;
  static String _tableName = 'favorite';

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db =
        openDatabase(join(path, 'favorite.db'), onCreate: (db, version) async {
      await db.execute(
        '''CREATE TABLE $_tableName (id TEXT, name TEXT, description TEXT,city TEXT, pictureId TEXT,rating REAL)''',
      );
    }, version: 1);
    return db;
  }

  Future<void> insertFavorite(Favorite restaurantElement) async {
    final Database db = await database;
    await db.insert(_tableName, restaurantElement.toMap());
    print("Data Saved");
  }

  Future<void> deleteFavorite(String id) async {
    final Database db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    print("Data Deleted");
  }

  Future<List<Favorite>> getFavorite() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);

    return results.map((e) => Favorite.fromMap(e)).toList();
  }
}
