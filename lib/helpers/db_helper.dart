import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import 'package:favorite_places/models/place.dart';

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();

    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_places(
            id TEXT PRIMARY KEY,
            title TEXT,
            image TEXT,
            lat REAL,
            lng REAL,
            address TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertPlace(Place place) async {
    final db = await database();

    await db.insert(
      'user_places',
      place.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Place>> getPlaces() async {
    final db = await database();

    final data = await db.query('user_places');

    return data.map((row) => Place.fromMap(row)).toList();
  }
}
