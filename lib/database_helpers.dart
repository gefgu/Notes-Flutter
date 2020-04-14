import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableNotes = 'notes';
final String columnId = "_id";
final String columnTitle = "title";
final String columnBody = "body";
final String columnForeign = "foreignCategory";
final String tableCategories = "categories";
final String columnCategoryName = "category";

class Note {
  int id;
  String title;
  String body;
  int categoryId;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnBody: body,
      columnForeign: categoryId,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Note();

  Note.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    body = map[columnBody];
    categoryId = map[columnForeign];
  }
}

class Category {
  int id;
  String name;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnCategoryName: name,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Category();

  Category.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnCategoryName];
  }

  @override
  String toString() {
    return name;
  }
}

class DatabaseHelper {
  static final _databaseName = "knight_note.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
     CREATE TABLE $tableNotes (
     $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
     $columnTitle TEXT NOT NULL,
     $columnBody TEXT,
     $columnForeign INTEGER REFERENCES $tableCategories($columnId)
     )
    ''');
    await db.execute('''
    CREATE TABLE $tableCategories (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnCategoryName TEXT NOT NULL
    )
    ''');
  }

  Future<List<Category>> getAllCategories() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableCategories);

    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<List<Note>> getAllNotes() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableNotes);

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<int> insertNote(Note note) async {
    Database db = await database;
    int id = await db.insert(tableNotes, note.toMap());

    return id;
  }

  Future<int> insertCategory(Category category) async {
    Database db = await database;
    int id = await db.insert(tableCategories, category.toMap());

    return id;
  }

  Future<int> deleteNote(int id) async {
    Database db = await database;
    return await db.delete(tableNotes, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateNote(Note note) async {
    Database db = await database;
    return await db.update(tableNotes, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }

  Future<int> deleteCategory(int id) async {
    Database db = await database;
    return await db.delete(tableNotes, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateCategory(Category category) async {
    Database db = await database;
    return await db.update(tableNotes, category.toMap(),
        where: '$columnId = ?', whereArgs: [category.id]);
  }
}
