import 'package:book_finder_app/data/models/book_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class BookDbHelper {
  static const _dbName = 'books.db';
  static const _tableName = 'saved_books';
  static final BookDbHelper _instance = BookDbHelper._internal();
  factory BookDbHelper() => _instance;
  BookDbHelper._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE $_tableName(
          key TEXT PRIMARY KEY,
          title TEXT,
          author TEXT,
          coverUrl TEXT
        )
      ''');
    });
  }

  Future<void> insertBook(BookModel book) async {
    final db = await database;
    await db.insert(_tableName, book.toDb(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<BookModel>> getBooks() async {
    final db = await database;
    final maps = await db.query(_tableName);
    return maps.map((e) => BookModel.fromDb(e)).toList();
  }
Future<void> deleteBookByKey(String key) async {
  final db = await database;
  await db.delete(_tableName, where: 'key = ?', whereArgs: [key]);
}

}
