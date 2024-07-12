import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? database;

  Future<int?> newRoute(distance, date) async {
    final db = database;
    var res = await db!.rawInsert("INSERT INTO Routes (distance,date)"
        " VALUES ('$distance', '$date');");
    return res;
  }

  Future<int?> newLocation(name, lat, lon, date) async {
    final db = database;
    var res = await db!.rawInsert("INSERT INTO Locations (name,lat,lon,date)"
        " VALUES ('$name', $lat, $lon, $date);");
    return res;
  }

  Future<List<Map<String, Object?>>> getRoutes() async {
    final db = database;
    final List<Map<String, Object?>> routeMaps = await db!.query("Routes");
    return routeMaps;
  }

  Future<Database> initDB() async {
    String documentsDirectory = "/storage/emulated/0/Documents";
    String path = '$documentsDirectory/TestDB.db';

    return await openDatabase(path, version: 1, onOpen: (db) {
      database = db;
    }, onCreate: (Database db, int version) {
      database = db;
      db.execute("CREATE TABLE Locations ("
          "name TEXT,"
          "lat REAL,"
          "lon REAL,"
          "date INTEGER"
          ")");

      db.execute("CREATE TABLE Routes ("
          "distance REAL,"
          "date INTEGER"
          ")");
    });
  }
}
