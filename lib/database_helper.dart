import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/movie.dart';
import 'models/user.dart';
import 'models/category.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'movie_app.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Movies tablosu
    await db.execute('''
      CREATE TABLE movies(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        imagePath TEXT,
        category TEXT,
        rating REAL
      )
    ''');

    // Categories tablosu
    await db.execute('''
      CREATE TABLE categories(
        name TEXT PRIMARY KEY,
        imageUrl TEXT
      )
    ''');

    // Users tablosu
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT,
        email TEXT UNIQUE,
        profileImage TEXT,
        fullName TEXT,
        phoneNumber TEXT,
        bio TEXT
      )
    ''');

    // Örnek film verileri
    await db.insert('movies', {
      'title': 'Inception',
      'description': 'Rüya içinde rüya...',
      'imagePath': 'assets/images/inception.jpg',
      'category': 'Aksiyon',
      'rating': 8.8
    });
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute('ALTER TABLE users ADD COLUMN profileImage TEXT;');
        await db.execute('ALTER TABLE users ADD COLUMN fullName TEXT;');
        await db.execute('ALTER TABLE users ADD COLUMN phoneNumber TEXT;');
        await db.execute('ALTER TABLE users ADD COLUMN bio TEXT;');
        print('Users tablosuna yeni sütunlar başarıyla eklendi.');
      } catch (e) {
        print('Users tablosuna sütun eklenirken hata oluştu: $e');
        rethrow;
      }
    }
  }

  // Film işlemleri
  Future<List<Movie>> getMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('movies');
    return List.generate(maps.length, (i) => Movie.fromMap(maps[i]));
  }

  Future<void> insertMovie(Movie movie) async {
    try {
      final db = await database;
      await db.insert(
        'movies',
        movie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Film eklenirken hata oluştu: $e');
      rethrow;
    }
  }

  // Kategori işlemleri
  Future<List<Category>> getCategories() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('categories');
      return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
    } catch (e) {
      print('Kategoriler getirilirken hata oluştu: $e');
      return [];
    }
  }

  Future<void> insertCategory(Category category) async {
    try {
      final db = await database;
      await db.insert(
        'categories',
        category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Kategori eklenirken hata oluştu: $e');
      rethrow;
    }
  }

  // Kullanıcı işlemleri
  Future<int> insertUser(User user) async {
    try {
      final db = await database;
      return await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Kullanıcı eklenirken hata oluştu: $e');
      rethrow;
    }
  }

  Future<User?> getUser(String username, String password) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Kullanıcı getirilirken hata oluştu: $e');
      return null;
    }
  }

  Future<User?> getUserByUsername(String username) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Kullanıcı adına göre kullanıcı getirilirken hata oluştu: $e');
      return null;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final db = await database;
      await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch (e) {
      print('Kullanıcı güncellenirken hata oluştu: $e');
      rethrow;
    }
  }
} 