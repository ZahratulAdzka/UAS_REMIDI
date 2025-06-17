import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/photo_model.dart';

class PhotoDbHelper {
  static Database? _database;
  static final PhotoDbHelper instance = PhotoDbHelper._internal();
  PhotoDbHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'photos.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE photos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        filePath TEXT,
        location TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertPhoto(PhotoModel photo) async {
    final db = await database;
    return await db.insert('photos', photo.toMap());
  }

  Future<List<PhotoModel>> getAllPhotos() async {
    final db = await database;
    final result = await db.query('photos');
    return result.map((e) => PhotoModel.fromMap(e)).toList();
  }

  Future<void> deleteAllPhotos() async {
    final db = await database;
    await db.delete('photos');
  }
}
